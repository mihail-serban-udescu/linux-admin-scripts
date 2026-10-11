#!/bin/bash
# check_services.sh - Verifică statusul serviciilor

# Import configurare
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

# Services default (dacă nu sunt date ca argumente)
DEFAULT_SERVICES=("ssh" "cron" "systemd-journald")

# Dacă sunt date argumente, folosește-le; altfel default
if [ $# -gt 0 ]; then
    SERVICES=("$@")
else
    SERVICES=("${DEFAULT_SERVICES[@]}")
fi

# Creează directorul pentru logs
mkdir -p "$LOG_DIR"

# Fișierul de log
LOG_FILE="${LOG_DIR}/check_services_${DATE}.log"

# Funcție de logging
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Start
log "===== Service check started ====="
log "Services to check: ${SERVICES[*]}"

ALERT=0

# Verifică fiecare serviciu
for SERVICE in "${SERVICES[@]}"; do
    log "Checking: $SERVICE"

    # Verifică cu systemctl (systemd)
    if systemctl is-active --quiet "$SERVICE" 2>/dev/null; then
        STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)
        log "  ✅ $SERVICE: $STATUS"
    # Fallback: verifică cu pgrep (proces)
    elif pgrep -x "$SERVICE" > /dev/null 2>&1; then
        log "  ✅ $SERVICE: running (process)"
    # Fallback: verifică cu ps
    elif ps aux | grep -v grep | grep -q "$SERVICE"; then
        log "  ✅ $SERVICE: running (via ps)"
    else
        log "  ❌ $SERVICE: NOT running"
        ALERT=1
    fi
done

# Verdict final
if [ $ALERT -eq 1 ]; then
    log "⚠️ ALERT: One or more services not running"
    log "===== Service check finished ====="
    exit 1
else
    log "✅ OK: All services running"
    log "===== Service check finished ====="
    exit 0
fi