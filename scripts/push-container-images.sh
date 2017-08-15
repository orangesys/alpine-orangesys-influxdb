#!/bin/bash
set -ex
_v=$(git describe --always --tags)
version=${_v#*v}  

docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
docker push "orangesys/${CIRCLE_PROJECT_REPONAME}:${version}"

echo $GCLOUD_SERVICE_KEY | base64 --decode -i > ${HOME}/account-auth.json
gcloud auth activate-service-account --key-file ${HOME}/account-auth.json
gcloud config set project $PROJECT_NAME
docker tag "orangesys/${CIRCLE_PROJECT_REPONAME}:${version}" "asia.gcr.io/saas-orangesys-io/${CIRCLE_PROJECT_REPONAME}:${version}"
gcloud docker -- push "asia.gcr.io/saas-orangesys-io/${CIRCLE_PROJECT_REPONAME}:${version}"

docker images
docker logout
curl -X POST https://hooks.microbadger.com/images/orangesys/alpine-orangesys-influxdb/MxMCnhHfqsOnIeY8lsp535xrNYQ=