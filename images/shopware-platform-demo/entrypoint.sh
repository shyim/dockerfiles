#!/bin/bash

/usr/bin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql & 
sleep 5

SCHEME="http"

if [[ ${VIRTUAL_SSL} == "1" ]]; then
    sed -i -e 's/<?php/<?php $_SERVER["HTTPS"] = true;/g' /var/www/html/public/index.php
    SCHEME="https"
fi

php /var/www/html/bin/console sales-channel:create:storefront --url="${SCHEME}://${VIRTUAL_HOST}"

if [[ $GENERATE_DEMODATA == "1" ]]; then
    php /var/www/html/bin/console framework:demodata
    php /var/www/html/bin/console dbal:refresh:index
fi;

if [[ ${DISABLE_BACKEND} == "1" ]]; then
	mkdir /var/www/html/admin
fi

if [[ ! -z ${PLUGIN_GIT_URL} ]]; then
    IFS=',' read -r -a GIT_URLS <<< "$PLUGIN_GIT_URL"
    IFS=',' read -r -a GIT_NAMES <<< "$PLUGIN_GIT_NAMES"

    for index in "${!GIT_URLS[@]}"
    do
        FOLDERNAME=$(basename ${GIT_URLS[index]})
        FOLDERNAME=$(echo ${FOLDERNAME} | sed 's/\.git//g')

        NAME=${GIT_NAMES[index]}
        echo "Checking out plugin: ${NAME}"

        cd /var/www/html/custom/plugins
        git clone ${GIT_URLS[index]}

        cd ${FOLDERNAME}

        /var/www/html/bin/console plugin:refresh
        /var/www/html/bin/console plugin:install ${NAME} --activate

        if [[ -e src/Resources/demo.sql ]]; then
            mysql shopware < src/Resources/demo.sql
        fi

        if [[ -e src/Resources/demo.sh ]]; then
            bash src/Resources/demo.sh
        fi

        cd /var/www/html/
    done
fi

rm -rf /var/www/html/var/cache/*

php /var/www/html/bin/console assets:install

rm -rf /var/www/html/var/cache/*

chown -R 1000:1000 /var/www/html

/usr/bin/supervisord -c /etc/supervisord.conf
