#!/bin/bash
# backup.sh - Backup automat pentru foldere

# Import configurare
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

# Verifică argumente
if [ $# -eq 0 ]; then
    echo "Usage: $0 <folder_to_backup> [backup_name]"
    echo "Example: $0 /home/user/documents documents"
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_NAME="${2:-$(basename "$SOURCE_DIR")}"

# Verifică că sursa există
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Creează directoarele necesare
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

# Fișierul de log
LOG_FILE="${LOG_DIR}/backup_${DATE}.log"

# Fișierul de backup
BACKUP_FILE="${BACKUP_DIR}/${BACKUP_NAME}_${TIMESTAMP}.tar.gz"

# Funcție de logging
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Începe backup-ul
log "===== Backup started ====="
log "Source: $SOURCE_DIR"
log "Destination: $BACKUP_FILE"

# Creează arhiva
if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>>"$LOG_FILE"; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    log "SUCCESS: Backup created ($SIZE)"
else
    log "ERROR: Backup failed"
    exit 1
fi

# Șterge backup-uri vechi
log "Cleaning backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete 2>>"$LOG_FILE"
log "Old backups cleaned"

log "===== Backup finished ====="
exit 0