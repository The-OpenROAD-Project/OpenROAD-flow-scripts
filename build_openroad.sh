#!/bin/bash
# This script builds the OpenROAD tools locally

# Exit on first error
set -e

function usage() {
  echo "Usage: $0 [-h|--help] [-l|--latest] [-o|--local] [--or_branch]"
  echo "  -h, --help              print this help message"
  echo "  -d, --dev_repo          (dev only) perform git pull on developer repositories"
  echo "  -l, --latest            build using the head of branch --or_branch or 'master' by default for OpenROAD"
  echo "  -o, --local             force local build instead of docker build"
  echo "  -p, --platform          perform git pull on all git-based platform repos"
  echo "  --or_branch BRANCH      build using the head of branch BRANCH for OpenROAD"
  echo "  --or_repo REPO-URL      build using a fork at REPO-URL(https/ssh) for OpenROAD"
  echo "  -n, --nice              build using all cpus but nice the jobs"
  echo "  --no_init               Skip initializing submodules"
  echo "  -c, --copy-platforms"   copy platforms to inside docker image

  echo "This script builds the openroad tools (OpenROAD, yosys)"
  echo "By default, the tools will be built from the linked submodule hashes"
}

# defaults
NICE=""
PROC=`nproc`
COPY_PLATFORMS="NO"
DOCKER_TAG="openroad/flow-scripts"
CURRENT_REMOTE="origin"
OR_BRANCH="master"

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
    --or_repo)
      OR_REPO=$2
      shift 2
      ;;
    -d|--dev_repo)
      UPDATE_PRIVATE=1
      shift
      ;;
    -l|--latest)
      UPDATE_OR=1
      shift
      ;;
    -n|--nice)
      NICE="nice"
      PROC=`nproc --all`
      shift
      ;;
    -o|--local)
      BUILD_METHOD="LOCAL"
      shift
      ;;
    -p|--platform)
      UPDATE_PLATFORM=1
      shift
      ;;
    --no_init)
      OPENROAD_FLOW_NO_INIT=1
      shift
      ;;
    -c|--copy-platforms)
      COPY_PLATFORMS="YES"
      shift
      ;;
    -*|--*=) # unsupported flags
      echo "[ERROR][FLOW-0004] Unsupported flag $1" >&2
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
  echo "[INFO FLOW-0000] Using docker build method. This will create a docker image tagged '${DOCKER_TAG}'"
  build_method="DOCKER"
else
  echo "[INFO FLOW-0000] Using local build method. This will create binaries at tools/install/"
  build_method="LOCAL"
fi

# Clone repositories
if [ -z ${OPENROAD_FLOW_NO_GIT_INIT+x} ]; then
  git submodule update --init --recursive
fi


if [ ! -z ${OR_REPO+x} ]; then
  base_url=$(dirname $OR_REPO)
  [[ ${base_url##*/} = $base_url ]] && CURRENT_REMOTE=${base_url##*:} || CURRENT_REMOTE=${base_url##*/}
  remotes=$(git --git-dir tools/OpenROAD/.git remote)
  SAVEIFS=$IFS
  IFS=$'\n'
  remotes=($remotes)
  IFS=$SAVEIFS
  if [[ ! " ${remotes[@]} " =~ " ${CURRENT_REMOTE} " ]]; then
    git --git-dir tools/OpenROAD/.git remote add $CURRENT_REMOTE $OR_REPO
  fi
fi


if [ ! -z ${UPDATE_OR+x} ]; then
  echo "[INFO FLOW-0005] Updating OpenROAD tool to the latest"
  (cd tools/OpenROAD && git fetch $CURRENT_REMOTE $OR_BRANCH \
    && git checkout $CURRENT_REMOTE/$OR_BRANCH \
    && git pull $CURRENT_REMOTE $OR_BRANCH \
    && git submodule update --init --recursive)
fi

# Update platforms
if [ ! -z ${UPDATE_PLATFORM+x} ]; then
  for dir in flow/platforms/*/ ; do
    if [ -d $dir/.git ]; then
      echo "[INFO FLOW-0001] Updating git repository '$dir'"
      (cd $dir && git pull)
    else
      echo "[INFO FLOW-0002] Directory '$dir' is not a git repository. Skipping update."
    fi
  done
fi

# Update developer repos
if [ ! -z ${UPDATE_PRIVATE+x} ]; then
  if [ -d flow/private ]; then
    echo "[INFO FLOW-0001] Updating git repository 'private'"
    (cd flow/private && git pull)
  else
    echo "[INFO FLOW-0002] Directory 'flow/private' is not a git repository. Skipping update."
  fi
fi

# Docker build
if [ "$build_method" == "DOCKER" ]; then
  docker build --tag openroad/yosys --file tools/yosys_util/Dockerfile --target builder tools/yosys
  docker build --tag openroad/lsoracle --file tools/LSOracle/Dockerfile.openroad tools
  ./tools/OpenROAD/etc/DockerHelper.sh create -target=builder
  if [ "$COPY_PLATFORMS" == "YES" ]; then
    cp .dockerignore{,.bak}
    sed -i '/flow\/platforms/d' .dockerignore
  fi
  docker build --tag ${DOCKER_TAG} --file Dockerfile .
  if [ "$COPY_PLATFORMS" == "YES" ]; then
    mv .dockerignore{.bak,}
  fi

# Local build
elif [ "$build_method" == "LOCAL" ]; then
  $NICE make install -C tools/yosys -j$PROC PREFIX=$(pwd)/tools/install/yosys CONFIG=gcc

  cmake -B tools/OpenROAD/build tools/OpenROAD -DCMAKE_INSTALL_PREFIX=tools/install/OpenROAD
  $NICE cmake --build tools/OpenROAD/build --target install -j$PROC

  cmake -B tools/LSOracle/build tools/LSOracle \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D YOSYS_INCLUDE_DIR=$(pwd)/tools/yosys \
        -D YOSYS_PLUGIN=ON \
        -D YOSYS_SHARE_DIR=$(pwd)/tools/install/yosys/share/yosys \
        -D CMAKE_INSTALL_PREFIX=$(pwd)/tools/install/LSOracle
  $NICE cmake --build tools/LSOracle/build -j$PROC --target install
else
  echo "[ERROR FLOW-0003] No valid build method found"
  exit 1
fi
