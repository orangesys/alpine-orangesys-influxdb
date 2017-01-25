FROM alpine:3.4
MAINTAINER gavin zhou <gavin.zhou@gmail.com>

ADD ./influxdb-*-static_linux_amd64.tar.gz /
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community dumb-init && \
    mkdir -p /influxdb/etc && \
    rm -f /influxdb-*/influxdb.conf && \
    chmod +x /influxdb-*/* && \
    cp -a /influxdb-*/* /usr/bin/ && \
    rm -rf *.tar.gz* /influxdb*
COPY config.docker/influxdb.conf /etc/influxdb/influxdb.conf

EXPOSE 8086

VOLUME /var/lib/influxdb

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["influxd", "-config=/etc/influxdb/influxdb.conf"]
