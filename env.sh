#!/bin/bash

: ${PATH_TO_THIS_DIR:=$(cd $(dirname ${0});pwd)}
if [[ -e ${PATH_TO_THIS_DIR}/env_me.sh ]]
then
  source ${PATH_TO_THIS_DIR}/env_me.sh
fi

export DOCKER_REGISTRY_HOST=${DOCKER_REGISTRY_HOST:-""}
export DOCKER_IMAGE_BASE=${DOCKER_IMAGE_BASE:-""}
export HOME_USERS=${HOME_USERS:-""}
export HOME_SUDOERS=${HOME_SUDOERS:-""}
export HOME_SSHD_EXTRA_ARGS=${HOME_SSHD_EXTRA_ARGS:-""}
