# OpenROAD-flow-scripts Tutorial

The OpenROAD-flow-scripts tutorial to run the complete OpenROAD based
flow from RTL-to-GDS using [OpenROAD Flow
Scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts).

This tutorial also includes examples of useful design explorations and manual
usage in key flow stages to help user gain a good understanding of the
[OpenROAD](https://openroad.readthedocs.io/en/latest/main/README.html)
application flow, data organization, GUI and commands. 

Refer the flow tutorials documentation details 
[here]((https://github.com/OpenROAD/blob/master/docs/tutorials/FlowTutorial.md)

## Tutorial Test Scripts

The directory `TutorialScripts` contains a few scripts used by the  `Flow tutorial`.
The tutorial generally uses sample test scripts that are already part of OpenROAD `test`.

### OpenROAD GUI Test Case
`./TutorialScripts/gui/load_lef.tcl`, example tcl script that shows a 
simple user defined GUI customization.

### Detail Routing Test Case
`./TutorialScripts/drt/drt_issue.tcl`, example tcl script to trace a simple DRC violation.

`./TutorialScripts/drt/drt_fix.tcl`, example tcl script to fix the DRC violation.
