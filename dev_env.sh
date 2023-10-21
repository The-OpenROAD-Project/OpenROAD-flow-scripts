#!/usr/bin/env bash

function setpaths() {
    local DIR=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")
    export PATH="$DIR/dependencies/bin:$PATH"
    export CMAKE_INSTALL_RPATH=$DIR/dependencies/lib:$DIR/dependencies/lib64
}

setpaths
