#!/bin/bash
# cron_setup.sh - Generează configurări cron pentru scripturile proiectului

# Import configurare
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

# Creează directorul pentru logs
mkdir -p "$LOG_DIR"

# Fișierul de log
LOG_FILE="${LOG_DIR}/cron_setup_${DATE}.log"

# Funcție de logging
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Calea absolută către scripturi
SCRIPTS_PATH="${SCRIPT_DIR}"

# Start
log "===== Cron setup started ====="
log "Scripts path: $SCRIPTS_PATH"

# Verifică că crontab există
if ! command -v crontab &>/dev/null; then
    log "❌ ERROR: crontab not found. Install: sudo apt-get install cron"
    exit 1
fi

log "✅ crontab found: $(which crontab)"

# Afișează crontab-ul actual
log ""
log "--- Current crontab ---"
CURRENT_CRON=$(crontab -l 2>/dev/null)
if [ -z "$CURRENT_CRON" ]; then
    log "  (empty - no crontab configured)"
else
    echo "$CURRENT_CRON" | tee -a "$LOG_FILE"
fi

# Generează liniile cron
log ""
log "--- Recommended cron entries ---"
log ""
log "# Backup - daily at 2:00 AM"
log "0 2 * * * ${SCRIPTS_PATH}/backup.sh /path/to/backup >> ${LOG_DIR}/cron_backup.log 2>&1"
log ""
log "# Cleanup - weekly on Sunday at 3:00 AM"
log "0 3 * * 0 ${SCRIPTS_PATH}/cleanup.sh /path/to/cleanup 30 '*.log' >> ${LOG_DIR}/cron_cleanup.log 2>&1"
log ""
log "# Monitor - every hour"
log "0 * * * * ${SCRIPTS_PATH}/monitor.sh >> ${LOG_DIR}/cron_monitor.log 2>&1"
log ""
log "# Disk alert - every 6 hours"
log "0 */6 * * * ${SCRIPTS_PATH}/disk_alert.sh >> ${LOG_DIR}/cron_disk_alert.log 2>&1"
log ""
log "# Check services - every 15 minutes"
log "*/15 * * * * ${SCRIPTS_PATH}/check_services.sh ssh cron >> ${LOG_DIR}/cron_check_services.log 2>&1"
log ""
log "# Log rotation - monthly (1st day, 4:00 AM)"
log "0 4 1 * * ${SCRIPTS_PATH}/log_rotate.sh /var/log 30 >> ${LOG_DIR}/cron_log_rotate.log 2>&1"
log ""
log "# User audit - weekly on Monday at 5:00 AM"
log "0 5 * * 1 ${SCRIPTS_PATH}/user_audit.sh >> ${LOG_DIR}/cron_user_audit.log 2>&1"

log ""
log "--- How to install ---"
log "1. Copy the lines above (without # comments if you want)"
log "2. Run: crontab -e"
log "3. Paste the lines"
log "4. Save and exit (Ctrl+O, Enter, Ctrl+X in nano)"
log "5. Verify: crontab -l"

log ""
log "===== Cron setup finished ====="
exit 0