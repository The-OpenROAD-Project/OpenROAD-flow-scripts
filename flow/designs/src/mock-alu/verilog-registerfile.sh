#!/usr/bin/env bash
set -ex

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE=$DIR/../..

cd $DIR

rm -rf registerfile/

sbt -Duser.home="$HOME" -Djline.terminal=jline.UnsupportedTerminal -batch \
     "test:runMain GenerateMockRegisterFile \
     --width ${MOCK_REGISTERFILE_WIDTH} \
     --read-ports ${MOCK_REGISTERFILE_READ_PORTS} \
     --write-ports ${MOCK_REGISTERFILE_WRITE_PORTS} \
     --registers ${MOCK_REGISTERFILE_REGISTERS} \
     --platform ${PLATFORM} \
     -- \
     registerfile/"

cd registerfile
# reduce git noise as these comments will change if the line numbers in Chisel changes
find . \( -name "*.sv" -o -name "*.v" \) -type f -exec sed -i '/^\/\/.*/d' {} \;
