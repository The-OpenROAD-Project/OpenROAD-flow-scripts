#!/usr/bin/env bash
set -ex

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE=$DIR/../..

cd $DIR

cd ../../src/mock-array-big

sbt -Duser.home="$HOME" -Djline.terminal=jline.UnsupportedTerminal -batch \
     "test:runMain GenerateMockArray --width ${MOCK_ARRAY_WIDTH} --height ${MOCK_ARRAY_HEIGHT} --dataWidth ${MOCK_ARRAY_DATAWIDTH} -- --emit-modules verilog --emission-options disableMemRandomization,disableRegisterRandomization --target-dir ."

# reduce git noise as these comments will change if the line numbers in MockArray.scala changes
find . -name "*.v" -type f -exec sed -i 's/ \/\/.*$//' {} \;
