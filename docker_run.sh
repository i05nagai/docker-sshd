#!/bin/bash

PATH_TO_THIS_DIR=$(cd $(dirname ${0});pwd)
source ${PATH_TO_THIS_DIR}/env.sh

docker run \
  --name sshd \
  --rm -it \
  --env HOME_USERS=${HOME_USERS} \
  --env HOME_SUDOERS=${HOME_SUDOERS} \
  --env DOCKER_HOST=${DOCKER_HOST} \
  --volume $(pwd)/templates/home:/srv/volume/home \
  i05nagai/sshd:latest
