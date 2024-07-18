#!/usr/bin/env bash

cd $(dirname $(realpath $0))/../

if [[ "$@" == "-dev" ]]; then
    file_list=(
        "./build_openroad.sh"
        "./docker/Dockerfile.builder"
        "./docker/Dockerfile.dev"
        "./etc/DependencyInstaller.sh"
        "./etc/DockerHelper.sh"
        "./etc/DockerTag.sh"
        "./tools/OpenROAD/docker/Dockerfile.binary"
        "./tools/OpenROAD/docker/Dockerfile.builder"
        "./tools/OpenROAD/docker/Dockerfile.dev"
        "./tools/OpenROAD/etc/DependencyInstaller.sh"
        "./tools/OpenROAD/etc/DockerHelper.sh"
        "./tools/OpenROAD/etc/DockerTag.sh"
    )
    cat "${file_list[@]}" | sha256sum | awk '{print substr($1, 1, 6)}'
elif [[ "$@" == "-master" ]]; then
    git describe
else
    echo "Usage: $0 {-dev|-master}"
    exit 1
fi
