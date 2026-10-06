#!/usr/bin/env bash

cd $(dirname $(realpath $0))/../

if [[ "$@" == "-dev" ]]; then
    file_list=(
        "./docker/Dockerfile.builder"
        "./docker/Dockerfile.dev"
        "./Dockerfile"
        "./etc/DependencyInstaller.sh"
        "./etc/requirements-common_lock.txt"
        "./etc/requirements-pip_lock.txt"
        "./tools/OpenROAD/etc/DependencyInstaller.sh"
    )
    cat "${file_list[@]}" | sha256sum | awk '{print substr($1, 1, 6)}'
elif [[ "$@" == "-tools" ]]; then
    # Everything the orfs-tools target of Dockerfile.builder depends on:
    # the dev image, the build scripts, the ignore file that filters the
    # build context, and the checked-out tools except OpenROAD.
    ignore_file=./docker/Dockerfile.builder.dockerignore
    if [[ ! -f "${ignore_file}" ]]; then
        ignore_file=./.dockerignore
    fi
    {
        ./etc/DockerTag.sh -dev
        cat ./build_openroad.sh ./dev_env.sh ./etc/setup_compiler_wrappers.sh
        cat "${ignore_file}"
        # Drop the trailing describe output, which depends on fetched tags.
        git submodule status tools/yosys tools/kepler-formal | awk '{print $1, $2}'
        git ls-tree HEAD tools/ | grep -v -e 'tools/OpenROAD$' -e 'tools/AutoTuner$' \
            -e 'tools/yosys$' -e 'tools/kepler-formal$'
    } | sha256sum | awk '{print substr($1, 1, 6)}'
elif [[ "$@" == "-master" ]]; then
    git fetch --tags >&2
    git -C tools/OpenROAD fetch --tags >&2
    git describe
else
    echo "Usage:"
    echo " To generate a tag for images that only have dev dependencies:"
    echo "       $0 -dev"
    echo " To generate a tag for the image with the prebuilt tools other than OpenROAD:"
    echo "       $0 -tools"
    echo " To generate a tag for full releases based on master branch"
    echo "       $0 -master"
    exit 1
fi
