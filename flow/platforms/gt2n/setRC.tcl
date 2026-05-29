# Per-length wire RC for GT2N. Resistance values are R_BEOL from
# Jang et al., GT2N Fig. 1(b) (Ohm/um, already in the units Liberty
# expects). Capacitance values are still rough placeholders -- the
# ICT shipped with the PDK does not contain extracted C -- so they
# should be replaced with values from a calibrated RCX/QRC model
# before treating any C-derived quantity as physical. Via resistances
# are also placeholders, scaled roughly by cut size.
#
# Liberty units in gt2_6t_w31_lvt_tt_0p7v25c.lib:
#   pulling_resistance_unit : 1ohm  -> R values are ohm / um
#   capacitive_load_unit(1, pf)     -> C values are pf / um

# Front-side routing (R from Fig. 1(b))
set_layer_rc -layer M0 -resistance 622 -capacitance 1.5e-4
set_layer_rc -layer M1 -resistance 438 -capacitance 1.5e-4
set_layer_rc -layer M2 -resistance 622 -capacitance 1.5e-4
set_layer_rc -layer M3 -resistance 438 -capacitance 1.5e-4
set_layer_rc -layer M4 -resistance 166 -capacitance 1.7e-4
set_layer_rc -layer M5 -resistance 166 -capacitance 1.7e-4
set_layer_rc -layer M6 -resistance 26 -capacitance 2.0e-4
set_layer_rc -layer M7 -resistance 26 -capacitance 2.0e-4
set_layer_rc -layer M8 -resistance 26 -capacitance 2.0e-4
set_layer_rc -layer M9 -resistance 26 -capacitance 2.0e-4
set_layer_rc -layer M10 -resistance 7.5 -capacitance 2.5e-4
set_layer_rc -layer M11 -resistance 7.5 -capacitance 2.5e-4
set_layer_rc -layer M12 -resistance 0.64 -capacitance 3.0e-4
set_layer_rc -layer M13 -resistance 0.64 -capacitance 3.0e-4

# Backside (R from Fig. 1(b))
set_layer_rc -layer BPR -resistance 28 -capacitance 1.0e-4
set_layer_rc -layer BM1 -resistance 7.5 -capacitance 1.5e-4
set_layer_rc -layer BM2 -resistance 7.5 -capacitance 1.5e-4
set_layer_rc -layer BM3 -resistance 0.64 -capacitance 1.5e-4
set_layer_rc -layer BM4 -resistance 0.64 -capacitance 1.5e-4

# Via resistances (fake; rough scaling vs. cut size)
set_layer_rc -via V0 -resistance 10
set_layer_rc -via V1 -resistance 10
set_layer_rc -via V2 -resistance 8
set_layer_rc -via V3 -resistance 8
set_layer_rc -via V4 -resistance 5
set_layer_rc -via V5 -resistance 5

# Backside via resistances (fake; same scale as front-side V0..V4)
set_layer_rc -via BV0 -resistance 10
set_layer_rc -via BV1 -resistance 8
set_layer_rc -via BV2 -resistance 8
set_layer_rc -via BV3 -resistance 5
set_layer_rc -via BV4 -resistance 5

set_wire_rc -signal -layer M3
set_wire_rc -clock -layer M5
