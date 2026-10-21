#!/bin/bash

# backup.sh - Creates a timestamped backup of the 2023/ directory
#
# The backup is saved as a .tar.gz archive in a backups/ folder
# located next to this script.
#
# Usage: ./backup.sh

# Resolve the directory where this script lives so the paths work
# regardless of where you call the script from
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# The source directory to back up (the 2023/ folder at the repo root)
SOURCE_DIR="$(cd "${SCRIPT_DIR}/../" && pwd)/2023"

# Destination: a backups/ folder inside the day05 directory
BACKUP_DIR="${SCRIPT_DIR}/backups"

# Create the backups directory if it does not already exist
mkdir -p "${BACKUP_DIR}"

# Build a timestamp string for the filename
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"

# Create the compressed archive
tar -czf "${BACKUP_FILE}" -C "$(dirname "${SOURCE_DIR}")" "$(basename "${SOURCE_DIR}")"

echo "Backup saved to: ${BACKUP_FILE}"
