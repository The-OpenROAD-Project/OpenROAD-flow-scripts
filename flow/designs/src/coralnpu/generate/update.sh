#!/usr/bin/env bash
# Copies the generated CoreMiniAxi.sv into flow/designs/src/coralnpu.
set -euo pipefail
src="$PWD/CoreMiniAxi_generated.sv"
dst="$BUILD_WORKSPACE_DIRECTORY/../CoreMiniAxi.sv"
cp "$src" "$dst"
chmod u+w "$dst"
