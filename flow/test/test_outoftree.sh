#!/bin/bash
#
# deltaDebug.py integration smoke-test, run from ORFS/flow folder.
#
# Exit with error if anything is amiss, including evaluation of
# variable names such as $(false), unused variables, etc.
set -x -ue -o pipefail

cd "$(dirname "$0")/.."
rm -rf results/outoftree/
mkdir -p results/outoftree/
cd results/outoftree/
cp ../../designs/src/aes/* .
make --file=../../Makefile DESIGN_CONFIG=../../designs/asap7/minimal/config.mk DESIGN_NAME=aes_cipher_top VERILOG_FILES="$(ls *.v | xargs)" grt
