#!/bin/bash -x

DESIGN=$1
PLATFORM=$2

user_id="$(id -u ${USER}):$(id -g ${USER})"
flow_mount="$(pwd)/flow:/OpenROAD-flow/flow"
tr_mount="$(pwd)/flow/tools/TritonRoute14:/OpenROAD-flow/flow/tools/TritonRoute14"

if [ "${PLATFORM}" = "gf14" ]; then
  docker_tag="openroad/flow14"
else
  docker_tag="openroad/flow"
fi

docker_script="source setup_env.sh && \
  cd flow/flow && \
  test/test_helper.sh ${DESIGN} ${PLATFORM}; \
  status=\$?; \
  make metadata DESIGN_CONFIG=designs/${PLATFORM}/${DESIGN}.mk && exit \$status"

docker run --rm -u ${user_id} -v ${flow_mount} -v ${tr_mount} ${docker_tag} bash -xc "${docker_script}"
