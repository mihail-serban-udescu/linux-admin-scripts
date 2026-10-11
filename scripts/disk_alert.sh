#!/bin/bash
# disk_alert.sh - Alertează când disk-ul e aproape plin

# Import configurare
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

# Threshold (default din config sau din argument)
THRESHOLD="${1:-$DISK_THRESHOLD}"

# Creează directorul pentru logs
mkdir -p "$LOG_DIR"

# Fișierul de log
LOG_FILE="${LOG_DIR}/disk_alert_${DATE}.log"

# Funcție de logging
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Start
log "===== Disk alert check started ====="
log "Threshold: ${THRESHOLD}%"

ALERT=0

# Verifică fiecare partiție (exclude tmpfs, squashfs)
while read -r LINE; do
    FILESYSTEM=$(echo "$LINE" | awk '{print $1}')
    SIZE=$(echo "$LINE" | awk '{print $2}')
    USED=$(echo "$LINE" | awk '{print $3}')
    AVAIL=$(echo "$LINE" | awk '{print $4}')
    USE_PERCENT=$(echo "$LINE" | awk '{print $5}' | sed 's/%//')
    MOUNT=$(echo "$LINE" | awk '{print $6}')

    log "Filesystem: $FILESYSTEM"
    log "  Mount: $MOUNT"
    log "  Size: $SIZE, Used: $USED, Avail: $AVAIL, Use%: ${USE_PERCENT}%"

    if [ "$USE_PERCENT" -ge "$THRESHOLD" ]; then
        log "  ⚠️ WARNING: Usage above ${THRESHOLD}%"
        ALERT=1
    fi
done < <(df -h | grep -v "tmpfs" | grep -v "squashfs" | grep -v "udev" | tail -n +2)

# Verdict final
if [ $ALERT -eq 1 ]; then
    log "⚠️ ALERT: One or more filesystems above ${THRESHOLD}%"
    log "===== Disk alert check finished ====="
    exit 1
else
    log "✅ OK: All filesystems below ${THRESHOLD}%"
    log "===== Disk alert check finished ====="
    exit 0
fi