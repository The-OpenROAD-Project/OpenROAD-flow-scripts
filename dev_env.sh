#!/usr/bin/env bash
#
# Set developer paths and environment variables here,
# user settings go in ./env.sh
function __setpaths() {
    local DIR=$(readlink -f "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")")
    [ "$(find $DIR/dependencies -type f -user root)" ] && echo "WARNING! Files set up by sudo found in $DIR"
    export PATH="$DIR/dependencies/bin:$PATH"
    export CMAKE_INSTALL_RPATH=$DIR/dependencies/lib:$DIR/dependencies/lib64

    if [[ "$OSTYPE" == "darwin"* ]]; then
        export CMAKE_PREFIX_PATH="$(brew --prefix or-tools)"
    fi
}
__setpaths
unset -f __setpaths
