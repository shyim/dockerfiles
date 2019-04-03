#!/usr/bin/env bash

phpVersions=(72 73)

for t in ${phpVersions[@]}; do
    echo "Building nginx container for php version $t"
    docker build -t shyim/nginx-php:${t} -f ../images/php/${t}/Dockerfile ../images/php/
done

for t in ${phpVersions[@]}; do
    echo "Building nginx container for php version $t"
    docker build -t shyim/nginx-php-public:${t} -f ../images/php-public/${t}/Dockerfile ../images/php-public/
done

for t in ${phpVersions[@]}; do
    echo "Building nginx container for php version $t"
    docker build -t shyim/nginx-php-shopware:${t} -f ../images/php-shopware/${t}/Dockerfile ../images/php-shopware/
done

docker build -t shyim/nginx-static -f ../images/static/noindex/Dockerfile ../images/static/
docker build -t shyim/nginx-static:autoindex -f ../images/static/index/Dockerfile ../images/static/
docker build -t shyim/nut -f ../images/nut/Dockerfile ../images/nut/
docker build -t shyim/shopware-demo:5.5.7 -f ../images/shopware-demo/Dockerfile ../images/shopware-demo/
docker build -t shyim/shopware-demo-de:5.5.7 -f ../images/shopware-demo/Dockerfile ../images/shopware-demo-de/
docker build -t shyim/nginx-php-root:73 -f ../images/php/73-root/Dockerfile ../images/php/73-root/