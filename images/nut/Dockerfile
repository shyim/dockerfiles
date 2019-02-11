FROM python:3-stretch

RUN git clone https://github.com/blawar/nut.git /root/nut --depth 1 && \
    cd /root/nut && \
    pip3 install colorama pyopenssl requests tqdm unidecode image bs4 urllib3 flask

ADD /entrypoint.sh /

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]