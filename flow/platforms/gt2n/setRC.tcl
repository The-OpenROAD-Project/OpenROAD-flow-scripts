# Per-length wire RC for GT2N derived from GT2N/qrc/GT2.ict.
# Liberty units in gt2_6t_w31_lvt_tt_0p7v25c.lib:
#   pulling_resistance_unit : 1ohm  -> R values are ohm / um
#   capacitive_load_unit(1, pf)     -> C values are pf / um
#
# R per length is computed as (resistivity [uOhm.cm] * 0.01) / (thickness [um])
# divided by the minimum wire width, giving ohm / um. Capacitance is a rough
# guess (no PEX data shipped in the ICT for these layers).

# Front-side routing
set_layer_rc -layer M0  -resistance 259    -capacitance 1.5e-4
set_layer_rc -layer M1  -resistance 156    -capacitance 1.5e-4
set_layer_rc -layer M2  -resistance 259    -capacitance 1.5e-4
set_layer_rc -layer M3  -resistance 156    -capacitance 1.5e-4
set_layer_rc -layer M4  -resistance  40    -capacitance 1.7e-4
set_layer_rc -layer M5  -resistance  40    -capacitance 1.7e-4
set_layer_rc -layer M6  -resistance   3.5  -capacitance 2.0e-4
set_layer_rc -layer M7  -resistance   3.5  -capacitance 2.0e-4
set_layer_rc -layer M8  -resistance   3.5  -capacitance 2.0e-4
set_layer_rc -layer M9  -resistance   3.5  -capacitance 2.0e-4
set_layer_rc -layer M10 -resistance   0.67 -capacitance 2.5e-4

# Backside (no calibration data in ICT; estimate from layer dimensions)
set_layer_rc -layer BPR -resistance  30    -capacitance 1.0e-4
set_layer_rc -layer BM1 -resistance   5    -capacitance 1.5e-4
set_layer_rc -layer BM2 -resistance   5    -capacitance 1.5e-4

# Via resistances (rough)
set_layer_rc -via V0 -resistance 10
set_layer_rc -via V1 -resistance 10
set_layer_rc -via V2 -resistance 8
set_layer_rc -via V3 -resistance 8
set_layer_rc -via V4 -resistance 5
set_layer_rc -via V5 -resistance 5

set_wire_rc -signal -layer M3
set_wire_rc -clock  -layer M5
