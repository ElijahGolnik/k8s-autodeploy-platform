#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Checking Kubernetes connectivity..."

kubectl cluster-info >/dev/null

# Prevent accidental deployment to another cluster.
CONTEXT="$(kubectl config current-context)"

if [[ "$CONTEXT" != "docker-desktop" ]]; then
  echo "ERROR: Expected docker-desktop context, found: $CONTEXT"
  exit 1
fi

echo "Kubernetes connection verified."

# --------------------------------------------------
# 1. Restore Traefik
# --------------------------------------------------

echo "Installing or verifying Traefik..."

helm repo add traefik https://traefik.github.io/charts --force-update
helm repo update traefik

helm upgrade --install traefik traefik/traefik \
  --namespace traefik \
  --create-namespace \
  --version 41.7.0 \
  --values "$REPO_ROOT/infrastructure/traefik/values.yaml" \
  --wait \
  --timeout 5m

# --------------------------------------------------
# 2. Restore MongoDB Secret
# --------------------------------------------------

echo "Checking MongoDB Secret..."

if kubectl get secret mongo-secret >/dev/null 2>&1; then
  echo "MongoDB Secret already exists."
else
  if [[ -z "${MONGO_URI:-}" ]]; then
    echo "ERROR: mongo-secret is missing and MONGO_URI is not set."
    exit 1
  fi

  kubectl create secret generic mongo-secret \
    --from-literal="MONGO_URI=$MONGO_URI"

  echo "MongoDB Secret created."
fi

# --------------------------------------------------
# 3. Restore application resources
# --------------------------------------------------

echo "Applying Kubernetes application configuration..."

kubectl apply -k "$REPO_ROOT"

# --------------------------------------------------
# 4. Verify deployments
# --------------------------------------------------

echo "Waiting for MongoDB..."

kubectl rollout status deployment/mongo --timeout=180s

echo "Waiting for backend..."

kubectl rollout status deployment/backend --timeout=180s

echo "Waiting for frontend..."

kubectl rollout status deployment/frontend --timeout=180s

# --------------------------------------------------
# 5. Display recovery status
# --------------------------------------------------

echo "Checking Kubernetes resources..."

kubectl get deployments
kubectl get pods
kubectl get pvc
kubectl get ingress

echo "Cluster resource recovery completed."
echo "Application URL: http://myapp.local"