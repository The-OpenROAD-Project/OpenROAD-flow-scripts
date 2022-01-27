# sync from openroad repo test/sky130hd/sky130hd.rc
set_layer_rc -layer li1 -capacitance 1.499e-04 -resistance 7.176e-02
set_layer_rc -layer met1 -capacitance 1.449e-04 -resistance 8.929e-04
set_layer_rc -layer met2 -capacitance 1.331e-04 -resistance 8.929e-04
set_layer_rc -layer met3 -capacitance 1.464e-04 -resistance 1.567e-04
set_layer_rc -layer met4 -capacitance 1.297e-04 -resistance 1.567e-04
set_layer_rc -layer met5 -capacitance 1.501e-04 -resistance 1.781e-05
# end sync

set_layer_rc -via mcon -resistance 9.249146E-3
set_layer_rc -via via -resistance 4.5E-3
set_layer_rc -via via2 -resistance 3.368786E-3
set_layer_rc -via via3 -resistance 0.376635E-3
set_layer_rc -via via4 -resistance 0.00580E-3

set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5
