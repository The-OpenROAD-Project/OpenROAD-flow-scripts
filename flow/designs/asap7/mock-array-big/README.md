Mock array big
==============

A mock array that can be configured in different sizes to generate
interesting test-cases.

By default, the array is 8x8 elements and has an 8 bit datapath.

To create a 4x4 element array with 4 bit datapath, first create a settings.mk file:

```
export MOCK_ARRAY_WIDTH=4
export MOCK_ARRAY_HEIGHT=4
export MOCK_ARRAY_DATAWIDTH=4
export FLOW_VARIANT=small
# use a different folder for each combination of parameters
#export MOCK_ARRAY_WIDTH=16
#export MOCK_ARRAY_HEIGHT=16
#export MOCK_ARRAY_DATAWIDTH=64
#export FLOW_VARIANT=giant
export DESIGN_CONFIG=designs/asap7/mock-array-big/config.mk
```

Now run configure, which a custom target in mock-array-big, that runs Chisel to
regenerate the Verilog code for the above configuration:

```
make verilog
```

Now build the design as usual:

```
make
```
