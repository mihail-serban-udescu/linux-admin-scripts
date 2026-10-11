#!/bin/bash
# log_rotate.sh - Rotește log-uri vechi (arhivează + șterge)

# Import configurare
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

# Verifică argumente
if [ $# -eq 0 ]; then
    echo "Usage: $0 <log_directory> [days]"
    echo "Example: $0 /var/log 7"
    exit 1
fi

LOG_SOURCE="$1"
ROTATE_DAYS="${2:-7}"
ARCHIVE_DAYS=$((ROTATE_DAYS * 4))

# Verifică că folderul există
if [ ! -d "$LOG_SOURCE" ]; then
    echo "ERROR: Directory '$LOG_SOURCE' does not exist."
    exit 1
fi

# Creează directoarele necesare
ARCHIVE_DIR="${LOG_SOURCE}/archive"
mkdir -p "$ARCHIVE_DIR"
mkdir -p "$LOG_DIR"

# Fișierul de log
LOG_FILE="${LOG_DIR}/log_rotate_${DATE}.log"

# Funcție de logging
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Start
log "===== Log rotation started ====="
log "Source: $LOG_SOURCE"
log "Rotate logs older than: $ROTATE_DAYS days"
log "Delete archives older than: $ARCHIVE_DAYS days"
log "Archive dir: $ARCHIVE_DIR"

# Numără log-uri înainte
BEFORE=$(find "$LOG_SOURCE" -maxdepth 1 -name "*.log" -type f 2>/dev/null | wc -l)
log "Log files found: $BEFORE"

# Rotește log-urile vechi
ROTATED=0
while IFS= read -r LOGFILE; do
    FILENAME=$(basename "$LOGFILE")
    ARCHIVE_NAME="${FILENAME}_${TIMESTAMP}.tar.gz"

    log "Rotating: $FILENAME"

    if tar -czf "${ARCHIVE_DIR}/${ARCHIVE_NAME}" -C "$(dirname "$LOGFILE")" "$FILENAME" 2>>"$LOG_FILE"; then
        if rm -f "$LOGFILE"; then
            log "  ✅ Archived + removed"
            ROTATED=$((ROTATED + 1))
        else
            log "  ❌ Failed to remove original"
        fi
    else
        log "  ❌ Failed to archive"
    fi
done < <(find "$LOG_SOURCE" -maxdepth 1 -name "*.log" -type f -mtime +$ROTATE_DAYS 2>/dev/null)

log "Logs rotated: $ROTATED"

# Șterge arhive vechi
DELETED=$(find "$ARCHIVE_DIR" -name "*.tar.gz" -type f -mtime +$ARCHIVE_DAYS -print -delete 2>>"$LOG_FILE" | wc -l)
log "Old archives deleted: $DELETED"

log "===== Log rotation finished ====="
exit 0