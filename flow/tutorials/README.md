# OpenROAD-flow-scripts Tutorial

The OpenROAD-flow-scripts tutorial to run the complete
OpenROAD based flow from RTL-to-GDS using [OpenROAD Flow
Scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts).

This tutorial also includes examples of useful design explorations and
manual usage in key flow stages to help users gain a good understanding of
the [OpenROAD](https://openroad.readthedocs.io/en/latest/main/README.html)
application flow, data organization, GUI and commands.

Refer to the [Flow
Tutorial](https://openroad.readthedocs.io/en/latest/tutorials/FlowTutorial.html).

## Tutorial Test Scripts

The directory `tutorials` contains a few scripts used by the `Flow
Tutorial`. The tutorial uses sample test scripts already part of OpenROAD
`test`.

### OpenROAD GUI Test Case
View [load_lef.tcl](./scripts/gui/load_lef.tcl) example Tcl script that shows
a simple user defined GUI customization to add `sky130` technology LEF file.

### Detail Routing Test Case
View [drc_issue.tcl](./scripts/drt/drc_issue.tcl) example Tcl script to
trace a simple DRC violation.

View [drc_fix.tcl](./scripts/drt/drc_fix.tcl) example Tcl script to fix
the DRC violation.

### Metal Fill Test Case
View [metal_fill.tcl](./scripts/metal_fill/metal_fill.tcl) example Tcl scrit
to add metal fill.
