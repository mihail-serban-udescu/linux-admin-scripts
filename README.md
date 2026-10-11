# 🐧 Linux Admin Scripts

Collection of Bash scripts for Linux administration and DevOps operations.

## 📋 Scripts

| Script | Description |
|--------|-------------|
| `scripts/backup.sh` | Automated backup with timestamp, logging, and retention |

## 🛠️ Tech Stack

- **Bash** — shell scripting
- **Linux** — WSL 2 / Ubuntu
- **Git** — version control
- **Cron** — scheduling (planned)

## 📦 Installation

```bash
# Clone repository
git clone https://github.com/mihail-serban-udescu/linux-admin-scripts.git
cd linux-admin-scripts

# Make scripts executable
chmod +x scripts/*.sh
chmod +x config/*.sh
🚀 Usage
backup.sh
Creates a compressed .tar.gz archive of a folder, with logging and automatic cleanup.

bash
./scripts/backup.sh <source_folder> [backup_name]
Example:

bash
./scripts/backup.sh /home/user/documents documents
Output:

text
[2026-10-11 05:33:04] ===== Backup started =====
[2026-10-11 05:33:04] Source: /home/user/documents
[2026-10-11 05:33:04] Destination: /path/backups/documents_2026-10-11_05-33-04.tar.gz
[2026-10-11 05:33:04] SUCCESS: Backup created (4.0K)
[2026-10-11 05:33:04] Cleaning backups older than 7 days...
[2026-10-11 05:33:04] Old backups cleaned
[2026-10-11 05:33:04] ===== Backup finished =====
📁 Project Structure
text
linux-admin-scripts/
├── config/
│   └── config.sh          # Common variables
├── scripts/
│   └── backup.sh          # Backup script
├── logs/                  # Log files (gitignored)
├── backups/               # Backup archives (gitignored)
├── tests/                 # Tests (planned)
├── docs/                  # Documentation (planned)
├── .gitattributes         # Force LF line endings
├── .gitignore
└── README.md
✨ Features
✅ Logging — every action is logged with timestamp

✅ Error handling — graceful failure with exit codes

✅ Retention — old backups auto-deleted after 7 days

✅ Configurable — all settings in config/config.sh

✅ Portable — uses #!/bin/bash shebang

✅ LF line endings — enforced via .gitattributes

🎯 Roadmap
☑ backup.sh — backup with logging
□ cleanup.sh — remove old files
□ monitor.sh — CPU/RAM/disk monitoring
□ disk_alert.sh — disk space alerts
□ check_services.sh — verify services
□ log_rotate.sh — rotate logs
□ user_audit.sh — user audit
□ cron_setup.sh — cron job setup
📄 License
MIT