# Per-length wire RC for GT2N, derived analytically from
# GT2N/nxtgrd/GT2.itf (the StarRC interconnect tech file shipped with
# the PDK). See flow/platforms/gt2n/itf_to_rc.py for the script.
#
#   R/um  = RPSQ / WMIN                     (matches Fig 1(b) of the
#                                            GT2N paper)
#   C/um  = (Ca + Cb) * fringe + 2 * Cc     with
#     Ca = eps0 * eps_above * W / d_above   parallel-plate to neighbor above
#     Cb = eps0 * eps_below * W / d_below   parallel-plate to neighbor below
#     Cc = eps0 * eps_side  * T / SMIN      between sidewalls of min-spaced
#                                           neighbors at this layer
#     fringe factor 1.5x folds in a coarse fringe-field correction.
#
# The C numbers are physically grounded but still approximate -- the
# proper fix is a real RCX extraction pass. The ITF and the matching
# NXTGRD/QRC files (GT2N/nxtgrd/GT2.nxtgrd, GT2N/qrc/{GT2.ict,
# GT2_qrc.tch}) carry all the data a calibrated extractor needs;
# OpenRCX rules can be generated from a SPEF produced by either a
# proprietary tool or a 3D field solver (e.g. FasterCap) run on
# OpenRCX's own pattern DEFs. Until then this set_layer_rc table is
# the working approximation.
#
# Liberty units in gt2_6t_w*_*_tt_0p7v25c.lib:
#   pulling_resistance_unit : 1ohm    -> R values are ohm / um
#   capacitive_load_unit(1, pf)       -> C values are pf / um
# Via R is per via.

# Frontside routing
set_layer_rc -layer M0 -resistance 621.75 -capacitance 1.200e-04
set_layer_rc -layer M1 -resistance 437.50 -capacitance 1.023e-04
set_layer_rc -layer M2 -resistance 621.75 -capacitance 9.980e-05
set_layer_rc -layer M3 -resistance 437.50 -capacitance 1.023e-04
set_layer_rc -layer M4 -resistance 166.95 -capacitance 1.088e-04
set_layer_rc -layer M5 -resistance 166.95 -capacitance 1.051e-04
set_layer_rc -layer M6 -resistance 26.55 -capacitance 1.119e-04
set_layer_rc -layer M7 -resistance 26.55 -capacitance 1.051e-04
set_layer_rc -layer M8 -resistance 26.55 -capacitance 1.051e-04
set_layer_rc -layer M9 -resistance 26.55 -capacitance 1.051e-04
set_layer_rc -layer M10 -resistance 7.48 -capacitance 1.091e-04
set_layer_rc -layer M11 -resistance 7.48 -capacitance 1.051e-04
set_layer_rc -layer M12 -resistance 0.64 -capacitance 1.205e-04
set_layer_rc -layer M13 -resistance 0.64 -capacitance 1.205e-04
set_layer_rc -layer RDL -resistance 0.01 -capacitance 3.572e-04

# Backside routing
set_layer_rc -layer BPR -resistance 24.31 -capacitance 7.793e-05
set_layer_rc -layer BM1 -resistance 7.48 -capacitance 1.535e-04
set_layer_rc -layer BM2 -resistance 7.48 -capacitance 1.051e-04
set_layer_rc -layer BM3 -resistance 0.64 -capacitance 1.205e-04
set_layer_rc -layer BM4 -resistance 0.64 -capacitance 8.666e-05
set_layer_rc -layer BRDL -resistance 0.01 -capacitance 1.006e-04

# Frontside via R (per via, derived from ITF RPV)
set_layer_rc -via V0 -resistance 54.99
set_layer_rc -via V1 -resistance 54.99
set_layer_rc -via V2 -resistance 54.99
set_layer_rc -via V3 -resistance 45.78
set_layer_rc -via V4 -resistance 27.80
set_layer_rc -via V5 -resistance 14.89
set_layer_rc -via V6 -resistance 13.26
set_layer_rc -via V7 -resistance 13.26
set_layer_rc -via V8 -resistance 13.26
set_layer_rc -via V9 -resistance 7.65
set_layer_rc -via V10 -resistance 6.08
set_layer_rc -via V11 -resistance 6.08
set_layer_rc -via V12 -resistance 0.95
set_layer_rc -via V13 -resistance 0.15

# Backside via R (per via, derived from ITF RPV)
set_layer_rc -via BV0 -resistance 25.10
set_layer_rc -via BV1 -resistance 6.08
set_layer_rc -via BV2 -resistance 6.08
set_layer_rc -via BV3 -resistance 0.95
set_layer_rc -via BV4 -resistance 0.15

set_wire_rc -signal -layer M3
set_wire_rc -clock -layer M5
