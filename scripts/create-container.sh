#!/bin/bash

set -ex

version=$(git describe --always --tags|sed 's/^v//')
docker build --tag "orangesys/${CIRCLE_PROJECT_REPONAME}:${version}" .
docker images