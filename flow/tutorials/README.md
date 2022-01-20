# OpenROAD-flow-scripts Tutorial

The OpenROAD-flow-scripts tutorial to run the complete OpenROAD based
flow from RTL-to-GDS using [OpenROAD Flow
Scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts).

This tutorial also includes examples of useful design explorations and manual
usage in key flow stages to help users gain a good understanding of the
[OpenROAD](https://openroad.readthedocs.io/en/latest/main/README.html)
application flow, data organization, GUI and commands. 

Refer to the flow tutorials documentation details 
[here]((https://github.com/OpenROAD/blob/master/docs/tutorials/FlowTutorial.md)

## Tutorial Test Scripts

The directory `TutorialScripts` contains a few scripts used by the  `Flow tutorial`.
The tutorial uses sample test scripts already part of OpenROAD `test`.

### OpenROAD GUI Test Case
View [load_lef.tcl](./TutorialScripts/gui/load_lef.tcl) example tcl script that shows a 
simple user defined GUI customization to add `sky130` technology `.lef` file.

### Detail Routing Test Case
View [drt_issue.tcl](./TutorialScripts/drt/drt_issue.tcl) example tcl script to trace a simple DRC violation.

View [drc_fix.tcl](./TutorialScripts/drt/drt_fix.tcl) example tcl script to fix the DRC violation.
