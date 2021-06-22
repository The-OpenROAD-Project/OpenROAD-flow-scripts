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
    -n|--no_init)
      NO_INIT=1
      shift
      ;;
    -c|--copy-platforms)
      COPY_PLATFORMS="YES"
      shift
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
  echo "[INFO][FLOW-0000] using docker build method. This will create a docker image tagged '${DOCKER_TAG}'"
  build_method="DOCKER"
else
  echo "[INFO][FLOW-0000] using local build method. This will create binaries at tools/build/"
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
  echo "updating OpenROAD tool to the latest"
  (cd tools/OpenROAD && git fetch $CURRENT_REMOTE $OR_BRANCH \
    && git checkout $CURRENT_REMOTE/$OR_BRANCH \
    && git pull $CURRENT_REMOTE $OR_BRANCH \
    && git submodule update --init --recursive)
fi 

# Update platforms
if [ ! -z ${UPDATE_PLATFORM+x} ]; then
  for dir in flow/platforms/*/ ; do
    if [ -d $dir/.git ]; then
      echo "[INFO][FLOW-0001] updating git repository '$dir'"
      (cd $dir && git pull)
    else
      echo "[INFO][FLOW-0002] directory '$dir' is not a git repository. Skipping update."
    fi
  done
fi

# Update developer repos
if [ ! -z ${UPDATE_PRIVATE+x} ]; then
  if [ -d flow/private ]; then
    echo "[INFO][FLOW-0001] updating git repository 'private'"
    (cd flow/private && git pull)
  else
    echo "[INFO][FLOW-0002] directory 'flow/private' is not a git repository. Skipping update."
  fi
fi

# Docker build
if [ "$build_method" == "DOCKER" ]; then
  docker build -t openroad/yosys -f tools/yosys_util/Dockerfile tools/yosys
  ./tools/OpenROAD/etc/DockerHelper.sh create -target=builder
  if [ "$COPY_PLATFORMS" == "YES" ]; then
    cp .dockerignore{,.bak}
    sed -i '/flow\/platforms/d' .dockerignore
  fi
  docker build -t ${DOCKER_TAG} -f Dockerfile .
  if [ "$COPY_PLATFORMS" == "YES" ]; then
    mv .dockerignore{.bak,}
  fi

# Local build
elif [ "$build_method" == "LOCAL" ]; then
  mkdir -p tools/build/yosys
  (cd tools/yosys && $NICE make install -j$PROC PREFIX=../build/yosys CONFIG=gcc)

  mkdir -p tools/build/OpenROAD
  (cd tools/build/OpenROAD && cmake ../../OpenROAD && $NICE make -j$PROC)
else
  echo "ERROR: No valid build method found"
  exit 1
fi
