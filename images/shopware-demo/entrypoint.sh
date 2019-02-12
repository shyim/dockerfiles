#!/bin/sh

/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &
sleep 5

mysql shopware -e "UPDATE s_core_shops set host = '${VIRTUAL_HOST}'"
mysql shopware -e "UPDATE s_core_shops set secure = '${VIRTUAL_SSL}'"
rm -rf /var/www/html/var/cache/*

/usr/bin/supervisord -c /etc/supervisord.conf
