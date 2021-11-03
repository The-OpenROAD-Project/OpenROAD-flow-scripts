#!/bin/bash
# This script builds the OpenROAD tools locally

# Exit on first error
set -e

function usage() {
        cat << EOF

Usage: $0 [-h|--help] [-o|--local] [-l|--latest] [--or_branch BRANCH]
          [--or_repo REPO-URL] [-n|--nice] [-t|--threads N]
          [-c|--copy-platforms]

Options:
    -h, --help              Print this help message.

    -o, --local             Build locally instead of building a Docker image.

    -l, --latest            Use the head of branch --or_branch or 'master'
                            by default for tools/OpenROAD.
    --or_branch BRANCH      Use the head of branch BRANCH for tools/OpenROAD.
    --or_repo REPO-URL      Use a fork at REPO-URL (https/ssh) for tools/OpenROAD.
    --no_init               Skip initializing submodules.
    -n, --nice              Use all cpus but nice the jobs.
    -t, --threads N         Use N cpus when compiling software.

Options valid only for Docker builds:
    -c, --copy-platforms    Copy platforms to inside docker image.

    This script builds the OpenROAD tools: openroad, yosys and yosys plugins.
    By default, the tools will be built from the linked submodule hashes.

EOF
}

# defaults
NICE=""
PROC=$(nproc)
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
                -l|--latest)
                        UPDATE_OR=1
                        shift
                        ;;
                -t|--threads)
                        PROC=$2
                        shift 2
                        ;;
                -n|--nice)
                        NICE="nice"
                        PROC=$(nproc --all)
                        shift
                        ;;
                -o|--local)
                        BUILD_METHOD="LOCAL"
                        shift
                        ;;
                --no_init)
                        OPENROAD_FLOW_NO_GIT_INIT=1
                        shift
                        ;;
                -c|--copy-platforms)
                        COPY_PLATFORMS="YES"
                        shift
                        ;;
                -*|--*=) # unsupported flags
                        echo "[ERROR FLW-0004] Unsupported flag $1." >&2
                        exit 1
                        ;;
                *) # preserve positional arguments
                        PARAMS="$PARAMS $1"
                        shift
                        ;;
        esac
done

__docker_build()
{
        docker build \
                --no-cache \
                --tag openroad/yosys \
                --file tools/yosys_util/Dockerfile \
                --target builder \
                tools/yosys

        docker build \
                --no-cache \
                --tag openroad/lsoracle \
                --file tools/LSOracle/Dockerfile.openroad \
                tools

        ./tools/OpenROAD/etc/DockerHelper.sh create \
                -target=builder \
                -threads=${PROC}

        if [ "$COPY_PLATFORMS" == "YES" ]; then
                cp .dockerignore{,.bak}
                sed -i '/flow\/platforms/d' .dockerignore
        fi
        docker build --no-cache --tag ${DOCKER_TAG} --file Dockerfile .
        if [ "$COPY_PLATFORMS" == "YES" ]; then
                mv .dockerignore{.bak,}
        fi
}

__local_build()
{
        $NICE make install \
                -C tools/yosys \
                -j ${PROC} \
                CONFIG=gcc \
                PREFIX=$(pwd)/tools/install/yosys \
                ABCREV=bafd2a7 ABCURL=https://github.com/berkeley-abc/abc

        cmake tools/OpenROAD \
                -B tools/OpenROAD/build \
                -DCMAKE_INSTALL_PREFIX=tools/install/OpenROAD

        $NICE cmake \
                --build tools/OpenROAD/build \
                --target install \
                -j ${PROC}

        cmake tools/LSOracle \
                -B tools/LSOracle/build \
                -D CMAKE_BUILD_TYPE=RELEASE \
                -D YOSYS_INCLUDE_DIR=$(pwd)/tools/yosys \
                -D YOSYS_PLUGIN=ON \
                -D YOSYS_SHARE_DIR=$(pwd)/tools/install/yosys/share/yosys \
                -D CMAKE_INSTALL_PREFIX=$(pwd)/tools/install/LSOracle

        $NICE cmake --build tools/LSOracle/build -j ${PROC} --target install
}

__common_setup()
{
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
                        git --git-dir tools/OpenROAD/.git \
                                remote add $CURRENT_REMOTE $OR_REPO
                fi
        fi

        if [ ! -z ${UPDATE_OR+x} ]; then
                echo "[INFO FLW-0005] Updating OpenROAD tool to the latest."
                (cd tools/OpenROAD && git fetch $CURRENT_REMOTE $OR_BRANCH \
                        && git checkout $CURRENT_REMOTE/$OR_BRANCH \
                        && git pull $CURRENT_REMOTE $OR_BRANCH \
                        && git submodule update --init --recursive)
        fi
}

__common_setup
# Choose install method
if [ -z ${BUILD_METHOD+x} ] && command -v docker &> /dev/null; then
        echo "[INFO FLW-0000] Using docker build method. This will create a docker image tagged '${DOCKER_TAG}'."
        __docker_build
else
        echo "[INFO FLW-0000] Using local build method. This will create binaries at 'tools/install/..'."
        __local_build
fi
