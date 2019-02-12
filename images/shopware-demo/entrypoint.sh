#!/bin/sh

/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &
sleep 5

mysql shopware -e "UPDATE s_core_shops set host = '${VIRTUAL_HOST}'"
mysql shopware -e "UPDATE s_core_shops set secure = '${VIRTUAL_SSL}'"

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

    /var/www/html/bin/console sw:plugin:refresh
    /var/www/html/bin/console sw:plugin:install $name --activate
fi

rm -rf /var/www/html/var/cache/*

/usr/bin/supervisord -c /etc/supervisord.conf
