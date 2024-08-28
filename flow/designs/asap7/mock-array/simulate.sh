#!/usr/bin/env bash
#
# Executes Verilator to generate a VCD file based on simulation
# simulate.cpp is set up to write the VCD file into the results directory
#
set -ex

OBJ_DIR="$RESULTS_DIR/verilator/obj"
POST_DIR="$RESULTS_DIR/verilator/post"

# Make sure the output directories are created
mkdir -p $OBJ_DIR
mkdir -p $POST_DIR

# Copy Verilog files used for simulation to post dir in the objects area
cp $FLOW_HOME/results/asap7/mock-array/base/6_final.v $POST_DIR/MockArrayFinal.v
cp $FLOW_HOME/results/asap7/mock-array_Element/base/6_final.v $POST_DIR/MockArrayElement.v

# Run simulation and have Verilator write the output files to the objects area
verilator -Wall --cc \
  -Wno-DECLFILENAME \
  -Wno-UNUSEDSIGNAL \
  -Wno-PINMISSING \
  --Mdir $OBJ_DIR \
  --top-module MockArray \
  --trace \
  $PLATFORM_DIR/verilog/stdcell/asap7sc7p5t_AO_RVT_TT_201020.v \
  $PLATFORM_DIR/verilog/stdcell/asap7sc7p5t_INVBUF_RVT_TT_201020.v \
  $PLATFORM_DIR/verilog/stdcell/asap7sc7p5t_SIMPLE_RVT_TT_201020.v \
  $PLATFORM_DIR/verilog/stdcell/dff.v \
  $PLATFORM_DIR/verilog/stdcell/empty.v \
  $FLOW_HOME/results/asap7/mock-array/base/6_final.v \
  $FLOW_HOME/results/asap7/mock-array_Element/base/6_final.v \
  --exe \
  $FLOW_HOME/designs/src/mock-array/simulate.cpp

# Link the generated object files into the VMockArray executable
make -j -C $OBJ_DIR -f VMockArray.mk

# Run the simulation
$OBJ_DIR/VMockArray
