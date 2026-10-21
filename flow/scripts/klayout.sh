#!/usr/bin/env bash
set -u -eo pipefail
if [ -z "$KLAYOUT_CMD" ]; then
    # Quality of life for those who don't need or want a GDS file: KLayout
    # is a big, distribution-specific dependency for the small task of
    # writing one out. Without it, streaming out GDS/OAS writes an empty
    # file and warns, so the flow runs to the end. Installing KLayout opts
    # out. Nobody mistakes an empty GDS file for a valid one; DRC, LVS and
    # the viewers still need KLayout and stop here.
    out_file=""
    stream=0
    prev=""
    for arg in "$@"; do
        case "$prev,$arg" in
        -rd,out_file=*) out_file="${arg#out_file=}" ;;
        -r,*/def2stream.py) stream=1 ;;
        esac
        prev="$arg"
    done
    if [ "$stream" = 1 ] && [ -n "$out_file" ]; then
        echo "WARNING: klayout not found, mocking klayout by writing empty file $out_file"
        : >"$out_file"
        exit 0
    fi
    echo "Error: KLayout not found in PATH"
    exit 1
fi
# Log version
$KLAYOUT_CMD -v
$KLAYOUT_CMD "$@"
