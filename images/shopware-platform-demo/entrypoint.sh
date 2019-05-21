#!/bin/sh

/usr/bin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql & 
sleep 5

SCHEME="http"

if [[ $VIRTUAL_SSL == "1" ]]; then
    sed -i -e 's/<?php/<?php $_SERVER["HTTPS"] = true;/g' /var/www/html/public/index.php
    SCHEME="https"
fi

php /var/www/html/bin/console sales-channel:create:storefront --url="${SCHEME}://${VIRTUAL_HOST}"

php /var/www/html/bin/console framework:demodata
php /var/www/html/bin/console dbal:refresh:index

if [[ $DISABLE_BACKEND == "1" ]]; then
	mkdir /var/www/html/admin
fi


if [[ ! -z $PLUGIN_GIT_URL ]]; then
    name=$(basename $PLUGIN_GIT_URL)
    name=$(echo $name | sed 's/\.git//g')

    echo "Checking out plugin: $name"

    cd /var/www/html/custom/plugins
    git clone $PLUGIN_GIT_URL

    if [[ ! -z $PLUGIN_GIT_COMMIT ]]; then
        echo "Checking out commit: $PLUGIN_GIT_COMMIT"
        git checkout $PLUGIN_GIT_COMMIT
    fi

    cd $name
    if [[ -e composer.json ]]; then
        composer install -o --no-dev
    fi

    /var/www/html/bin/console plugin:refresh
    /var/www/html/bin/console plugin:install $INSTALL_NAME --activate

    if [[ -e src/Resources/demo.sql ]]; then
    	mysql shopware < src/Resources/demo.sql
    fi

    if [[ -e src/Resources/demo.sh ]]; then
        bash src/Resources/demo.sh
    fi
fi

rm -rf /var/www/html/var/cache/*

/usr/bin/supervisord -c /etc/supervisord.conf
