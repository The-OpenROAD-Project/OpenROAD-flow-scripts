Mock array big
==============

A mock array that can be configured in different sizes to generate
interesting test-cases.

By default, the array is 8x8 elements, has an 8 bit datapath with 
Element size of 4x4 unit and Element placement pitch of 6,6 - x,y direction.

export MOCK_ARRAY_TABLE         ?= 8 8 4 4 6 6

# Element'd data width
export MOCK_ARRAY_DATAWIDTH     ?= 8

To create a 4x4 element array with 4 bit datapath with element size of 5x6 and
placement pitch of 8x6, set the user control variable MOCK_ARRAY_TABLE

```
export MOCK_ARRAY_TABLE="4 4 5 6 8 6"
export MOCK_ARRAY_DATAWIDTH=4
export FLOW_VARIANT=small

export DESIGN_CONFIG=designs/asap7/mock-array/config.mk
```

Now run configure, which a custom target in mock-array, that runs Chisel to
regenerate the Verilog code for the above configuration:

```
make verilog
```

Now build the design as usual:

```
make
```

CTS
---

mock-array and mock-array Element are intended
to be fitted into a higher level module where CTS creates a balanced clock tree
that takes the mock-array and mock-array Element clock insertion
latency into account. This means that the optimization target
for mock-array and mock-array Element have zero skew.
