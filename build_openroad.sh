#!/bin/bash
# This script builds the OpenROAD tools locally

# Exit on first error
set -e

# Choose install method
if which docker &> /dev/null; then
  echo "INFO: using docker build method. This will create a docker image tagged 'openroad/flow'"
  build_method="DOCKER"
else
  echo "INFO: using local build method. This will create binaries at tools/build/"
  build_method="LOCAL"
fi

# Clone repositories
if [ -z ${OPENROAD_FLOW_NO_GIT_INIT+x} ]; then
  git submodule update --init --recursive
fi

if [ -d flow/platforms/gf14 ]; then
  if [ -d tools/TritonRoute14 ]; then
    git -C tools/TritonRoute14 pull || true
  else
    git -C tools clone git@github.com:The-OpenROAD-Project/TritonRoute14.git || true
  fi
fi

# Docker build
if [ "$build_method" == "DOCKER" ]; then
  docker build -t openroad/yosys -f tools/yosys/Dockerfile tools/yosys
  docker build -t openroad/tritonroute -f tools/TritonRoute/Dockerfile tools/TritonRoute
  docker build -t openroad -f tools/OpenROAD/Dockerfile tools/OpenROAD
  docker build -t openroad/flow -f Dockerfile .
  if [ -d flow/platforms/gf14 ]; then
    docker build -t openroad/tritonroute14 -f tools/TritonRoute14/Dockerfile tools/TritonRoute14
    docker build -t openroad/flow14 -f jenkins/docker/14.Dockerfile .
  fi

# Local build
elif [ "$build_method" == "LOCAL" ]; then
  mkdir -p tools/build/yosys
  (cd tools/yosys && make install -j$(nproc) PREFIX=../build/yosys CONFIG=gcc TCL_VERSION=tcl8.5)

  mkdir -p tools/build/TritonRoute
  (cd tools/build/TritonRoute && cmake ../../TritonRoute && make -j$(nproc))

  mkdir -p tools/build/OpenROAD
  (cd tools/build/OpenROAD && cmake ../../OpenROAD && make -j$(nproc))
else
  echo "ERROR: No valid build method found"
  exit 1
fi
