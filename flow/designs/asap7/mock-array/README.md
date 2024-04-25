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

constraint.sdc shared between mock-array and mock-array/Element
---------------------------------------------------------------

From the following observations, all else follows: the only thing
that can fail timing closure, is a register to register path. All
other constraints give the flow an optimization target. Failure
to meet the timing constraint of an optimization target constraint
is not a timing closure failure.

Note that ORFS regression checks does not have the ability to distinguish
between timing closure failures(register to register paths) and
optimization constraints violations. Timing violations for optimization constraints
in mock-array Element, such as maximum transit time for a combinational path
through mock-array Element, may or may not cause timing
violations later on higher up in mock-array on register to register paths.

For the Element constraint.sdc, the only register to register path
are within the Element and no lower level macros are
involved. Register to register paths within Element have to be checked
at the Element level as they are invisible higher up in mock-array.

As for the remaining optimization constraints for Element, they
should be for combinational through paths and from input pins to register and
from register to output pins.

The constraints.sdc file is designed such that the clock latency & tree
can be ignored as far constraints go;
it is not part of the optimization constraints. The clock tree latency
is accounted for in register to register paths within.

The timing closure for the register to register paths between
Element macros is checked at the mock-array level.

With this in mind, the constraints.sdc file for the Element becomes
quite general and simple. set_max_delay is used exclusively for
optimization constraints and the clock period is used to check timing
closure for register to register paths.

set_input/output_delay are not used and can't really be used
with the requirement that the constraint.sdc file should be articulated
without making assumptions on the clock tree insertion latency. The time specified
for set_input/output_delay is relative to the clock insertion point, i.e.
the time at the clock pin for the macro, which makes it impossible to articulate
the number that is passed in to set_input/output_delay without taking
clock network insertion latency into account.

Since set_input_delay is not used and set_max_delay is used instead, then
no hold cells are inserted, which is what is desired here.

Beware of [path segmentation](https://docs.xilinx.com/r/2020.2-English/ug906-vivado-design-analysis/TIMING-13-Timing-Paths-Ignored-Due-to-Path-Segmentation), which
can occur with OpenSTA.
