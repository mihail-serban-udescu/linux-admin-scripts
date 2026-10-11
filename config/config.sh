#!/bin/bash
# config.sh - Variabile comune pentru toate scripturile

# Directorul rădăcină al proiectului
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Directorul pentru logs
LOG_DIR="${PROJECT_ROOT}/logs"

# Directorul pentru backup
BACKUP_DIR="${PROJECT_ROOT}/backups"

# Data curentă (format YYYY-MM-DD)
DATE=$(date +%Y-%m-%d)

# Timestamp (format YYYY-MM-DD_HH-MM-SS)
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

# Directorul pentru backup-uri vechi
TEMP_DIR="${PROJECT_ROOT}/tmp"

# Câte zile păstrăm backup-urile
RETENTION_DAYS=7

# Threshold disk (%)
DISK_THRESHOLD=80

# Threshold memorie (%)
MEM_THRESHOLD=80

# Threshold CPU (%)
CPU_THRESHOLD=80