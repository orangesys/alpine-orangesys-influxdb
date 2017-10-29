FROM alpine:3.6
MAINTAINER gavin zhou <gavin.zhou@gmail.com>

ENV INFLUXDB_VERSION 1.3.7
RUN echo 'hosts: files dns' >> /etc/nsswitch.conf && \
    apk add --no-cache tzdata && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community dumb-init && \
    set -ex && \
    apk add --no-cache --virtual .build-deps wget gnupg tar ca-certificates && \
    update-ca-certificates && \
    for key in \
        05CE15085FC09D18E99EFB22684A14CF2582E0C5 ; \
    do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
        gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
    done && \
    wget -q https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz.asc && \
    wget -q https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    gpg --batch --verify influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz.asc influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    mkdir -p /usr/src && \
    tar -xzf influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    chmod +x /usr/bin/influx_inspect /usr/bin/influx_stress /usr/bin/influxd /usr/bin/influx_tsm /usr/bin/influx && \
    rm -rf *.tar.gz* /usr/src /root/.gnupg /etc/influxdb/influxdb.conf && \
    apk del .build-deps

COPY config.docker/influxdb.conf /etc/influxdb/influxdb.conf

EXPOSE 8086

VOLUME /var/lib/influxdb

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["influxd"]
