# correlation result (aes, gcd, ibex, riscv32i, spi)
# Metal1 capacitance fixed up from -1.1e-05 to 1e-10 as a minuscule positive value
set_layer_rc -layer Metal1 -resistance 8.54576E-03 -capacitance 1e-10
set_layer_rc -layer Metal2 -resistance 2.53519E-03 -capacitance 1.69121E-04
set_layer_rc -layer Metal3 -resistance 1.54329E-03 -capacitance 1.82832E-04
set_layer_rc -layer Metal4 -resistance 6.31424E-04 -capacitance 1.66454E-04
set_layer_rc -layer Metal5 -resistance 6.84051E-04 -capacitance 8.57431E-05
set_wire_rc -signal -resistance 2.07259E-03 -capacitance 1.73072E-04
set_wire_rc -clock -resistance 2.48603E-03 -capacitance 1.44812E-04

set_layer_rc -via Via1 -resistance 2.0E-3
set_layer_rc -via Via2 -resistance 2.0E-3
set_layer_rc -via Via3 -resistance 2.0E-3
set_layer_rc -via Via4 -resistance 2.0E-3
set_layer_rc -via TopVia1 -resistance 0.4E-3
set_layer_rc -via TopVia2 -resistance 0.22E-3
