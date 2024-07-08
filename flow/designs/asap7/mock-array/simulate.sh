#!/usr/bin/env bash
set -ex

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE=$DIR/../..

cd $DIR

cd ../../src/mock-array
cp ../../../results/asap7/mock-array/base/6_final.v MockArrayFinal.v
cp ../../../results/asap7/mock-array_Element/base/6_final.v MockArrayElementFinal.v

pwd
sbt -Duser.home="$HOME" -Djline.terminal=jline.UnsupportedTerminal -batch \
     "test:runMain SimulatePostSynthesis --width ${MOCK_ARRAY_COLS} --height ${MOCK_ARRAY_ROWS} --dataWidth ${MOCK_ARRAY_DATAWIDTH}"

cp test_run_dir/MockArray_should_Wiggle_some_wires/MockArray.vcd .

