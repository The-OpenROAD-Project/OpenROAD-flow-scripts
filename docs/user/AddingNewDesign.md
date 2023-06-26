# Adding New Designs to the ORFS

This section explains how to add  verilog designs to ORFS
repository for a full RTL-GDS flow execution.

The following design example is based on the design `spm` that
implements a Single-port memory using `gf180` platform. This
procedure  applies to any design for a given platform you choose.

**Note:** The commands refer to the base directory as
`OpenROAD-flow-scripts/flow` as the starting point for the flow.

**Step 1:** Create the Verilog source files directory based on
the top module name.

``` shell
cd designs/src
mkdir spm
cd spm
vi spm.v
```

Copy [this](https://raw.githubusercontent.com/The-OpenROAD-Project/OpenLane/master/designs/spm/src/spm.v)
verilog code into spm.v.

**Step 2:** Create `config.mk` to define design configuration.

``` shell
cd designs/gf180
mkdir spm
cd spm
vi config.mk
```

**Step 3:** Define key design parameters in `config.mk`.

```
export PLATFORM         = gf180

export DESIGN_NAME      = spm

export VERILOG_FILES    = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE         = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.60

export TNS_END_PERCENT  = 100
```

To customize or add new variables to the `config.mk` refer to the
other built-in design examples or the flow variables list [here](./FlowVariables.md).

**Step 4:** Define SDC constraints.

``` shell
cd designs/gf180/spm
vi constraint.sdc
```

Edit as required to define design constraints.

```
current_design spm

set clk_name  core_clock
set clk_port_name clk
set clk_period 10
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

create_clock -name $clk_name -period $clk_period  $clk_port

set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]
```

Update only `current_design`, `clk_port_name` and `clk_period` as
per design requirements. Do not modify the remaining values for the
default template.

**Step 5:** Add the design name to `Makefile` to run the flow
with the `make` command.

``` shell
vi Makefile
```

Comment (#) any `DESIGN_CONFIG` if already enabled.

Add the following lines to `Makefile` and save the changes.
``` 
DESIGN_CONFIG=./designs/gf180/spm/config.mk
```

Run `make` command to run the flow from RTL to GDSII generation.

``` shell
make
```

If you do not want to change `Makefile`, you can simply run,

``` shell
make DESIGN_CONFIG=./designs/gf180/spm/config.mk
```
