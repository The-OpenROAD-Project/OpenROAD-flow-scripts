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

Element/constraint.sdc
----------------------

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
need to be particularly detailed. In fact, details can be counterproductive.

Consider minimum input delay, which relates to hold times. If the main concern
of architectural exploration is to ensure that the design can operate on a
sufficiently high frequency, then specifying minimum input delays during
exploration is premature. Minimum input delay is a constraint that belongs at
the end the development cycle when the design is well established and won't change
and the concern is to lock down the macro for it's specific operating frequency.

Choosing a strategy for Element/constraint.sdc combinational paths
------------------------------------------------------------------

It isn't possible to articulate a single .sdc file that exactly captures the
constraints of an Element as each element is used in unique circumstances.
Instead, a choice has to made and each choice has it's pros and cons.

It is relatively easy to set up a maximum input/output delay for paths
that start or end in a register, so this case is not discussed here.

It is the combinational(unregistered)
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
  However, path segmentation could occur with OpenSTA: https://docs.xilinx.com/r/2020.2-English/ug906-vivado-design-analysis/TIMING-13-Timing-Paths-Ignored-Due-to-Path-Segmentation
- Overconstrain: set up a maximum input/output path for the element and ignore
  timing violations at the Element level for combinational paths.
  The timing violations for the combinational paths are not real violations,
  because the maximum input and output paths can not occur at the same time
  in the array. The leftmost Element has the shortest maximum input path and
  and the rightmost the longestm aximum input path for
  `assign io_lsbOuts_0 = io_lsbIns_1;`. The OpenROAD tool could put too much
  emphasis on optimising the combinational path in this case, which could
  lead to less than optimal results.
