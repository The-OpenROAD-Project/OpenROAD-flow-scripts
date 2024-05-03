#!/usr/bin/env bash
set -ex

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE=$DIR/../..

cd $DIR

cd ../../src/mock-array
cp ../../../results/asap7/mock-array/base/6_final.v post/MockArrayFinal.v
cp ../../../results/asap7/mock-array_Element/base/6_final.v post/MockArrayElementFinal.v

verilator -Wall --cc \
  -Wno-DECLFILENAME \
  -Wno-UNUSEDSIGNAL \
  -Wno-PINMISSING \
  --top-module MockArray \
  --trace \
  $PLATFORM_DIR/verilog/stdcell/asap7sc7p5t_AO_RVT_TT_201020.v \
  $PLATFORM_DIR/verilog/stdcell/asap7sc7p5t_INVBUF_RVT_TT_201020.v \
  $PLATFORM_DIR/verilog/stdcell/asap7sc7p5t_SIMPLE_RVT_TT_201020.v \
  $PLATFORM_DIR/verilog/stdcell/dff.v \
  $PLATFORM_DIR/verilog/stdcell/empty.v \
  ../../../results/asap7/mock-array/base/6_final.v \
  ../../../results/asap7/mock-array_Element/base/6_final.v \
  --exe \
  ../../../designs/src/mock-array/simulate.cpp

make -C obj_dir -f VMockArray.mk

obj_dir/VMockArray
