#!/bin/bash
# This script builds the OpenROAD tools locally

# Exit on first error
set -e

cd "$(dirname $(readlink -f $0))"

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
PROC=$(nproc --all)
COPY_PLATFORMS="NO"
DOCKER_TAG="openroad/flow-scripts"
CURRENT_REMOTE="origin"
OPENROAD_BRANCH="master"

INSTALL_PATH="$(pwd)/tools/install"

DOCKER_OVERWIRTE_ARGS="NO"
DOCKER_USER_ARGS=""
DOCKER_ARGS="--no-cache"

YOSYS_OVERWIRTE_ARGS="NO"
YOSYS_USER_ARGS=""

OPENROAD_OVERWIRTE_ARGS="NO"

LSORACLE_OVERWIRTE_ARGS="NO"
LSORACLE_USER_ARGS=""

# Parse arguments
while (( "$#" )); do
        case "$1" in
                -h|--help)
                        usage 2> /dev/null
                        exit
                        ;;
                --or_branch)
                        OR_BRANCH="$2"
                        shift
                        ;;
                --or_repo)
                        OPENROAD_GIT_URL="$2"
                        shift
                        ;;
                -l|--latest)
                        USE_OPENROAD_MASTER=1
                        ;;
                -t|--threads)
                        PROC="$2"
                        shift
                        ;;
                -n|--nice)
                        NICE="nice"
                        ;;
                -o|--local)
                        BUILD_METHOD="LOCAL"
                        ;;
                --no_init)
                        OPENROAD_FLOW_NO_GIT_INIT=1
                        ;;
                -c|--copy-platforms)
                        COPY_PLATFORMS="YES"
                        ;;
                --docker-args-overwrite)
                        DOCKER_OVERWIRTE_ARGS="YES"
                        ;;
                --docker-args)
                        DOCKER_USER_ARGS="$2"
                        shift
                        ;;
                --yosys-args-overwrite)
                        YOSYS_OVERWIRTE_ARGS="YES"
                        ;;
                --yosys-args)
                        YOSYS_USER_ARGS="$2"
                        shift
                        ;;
                --openroad-args-overwrite)
                        OPENROAD_OVERWIRTE_ARGS="YES"
                        ;;
                --openroad-args)
                        OPENROAD_USER_ARGS="$2"
                        shift
                        ;;
                --lsoracle-args-overwrite)
                        LSORACLE_OVERWIRTE_ARGS="YES"
                        ;;
                --lsoracle-args)
                        LSORACLE_USER_ARGS="$2"
                        shift
                        ;;
                --install-path)
                        INSTALL_PATH="$2"
                        shift
                        ;;
                -*|--*) # unsupported flags
                        echo "[ERROR FLW-0004] Unsupported flag $1." >&2
                        usage 2> /dev/null
                        exit 1
                        ;;
        esac
        shift
done

if [[ "${DOCKER_OVERWIRTE_ARGS}" == "YES" ]]; then
        DOCKER_ARGS="${DOCKER_USER_ARGS}"
else
        DOCKER_ARGS="${DOCKER_ARGS} ${DOCKER_USER_ARGS}"
fi

YOSYS_ARGS="\
CONFIG=gcc \
PREFIX=${INSTALL_PATH}/yosys \
ABCREV=bafd2a7 ABCURL=https://github.com/berkeley-abc/abc \
"
if [[ "${YOSYS_OVERWIRTE_ARGS}" == "YES" ]]; then
        YOSYS_ARGS="${YOSYS_USER_ARGS}"
else
        YOSYS_ARGS="${YOSYS_ARGS} ${YOSYS_USER_ARGS}"
fi

OPENROAD_USER_ARGS=""
OPENROAD_ARGS="\
-D CMAKE_INSTALL_PREFIX=${INSTALL_PATH}/OpenROAD \
"
if [[ "${OPENROAD_OVERWIRTE_ARGS}" == "YES" ]]; then
        OPENROAD_ARGS="${OPENROAD_USER_ARGS}"
else
        OPENROAD_ARGS="${OPENROAD_ARGS} ${OPENROAD_USER_ARGS}"
fi

LSORACLE_ARGS="\
-D CMAKE_BUILD_TYPE=RELEASE \
-D YOSYS_INCLUDE_DIR=$(pwd)/tools/yosys \
-D YOSYS_PLUGIN=ON \
-D YOSYS_SHARE_DIR=${INSTALL_PATH}/yosys/share/yosys \
-D CMAKE_INSTALL_PREFIX=${INSTALL_PATH}/LSOracle \
"
if [[ "${LSORACLE_OVERWIRTE_ARGS}" == "YES" ]]; then
        LSORACLE_ARGS="${LSORACLE_USER_ARGS}"
else
        LSORACLE_ARGS="${LSORACLE_ARGS} ${LSORACLE_USER_ARGS}"
fi

__docker_build()
{
        ${NICE} docker build \
                "${DOCKER_ARGS}" \
                --tag openroad/yosys \
                --file tools/yosys_util/Dockerfile \
                --target builder \
                tools/yosys

        ${NICE} docker build \
                "${DOCKER_ARGS}" \
                --tag openroad/lsoracle \
                --file tools/LSOracle/Dockerfile.openroad \
                tools

        ${NICE} ./tools/OpenROAD/etc/DockerHelper.sh create \
                -target=builder \
                -threads=${PROC}

        if [ "${COPY_PLATFORMS}" == "YES" ]; then
                cp .dockerignore{,.bak}
                sed -i '/flow\/platforms/d' .dockerignore
        fi
        ${NICE} docker build \
                "${DOCKER_ARGS}" \
                --tag "${DOCKER_TAG}" \
                --file Dockerfile \
                .
        if [ "${COPY_PLATFORMS}" == "YES" ]; then
                mv .dockerignore{.bak,}
        fi
}

__local_build()
{
        # build yosys
        ${NICE} make install -C tools/yosys -j "${PROC}" ${YOSYS_ARGS}

        # build openroad
        ${NICE} cmake tools/OpenROAD -B tools/OpenROAD/build ${OPENROAD_ARGS}
        ${NICE} cmake --build tools/OpenROAD/build --target install -j "${PROC}"

        # build lsoracle
        ${NICE} cmake tools/LSOracle -B tools/LSOracle/build ${LSORACLE_ARGS}
        ${NICE} cmake --build tools/LSOracle/build --target install -j "${PROC}"
}

__change_or_repo()
(
        base_url=$(dirname "${OPENROAD_GIT_URL}")
        [[ ${base_url##*/} = $base_url ]] && CURRENT_REMOTE=${base_url##*:} || CURRENT_REMOTE=${base_url##*/}
        cd tools/OpenROAD
        remotes=$(git remote)
        SAVEIFS=$IFS
        IFS=$'\n'
        remotes=($remotes)
        IFS=$SAVEIFS
        if [[ ! " ${remotes[@]} " =~ " ${CURRENT_REMOTE} " ]]; then
                git remote add "${CURRENT_REMOTE}" "${OPENROAD_GIT_URL}"
        fi
)

__update_or_latest()
(
        cd tools/OpenROAD
        git fetch "${CURRENT_REMOTE}" "${OPENROAD_BRANCH}"
        git checkout "${CURRENT_REMOTE}/${OPENROAD_BRANCH}"
        git pull "${CURRENT_REMOTE}" "${OPENROAD_BRANCH}"
        git submodule update --init --recursive
)

__common_setup()
{
        # Clone repositories
        if [ -z "${OPENROAD_FLOW_NO_GIT_INIT+x}" ]; then
                git submodule update --init --recursive
        fi

        if [ ! -z "${OPENROAD_GIT_URL+x}" ]; then
                __change_or_repo
        fi

        if [ ! -z "${USE_OPENROAD_MASTER+x}" ]; then
                echo "[INFO FLW-0005] Updating OpenROAD tool to the latest."
                __update_or_latest
        fi
}

__common_setup
# Choose install method
if [ -z "${BUILD_METHOD+x}" ] && command -v docker &> /dev/null; then
        echo -n "[INFO FLW-0000] Using docker build method."
        echo " This will create a docker image tagged '${DOCKER_TAG}'."
        __docker_build
else
        echo -n "[INFO FLW-0000] Using local build method."
        echo " This will create binaries at 'tools/install unless overwritten."
        __local_build
fi
