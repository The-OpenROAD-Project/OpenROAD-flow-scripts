#!/bin/bash
# This script builds the OpenROAD tools locally

# Exit on first error
set -e

function usage() {
  echo "Usage: $0 [-h|--help] [-l|--latest] [-o|--local] [--or_branch] [--tr_branch]"
  echo "  -h, --help          print this help message"
  echo "  -l, --latest        build using the head of branch 'openroad' for OpenROAD"
  echo "                      and TritonRoute"
  echo "  -o, --local         force local build instead of docker build"
  echo "  --or_branch BRANCH  build using the head of branch BRANCH for OpenROAD"
  echo "  --tr_branch BRANCH  build using the head of branch BRANCH for TritonRoute"

  echo "This script builds the openroad tools (OpenROAD, yosys, TritonRoute)"
  echo "By default, the tools will be built from the linked submodule hashes"
  echo "Using -b or -l will By default, the tools will be built from the linked submodule hashes"
}

# Parse arguments
while (( "$#" )); do
  case "$1" in
    -h|--help)
      usage 2> /dev/null
      exit
      ;;
    --or_branch)
      OR_BRANCH=$2
      shift 2
      ;;
    --tr_branch)
      TR_BRANCH=$2
      shift 2
      ;;
    -l|--latest)
      OR_BRANCH="openroad"
      TR_BRANCH="openroad"
      shift
      break
      ;;
    -o|--local)
      BUILD_METHOD="LOCAL"
      shift
      break
      ;;
    -n|--no_init)
      NO_INIT=1
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "[ERROR][FLOW-1000] Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# Choose install method
if [ -z ${BUILD_METHOD+x} ] && which docker &> /dev/null; then
  echo "[INFO][FLOW-0000] using docker build method. This will create a docker image tagged 'openroad/flow'"
  build_method="DOCKER"
else
  echo "[INFO][FLOW-0000] using local build method. This will create binaries at tools/build/"
  build_method="LOCAL"
fi

# Clone repositories
if [ -z ${OPENROAD_FLOW_NO_GIT_INIT+x} ]; then
  git submodule update --init --recursive
fi

if [ ! -z ${OR_BRANCH+x} ]; then
  (cd tools/OpenROAD && git checkout ${OR_BRANCH} && git pull && git submodule update --init --recursive)
fi
if [ ! -z ${TR_BRANCH+x} ]; then
  (cd tools/TritonRoute && git checkout ${TR_BRANCH} && git pull)
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
