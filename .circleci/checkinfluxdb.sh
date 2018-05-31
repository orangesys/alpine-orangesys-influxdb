#!/bin/bash
set -ex

version=$(git describe --always --tags)
docker run -d --name influx -p 8086:8086 orangesys/alpine-orangesys-influxdb:${version}

docker run --network container:influx \
		orangesys/docker-curl -I 'http://127.0.0.1:8086/ping'

docker run --network container:influx \
		orangesys/docker-curl -sI 'http://127.0.0.1:8086/ping' | grep -q "X-Influxdb-Version"