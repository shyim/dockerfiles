FROM alpine:edge as builder

RUN apk add --no-cache git nodejs npm composer mysql mysql-client php7-tokenizer php7-xml php7-xmlreader php7-zip php7-posix php7-session php7-simplexml php7-soap php7-openssl php7-pdo php7-pdo_mysql php7-gettext php7-gmp php7-iconv php7-intl php7-json php7-mbstring php7-mysqli php7-curl php7-dom php7-bz2 php7-gd php7-xmlwriter php7-fileinfo unzip 

RUN git clone https://github.com/shopware/development.git

RUN composer global require hirak/prestissimo

RUN cd development && composer install

RUN mysql_install_db --datadir=/var/lib/mysql --user=mysql

ENV APP_ENV prod
ENV APP_SECRET 8583a6ff63c5894a3195331701749943
ENV APP_URL localhost
ENV MAILER_URL null://localhost
ENV DATABASE_URL mysql://root@localhost:3306/shopware
ENV COMPOSER_HOME /tmp/

RUN touch /development/.env

RUN npm install -g npm

RUN cd development && mkdir /run/mysqld/ && chown -R mysql:mysql /run/mysqld/ && /usr/bin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql & sleep 2 && \
	mysql -e "CREATE DATABASE shopware DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci" && \
	cd /development && \
	mysql shopware < vendor/shopware/platform/src/Core/schema.sql && \
	bin/console database:migrate --all Shopware\\ && \
	bin/console database:migrate-destructive --all Shopware\\ && \
	bin/console administration:dump:bundles && \
	bin/console scheduled-task:register && \
	bin/console user:create admin --password=shopware && \
	bin/console framework:demodata && \
	bin/console dbal:refresh:index && \
	# Admin
	npm --prefix vendor/shopware/platform/src/Administration/Resources/administration/ install && \
	PROJECT_ROOT=/development npm run --prefix vendor/shopware/platform/src/Administration/Resources/administration/ build && \
	# Frontend
	npm --prefix vendor/shopware/platform/src/Storefront/Resources/ install && \
	PROJECT_ROOT=/development/ npm --prefix vendor/shopware/platform/src/Storefront/Resources/ run production && \
	php bin/console assets:install && \
	mysqldump shopware > install.sql

RUN cd /development && php dev-ops/generate_ssl.php

RUN cd /development && \
	rm -rf .git \
    psh.phar \
    dev-ops \
    .idea \
    .psh* \
    docker* \
    *.sh \
    output \
    var/cache/* \
    bin/deleted_files_vendor \
    vendor/shopware/platform/src/Administration/Resources/administration \
    vendor/shopware/platform/src/Administration/Resources/nuxt-component-library \
    vendor/shopware/platform/src/Administration/Resources/e2e \
    vendor/shopware/platform/src/Storefront/Resources/node_modules \
    vendor/shopware/platform/src/Core/Framework/Test \
    vendor/shopware/platform/src/Core/Content/Test \
    vendor/shopware/platform/src/Core/Checkout/Test \
    vendor/shopware/platform/bin \
    vendor/symfony/*/Tests \
    vendor/twig/twig/test \
    vendor/swiftmailer/swiftmailer/tests \
    vendor/google/auth/tests \
    vendor/monolog/monolog/tests \
    vendor/phenx/php-font-lib/sample-fonts \
    vendor/shopware/platform/.git


FROM shyim/nginx-php-public:73

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=builder /development /var/www/html

ENV VIRTUAL_SSL 0
ENV DISABLE_BACKEND 1
ENV APP_ENV prod
ENV APP_SECRET 8583a6ff63c5894a3195331701749943
ENV APP_URL localhost
ENV MAILER_URL null://localhost
ENV DATABASE_URL mysql://root@localhost:3306/shopware
ENV COMPOSER_HOME /tmp/

RUN apk add --no-cache mysql \
	mysql-client \
	git && \
    mysql_install_db --datadir=/var/lib/mysql --user=mysql &&\
	echo "pdo_mysql.default_socket=/run/mysqld/mysqld.sock" > /usr/local/etc/php/conf.d/mysql.ini

RUN mkdir /run/mysqld/ && chown -R mysql:mysql /run/mysqld/ && /usr/bin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql & sleep 2 && \
	mysql -e "CREATE DATABASE shopware" && \
	cd /var/www/html/ && \
	mysql shopware < install.sql && \
	rm install.sql && \
	chown -R 1000:1000 /var/www/html

COPY entrypoint.sh /entrypoint.sh

CMD ["/bin/sh", "/entrypoint.sh"]
