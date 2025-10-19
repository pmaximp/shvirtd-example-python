#!/bin/ash

/usr/bin/env | /bin/grep MYSQL > ~/.mysql_env
/bin/chmod u+x ~/.mysql_env
~/.mysql_env 

now=$(/bin/date +"%s_%Y-%m-%d")
/usr/bin/mysqldump --opt -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} > "/backup/${now}_${MYSQL_DATABASE}.sql"
