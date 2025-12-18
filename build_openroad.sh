#!/usr/bin/env bash
# This script builds the OpenROAD Flow tools locally or in a Docker image.

# Exit on first error, do not allow unbound variables
set -eu

# Make sure we are on the correct folder before beginning
DIR="$(dirname $(readlink -f $0))"
cd "$DIR"

# Set up paths to dependencies, such as cmake and boost. Safe no-op
# if tools were set up elsewhere in the path.
. dev_env.sh

# Defaults variable values
NICE=""

OPENROAD_APP_REMOTE="origin"
OPENROAD_APP_BRANCH="master"

INSTALL_PATH="$(pwd)/tools/install"

YOSYS_USER_ARGS=""
YOSYS_ARGS=""

OPENROAD_APP_USER_ARGS=""
OPENROAD_APP_ARGS=""

DOCKER_OS_NAME="ubuntu22.04"
PROC=-1

VERIFIC_COMPONENTS='database util containers pct hier_tree verilog'
WITH_VERIFIC=0
VERIFIC_DIR=""

function usage() {
        cat << EOF

Usage: $0 [-h|--help] [-o|--local] [-l|--latest]
          [--or_branch BRANCH_NAME] [--or_repo REPO_URL] [--no_init]
          [-n|--nice] [-t|--threads N]
          [--yosys-args-overwrite] [--yosys-args STRING]
          [--with-verific PATH]
          [--openroad-args-overwrite] [--openroad-args STRING]
          [--install-path PATH] [--clean] [--clean-force]

          [-c|--copy-platforms]

Options:
    -h, --help              Print this help message.

    -o, --local             Build locally instead of building a Docker image.

    -l, --latest            Use the head of branch --or_branch or 'master'
                            by default for tools/OpenROAD.

    -s, --skip_openroad     Skip building and all git operations on OpenROAD.

    --or_branch BRANCH_NAME Use the head of branch BRANCH for tools/OpenROAD.

    --or_repo REPO_URL      Use a fork at REPO-URL (https/ssh) for tools/OpenROAD.

    --no_init               Skip initializing submodules.

    -t, --threads N         Use N cpus when compiling software.

    -n, --nice              Nice all jobs. Use all cpus unless --threads is
                            also given, then use N threads.

    --yosys-args-overwrite  Do not use default flags set by this scrip during
                            Yosys compilation.

    --yosys-args STRING     Additional compilation flags for Yosys compilation.

    --with-verific PATH     Compile Yosys with Verific support. PATH is the path
                            to the Verific source folder.

    --openroad-args-overwrite
                            Do not use default flags set by this scrip during
                            OpenROAD app compilation.

    --openroad-args STRING  Additional compilation flags for OpenROAD app
                            compilation.

    --install-path PATH     Path to install tools. Default is ${INSTALL_PATH}.

    --clean                 Call git clean interactively before compile.
                            Useful to remove old build files.

    --clean-force           Call git clean before compile. WARNING: this option
                            will not ask for confirmation. Useful to remove
                            old build files.


Options valid only for Docker builds:
    -c, --copy-platforms    Copy platforms to inside docker image.

    --os=DOCKER_OS_NAME     Choose between ubuntu22.04 (default), ubuntu20.04.

    This script builds the OpenROAD tools: openroad, yosys and yosys plugins.
    By default, the tools will be built from the linked submodule hashes.

EOF
}

# Parse arguments
__CMD="$0 $@"
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
                -s|--skip_openroad)
                        SKIP_OPENROAD=1
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
                        YOSYS_OVERWRITE_ARGS=1
                        ;;
                --yosys-args)
                        YOSYS_USER_ARGS="$2"
                        shift
                        ;;
                --with-verific)
                        YOSYS_USER_ARGS+=" ENABLE_VERIFIC=1"
                        YOSYS_USER_ARGS+=" ENABLE_VERIFIC_VHDL=0"
                        YOSYS_USER_ARGS+=" VERIFIC_COMPONENTS='${VERIFIC_COMPONENTS}'"
                        VERIFIC_DIR=${2}
                        if [ ! -d "${VERIFIC_DIR}" ]; then
                                echo "[ERROR] Verific path '${VERIFIC_DIR}' does not exist." >&2
                                exit 1
                        fi
                        YOSYS_USER_ARGS+=" VERIFIC_DIR=${VERIFIC_DIR}"
                        WITH_VERIFIC=1
                        shift
                        ;;
                --openroad-args-overwrite)
                        OPENROAD_APP_OVERWRITE_ARGS=1
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
                -*|--*) # unsupported flags
                        echo "[ERROR FLW-0005] Unsupported flag $1." >&2
                        usage 2> /dev/null
                        exit 1
                        ;;
        esac
        shift
done

if [[ "$PROC" == "-1" ]]; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                PROC=$(nproc --all)
        elif [[ "$OSTYPE" == "darwin"* ]]; then
                PROC=$(sysctl -n hw.ncpu)
        else
                cat << EOF
[WARNING FLW-0025] Unsupported OSTYPE: cannot determine number of host CPUs"
  Defaulting to 2 threads. Use --threads N to use N threads"
EOF
  PROC=2
        fi
fi

echo "[INFO FLW-0028] Compiling with ${PROC} threads."

# Only add install prefix variables after parsing arguments.
YOSYS_ARGS+=" PREFIX=${INSTALL_PATH}/yosys"
OPENROAD_APP_ARGS+=" -D CMAKE_INSTALL_PREFIX=${INSTALL_PATH}/OpenROAD"
if [ -n "$CMAKE_INSTALL_RPATH" ]; then
        OPENROAD_APP_ARGS+=" -D CMAKE_INSTALL_RPATH=${CMAKE_INSTALL_RPATH}"
        OPENROAD_APP_ARGS+=" -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE"
fi

__args_setup() {
        if [ ! -z "${YOSYS_OVERWRITE_ARGS+x}" ]; then
                echo "[INFO FLW-0014] Overwriting Yosys compilation flags."
                YOSYS_ARGS="${YOSYS_USER_ARGS}"
        else
                YOSYS_ARGS+=" ${YOSYS_USER_ARGS}"
        fi

        if [ ! -z "${OPENROAD_APP_OVERWRITE_ARGS+x}" ]; then
                echo "[INFO FLW-0015] Overwriting OpenROAD app compilation flags."
                OPENROAD_APP_ARGS="${OPENROAD_APP_USER_ARGS}"
        else
                OPENROAD_APP_ARGS+=" ${OPENROAD_APP_USER_ARGS}"
        fi
}

__docker_build()
{
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
}

__local_build()
{
        if [[ "$OSTYPE" == "darwin"* ]]; then
          export PATH="$(brew --prefix bison)/bin:$(brew --prefix flex)/bin:$(brew --prefix tcl-tk)/bin:$PATH"
          export CMAKE_PREFIX_PATH=$(brew --prefix or-tools)
        fi
        if [[ -f "/opt/rh/rh-python38/enable" ]]; then
            set +u
            source /opt/rh/rh-python38/enable
            set -u
        fi
        if [[ -f "/opt/rh/devtoolset-8/enable" ]]; then
            # the scl script has unbound variables
            set +u
            source /opt/rh/devtoolset-8/enable
            set -u
        fi

        if [ -z "${SKIP_OPENROAD+x}" ]; then
            echo "[INFO FLW-0018] Compiling OpenROAD."
            eval ${NICE} ./tools/OpenROAD/etc/Build.sh -dir="$DIR/tools/OpenROAD/build" -threads=${PROC} -cmake=\'${OPENROAD_APP_ARGS}\'
            ${NICE} cmake --build tools/OpenROAD/build --target install -j "${PROC}"
        fi

        YOSYS_ABC_PATH=tools/yosys/abc
        if [[ -d "${YOSYS_ABC_PATH}/.git" ]]; then
            # update indexes to make sure git diff-index uses correct data
            git --work-tree=${YOSYS_ABC_PATH} --git-dir=${YOSYS_ABC_PATH}/.git update-index --refresh
        fi

        if [ ${WITH_VERIFIC} -eq 1 ]; then
                echo "[INFO FLW-0031] Compiling Verific components."
                cp -r "${VERIFIC_DIR}" verific
                for c in ${VERIFIC_COMPONENTS}; do
                        make -j -C "verific/${c}" clean
                        make -j -C "verific/${c}"
                done
        fi

        echo "[INFO FLW-0017] Compiling Yosys."
        eval ${NICE} make install -C tools/yosys -j "${PROC}" ${YOSYS_ARGS}

        echo "[INFO FLW-0030] Compiling yosys-slang."
        # CMAKE_FLAGS added to work around yosys-slang#141 (unable to build outside of git checkout)
        ${NICE} make install -C tools/yosys-slang -j "${PROC}" YOSYS_PREFIX="${INSTALL_PATH}/yosys/bin/" CMAKE_FLAGS="-DYOSYS_SLANG_REVISION=unknown -DSLANG_REVISION=unknown"

        if [ ${WITH_VERIFIC} -eq 1 ]; then
                echo "[INFO FLW-0032] Cleaning up Verific components."
                rm -rf verific
        fi

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
(
        cd tools/OpenROAD
        git fetch "${OPENROAD_APP_REMOTE}"
        git checkout "${OPENROAD_APP_REMOTE}/${OPENROAD_APP_BRANCH}"
        git pull "${OPENROAD_APP_REMOTE}" "${OPENROAD_APP_BRANCH}"
        git submodule update --init --recursive
)

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

        if [ -z "${SKIP_OPENROAD+x}" ] &&  ( [ ! -z "${USE_OPENROAD_APP_LATEST+x}" ] || [ "${OPENROAD_APP_BRANCH}" != "master" ] ) ; then
                echo -n "[INFO FLW-0004] Updating OpenROAD app to the HEAD"
                echo "  of ${OPENROAD_APP_REMOTE}/${OPENROAD_APP_BRANCH}."
                __update_openroad_app_latest
        fi
}

__logging()
{
        local log_file="build_openroad.log"
        echo "[INFO FLW-0027] Saving logs to ${log_file}"
        echo "[INFO FLW-0028] $__CMD"
        exec > >(tee -i "${log_file}")
        exec 2>&1
}

__cleanup()
{
        if [ ! -z "${CLEAN_FORCE+x}" ]; then
                CLEAN_CMD="-x -d --force"
        else
                CLEAN_CMD="-x -d --interactive"
        fi
        echo "[INFO FLW-0026] Cleaning up previous binaries and build files."
        git clean ${CLEAN_CMD} tools
        YOSYS_ABC_PATH="tools/yosys/abc"
        if [[ -d "${YOSYS_ABC_PATH}" ]]; then
                echo "Entering '${YOSYS_ABC_PATH}'"
                git --work-tree=${YOSYS_ABC_PATH} --git-dir=${YOSYS_ABC_PATH}/.git clean ${CLEAN_CMD}
        fi
        git submodule foreach --recursive git clean ${CLEAN_CMD}
}

__logging
if [ ! -z "${CLEAN_BEFORE+x}" ]; then
        __cleanup
fi
__args_setup
__common_setup

# Choose install method
if [ -z "${LOCAL_BUILD+x}" ] && command -v docker &> /dev/null; then
        echo "[INFO FLW-0000] Using docker build method."
        __docker_build
else
        echo -n "[INFO FLW-0001] Using local build method."
        echo " This will create binaries at 'tools/install' unless overwritten."
        __local_build
fi
