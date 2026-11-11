#!/usr/bin/env bash
#Stops execution when a command fails
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]})")" && pwd)"

BACKUP_DIR="/mnt/d/AllProjects/k8s-backups/mongodb"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_FILE="$BACKUP_DIR/mongo-$TIMESTAMP.archive.gz"

#Keeps incomplete backups separate from completed backups
TEMP_FILE="$BACKUP_FILE.partial"

mkdir -p "$BACKUP_DIR"

#Removes the temp file after failure or success
cleanup() {
  rm -f "$TEMP_FILE"
}
trap cleanup EXIT

#Context check to prevent targeting another cluster
echo "Checking Kubernetes context..."
CONTEXT="$(kubectl config current-context)"

if [[ "$CONTEXT" != "docker-desktop" ]]; then
  echo "ERROR: Unexpected Kubernetes context: $CONTEXT"
  exit 1
fi

echo "Checking MongoDB deployment..."
kubectl rollout status deployment/mongo --timeout=120s

echo "Creating MongoDB backup..."

kubectl exec deployment/mongo -- \
  mongodump \
  --uri="mongodb://localhost:27017" \
  --archive \
  --gzip \
  > "$TEMP_FILE"

#Checks compressed file integrity
echo "Checking compressed archive..."
gzip -t "$TEMP_FILE"

#Checks that the archive can be read
echo "Validating MongoDB archive..."
kubectl exec -i deployment/mongo -- \
  mongorestore \
  --uri="mongodb://localhost:27017" \
  --archive=/dev/stdin \
  --gzip \
  --dryRun \
  < "$TEMP_FILE"

#Publishes the backup only after validation
mv "$TEMP_FILE" "$BACKUP_FILE"

echo "Backup completed successfully."
echo "Backup file: $BACKUP_FILE"

ls -lh "$BACKUP_FILE"

echo "Applying MongoDB backup retention..."

if bash "$SCRIPT_DIR/cleanup-mongodb-backups.sh" delete; then
  echo "Backup retention completed successfully."
else
  echo "WARNING: Backup succeeded, but retention cleanup failed." >&2
fi

echo "MongoDB backup workflow completed."