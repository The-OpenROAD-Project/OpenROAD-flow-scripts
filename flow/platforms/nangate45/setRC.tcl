# Liberty units are fF,kOhm
set_layer_rc -layer metal1 -resistance 5.4286e-03 -capacitance 7.41819E-02
set_layer_rc -layer metal2 -resistance 3.70635E-03 -capacitance 8.33611E-02
set_layer_rc -layer metal3 -resistance 3.57728E-03 -capacitance 1.03981E-01
set_layer_rc -layer metal4 -resistance 1.47397E-03 -capacitance 1.19150E-01
set_layer_rc -layer metal5 -resistance 1.49065E-03 -capacitance 1.09256E-01
set_layer_rc -layer metal6 -resistance 1.50265E-03 -capacitance 1.14168E-01
set_layer_rc -layer metal7 -resistance 2.64082E-04 -capacitance 1.17491E-01
set_layer_rc -layer metal8 -resistance 1.89296E-04 -capacitance 9.45346E-02
set_layer_rc -layer metal9 -resistance 3.42860E-05 -capacitance 1.06091E-01
set_layer_rc -layer metal10 -resistance 3.86540E-05 -capacitance 7.37095E-01

set_wire_rc -signal -layer metal3
set_wire_rc -clock -layer metal5
