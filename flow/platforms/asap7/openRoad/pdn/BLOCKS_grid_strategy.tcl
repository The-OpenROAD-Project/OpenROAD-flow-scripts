# Top level PDN for macros using BLOCK_grid_strategy.tcl
source $::env(SCRIPTS_DIR)/util.tcl
source [file join [file dirname [info script]] ring_offsets.tcl]

####################################
# global connections
####################################
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground

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
# The ring on the routing tracks: each wire an odd number of track widths, each
# width plus spacing a whole number of track pitches, and the offsets from the
# core chosen to centre the wires on tracks.  M5 is 0.408, a width the LEF allows
# under the 0.48 maximum;
# M6 is 0.288, the one width M6_M5widePWR1p152 makes a V5 bar as wide as.
add_pdn_ring -grid {top} -layers {M5 M6} -widths {0.408 0.288} -spacings {0.072 0.096} \
  -core_offsets [asap7_ring_core_offsets M6 0.288 M5 0.408 0.504]

# Minimum-width M5 straps: a V4 cut is then as wide as its M5 (V4.M5.AUX.2).
# Five times as many as the 0.12 um straps they replace, for the IR drop.
add_pdn_stripe -grid {top} -layer {M5} -width {0.024} -spacing {0.072} -pitch {0.432} \
  -offset {1.50} -extend_to_core_ring -snap_to_grid
add_pdn_stripe -grid {top} -layer {M6} -width {0.288} -spacing {0.096} -pitch {4.32} \
  -offset {1.504} -extend_to_core_ring -snap_to_grid

add_pdn_connect -grid {top} -layers {M1 M2}
# M3 and M4 at minimum width and the M4 pad on the M4 tracks, not on the M2 rails.
add_pdn_connect -grid {top} -layers {M2 M5} -min_width_layers {M3 M4} -ongrid {M4}
add_pdn_connect -grid {top} -layers {M5 M6}

####################################
# Element grid
####################################
# The halo around the macro prevents pdn from blocking pin access

set macro_names {}

foreach macro [find_macros] {
  set macro_name [[$macro getMaster] getName]
  dict set macro_names $macro_name 1
}
set macro_names [dict keys $macro_names]

set halo_x $::env(MACRO_ROWS_HALO_X)
set halo_y $::env(MACRO_ROWS_HALO_Y)
define_pdn_grid -macro -cells $macro_names \
  -halo "$halo_x $halo_y $halo_x $halo_y" \
  -voltage_domains {CORE} -name ElementGrid

add_pdn_connect -grid {ElementGrid} -layers {M5 M6}
