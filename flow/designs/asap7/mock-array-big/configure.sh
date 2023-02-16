#!/usr/bin/env bash
set -ex

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE=$DIR/../..

cd $DIR

cd ../../src/mock-array-big

sbt -Duser.home="$HOME" -Djline.terminal=jline.UnsupportedTerminal -batch \
     "test:runMain GenerateMockArray --width ${MOCK_ARRAY_WIDTH:-8} --height ${MOCK_ARRAY_HEIGHT:-8} --dataWidth ${MOCK_ARRAY_DATAWIDTH:-8} -- --emit-modules verilog --target-dir ."
