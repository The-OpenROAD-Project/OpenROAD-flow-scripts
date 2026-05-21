set_layer_rc -layer li1 -capacitance 1.499e-04 -resistance 6.81778E-02
set_layer_rc -layer met1 -capacitance 1.72375E-04 -resistance 1.20566E-03
set_layer_rc -layer met2 -capacitance 1.36233E-04 -resistance 1.22133E-03
set_layer_rc -layer met3 -capacitance 2.14962E-04 -resistance 1.66286E-04
set_layer_rc -layer met4 -capacitance 1.48128E-04 -resistance 1.68095E-04
set_layer_rc -layer met5 -capacitance 1.54087E-04 -resistance 1.83574E-05

set_layer_rc -via mcon -resistance 9.249146E-3
set_layer_rc -via via -resistance 4.5E-3
set_layer_rc -via via2 -resistance 3.368786E-3
set_layer_rc -via via3 -resistance 0.376635E-3
set_layer_rc -via via4 -resistance 0.00580E-3

set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5
