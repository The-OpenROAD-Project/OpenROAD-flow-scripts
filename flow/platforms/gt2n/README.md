# GT2N PDK

> **Source:** copied verbatim from [azadnaeemi/GT2N](https://github.com/azadnaeemi/GT2N) at commit [`308b221`](https://github.com/azadnaeemi/GT2N/commit/308b221b82e19199a9691f2f78cbc7ce981481ca) (2026-06-09). This release splits the original `gt2_6t_tap_w*_*` cell into a frontside-PDN variant (`gt2_6t_tapfspdn_w*_*`, M1 + BPR pins, full width) and a backside-PDN variant (`gt2_6t_tapbspdn_w*_*`, BPR-only pins, half width) in both the LEF and the GDS, resolving the LEF / GDS mismatch we filed as [azadnaeemi/GT2N#16](https://github.com/azadnaeemi/GT2N/issues/16). The platform `TAP_CELL_NAME` points at the backside-PDN variant since the PDN here is backside-only. Also incorporates the BPR `OBS` → `PORT` fix from [azadnaeemi/GT2N#12](https://github.com/azadnaeemi/GT2N/issues/12).

<img src="./VirtualFabricationDemo.gif" alt="VirtualFabricationDemo" width="400">

This is the initial release for the GT2N PDK with 71 standard cells. It is based on 2nm GAAFET with BSPDN.

If you use this PDK for publishing your work, we would appreciate citation of the following paper:

D. Jang, P. Kumar, M. N. H. Shazon, S. J. Ram, A. Svizhenko, V. Moroz, A. Ceyhan, N. A. Radhakrishn, and A. Naeemi, "GT2N: An Open-Source 2nm Nanosheet PDK Enabling Multi-Width/VT Benchmarking," in IEEE International Symposium on Circuits and Systems (ISCAS) 2026 [link](https://www.dropbox.com/scl/fi/3to35aip31hfqj76q7g5x/dongwon_iscas26.pdf?rlkey=utm8my3qq36y8mo0hkvto6tnv&st=876o2oh8&dl=0).

Quick setup guide for Custom Compiler:

Create a folder (e.g. gt2_techlib) and copy GT2N/techlib/nmos_lvt and GT2N/techlib/pmos_lvt inside that folder.
Inside the folder from where custom_compiler is run, add the following to the lib.defs file:
gt2_official <path_to_techlib_directory>/gt2_techlib

You can specify any name for the library instead of using gt2_offical. The current standard cell schematics are linked with the devices using this name. In case any other library name is used, the device references might need to be updated in the schematics.

To assign technology to the lib, the following .tf file can be imported using "Technology Manager" and applied to the gt2_official lib:
GT2N/techlib/gt2_techfile.tf

To import all the standard cells, either custom_compiler .oa format or .gds files can be used.
Create a folder for the standard cell library (e.g. gt2_std_cells) and add it to the lib.defs file:
gt2_std_cells <path_to_std_cells_directory>/gt2_std_cells

In the "Technology Manager", the associated technology needs to be changed to gt2_official (or the lib name used in the previous stage). Alternatively, the .tf file can also be imported and applied to gt2_std_cells. This is necessary, otherwise layers would not be identified. Any new library created needs to follow the same process. To assign colors to the layer, load "GT2N/techlib/gt2_layer_colors.tcl" using the "Display Resource Manager".

Copy everything inside GT2N/std_cells folder to gt2_std_cells. This includes layouts, schematics, and abstract views for custom_compiler.

Standard cell layouts can also be imported using the .gds file: GT2N/gds/gt2_6t_std_cells.gds

LVS and DRC rulesets for icvalidator are present in "GT2N/icv_runset".

Libraries are composed of 3 process corners (under development), 2 nanosheet width (W) flavors, and 5 threshold voltage (VT) flavors. (In the order of decreasing VT, HVT > SVT > LVT > ULVT > ELVT)

The collaterals required for synthesis and PnR are (depending on the process corner and W/VT flavor):

LIB: GT2N/lib/tt/gt2_6t_w31_lvt_tt_0p7v25c.lib

LEF: GT2N/lef/tt/gt2_6t_w31_lvt.lef

Techlef: GT2N/techlib/gt2_tech.lef

ICT: GT2N/qrc/GT2.ict

QRCTech: GT2N/qrc/GT2_qrc.tch

ITF: GT2N/nxtgrd/GT2.itf

NXTGRD: GT2N/nxtgrd/GT2.nxtgrd

The GAAFET (3-stack nanosheet) model card is (depending on the process corner and W/VT flavor):

GT2N/device/tt/gt2_w31_lvt_tt.sp

BSPDN support for Cadence Innovus implementation flow is under development.
