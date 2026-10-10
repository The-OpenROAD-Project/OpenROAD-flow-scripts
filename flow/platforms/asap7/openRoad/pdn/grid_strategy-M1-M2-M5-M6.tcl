####################################
# global connections
####################################
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDPE$}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDCE$}
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSSE$}
global_connect
####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
####################################
# standard cell grid
####################################
define_pdn_grid -name {top} -voltage_domains {CORE} -pins {M6}
add_pdn_stripe -grid {top} -layer {M1} -width {0.018} -pitch {0.54} -offset {0} -followpins
add_pdn_stripe -grid {top} -layer {M2} -width {0.018} -pitch {0.54} -offset {0} -followpins
# Minimum-width M5 straps on the M5 tracks: a V4 cut is then as wide as its M5
# (V4.M5.AUX.2) and the strap's edges lie on the 24 nm grid (M5.AUX.1, W.4).
# Five times as many as the 0.12 um straps they replace, at a fifth of the
# pitch, so the M5 metal and the M2-to-M5 stacks keep the IR drop down.
add_pdn_stripe -grid {top} -layer {M5} -width {0.024} -spacing {0.072} -pitch {1.08} -offset {0.300} \
  -snap_to_grid
add_pdn_stripe -grid {top} -layer {M6} -width {0.288} -spacing {0.096} -pitch {5.4} -offset {0.513} \
  -snap_to_grid
add_pdn_connect -grid {top} -layers {M1 M2}
# The M2-to-M5 stacks: M3 and M4 at minimum width, so each cut is as wide as the
# metal over it (V2.M3.AUX.2), and the M4 pad on the M4 tracks rather than
# centred on the 270 nm M2 rails, which are off M4's 24 nm grid (M4.AUX.1/2).
add_pdn_connect -grid {top} -layers {M2 M5} -min_width_layers {M3 M4} -ongrid {M4}
add_pdn_connect -grid {top} -layers {M5 M6}
####################################
# macro grids
####################################
####################################
# grid for: CORE_macro_grid_1
####################################
define_pdn_grid -name {CORE_macro_grid_1} -voltage_domains {CORE} -macro \
  -orient {R0 R180 MX MY} -halo {2.0 2.0 2.0 2.0} -default
add_pdn_connect -grid {CORE_macro_grid_1} -layers {M4 M5}
####################################
# grid for: CORE_macro_grid_2
####################################
define_pdn_grid -name {CORE_macro_grid_2} -voltage_domains {CORE} -macro \
  -orient {R90 R270 MXR90 MYR90} -halo {2.0 2.0 2.0 2.0} -default
add_pdn_connect -grid {CORE_macro_grid_2} -layers {M4 M5}
