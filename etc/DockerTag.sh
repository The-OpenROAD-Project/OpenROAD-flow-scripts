#!/usr/bin/env bash

cd $(dirname $(realpath $0))/../

if [[ "$@" == "-dev" ]]; then
    file_list=(
        "./docker/Dockerfile.builder"
        "./docker/Dockerfile.dev"
        "./Dockerfile"
        "./etc/DependencyInstaller.sh"
        "./tools/OpenROAD/etc/DependencyInstaller.sh"
    )
    cat "${file_list[@]}" | sha256sum | awk '{print substr($1, 1, 6)}'
elif [[ "$@" == "-master" ]]; then
    git fetch --tags >&2
    git -C tools/OpenROAD fetch --tags >&2
    git describe
else
    echo "Usage: $0 {-dev|-master}"
    exit 1
fi
