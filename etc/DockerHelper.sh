#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname $(readlink -f $0))/../"

baseDir="$(pwd)"
# docker hub organization/user from where to pull/push images
org=openroad

DOCKER_CMD="docker"
noConstantBuildDir=""

_help() {
    cat <<EOF
usage: $0 [CMD] [OPTIONS]

  CMD:
  create                        Create a docker image
  test                          Test the docker image
  push                          Push the docker image to Docker Hub

  OPTIONS:
  -os=OS_NAME                   Choose between ubuntu20.04 and ubuntu22.04 (default).
  -target=TARGET                Choose target for the Docker image:
                                  'dev': os + packages to compile app
                                  'builder': os + packages to compile app +
                                             copy source code and build app
  -threads=N                    Max number of threads to use if compiling.
                                  Default = \$(nproc)
  -tag=TAG                      Use as the image tag. Default is git commit sha.
  -username=USERNAME            Username to loging at the docker registry.
  -password=PASSWORD            Password to loging at the docker registry.
  -ci                           Install CI tools in image
  -dry-run                      Do not push images to the repository
  -no-constant-build-dir        Do not use constant build directory
  -h -help                      Show this message and exits

EOF
    exit "${1:-1}"
}

_setup() {
    case "${os}" in
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
    if [[ "${tag}" != "" ]]; then
        imageTag="${tag}"
    else
        imageTag=$(./etc/DockerTag.sh -dev)
    fi
    case "${target}" in
        "builder" | "master")
            fromImage="${FROM_IMAGE_OVERRIDE:-"${org}/flow-${os}-dev"}:${imageTag}"
            context="."
            buildArgs="--build-arg numThreads=${numThreads}"
            ;;
        "dev" )
            fromImage="${FROM_IMAGE_OVERRIDE:-$osBaseImage}"
            cp tools/OpenROAD/etc/DependencyInstaller.sh etc/InstallerOpenROAD.sh
            context="etc"
            buildArgs="--build-arg options=${options} ${noConstantBuildDir}"
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
    ${DOCKER_CMD} buildx build \
        --file "${file}" \
        --tag "${imagePath}" \
        ${buildArgs} \
        "${context}"
    rm -f etc/InstallerOpenROAD.sh
}

_push() {
    if [[ -z ${username+x} ]]; then
        echo "Missing required -username=<USER> argument"
        _help
    fi
    if [[ -z ${password+x} ]]; then
        echo "Missing required -password=<PASS> argument"
        _help
    fi
    if [[ "${target}" != "dev" ]] && [[ "${target}" != "master" ]]; then
        echo "Target ${target} is not valid candidate for push to Docker Hub." >&2
        _help
    fi

    if [[ "${dryRun}" == 1 ]]; then
        echo "Skipping docker login"
    else
        ${DOCKER_CMD} login --username "${username}" --password "${password}"
    fi

    if [[ "${tag}" == "" ]]; then
        tag=$(./etc/DockerTag.sh -dev)
    fi

    mkdir -p build

    if [[ "${target}" == "dev" ]]; then
        ./etc/DockerHelper.sh create -os=${os} -target=dev -tag=${tag} -ci \
            2>&1 | tee build/create-${os}-dev-${tag}.log

        if [[ "${dryRun}" != 1 ]]; then
            ${DOCKER_CMD} push "${org}/flow-${os}-dev:${tag}"
        fi
    fi

    if [[ "${target}" == "master" ]]; then
        tag=$(./etc/DockerTag.sh -master)
        # Create builder image
        ./etc/DockerHelper.sh create -os=${os} -target=builder \
            2>&1 | tee build/create-${os}-${target}-${tag}.log

        builderTag=${org}/flow-${os}-builder:${imageTag}
        orfsTag=${org}/orfs:${tag}
        echo "Renaming docker image: ${builderTag} -> ${orfsTag}"
        ${DOCKER_CMD} tag ${builderTag} ${orfsTag}
        if [[ "${dryRun}" == 1 ]]; then
            echo "[DRY-RUN] ${DOCKER_CMD} push ${orfsTag}"
        else
            ${DOCKER_CMD} push ${orfsTag}
        fi
    fi
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

# default values, can be overwritten by command line arguments
os="ubuntu22.04"
target="dev"
numThreads="-1"
tag=""
options=""
dryRun=0

while [ "$#" -gt 0 ]; do
    case "${1}" in
        -h|-help)
            _help 0
            ;;
        -ci )
            options="-ci"
            ;;
        -dry-run )
            dryRun=1
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
        -username=* )
            username="${1#*=}"
            ;;
        -password=* )
            password="${1#*=}"
            ;;
        -tag=* )
            tag="${1#*=}"
            ;;
        -no-constant-build-dir )
            noConstantBuildDir="--build-arg constantBuildDir= "
            ;;
        -os | -target | -threads | -username | -password | -tag )
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
