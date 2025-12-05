# Liberty units are fF,kOhm
set_layer_rc -layer metal2 -resistance 3.69946E-03 -capacitance 8.31598E-02
set_layer_rc -layer metal3 -resistance 3.59251E-03 -capacitance 1.04578E-01
set_layer_rc -layer metal4 -resistance 1.47169E-03 -capacitance 1.16865E-01
set_layer_rc -layer metal5 -resistance 1.48720E-03 -capacitance 1.10884E-01
set_layer_rc -layer metal6 -resistance 1.49718E-03 -capacitance 1.06865E-01
set_layer_rc -layer metal7 -resistance 2.16176E-04 -capacitance 1.15007E-01
set_layer_rc -layer metal8 -resistance 1.88720E-04 -capacitance 9.22290E-02
set_layer_rc -layer metal9 -resistance 3.77464E-05 -capacitance 1.19876E-01
set_layer_rc -layer metal10 -resistance 3.54210E-05 -capacitance 1.18534E-01

set_wire_rc -signal -layer metal3
set_wire_rc -clock -layer metal5
