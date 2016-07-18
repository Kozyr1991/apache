#!/bin/bash

set -e

if [ ! -d /home/mysql ]
then
mkdir /home/mysql    
mysql_install_db  
chown -R mysql:mysql /home/mysql
/usr/bin/mysqld_safe &  
sleep 10s
mysqladmin -u root password $MYSQL_ROOT_PASSWORD
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE $MYSQL_DATABASE; GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'localhost$
sleep 10s

else
   touch /check.txt
fi
exec "$@"
