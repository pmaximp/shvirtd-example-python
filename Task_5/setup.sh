#!/bin/bash

set -e

WORK_DIR="/opt"
BACKUP_DIR="/opt/backup"
PROJECT_NAME="shvirtd-example-python"
DOCKER_NETWORK="${PROJECT_NAME}_backend"

# Скрипт запускается только из под root
if [ "$EUID" -ne 0 ]; then
    echo "Use from root!"
    exit 1
fi

# Проверяем есть ли каталог для бэкапов
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p $BACKUP_DIR
fi

# Переходим в каталог для выполенения
cd $WORK_DIR/$PROJECT_NAME

echo "### Назначаем права ###"

# Назначаем права на файлы (иначе не работает)
chown 0:0 $(pwd)/Task_5/bin/setup_backup.sh && chmod 700 $(pwd)/Task_5/bin/setup_backup.sh
chown 0:0 $(pwd)/Task_5/bin/crontab && chmod 700 $(pwd)/Task_5/bin/crontab

echo "### Запускаем контейнер ###"

# Запускаем контейнер. Образ заранее загружен в CR yandex и настроен доступ.
docker run -it -d --network ${DOCKER_NETWORK} \
    -e MYSQL_HOST=${MYSQL_HOST} \
    -e MYSQL_USER=${MYSQL_USER} \
    -e MYSQL_DATABASE=${MYSQL_DATABASE} \
    -e MYSQL_PASSWORD=${MYSQL_PASSWORD} \
    -v /opt/backup:/backup \
    -v $(pwd)/Task_5/bin/setup_backup.sh:/usr/local/bin/setup_backup.sh \
    -v $(pwd)/Task_5/bin/crontab:/var/spool/cron/crontabs/root \ 
    --name hw4_t5_perman cr.yandex/crp48bqk06smf0548js4/mysqldump

# Ждем 1 минуту чтобы бэкап был готов
echo "### Бэкап создается... ###"

sleep 60

echo "### Бэкап находится по пути ${BACKUP_DIR} ###"