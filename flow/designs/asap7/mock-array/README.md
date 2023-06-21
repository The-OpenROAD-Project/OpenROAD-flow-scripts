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

Element/constraint.sdc
----------------------

A relatively simple constraint.sdc is adequate for the Element as
timing is exported when the Element macro is made and checked at the
mock-array level.

Note that a failure on timing at the Element level is
not a problem, as long as timing is met at the mock-array level.

The purpose of the constraint.sdc file at the Element level is to
be able to iterate on the Element during development and work on,
for instance, maximum operating frequency changes in the Verilog,
but also to give the tools some guidance on how to optimize the
macro.

Optimizing Element/constraint.sdc
---------------------------------

Before considering the various strategies to articulate an Element/constraint.sdc
file below, note that no tests have been run to verify that these
different constraint.sdc changes below have any effects on the quality
of results at the mock-array level. If there are no substantial
differences in quality of results and timing is met, then the differences
between the strategies below are inconsequential.

A single macro is made for all the elements in the array, though strictly
speaking each macro is unique in that the timing constraints of each element
in the array is different.

To illustrate, consider the `assign io_lsbOuts_0 = io_lsbIns_1;` statement in Element.v.
Here a signal is routed from left to right, through the Element without the signal
being registered.

Clearly, the maximum input delay for `io_lsbIns_1` is
smaller for the leftmost than for the rightmost Element.

Taking a step back, it is also worth considering what level of detail is
appropriate for the Element's constraint.sdc file.

In the beginning of a project, during exploration, the .sdc file does not
need to be particularly detailed. In fact, details can be counterproductive,
as they tend to be inaccurate and cause the tools to spend time solving potential non-issues.

Consider minimum input delay, which relates to hold times. If the main concern
of architectural exploration is to ensure that the design can operate on a
sufficiently high frequency, then specifying minimum input delays during
exploration is premature. Minimum input delay is a constraint that belongs at
the end the development cycle when the design is well established and won't change
and the concern is to lock down the macro for its specific operating frequency.

Choosing a strategy for Element/constraint.sdc combinational paths
------------------------------------------------------------------

It isn't possible to articulate a single .sdc file that exactly captures the
constraints of an Element as each element is used in unique circumstances.
Instead, a choice has to made and each choice has its pros and cons.

It is relatively easy to set up a maximum input/output delay for paths
that start or end in a register, so this case is not discussed here.

It is the combinational(unregistered) in -> out
paths that are tricky to create constraints for.

- Strategy used as of writing: mark non-registered/combinational paths through
  the Element as false paths. This will not steer the tools to optimize the
  through element path, such as discussed above and there's no timing information
  available at the Element level for these combinational paths.
  However, at the `MockArray` level when the Elements are used, timing will
  be checked, because the .lib file generated for the Element contains timing
  information, even for false paths.
- Use `set_max_delay` for combinational paths. This will make the tool try
  to optimize the combinational path and there will be timing information available.
  However, path segmentation could occur with OpenSTA. Refer [here](https://docs.xilinx.com/r/2020.2-English/ug906-vivado-design-analysis/TIMING-13-Timing-Paths-Ignored-Due-to-Path-Segmentation).
- Overconstrain: set up a maximum input/output path for the element and ignore
  timing violations at the Element level for combinational paths.
  The timing violations for the combinational paths are not real violations,
  because the maximum input and output paths can not occur at the same time
  in the array. The leftmost Element has the shortest maximum input path and
  and the rightmost the longest maximum input path for
  `assign io_lsbOuts_0 = io_lsbIns_1;`. The OpenROAD tool could put too much
  emphasis on optimising the combinational path in this case, which could
  lead to less than optimal results and/or inflated run times.
