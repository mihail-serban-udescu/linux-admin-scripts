#!/bin/bash
# cleanup.sh - Șterge fișiere vechi dintr-un folder

# Import configurare
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

# Verifică argumente
if [ $# -eq 0 ]; then
    echo "Usage: $0 <folder> [days] [pattern]"
    echo "Example: $0 /tmp/logs 30 '*.log'"
    exit 1
fi

TARGET_DIR="$1"
DAYS="${2:-30}"
PATTERN="${3:-*}"

# Verifică că folderul există
if [ ! -d "$TARGET_DIR" ]; then
    echo "ERROR: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Creează directorul pentru logs
mkdir -p "$LOG_DIR"

# Fișierul de log
LOG_FILE="${LOG_DIR}/cleanup_${DATE}.log"

# Funcție de logging
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Începe cleanup-ul
log "===== Cleanup started ====="
log "Target: $TARGET_DIR"
log "Older than: $DAYS days"
log "Pattern: $PATTERN"

# Numără fișiere înainte
BEFORE=$(find "$TARGET_DIR" -name "$PATTERN" -type f 2>/dev/null | wc -l)
log "Files found: $BEFORE"

# Calculează spațiu înainte
SIZE_BEFORE=$(du -sb "$TARGET_DIR" 2>/dev/null | cut -f1)

# Șterge fișiere mai vechi de N zile
DELETED=$(find "$TARGET_DIR" -name "$PATTERN" -type f -mtime +$DAYS -print -delete 2>>"$LOG_FILE" | wc -l)
log "Files deleted: $DELETED"

# Calculează spațiu după
SIZE_AFTER=$(du -sb "$TARGET_DIR" 2>/dev/null | cut -f1)
SPACE_FREED=$((SIZE_BEFORE - SIZE_AFTER))
SPACE_FREED_H=$(numfmt --to=iec $SPACE_FREED 2>/dev/null || echo "${SPACE_FREED} bytes")

log "Space freed: $SPACE_FREED_H"
log "===== Cleanup finished ====="
exit 0