#!/bin/bash
apt update
apt install -y evtest nvme-cli hdparm coreutils
chmod +x /usr/local/bin/system_watcher.sh
chmod +x /usr/local/bin/emergency_wipe.sh
systemctl daemon-reload
systemctl enable watcher.service
systemctl start watcher.service
echo "Система защиты активирована."

