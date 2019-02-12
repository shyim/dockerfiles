FROM shyim/nginx-php-shopware:72

ARG SHOPWARE_DL=http://releases.s3.shopware.com.s3.amazonaws.com/install_5.5.6_9cb9f7b8f22ef979df1acd99b0e8071a6fbaf785.zip
ENV VIRTUAL_SSL 0

RUN apk add --no-cache mysql \
	mysql-client && \
	cd /var/www/html && \
    wget $SHOPWARE_DL && \
    unzip *.zip && \
    rm *.zip && \
    mysql_install_db && \
    chown -R mysql:mysql /var/lib/mysql

RUN /usr/bin/mysqld_safe --datadir='/var/lib/mysql' & sleep 2 && \
	mysql -e "CREATE DATABASE shopware" && \
	php /var/www/html/recovery/install/index.php --shop-host localhost --db-host localhost --db-socket /run/mysqld/mysqld.sock  --db-user root --db-name shopware --shop-locale en_GB --shop-currency EUR --admin-username demo   --admin-password demo --admin-email demo@foo.com --admin-locale en_GB --admin-name demo -n && \
	php /var/www/html/bin/console sw:firstrunwizard:disable && \
	php /var/www/html/bin/console sw:store:download SwagDemoDataEN && \
	php /var/www/html/bin/console sw:plugin:install --activate SwagDemoDataEN && \
	chown -R 1000:1000 /var/www/html

COPY entrypoint.sh /entrypoint.sh

CMD ["/bin/sh", "/entrypoint.sh"]
