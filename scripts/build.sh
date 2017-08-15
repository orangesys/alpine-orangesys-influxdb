#!/bin/bash

set -ex

version=$(git describe --always --tags|sed 's/^v//')
docker_build -t "orangesys/alpine-orangesys-influxdb:${version}" .