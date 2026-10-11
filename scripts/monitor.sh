#!/bin/bash
# monitor.sh - Monitorizează CPU, RAM, disk

# Import configurare
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

# Creează directorul pentru logs
mkdir -p "$LOG_DIR"

# Fișierul de log
LOG_FILE="${LOG_DIR}/monitor_${DATE}.log"

# Funcție de logging
log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Funcție pentru CPU usage
get_cpu_usage() {
    # Media pe 1 secundă
    CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "$CPU"
}

# Funcție pentru RAM usage
get_ram_usage() {
    RAM=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "$RAM"
}

# Funcție pentru disk usage (partiția /)
get_disk_usage() {
    DISK=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    echo "$DISK"
}

# Start monitorizare
log "===== Monitor started ====="

# CPU
CPU_USAGE=$(get_cpu_usage)
log "CPU usage: ${CPU_USAGE}%"
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    log "⚠️ WARNING: CPU usage above ${CPU_THRESHOLD}%"
fi

# RAM
RAM_USAGE=$(get_ram_usage)
log "RAM usage: $(printf "%.2f" $RAM_USAGE)%"
if (( $(echo "$RAM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
    log "⚠️ WARNING: RAM usage above ${MEM_THRESHOLD}%"
fi

# Disk
DISK_USAGE=$(get_disk_usage)
log "Disk usage: ${DISK_USAGE}%"
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log "⚠️ WARNING: Disk usage above ${DISK_THRESHOLD}%"
fi

# Info suplimentare
log "Uptime: $(uptime -p)"
log "Load average: $(uptime | awk -F'load average:' '{print $2}')"
log "===== Monitor finished ====="

exit 0