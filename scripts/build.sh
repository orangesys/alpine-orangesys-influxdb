#!/bin/bash

set -ex

version=$(git describe --always --tags|sed 's/^v//')
docker build --tag "orangesys/alpine-orangesys-influxdb:${version}" .
docker images