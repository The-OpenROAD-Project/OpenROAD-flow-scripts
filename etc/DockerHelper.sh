#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname $(readlink -f $0))/../"

baseDir="$(pwd)"
# docker hub organization/user from where to pull/push images
org=openroad

_help() {
    cat <<EOF
usage: $0 [CMD] [OPTIONS]

  CMD:
  create                        Create a docker image
  test                          Test the docker image
  push                          Push the docker image to Docker Hub

  OPTIONS:
  -os=OS_NAME                   Choose beween centos7 (default), ubuntu20.04 and ubuntu22.04.
  -target=TARGET                Choose target fo the Docker image:
                                  'dev': os + packages to compile app
                                  'builder': os + packages to compile app +
                                             copy source code and build app
  -threads                      Max number of threads to use if compiling.
  -sha                          Use git commit sha as the tag image. Default is
                                  'latest'.
  -h -help                      Show this message and exits

EOF
    exit "${1:-1}"
}

_setup() {
    commitSha="$(git rev-parse HEAD)"
    case "${os}" in
        "centos7")
            osBaseImage="centos:centos7"
            ;;
        "ubuntu20.04")
            osBaseImage="ubuntu:20.04"
            ;;
        "ubuntu22.04")
            osBaseImage="ubuntu:22.04"
            ;;
        *)
            echo "Target OS ${os} not supported" >&2
            _help
            ;;
    esac
    imageName="${IMAGE_NAME_OVERRIDE:-"${org}/flow-${os}-${target}"}"
    if [[ "${useCommitSha}" == "yes" ]]; then
        imageTag="${commitSha}"
    else
        imageTag="latest"
    fi
    case "${target}" in
        "builder" )
            fromImage="${FROM_IMAGE_OVERRIDE:-"${org}/flow-${os}-dev"}:${imageTag}"
            context="."
            buildArgs="--build-arg numThreads=${numThreads}"
            ;;
        "dev" )
            fromImage="${FROM_IMAGE_OVERRIDE:-$osBaseImage}"
            cp tools/OpenROAD/etc/DependencyInstaller.sh etc/InstallerOpenROAD.sh
            context="etc"
            buildArgs=""
            ;;
        *)
            echo "Target ${target} not found" >&2
            _help
            ;;
    esac
    imagePath="${imageName}:${imageTag}"
    buildArgs="--build-arg fromImage=${fromImage} ${buildArgs}"
    file="docker/Dockerfile.${target}"
}

_create() {
    echo "Create docker image ${imagePath} using ${file}"
    docker build --file "${file}" --tag "${imagePath}" ${buildArgs} "${context}"
    rm -f etc/InstallerOpenROAD.sh
}

_push() {
    case "${target}" in
        "dev" )
            read -p "Will push docker image ${imagePath} to DockerHub [y/N]" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$  ]]; then
                mkdir -p build

                OS_LIST="centos7 ubuntu20.04 ubuntu22.04"
                # create image with sha and latest tag for all os
                for os in ${OS_LIST}; do
                    ./etc/DockerHelper.sh create -target=dev \
                        2>&1 | tee build/create-${os}-latest.log
                    ./etc/DockerHelper.sh create -target=dev -sha \
                        2>&1 | tee build/create-${os}-${commitSha}.log
                done

                for os in ${OS_LIST}; do
                    echo [DRY-RUN] docker push openroad/flow-${os}-dev:latest
                    echo [DRY-RUN] docker push openroad/flow-${os}-dev:${commitSha}
                done

            else
                echo "Will not push."
            fi
            ;;
        *)
            echo "Target ${target} is not valid candidate for push to DockerHub." >&2
            _help
            ;;
    esac
}

#
# MAIN
#

# script has at least 1 argument, the rule
if [[ $# -lt 1 ]]; then
    echo "Too few arguments" >&2
    _help
fi

if [[ "$1" == "-h" || "$1" == "-help" ]]; then
    _help 0
fi

_rule="_${1}"
shift 1

# check if the rule is exists
if [[ -z $(command -v "${_rule}") ]]; then
    echo "Command ${_rule/_/} not found" >&2
    _help
fi

# default values, can be overwritten by cmdline args
os="centos7"
target="dev"
useCommitSha="no"
numThreads="-1"

while [ "$#" -gt 0 ]; do
    case "${1}" in
        -h|-help)
            _help 0
            ;;
        -os=* )
            os="${1#*=}"
            ;;
        -target=* )
            target="${1#*=}"
            ;;
        -threads=* )
            numThreads="${1#*=}"
            ;;
        -sha )
            useCommitSha=yes
            ;;
        -os | -target )
            echo "${1} requires an argument" >&2
            _help
            ;;
        *)
            echo "unknown option: ${1}" >&2
            _help
            ;;
    esac
    shift 1
done

if [[ "${numThreads}" == "-1" ]]; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        numThreads=$(nproc --all)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        numThreads=$(sysctl -n hw.ncpu)
    else
        numThreads=2
        cat << EOF
[WARNING] Unsupported OSTYPE: cannot determine number of host CPUs"
  Defaulting to 2 threads. Use --threads N to use N threads"
EOF
    fi
fi

_setup

"${_rule}"
