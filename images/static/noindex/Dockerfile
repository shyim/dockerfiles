FROM alpine

RUN apk add --no-cache \
      nginx \
      supervisor

COPY rootfs/ /
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]