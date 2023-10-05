#!/usr/bin/env bash
set -ex

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE=$DIR/../..

cd $DIR

rm -rf aluregisterfile/

sbt -Duser.home="$HOME" -Djline.terminal=jline.UnsupportedTerminal -batch \
     "test:runMain GenerateMockAluRegisterFile \
     --width ${MOCK_REGISTERFILE_WIDTH} \
     --operations ${MOCK_ALU_OPERATIONS} \
     --read-ports ${MOCK_REGISTERFILE_READ_PORTS} \
     --write-ports ${MOCK_REGISTERFILE_WRITE_PORTS} \
     --registers ${MOCK_REGISTERFILE_REGISTERS} \
     --platform ${PLATFORM} \
     --split ${MOCK_REGISTERFILE_SPLIT}
     -- \
     aluregisterfile/"

cd aluregisterfile
# reduce git noise as these comments will change if the line numbers in Chisel changes
find . \( -name "*.sv" -o -name "*.v" \) -type f -exec sed -i '/^\/\/.*/d' {} \;
