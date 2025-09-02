#!/usr/bin/env bash
set -u -eo pipefail
if [ -z "$KLAYOUT_CMD" ]; then
    echo "Error: KLayout not found in PATH"
    exit 1
fi
# Log version
$KLAYOUT_CMD -v
$KLAYOUT_CMD "$@"
