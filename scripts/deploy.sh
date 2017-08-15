#!/bin/bash

set -ex

version=$(git describe --always --tags|sed 's/^v//')

docker tag "orangesys/${CIRCLE_PROJECT_REPONAME}:${version}" "asia.gcr.io/saas-orangesys-io/${CIRCLE_PROJECT_REPONAME}:${version}"
docker tag "orangesys/${CIRCLE_PROJECT_REPONAME}:${version}" "quay.io/orangesys/${CIRCLE_PROJECT_REPONAME}:${version}"

docker push quay.io/orangesys/alpine-orangesys-influxdb:${version}
sudo /opt/google-cloud-sdk/bin/gcloud docker -- push asia.gcr.io/saas-orangesys-io/${CIRCLE_PROJECT_REPONAME}:${version}
docker logout
