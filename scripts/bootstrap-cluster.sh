#!/usr/bin/env bash

set -euo pipefail

# Determine the repository root.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Checking Kubernetes connectivity..."

kubectl cluster-info >/dev/null

echo "Kubernetes is available."

echo "Installing or updating Traefik..."

helm repo add traefik https://traefik.github.io/charts --force-update
helm repo update traefik

helm upgrade --install traefik traefik/traefik \
  --namespace traefik \
  --create-namespace \
  --version 41.7.0 \
  --values "$REPO_ROOT/infrastructure/traefik/values.yaml" \
  --wait \
  --timeout 5m

echo "Traefik installation verified."