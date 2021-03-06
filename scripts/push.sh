#!/usr/bin/env bash

phpVersions=(72 73)

for t in ${phpVersions[@]}; do
    docker push shyim/nginx-php:${t}
done

for t in ${phpVersions[@]}; do
    docker push shyim/nginx-php-public:${t}
done

for t in ${phpVersions[@]}; do
    docker push shyim/nginx-php-shopware:${t}
done

docker push shyim/nginx-static
docker push shyim/nginx-static:autoindex
docker push shyim/nut
docker push shyim/shopware-demo:5.5.7
docker push shyim/shopware-demo-de:5.5.7
docker push shyim/nginx-php-root:73