#!/usr/bin/env bash
set -ex

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE=$DIR/../..

cd $DIR

rm -f *.v

sbt -Duser.home="$HOME" -Djline.terminal=jline.UnsupportedTerminal -batch \
     "test:runMain GenerateMockAlu --width ${MOCK_ALU_WIDTH} --operations ${MOCK_ALU_OPERATIONS} --platform ${PLATFORM} -- --emit-modules verilog --emission-options disableMemRandomization,disableRegisterRandomization --target-dir ."

# reduce git noise as these comments will change if the line numbers in Chisel changes
find . -name "*.v" -type f -exec sed -i 's/ \/\/.*$//' {} \;
