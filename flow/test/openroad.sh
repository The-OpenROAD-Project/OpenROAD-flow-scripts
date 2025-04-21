#!/usr/bin/env bash
set -e
# HACK while we're waiting for OpenROAD to be switched to MODULE.bazel
# OpenROAD has its own TCL library
unset TCL_LIBRARY
./external/_main~_repo_rules~openroad/openroad "$@"
