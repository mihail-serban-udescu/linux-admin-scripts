# 🐧 Linux Admin Scripts

Collection of Bash scripts for Linux administration and DevOps operations.

## 📋 Scripts

| Script | Description |
|--------|-------------|
| [`scripts/backup.sh`](scripts/backup.sh) | Automated backup with timestamp, logging, and retention |
| [`scripts/cleanup.sh`](scripts/cleanup.sh) | Remove old files with pattern matching and retention |
| [`scripts/monitor.sh`](scripts/monitor.sh) | Monitor CPU, RAM, and disk usage with threshold alerts |
| [`scripts/disk_alert.sh`](scripts/disk_alert.sh) | Check disk usage on all partitions, alert if > threshold |
| [`scripts/check_services.sh`](scripts/check_services.sh) | Verify services are running (systemctl/pgrep/ps fallback) |
| [`scripts/log_rotate.sh`](scripts/log_rotate.sh) | Rotate old logs (archive + remove + cleanup archives) |
| [`scripts/user_audit.sh`](scripts/user_audit.sh) | Audit users: UID, shell, last login, users without password |
| [`scripts/cron_setup.sh`](scripts/cron_setup.sh) | Generate cron entries for all scripts |

## 🛠️ Tech Stack

- **Bash** — shell scripting
- **Linux** — WSL 2 / Ubuntu
- **Coreutils** — `find`, `awk`, `sed`, `grep`, `df`, `free`, `tar`
- **Systemd tools** — `systemctl`, `journalctl`
- **Git** — version control
- **Cron** — scheduling

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
cleanup.sh
Removes files older than N days, with pattern matching and logging.

bash
./scripts/cleanup.sh <folder> [days] [pattern]
Example:

bash
./scripts/cleanup.sh /tmp/logs 30 "*.log"
monitor.sh
Reports CPU, RAM, and disk usage. Alerts if above thresholds.

bash
./scripts/monitor.sh
disk_alert.sh
Checks all partitions. Exits with code 1 if any partition is above threshold (useful for cron alerts).

bash
./scripts/disk_alert.sh [threshold]
Example:

bash
./scripts/disk_alert.sh 80
check_services.sh
Checks if services are running. Uses systemctl, falls back to pgrep and ps.

bash
./scripts/check_services.sh [service1 service2 ...]
Example:

bash
./scripts/check_services.sh ssh cron nginx
log_rotate.sh
Rotates old .log files (archives to .tar.gz, removes originals, cleans old archives).

bash
./scripts/log_rotate.sh <log_dir> [days]
Example:

bash
./scripts/log_rotate.sh /var/log 30
user_audit.sh
Audits users: UID, shell, last login, and checks for users without password.

bash
./scripts/user_audit.sh
cron_setup.sh
Generates cron entries for all scripts. Shows current crontab and recommended schedule.

bash
./scripts/cron_setup.sh
📁 Project Structure
text
linux-admin-scripts/
├── config/
│   └── config.sh          # Common variables
├── scripts/
│   ├── backup.sh          # Backup script
│   ├── cleanup.sh         # Cleanup old files
│   ├── monitor.sh         # CPU/RAM/disk monitoring
│   ├── disk_alert.sh      # Disk usage alerts
│   ├── check_services.sh  # Service checks
│   ├── log_rotate.sh      # Log rotation
│   ├── user_audit.sh      # User audit
│   └── cron_setup.sh      # Cron setup
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

✅ Retention — old backups auto-deleted after N days

✅ Configurable — all settings in config/config.sh

✅ Portable — uses #!/bin/bash shebang

✅ LF line endings — enforced via .gitattributes

✅ Exit codes — 0 for OK, 1 for alerts (cron-friendly)

✅ Fallbacks — service check tries systemctl, pgrep, ps

🎯 Cron Schedule Examples
Script	Schedule	Description
backup.sh	0 2 * * *	Daily at 2:00 AM
cleanup.sh	0 3 * * 0	Weekly on Sunday at 3:00 AM
monitor.sh	0 * * * *	Every hour
disk_alert.sh	0 */6 * * *	Every 6 hours
check_services.sh	*/15 * * * *	Every 15 minutes
log_rotate.sh	0 4 1 * *	Monthly (1st day, 4:00 AM)
user_audit.sh	0 5 * * 1	Weekly on Monday at 5:00 AM
Run ./scripts/cron_setup.sh to generate the exact cron lines.

🎯 Roadmap
☑ backup.sh — backup with logging
☑ cleanup.sh — remove old files
☑ monitor.sh — CPU/RAM/disk monitoring
☑ disk_alert.sh — disk space alerts
☑ check_services.sh — verify services
☑ log_rotate.sh — rotate logs
☑ user_audit.sh — user audit
☑ cron_setup.sh — cron job setup
□ Tests with bats (Bash Automated Testing System)
□ Docker container for testing
□ CI/CD with GitHub Actions
📄 License
MIT

