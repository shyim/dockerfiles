FROM php:7.3-fpm-alpine

RUN apk add --no-cache \
      nginx \
      supervisor \
	  shadow \
	  bzip2-dev \
      ca-certificates \
      freetype \
      freetype-dev \
      git \
      icu-dev \
      libjpeg-turbo \
      libjpeg-turbo-dev \
      libmcrypt-dev \
      libpng \
      libpng-dev \
      mysql-client \
      pcre-dev \
      libzip-dev \
      unzip \
      libsodium-dev \
      wget && \
    apk add --no-cache --virtual build-deps \
      coreutils \
      build-base \
      autoconf \
      automake && \
    docker-php-ext-configure gd \
      --with-gd \
      --with-freetype-dir=/usr/include/ \
      --with-png-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) \
      bcmath \
      gd \
      intl \
      mysqli \
      pdo_mysql \
      sockets \
      bz2 \
      sodium \
      zip && \
    update-ca-certificates && \
    ln -s /usr/local/bin/php /usr/bin/php && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -rf /var/lib/nginx/tmp && \
    ln -sf /tmp /var/lib/nginx/tmp && \
    mkdir /etc/supervisor.d/ && \
    chown -R www-data:www-data /var/lib/nginx /var/tmp/nginx/ && \
    chmod 777 -R /var/tmp/nginx/ && \
    pecl install redis apcu && \
    docker-php-ext-enable redis apcu && \
    apk del build-deps && \
    rm -rf /tmp/* && \
    chown -R www-data:www-data /var/www && \
    usermod -u 1000 www-data && \
    apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

COPY rootfs/etc/nginx /etc/nginx
COPY rootfs/etc/supervisord.conf /etc/supervisord.conf
COPY rootfs/usr/local/etc/php/conf.d/docker.ini /usr/local/etc/php/conf.d/docker.ini

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]