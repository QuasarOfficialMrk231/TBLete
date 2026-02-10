#!/bin/bash

# Коды клавиш: CTRL=29, R_SHIFT=54, F6=64, DELETE=111
K_CTRL=0; K_SHIFT=0; K_F6=0; K_DEL=0
TRIGGER_COUNT=0
LAST_TIME=0

# Поиск клавиатуры
KBD_DEV=$(grep -E 'Handlers|EV=' /proc/bus/input/devices | grep -B1 'EV=120013' | grep -oE 'event[0-9]+' | head -n1)
[ -z "$KBD_DEV" ] && exit 1

evtest /dev/input/$KBD_DEV | while read line; do
    # Отслеживаем нажатия (value 1) и отпускания (value 0)
    [[ $line == *"code 29 (KEY_LEFTCTRL), value 1"* ]] && K_CTRL=1
    [[ $line == *"code 29 (KEY_LEFTCTRL), value 0"* ]] && K_CTRL=0
    [[ $line == *"code 54 (KEY_RIGHTSHIFT), value 1"* ]] && K_SHIFT=1
    [[ $line == *"code 54 (KEY_RIGHTSHIFT), value 0"* ]] && K_SHIFT=0
    [[ $line == *"code 64 (KEY_F6), value 1"* ]] && K_F6=1
    [[ $line == *"code 64 (KEY_F6), value 0"* ]] && K_F6=0
    [[ $line == *"code 111 (KEY_DELETE), value 1"* ]] && K_DEL=1
    [[ $line == *"code 111 (KEY_DELETE), value 0"* ]] && K_DEL=0

    # Проверяем, зажат ли "аккорд"
    if [ $K_CTRL -eq 1 ] && [ $K_SHIFT -eq 1 ] && [ $K_F6 -eq 1 ] && [ $K_DEL -eq 1 ]; then
        NOW=$(date +%s)
        
        # Сброс счетчика, если прошло больше 5 секунд
        if (( NOW - LAST_TIME > 5 )); then
            TRIGGER_COUNT=1
        else
            ((TRIGGER_COUNT++))
        fi
        LAST_TIME=$NOW

        # Если нажали 3 раза подряд — запускаем финал
        if [ $TRIGGER_COUNT -ge 3 ]; then
            /bin/bash /usr/local/bin/emergency_wipe.sh &
            exit 0
        fi
        
        # Небольшая пауза, чтобы одно долгое нажатие не засчиталось за три
        sleep 0.5
    fi
done

