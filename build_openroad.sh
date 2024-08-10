#!/usr/bin/env bash
# This script builds the OpenROAD Flow tools locally or in a Docker image.

# Exit on first error, do not allow unbound variables
set -eu

# Make sure we are on the correct folder before beginning
cd "$(dirname $(readlink -f $0))"

# Set up paths to dependencies, such as cmake and boost. Safe no-op
# if tools were set up elsewhere in the path.
. dev_env.sh

# Defaults variable values
NICE=""

OPENROAD_APP_REMOTE="origin"
OPENROAD_APP_BRANCH="master"

INSTALL_PATH="$(pwd)/tools/install"

YOSYS_USER_ARGS=""
YOSYS_ARGS="CONFIG=clang"

OPENROAD_APP_USER_ARGS=""
OPENROAD_APP_ARGS=""

DOCKER_OS_NAME="ubuntu22.04"
PROC=-1

LOCAL_BUILD=0
CLEAN_BEFORE=0
CLEAN_FORCE=0
USE_OPENROAD_APP_LATEST=0
DOCKER_COPY_PLATFORMS=0

__usage() {
    cat << EOF

Usage: $0 [-h|--help] [-o|--local] [--pull-docker] [-l|--latest] 
          [--or_branch BRANCH_NAME] [--or_repo REPO_URL] [--no_init]
          [-n|--nice] [-t|--threads N] 
          [--yosys-args-overwrite] [--yosys-args STRING] 
          [--openroad-args-overwrite] [--openroad-args STRING]
          [--install-path PATH] [--clean] [--clean-force]

          [-c|--copy-platforms] [--os DOCKER_OS_NAME]

Options:
    -h, --help              Print this help message.

    -o, --local             Build locally instead of building a Docker image.

    --pull-docker           Pull the latest Docker image instead of building it.

    -l, --latest            Use the head of branch --or_branch or 'master'
                            by default for tools/OpenROAD.

    --or_branch BRANCH_NAME Use the head of branch BRANCH for tools/OpenROAD.

    --or_repo REPO_URL      Use a fork at REPO-URL (https/ssh) for tools/OpenROAD.

    --no_init               Skip initializing submodules.

    -t, --threads N         Use N cpus when compiling software.

    -n, --nice              Nice all jobs. Use all cpus unless --threads is
                            also given, then use N threads.

    --yosys-args-overwrite  Do not use default flags set by this scrip during
                            Yosys compilation.

    --yosys-args STRING      Aditional compilation flags for Yosys compilation.

    --openroad-args-overwrite
                            Do not use default flags set by this scrip during
                            OpenROAD app compilation.

    --openroad-args STRING  Aditional compilation flags for OpenROAD app
                            compilation.

    --install-path PATH     Path to install tools. Default is ${INSTALL_PATH}.

    --clean                 Call git clean interactively before compile.
                            Useful to remove old build files.

    --clean-force           Call git clean before compile. WARNING: this option
                            will not ask for confirmation. Useful to remove
                            old build files.


Options valid only for Docker builds:
    -c, --copy-platforms    Copy platforms to inside docker image.

    --os=DOCKER_OS_NAME     Choose beween ubuntu22.04 (default), ubuntu20.04.

    This script builds the OpenROAD tools: openroad, yosys and yosys plugins.
    By default, the tools will be built from the linked submodule hashes.

EOF
}

__parse_args() {
        while (( "$#" )); do
                case "$1" in
                        -h|--help)
                                usage 2> /dev/null
                                exit
                                ;;
                        -o|--local)
                                LOCAL_BUILD=1
                                ;;
                        -l|--latest)
                                USE_OPENROAD_APP_LATEST=1
                                ;;
                        --or_branch)
                                OPENROAD_APP_BRANCH="$2"
                                shift
                                ;;
                        --or_repo)
                                OPENROAD_APP_GIT_URL="$2"
                                shift
                                ;;
                        --no_init)
                                OPENROAD_FLOW_NO_GIT_INIT=1
                                ;;
                        -t|--threads)
                                PROC="$2"
                                shift
                                ;;
                        -n|--nice)
                                NICE="nice"
                                ;;
                        -c|--copy-platforms)
                                DOCKER_COPY_PLATFORMS=1
                                ;;
                        --yosys-args-overwrite)
                                YOSYS_OVERWIRTE_ARGS=1
                                ;;
                        --yosys-args)
                                YOSYS_USER_ARGS="$2"
                                shift
                                ;;
                        --openroad-args-overwrite)
                                OPENROAD_APP_OVERWIRTE_ARGS=1
                                ;;
                        --openroad-args)
                                OPENROAD_APP_USER_ARGS="$2"
                                shift
                                ;;
                        --install-path)
                                INSTALL_PATH="$2"
                                shift
                                ;;
                        --clean)
                                CLEAN_BEFORE=1
                                ;;
                        --clean-force)
                                CLEAN_BEFORE=1
                                CLEAN_FORCE=1
                                ;;
                        --os=* )
                                DOCKER_OS_NAME="${1#*=}"
                                ;;
                        --pull-docker)
                                PULL_DOCKER_IMAGE=1
                                ;;
                        -*|--*) # unsupported flags
                                echo "[ERROR FLW-0005] Unsupported flag $1." >&2
                                usage 2> /dev/null
                                exit 1
                                ;;
                esac
                shift
        done
}

__setup_parallelism() {
    if [[ "$PROC" == "-1" ]]; then
        case "$OSTYPE" in
            linux-gnu*) PROC=$(nproc --all) ;;
            darwin*) PROC=$(sysctl -n hw.ncpu) ;;
            *) cat << EOF
[WARNING FLW-0025] Unsupported OSTYPE: cannot determine number of host CPUs"
  Defaulting to 2 threads. Use --threads N to use N threads" 
EOF
  PROC=2 ;;
        esac
    fi
    echo "[INFO FLW-0028] Compiling with ${PROC} threads."
}

__setup_build_args() {
        YOSYS_ARGS+=" PREFIX=${INSTALL_PATH}/yosys"
        OPENROAD_APP_ARGS+=" -D CMAKE_INSTALL_PREFIX=${INSTALL_PATH}/OpenROAD"
        if [ -n "$CMAKE_INSTALL_RPATH" ]; then
                OPENROAD_APP_ARGS+=" -D CMAKE_INSTALL_RPATH=${CMAKE_INSTALL_RPATH}"
                OPENROAD_APP_ARGS+=" -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE"
        fi

        if [ ! -z "${YOSYS_OVERWIRTE_ARGS+x}" ]; then
                echo "[INFO FLW-0014] Overwriting Yosys compilation flags."
                YOSYS_ARGS="${YOSYS_USER_ARGS}"
        else
                YOSYS_ARGS+=" ${YOSYS_USER_ARGS}"
        fi

        if [ ! -z "${OPENROAD_APP_OVERWIRTE_ARGS+x}" ]; then
                echo "[INFO FLW-0015] Overwriting OpenROAD app compilation flags."
                OPENROAD_APP_ARGS="${OPENROAD_APP_USER_ARGS}"
        else
                OPENROAD_APP_ARGS+=" ${OPENROAD_APP_USER_ARGS}"
        fi
}

__docker_build() {
        if [[ "$PULL_DOCKER_IMAGE" -eq 1 ]]; then
                echo "[INFO FLW-0030] Pulling Docker image for OpenROAD Flow."
                docker pull openroad/orfs:latest
        else
                echo "[INFO FLW-0020] Building docker image for OpenROAD Flow."
                if [ ! -z "${DOCKER_COPY_PLATFORMS+x}" ]; then
                        cp .dockerignore{,.bak}
                        sed -i '/flow\/platforms/d' .dockerignore
                fi
                ./etc/DockerHelper.sh create -target=dev -os="${DOCKER_OS_NAME}" -threads="${PROC}"
                ./etc/DockerHelper.sh create -target=builder -os="${DOCKER_OS_NAME}" -threads="${PROC}"
                if [ ! -z "${DOCKER_COPY_PLATFORMS+x}" ]; then
                        mv .dockerignore{.bak,}
                fi
        fi
}

__local_build() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                export PATH="$(brew --prefix bison)/bin:$(brew --prefix flex)/bin:$(brew --prefix tcl-tk)/bin:$PATH"
                export CMAKE_PREFIX_PATH=$(brew --prefix or-tools)
        fi

        echo "[INFO FLW-0017] Compiling Yosys."
        ${NICE} make install -C tools/yosys -j "${PROC}" ${YOSYS_ARGS}

        echo "[INFO FLW-0018] Compiling OpenROAD."
        eval ${NICE} cmake tools/OpenROAD -B tools/OpenROAD/build ${OPENROAD_APP_ARGS}
        ${NICE} cmake --build tools/OpenROAD/build --target install -j "${PROC}"
}

__update_openroad_app_remote()
(
        cd tools/OpenROAD
        remotes=$(git remote)
        SAVEIFS=$IFS
        IFS=$'\n'
        remotes=($remotes)
        IFS=$SAVEIFS
        if [[ ! " ${remotes[@]} " =~ " ${OPENROAD_APP_REMOTE} " ]]; then
                git remote add "${OPENROAD_APP_REMOTE}" "${OPENROAD_APP_GIT_URL}"
        fi
)

__change_openroad_app_remote()
{
        base_url=$(dirname "${OPENROAD_APP_GIT_URL}")
        if [[ ${base_url##*/} = $base_url ]]; then
                OPENROAD_APP_REMOTE=${base_url##*:}
        else
                OPENROAD_APP_REMOTE=${base_url##*/}
        fi
        __update_openroad_app_remote
}

__update_openroad_app_latest() 
{
        cd tools/OpenROAD
        git fetch "${OPENROAD_APP_REMOTE}"
        git checkout "${OPENROAD_APP_REMOTE}/${OPENROAD_APP_BRANCH}"
        git pull "${OPENROAD_APP_REMOTE}" "${OPENROAD_APP_BRANCH}"
        git submodule update --init --recursive
}

__common_setup()
{
        # Clone repositories
        if [ -z "${OPENROAD_FLOW_NO_GIT_INIT+x}" ]; then
                echo "[INFO FLW-0002] Updating git submodules."
                git submodule update --init --recursive
        fi

        if [ ! -z "${OPENROAD_APP_GIT_URL+x}" ]; then
                echo -n "[INFO FLW-0003] Changing OpenROAD app remote to"
                echo " ${OPENROAD_APP_GIT_URL}."
                __change_openroad_app_remote
        fi

        if [ ! -z "${USE_OPENROAD_APP_LATEST+x}" ] || [ "${OPENROAD_APP_BRANCH}" != "master" ]; then
                echo -n "[INFO FLW-0004] Updating OpenROAD app to the HEAD"
                echo "  of ${OPENROAD_APP_REMOTE}/${OPENROAD_APP_BRANCH}."
                __update_openroad_app_latest
        fi
}

####
__update_openroad_app() {
    cd tools/OpenROAD
    if ! git remote | grep -q "$OPENROAD_APP_REMOTE"; then
        git remote add "$OPENROAD_APP_REMOTE" "$OPENROAD_APP_GIT_URL"
    fi

    if [ "${USE_OPENROAD_APP_LATEST:-0}" -eq 1 ] || [ "$OPENROAD_APP_BRANCH" != "master" ]; then
        git fetch "$OPENROAD_APP_REMOTE"
        git checkout "$OPENROAD_APP_REMOTE/$OPENROAD_APP_BRANCH"
        git pull "$OPENROAD_APP_REMOTE" "$OPENROAD_APP_BRANCH"
        git submodule update --init --recursive
    fi
}
####

__logging()
{
        local log_file="build_openroad.log"
        echo "[INFO FLW-0027] Saving logs to ${log_file}"
        echo "[INFO FLW-0028] $__CMD"
        exec > >(tee -i "${log_file}")
        exec 2>&1
}

__clean_previous_build() {
    CLEAN_CMD="-x -d"
    [ "$CLEAN_FORCE" -eq 1 ] && CLEAN_CMD+=" --force" || CLEAN_CMD+=" --interactive"
    echo "[INFO FLW-0026]Cleaning up previous binaries and build files."
    git clean $CLEAN_CMD tools
    git submodule foreach --recursive git clean $CLEAN_CMD
}

function main() {
        __logging
        [ "$CLEAN_BEFORE" -eq 1 ] && __clean_previous_build
        __parse_args "$@"
        __setup_parallelism
        __setup_build_args
        __common_setup

        if [ -z "${LOCAL_BUILD+x}" ] && command -v docker &> /dev/null; then
                echo -n "[INFO FLW-0000] Using docker build method."
                __docker_build
        else
                echo -n "[INFO FLW-0001] Using local build method."
                echo " This will create binaries at 'tools/install' unless overwritten."
                __local_build
        fi
}
__CMD="$0 $@"
main "$@"
