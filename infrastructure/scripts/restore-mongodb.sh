#!/usr/bin/env bash
set -euo pipefail

SOURCE_DB="test"
VALIDATION_DB="restore_validation"
EXPECTED_CONTEXT="docker-desktop"

usage() {
  echo "Usage: $0 {validate|recover} <backup-file> <namespace> <deployment>"
  exit 1
}

#Script Input for restoration
[[ $# -eq 4 ]] || usage

MODE="$1"
BACKUP_FILE="$2"
NAMESPACE="$3"
DEPLOYMENT="$4"

case "$MODE" in
  validate|recover) ;;
  *) usage ;;
esac

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "ERROR: Backup file does not exist."
  exit 1
fi

CONTEXT="$(kubectl config current-context)"

if [[ "$CONTEXT" != "$EXPECTED_CONTEXT" ]]; then
  echo "ERROR: Unexpected Kubernetes context: $CONTEXT"
  exit 1
fi

# Prevent validation mode from targeting production.
if [[ "$MODE" == "validate" ]]; then
  if [[ "$NAMESPACE" != "recovery-test" || "$DEPLOYMENT" != "mongo-recovery" ]]; then
    echo "ERROR: Validation mode requires recovery-test/mongo-recovery."
    exit 1
  fi
fi

# Restrict recovery mode to the expected production target.
if [[ "$MODE" == "recover" ]]; then
  if [[ "$NAMESPACE" != "default" || "$DEPLOYMENT" != "mongo" ]]; then
    echo "ERROR: Production recovery requires default/mongo."
    exit 1
  fi
fi

echo "Checking MongoDB Deployment..."

kubectl rollout status \
  "deployment/$DEPLOYMENT" \
  -n "$NAMESPACE" \
  --timeout=120s

echo "Validating compressed backup..."
gzip -t "$BACKUP_FILE"

echo "Checking MongoDB archive..."

kubectl exec -i -n "$NAMESPACE" "deployment/$DEPLOYMENT" -- \
  mongorestore \
  --uri="mongodb://localhost:27017" \
  --archive=/dev/stdin \
  --gzip \
  --dryRun \
  --nsInclude="$SOURCE_DB.users" \
  < "$BACKUP_FILE"

if [[ "$MODE" == "validate" ]]; then
  TARGET_DB="$VALIDATION_DB"
else
  TARGET_DB="$SOURCE_DB"
fi

echo "Checking target database: $TARGET_DB"

DB_EMPTY="$(kubectl exec -n "$NAMESPACE" "deployment/$DEPLOYMENT" -- \
  mongosh --quiet --eval \
  "print(db.getSiblingDB('$TARGET_DB').getCollectionNames().length === 0)")"

if [[ "$DB_EMPTY" != "true" ]]; then
  echo "ERROR: Target database is not empty."
  echo "Restore refused."
  exit 1
fi

if [[ "$MODE" == "recover" ]]; then
  echo "WARNING: Production recovery requested."
  echo "Target: $NAMESPACE/$DEPLOYMENT"
  echo "Database: $TARGET_DB"

  read -r -p "Type RESTORE to continue: " CONFIRMATION

  if [[ "$CONFIRMATION" != "RESTORE" ]]; then
    echo "Recovery cancelled."
    exit 1
  fi

  # Check again after operator confirmation.
  DB_EMPTY="$(kubectl exec -n "$NAMESPACE" "deployment/$DEPLOYMENT" -- \
    mongosh --quiet --eval \
    "print(db.getSiblingDB('$TARGET_DB').getCollectionNames().length === 0)")"

  if [[ "$DB_EMPTY" != "true" ]]; then
    echo "ERROR: Database is no longer empty."
    exit 1
  fi
fi

echo "Restoring MongoDB data..."

if [[ "$MODE" == "validate" ]]; then

  kubectl exec -i -n "$NAMESPACE" "deployment/$DEPLOYMENT" -- \
    mongorestore \
    --uri="mongodb://localhost:27017" \
    --archive=/dev/stdin \
    --gzip \
    --nsInclude="$SOURCE_DB.users" \
    --nsFrom="$SOURCE_DB.users" \
    --nsTo="$TARGET_DB.users" \
    < "$BACKUP_FILE"

else

  kubectl exec -i -n "$NAMESPACE" "deployment/$DEPLOYMENT" -- \
    mongorestore \
    --uri="mongodb://localhost:27017" \
    --archive=/dev/stdin \
    --gzip \
    --nsInclude="$SOURCE_DB.users" \
    < "$BACKUP_FILE"

fi

echo "Checking restored documents..."

kubectl exec -n "$NAMESPACE" "deployment/$DEPLOYMENT" -- \
  mongosh --quiet --eval \
  "print('Restored users: ' + db.getSiblingDB('$TARGET_DB').users.countDocuments({}))"

echo "MongoDB restoration completed successfully."