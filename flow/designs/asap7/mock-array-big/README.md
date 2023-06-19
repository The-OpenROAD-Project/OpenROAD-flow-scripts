Mock array big
==============

A mock array that can be configured in different sizes to generate
interesting test-cases.

By default, the array is 8x8 elements and has an 8 bit datapath.


```
# To create a 4x4 element array, 3unit x 3unit size, placement pitch 5x5 and 4 bit datapath, 
# first create a settings.mk file:
export MOCK_ARRAY_TABLE="4 4 3 3 5 5"
export MOCK_ARRAY_DATAWIDTH=4
export FLOW_VARIANT=small

# To create a 4x4 element array, 16unit x 16unit size, placement pitch 6x5 and 4 bit datapath, 
# first create a settings.mk file:
# use a different folder for each combination of parameters
#export MOCK_ARRAY_TABLE="4 4 16 16 6 5"
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
