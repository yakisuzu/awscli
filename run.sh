#!/usr/bin/env bash
pushd `dirname $0` > /dev/null

SERVICE_NAME="awscli"
IMAGE_TAG="latest"

TMP_AWS_ACCESS_KEY="$1"
TMP_AWS_SECRET_KEY="$2"
TMP_AWS_REGION="$3"
TMP_NO_CACHE="$4"

if [ "$TMP_AWS_ACCESS_KEY" = "" ]; then
  echo Require AWS_ACCESS_KEY_ID >&2
  popd > /dev/null & exit
fi
if [ "$TMP_AWS_SECRET_KEY" = "" ]; then
  echo Require AWS_SECRET_ACCESS_KEY >&2
  popd > /dev/null & exit
fi
if [ "$TMP_AWS_REGION" = "" ]; then
  # Asia(TOKYO)
  TMP_AWS_REGION="ap-northeast-1"
fi
if [ "$TMP_NO_CACHE" = "" ]; then
  TMP_NO_CACHE="false"
else
  TMP_NO_CACHE="true"
fi

echo
echo [docker build start]
docker build --no-cache=$TMP_NO_CACHE -t ${SERVICE_NAME}:${IMAGE_TAG} .

echo
echo [docker run start]
if [ "$HOME" != "" ]; then
  MOUNT_HOST_DIR="/$HOME"
else
  MOUNT_HOST_DIR="/$USERPROFILE"
fi
MOUNT_DOCKER_DIR="/mnt/hosthome"
TMP_MOUNT="${MOUNT_HOST_DIR}:${MOUNT_DOCKER_DIR}"
echo run image=${SERVICE_NAME}:${IMAGE_TAG} mount=$TMP_MOUNT

echo
docker run --rm \
  -e AWS_ACCESS_KEY_ID=$TMP_AWS_ACCESS_KEY \
  -e AWS_SECRET_ACCESS_KEY=$TMP_AWS_SECRET_KEY \
  -e AWS_DEFAULT_REGION=$TMP_AWS_REGION \
  -v $TMP_MOUNT \
  -it ${SERVICE_NAME}:${IMAGE_TAG}

popd > /dev/null
