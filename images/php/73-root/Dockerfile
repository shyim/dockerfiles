FROM shyim/nginx-php-shopware:73

RUN echo 'user = root' >> /usr/local/etc/php-fpm.d/zz-docker.conf
RUN sed -i -e 's/\/usr\/local\/sbin\/php-fpm/\/usr\/local\/sbin\/php-fpm --allow-to-run-as-root/g' /etc/supervisord.conf