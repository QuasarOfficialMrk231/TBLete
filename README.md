# TBLete
Скрипт TBLete будет работать в 90% дистрибутивов Linux, таких как Kali Linux, Ubuntu, Linux Mint, Debian, Fedora, Manjaro и др. Система совместима с любым дистрибутивом, использующим systemd и имеющим в репозиториях пакеты evtest, nvme-cli и hdparm.
#### Инициализатор после установки это нажатие в течении 5 секунд 3 раза комбинации:
**F6 + Right Shift + Delete + Ctrl одновременно**
#### Рекомендуется иметь флешку с образом GParted (ниже ссылки) для востановления разметки на SSD накопителях.
### ​TBLete (Dead Man's Switch)
​Инструмент для мгновенного уничтожения данных и глубокой очистки системы при нажатии комбинации клавиш Ctrl + F6 + Right Shift + Delete (трижды). Разработан для сценариев, когда необходимо полностью исключить возможность извлечения информации с устройства при физическом захвате.
​Низкоуровневое уничтожение: Выполняет nvme format --ses=1 для NVMe или security-erase для SATA SSD. Эти команды отдаются напрямую контроллеру диска, который физически обнуляет все ячейки памяти или сбрасывает криптографический ключ доступа к данным.
##### ​Гарантированный результат: После выполнения команды восстановление данных невозможно даже в специализированных лабораториях криминалистики или с использованием дорогостоящего оборудования, так как данные уничтожаются на физическом уровне (уровень электрических зарядов в ячейках NAND).
​Затирание метаданных: Дополнительно использует dd для перезаписи начала и конца диска случайным мусором, что уничтожает таблицы разделов и файловые системы.
##### ​Анонимизация: Скрипт подменяет MAC-адреса, удаляет все журналы событий (/var/log), историю сетевых подключений Wi-Fi и уникальный Machine ID, делая систему «чистой» и неидентифицируемой.
​Устойчивость процесса: Система копирует интерпретатор и все утилиты в оперативную память (/dev/shm), поэтому процесс не прервется даже тогда, когда файловая система на диске будет уже уничтожена.
##### **Скрипт ничего не уничтожает физически**
Для восстановления SSD потребуется заново создать таблицу разделов, скачав стороннюю программу GParted. Вот ссылка на официальный сайт:
##### https://gparted.org/download.php
##### ​Для amd64 (64-бит процессоры)
[​gparted-live-1.6.0-3-amd64.iso](https://downloads.sourceforge.net/gparted/gparted-live-1.6.0-3-amd64.iso)
##### ​Для x86 (32-бит процессоры)
​[gparted-live-1.6.0-3-i686.iso](https://downloads.sourceforge.net/gparted/gparted-live-1.6.0-3-i686.iso)
##### ​Для x86-pae (32-бит процессоры)
[​gparted-live-1.6.0-3-i686-pae.iso](https://downloads.sourceforge.net/gparted/gparted-live-1.6.0-3-i686-pae.iso)  
#### Краткая инструкция:
##### ​Запишите образ на флешку и загрузитесь с неё.
​В GParted выберите диск и нажмите Device -> Create Partition Table -> gpt.
​Создайте новый раздел (New) и нажмите Apply. 
## ​Список дистрибутивов, где скрипт НЕ БУДЕТ РАБОТАТЬ
​В данных системах отсутствует systemd или используется иная логика управления устройствами, что делает невозможным автозапуск и работу службы в текущем виде:  
##### Alpine Linux
##### Devuan
##### ​Artix Linux
##### ​Void Linux
##### ​MX Linux (в режиме по умолчанию)
##### ​antiX
##### ​Gentoo
##### ​Slackware
##### ​NixOS
##### ​PCLinuxOS
##### ​Puppy Linux
##### ​Guix System
##### ​Tiny Core Linux
##### Android (Termux)
##### ​Любые Docker-контейнеры
## Как установить:
```bash
sudo bash -c "wget -qO /usr/local/bin/emergency_wipe.sh https://raw.githubusercontent.com/QuasarOfficialMrk231/TBLete/main/emergency_wipe.sh && wget -qO /usr/local/bin/system_watcher.sh https://raw.githubusercontent.com/QuasarOfficialMrk231/TBLete/main/system_wather.sh && wget -qO /etc/systemd/system/watcher.service https://raw.githubusercontent.com/QuasarOfficialMrk231/TBLete/main/watcher.service && wget -qO /tmp/start.sh https://raw.githubusercontent.com/QuasarOfficialMrk231/TBLete/main/start.sh && chmod +x /tmp/start.sh && /tmp/start.sh"
```
