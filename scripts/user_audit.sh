#!/bin/bash
# user_audit.sh - Audit useri (UID, shell, ultimul login, useri fără parolă)

# Import configurare
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

# Creează directorul pentru logs
mkdir -p "$LOG_DIR"

# Fișierul de log
LOG_FILE="${LOG_DIR}/user_audit_${DATE}.log"

# Funcție de logging
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Start
log "===== User audit started ====="
log "Hostname: $(hostname)"
log "Date: $DATE $TIMESTAMP"

# Contoare
TOTAL_USERS=0
NO_PASSWORD=0

# 1. Listează toți userii (exclude system users < UID 1000)
log ""
log "--- Regular users (UID >= 1000) ---"

while IFS=: read -r USERNAME _PASS USER_UID _GID GECOS HOME SHELL; do
    # Doar useri cu UID >= 1000
    if [ "$USER_UID" -ge 1000 ] && [ "$USER_UID" -lt 65534 ]; then
        TOTAL_USERS=$((TOTAL_USERS + 1))

        # Ultimul login
        LAST_LOGIN=$(last -n 1 "$USERNAME" 2>/dev/null | head -1 | awk '{print $4, $5, $6, $7}')
        [ -z "$LAST_LOGIN" ] && LAST_LOGIN="never"

        log "User: $USERNAME"
         log "  UID: $USER_UID"
        log "  Home: $HOME"
        log "  Shell: $SHELL"
        log "  Last login: $LAST_LOGIN"
    fi
done < /etc/passwd

log ""
log "Total regular users: $TOTAL_USERS"

# 2. Verifică useri fără parolă (SECURITATE!)
log ""
log "--- Users without password (SECURITY) ---"

while IFS=: read -r USERNAME PASS _REST; do
    if [ "$PASS" = "" ]; then
        log "⚠️ User without password: $USERNAME"
        NO_PASSWORD=$((NO_PASSWORD + 1))
    fi
done < /etc/shadow 2>/dev/null || log "  (Cannot read /etc/shadow - need root)"

log "Users without password: $NO_PASSWORD"

# 3. Useri cu UID 0 (doar root ar trebui)
log ""
log "--- Users with UID 0 (should be only root) ---"
awk -F: '$3 == 0 {print "  " $1}' /etc/passwd | tee -a "$LOG_FILE"

# 4. Useri cu shell valid
log ""
log "--- Users with valid shell (not /nologin or /false) ---"
awk -F: '$7 != "/usr/sbin/nologin" && $7 != "/bin/false" && $3 >= 1000 {print "  " $1 " -> " $7}' /etc/passwd | tee -a "$LOG_FILE"

# Verdict final
log ""
if [ $NO_PASSWORD -gt 0 ]; then
    log "⚠️ WARNING: $NO_PASSWORD users without password!"
    log "===== User audit finished ====="
    exit 1
else
    log "✅ OK: No users without password"
    log "===== User audit finished ====="
    exit 0
fi