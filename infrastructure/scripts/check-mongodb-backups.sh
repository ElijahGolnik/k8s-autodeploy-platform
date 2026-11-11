#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR='/mnt/d/AllProjects/k8s-backups/mongodb'
MAX_AGE_HOURS=36

echo "Checking MongoDB backup health..."

if [[ ! -d "$BACKUP_DIR" ]]; then
  echo "CRITICAL: Backup directory does not exist."
  exit 2
fi

LATEST_BACKUP="$(
  find "$BACKUP_DIR" \
    -maxdepth 1 \
    -type f \
    -name 'mongo-*.archive.gz' \
    -printf '%T@ %p\n' |
  sort -nr |
  head -n 1 |
  cut -d' ' -f2-
)"

if [[ -z "$LATEST_BACKUP" ]]; then
  echo "CRITICAL: No MongoDB backups found."
  exit 2
fi

NOW="$(date +%s)"
BACKUP_TIME="$(stat -c %Y "$LATEST_BACKUP")"

AGE_SECONDS=$((NOW - BACKUP_TIME))
AGE_HOURS=$((AGE_SECONDS / 3600))

echo "Latest backup: $LATEST_BACKUP"
echo "Backup age: $AGE_HOURS hours"

if (( AGE_SECONDS > MAX_AGE_HOURS * 3600 )); then
  echo "CRITICAL: Latest MongoDB backup exceeds $MAX_AGE_HOURS hours."
  exit 2
fi

if ! gzip -t "$LATEST_BACKUP"; then
  echo "CRITICAL: Latest MongoDB backup failed gzip integrity verification."
  exit 2
fi

echo "OK: MongoDB backup is within the expected age and passed gzip verification."
exit 0