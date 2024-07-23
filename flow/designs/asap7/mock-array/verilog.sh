#!/usr/bin/env bash
set -ex

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE=$DIR/../..

cd $DIR

cd ../../src/mock-array

sbt -Duser.home="$HOME" -Djline.terminal=jline.UnsupportedTerminal -batch \
     "test:runMain GenerateMockArray --width ${MOCK_ARRAY_COLS} --height ${MOCK_ARRAY_ROWS} --dataWidth ${MOCK_ARRAY_DATAWIDTH} -- --emit-modules verilog --emission-options disableMemRandomization,disableRegisterRandomization --target-dir ."

# reduce git noise as these comments will change if the line numbers in Chisel changes
find . -name "*.v" -type f -exec sed -i 's/ \/\/.*$//' {} \;
