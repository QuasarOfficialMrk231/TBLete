#!/bin/bash

# --- 1. ПОДГОТОВКА ОКРУЖЕНИЯ (RAM) ---
WIPE_DIR="/dev/shm/.alpha_wipe"
mkdir -p $WIPE_DIR
# Копируем всё необходимое, включая библиотеки
cp /bin/bash /bin/rm /bin/dd /bin/lsblk /bin/grep /bin/awk /bin/sleep /sbin/ip /usr/sbin/nvme /sbin/hdparm /usr/bin/nmcli $WIPE_DIR/
export PATH=$WIPE_DIR:$PATH
cd $WIPE_DIR

# --- 2. СБРОС ЦИФРОВЫХ СЛЕДОВ ---
# MAC-адреса
for iface in $(ls /sys/class/net/ | grep -v lo); do
    ip link set dev $iface down
    ip link set dev $iface address 00:$((RANDOM%89+10)):$((RANDOM%89+10)):$((RANDOM%89+10)):$((RANDOM%89+10)):$((RANDOM%89+10))
    ip link set dev $iface up
done

# Wi-Fi и Сеть
nmcli networking off
rm -rf /etc/NetworkManager/system-connections/*
rm -rf /var/lib/bluetooth/*

# Очистка Machine ID и логов (делаем систему "новой")
echo "" > /etc/machine-id
echo "" > /var/lib/dbus/machine-id
rm -rf /var/log/*
rm -rf /var/tmp/*
rm -rf /tmp/*

# Сброс настроек DE (для всех пользователей)
for user_home in /home/*; do
    user_name=$(basename $user_home)
    # Пытаемся сбросить dconf, если есть сессия
    sudo -u $user_name DCONF_DBUS_RUN_SESSION=1 dconf reset -f /org/gnome/ 2>/dev/null
done

# --- 3. УНИЧТОЖЕНИЕ ДАННЫХ (SSD SECURE ERASE) ---
DISKS=$(lsblk -dno NAME,TRAN | grep -E 'nvme|sata' | awk '{print $1}')

for disk in $DISKS; do
    DEV="/dev/$disk"
    
    # 3.1 NVMe Secure Erase (Самый надежный метод)
    if [[ $disk == nvme* ]]; then
        # --ses=1 (User Data Erase), --crypto-erase (если доступно)
        nvme format $DEV --ses=1 -f > /dev/null 2>&1 || \
        nvme format $DEV --ses=2 -f > /dev/null 2>&1
    
    # 3.2 SATA SSD Secure Erase
    else
        # Снимаем парольную защиту, если была, и ставим временный пароль 'p'
        hdparm --user-master u --security-set-pass p $DEV > /dev/null 2>&1
        hdparm --user-master u --security-erase p $DEV > /dev/null 2>&1
    fi

    # 3.3 Резервный метод (Затирание метаданных и таблиц)
    # Трём начало и конец диска (где GPT/MBR)
    dd if=/dev/urandom of=$DEV bs=1M count=1024 conv=notrunc 2>/dev/null
    SIZE=$(blockdev --getsize64 $DEV)
    dd if=/dev/urandom of=$DEV bs=1M count=1024 seek=$(( (SIZE / 1048576) - 1024 )) 2>/dev/null
done

# --- 4. ФИНАЛ ---
sync
# Вызываем Kernel Panic и мгновенную перезагрузку
echo b > /proc/sysrq-trigger

