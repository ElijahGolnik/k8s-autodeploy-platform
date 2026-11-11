#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/mnt/d/AllProjects/k8s-backups/mongodb}"
RETENTION_DAYS=7
MIN_BACKUPS=7

MODE="${1:-dry-run}"

if [[ "$MODE" != "dry-run" && "$MODE" != "delete" ]]; then
  echo "Usage: $0 [dry-run|delete]"
  exit 1
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
  echo "ERROR: Backup directory not found."
  exit 1
fi

mapfile -d '' -t BACKUPS < <(
  find "$BACKUP_DIR" \
    -maxdepth 1 \
    -type f \
    -name 'mongo-*.archive.gz' \
    -printf '%T@ %p\0' |
  sort -zrn |
  cut -z -d' ' -f2-
)

echo "Completed backups found: ${#BACKUPS[@]}"

if (( ${#BACKUPS[@]} <= MIN_BACKUPS )); then
  echo "Retention minimum reached. Nothing to delete."
  exit 0
fi

NOW="$(date +%s)"
MAX_AGE_SECONDS=$((RETENTION_DAYS * 86400))

for INDEX in "${!BACKUPS[@]}"; do
  FILE="${BACKUPS[$INDEX]}"

  # Always preserve the newest MIN_BACKUPS files.
  if (( INDEX < MIN_BACKUPS )); then
    continue
  fi

  MODIFIED="$(stat -c %Y "$FILE")"
  AGE_SECONDS=$((NOW - MODIFIED))

  if (( AGE_SECONDS > MAX_AGE_SECONDS )); then
    if [[ "$MODE" == "dry-run" ]]; then
      echo "WOULD DELETE: $FILE"
    else
      rm -- "$FILE"
      echo "DELETED: $FILE"
    fi
  fi
done

echo "Retention processing complete."