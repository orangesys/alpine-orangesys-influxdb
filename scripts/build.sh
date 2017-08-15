#!/bin/bash

set -ex

version=$(git describe --always --tags|sed 's/^v//')
docker -t "orangesys/alpine-orangesys-influxdb:${version}" .