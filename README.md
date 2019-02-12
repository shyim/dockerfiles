# dockerfiles

This repo contains some images for jwilder`s nginx-proxy.

* shyim/nginx-static:latest
  * Nginx Server for static serving
* shyim/nginx-static:autoindex
  * Nginx Server for static serving, with enabled autoindex
* shyim/nginx-php:73 , shyim/nginx-php:72
  * Nginx Server with PHP-FPM and try_files to index.php
* shyim/nginx-php-public:73 , shyim/nginx-php-public:72
  * Nginx Server with PHP-FPM and try_files to index.php and root located in public
* shyim/nginx-php-shopware:73 , shyim/nginx-php-shopware:72
  * Nginx Server with PHP-FPM and Shopware Nginx Rules
* shyim/nut
  * Nut Server
  
The files should be mounted into ``/var/www/html``
