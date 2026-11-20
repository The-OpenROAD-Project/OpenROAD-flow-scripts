# Scripts

Various scripts to support flow as well as utilities.

## variables.mk

ORFS defines tcl scripts and variables that can be used to implement a flow. Variables in EDA flows is an idiomatic domain feature: placement density, list of .lib, .lef files, etc.

The variables are implemented using the `make` language, which ORFS makes no effort to hide. See examples below for usage. Beyond `make`, ORFS uses Python and bash to implement the variables.

The choice of `make` to implement the ORFS variables is historical and technical. Technically, the `make` language implements features such as default values, forward references, conditional evaluation of variables, environment variables support and specifying variables on the command line. `make` itself is an uncomplicated dependency, even if depending on and sharing makefiles can be trickier. There is no simple and obviously better choice than `make` to support these features and the use-cases.

ORFS avoids the [inversion of control](https://en.wikipedia.org/wiki/Inversion_of_control) trap where the user wants to be in control of the flow and also ORFS wants to be in the flow. To ORFS all build systems are first class citizens and the user can choose if it wants to let ORFS run the flow or if the user wants to be in control of the flow. The job of ORFS is to define and support an interface such that the user can pick a flow implementation that balances simplicity and required features for their project.

`make`'s simplicity reduces the cognitive load when getting started with simple OpenROAD examples, but its simplicity eventually causes more problems than it solves when the flow gets complicated enough. MegaBoom illustrates a how a more complicated flow is better implemented in bazel-orfs.

Some use-cases for `variables.mk`:

- ORFS has a Makefile that implements a flow on top of the variables implemented in `variables.mk` and the ORFS scripts. This is used for CI and local regression testing.
- The has his own Makefile where ORFS is part of the user's flow where they can include and use only `variables.mk` or the ORFS `makefile`, while remaining in charge.
- bazel-orfs currently uses the ORFS `makefile` do- targets where no dependency checking is done to implement an ORFS flow. bazel-orfs may switch to using `variables.mk` to evaluate the variables and invoking OpenROAD directly.

### Variables hello world

It can be useful to run simple experiments to see what variables evaluate to:

    $ make --file=scripts/variables.mk PLATFORM=asap7 DESIGN_NAME=gcd print-OBJECTS_DIR
    OBJECTS_DIR = ./objects/asap7/gcd/base

### Creating and using a bash sourceable script to set up variables

As an example of evaluating ORFS variables and invoking OpenROAD directly, first run synthesis on an existing design, set up variables, source the environment variables, then invoke floorplan directly:

    $ cd .../OpenROAD-flow-scripts/flow
    $ make DESIGN_CONFIG=designs/asap7/gcd/config.mk synth
    $ make DESIGN_CONFIG=designs/asap7/gcd/config.mk vars
    $ . objects/asap7/gcd/base/vars.sh
    $ openroad -exit scripts/floorplan.tcl
    [deleted]
    ==========================================================================
    floorplan final report_design_area
    --------------------------------------------------------------------------
    Design area 38 u^2 19% utilization.
    $

### Creating a bash sourcable script to set up variables using `variables.mk` directly

It is also possible to evaluate the variables without using the ORFS `Makefile`, but using `variables.mk` directly. In this example we copy the variables set in `designs/asap7/gcd/config.mk` onto the command line:

    $ make PLATFORM=asap7 DESIGN_NAME=gcd VERILOG_FILES=$(ls designs/src/gcd/*.v) SDC_FILE=designs/asap7/gcd/constraint.sdc "DIE_AREA=0 0 16.2 16.2" "CORE_AREA=1.08 1.08 15.12 15.12" PLACE_DENSITY=0.35 SKIP_LAST_GASP=1 --file=scripts/variables.mk vars
    $ . objects/asap7/gcd/base/vars.sh
    $ openroad -exit scripts/floorplan.tcl
    [deleted]
    ==========================================================================
    floorplan final report_design_area
    --------------------------------------------------------------------------
    Design area 38 u^2 19% utilization.
    $

### flow.sh and synth.sh

Utility scripts that can be used in combination with `variables.mk` to invoke synthesis and flow steps without going through the ORFS `Makefile`.

## Creating a .yaml file with specific variable values

Print any variable in .yaml syntax. To create a .yaml file that
contains value of variables, run:

    make print-CORE_UTILIZATION print-PLACE_DENSITY > foo.yaml

Outputs foo.yaml:

    CORE_UTILIZATION: 55
    PLACE_DENSITY: 0.30

Useful in bazel-orfs flows or debugging configuration.
