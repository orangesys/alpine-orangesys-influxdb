#!/bin/bash

set -e

dir=.
if [ $# -gt 0 ]; then
  dir=("$@")
fi

log_msg() {
  echo "[$(date "+%Y/%m/%d %H:%M:%S %z")] $@"
}

docker_build() {
  # CircleCI cannot build docker images with --rm=true correctly.
  if [ -z "$CIRCLE_BUILD_NUM" ]; then
    docker build --rm=false "$@"
  else
    docker build --rm=true "$@"
  fi
}

docker_run() {
  # CircleCI cannot build docker images with --rm=true correctly.
  if [ -z "$CIRCLE_BUILD_NUM" ]; then
    docker run --rm=false "$@"
  else
    docker run --rm=true "$@"
  fi
}

log_msg "Verifying docker daemon connectivity"
docker version

failed_builds=()

# Gather directories with a Dockerfile and sanitize the path to remove leading
# a leading ./ and multiple slashes into a single slash.
dockerfiles=$(find "$dir" -name Dockerfile -print0 | xargs -0 -I{} dirname {} | sed 's@^./@@' | sed 's@//*@/@g')
for path in $dockerfiles; do
  # Generate a tag by replacing the first slash with a colon and all remaining slashes with a dash.
  tag=$(echo $path | sed 's@/@:@' | sed 's@/@-@g')
  log_msg "Building influxd-${tag} bin file"
  git clone -b v${tag} https://github.com/influxdata/influxdb.git
  curl -sL https://raw.githubusercontent.com/gavinzhou/influxdb/orangesys-logger-patch/services/httpd/response_logger.go > ./influxdb/services/httpd/response_logger.go
  if ! docker_build -f ./influxdb/Dockerfile_build_ubuntu64 -t influxdb-builder influxdb; then
    failed_builds+=("$tag")
  fi
  log_msg "Building docker image influxdb-builder"
done

if [ ${#failed_builds[@]} -eq 0 ]; then
  docker_run -v "$(pwd)/influxdb":/root/go/src/github.com/influxdata/influxdb influxdb-builder --package --static --release
  cp ./influxdb/build/influxdb-${tag}-static_linux_amd64.tar.gz ${tag}/
  log_msg "All builds succeeded."
else
  log_msg "Failed to build the following images:"
  for tag in ${failed_builds[@]}; do
    echo "	$tag"
  done
fi
rm -rf influxdb
