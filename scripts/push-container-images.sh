#!/bin/bash
set -ex
_v=$(git describe --always --tags)
version=${_v#*v}  

docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
docker push "orangesys/alpine-orangeapi:${version}"

echo $GCLOUD_SERVICE_KEY | base64 --decode -i > ${HOME}/account-auth.json
gcloud auth activate-service-account --key-file ${HOME}/account-auth.json
gcloud config set project $PROJECT_NAME
gcloud docker -- push asia.gcr.io/saas-orangesys-io/alpine-orangeapi:${version}

docker logout
curl -X POST https://hooks.microbadger.com/images/orangesys/alpine-orangeapi/_24B4d4BBsQhsH6Av_nH1ZKsl2s=