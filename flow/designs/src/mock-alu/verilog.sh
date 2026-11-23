#!/usr/bin/env bash
set -ex

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE=$DIR/../..

cd $DIR

MOCK_ALU_WIDTH=${MOCK_ALU_WIDTH:-64}
MOCK_ALU_OPERATIONS=${MOCK_ALU_OPERATIONS:-ADD,SUB,AND,OR,XOR,SHL,SHR,SRA,SETCC_EQ,SETCC_NE,SETCC_LT,SETCC_ULT,SETCC_LE,SETCC_ULE,MULT}
PLATFORM=${PLATFORM:-asap7}

rm -f *.v

sbt -Duser.home="$HOME" -Djline.terminal=jline.UnsupportedTerminal -batch \
     "test:runMain GenerateMockAlu --width ${MOCK_ALU_WIDTH} --operations ${MOCK_ALU_OPERATIONS} --platform ${PLATFORM} -- --emit-modules verilog --emission-options disableMemRandomization,disableRegisterRandomization --target-dir ."

# reduce git noise as these comments will change if the line numbers in Chisel changes
find . -name "*.v" -type f -exec sed -i 's/ \/\/.*$//' {} \;
