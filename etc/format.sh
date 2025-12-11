#!/bin/bash
set -ex
black=$1
shift
tclfmt=$1
shift

$black --check \
--extend-exclude "(tools/OpenROAD/src/sta|\
tools/yosys|\
tools/yosys-slang)" \
${BUILD_WORKSPACE_DIRECTORY}

# FIXME can't get it to work with our tclfmt config yet, it assumes that source is pwd
# $tclfmt --config=${BUILD_WORKSPACE_DIRECTORY}/tclint.toml --check \
# ${BUILD_WORKSPACE_DIRECTORY}
