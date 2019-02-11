FROM alpine

RUN apk add --no-cache \
      nginx \
      supervisor

COPY rootfs/ /
COPY index/10-docker.conf /etc/nginx/sites-enabled/10-docker.conf
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]