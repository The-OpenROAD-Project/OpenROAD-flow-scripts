#!/bin/bash
set -e
black=$1
shift
tclfmt=$1
shift
$tclfmt --in-place ${BUILD_WORKSPACE_DIRECTORY}
$black ${BUILD_WORKSPACE_DIRECTORY}
