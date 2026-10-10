# macro level counterpart to BLOCKS_grid_strategy.tcl
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
# M1 M2 are for follow pin, width derived from PG rail in standard cell
# M5 stripes at minimum width on the M5 tracks: a V4 cut is then as wide as its
#   M5 (V4.M5.AUX.2), so the same holds where they meet the M4 ring
# The M4 M5 ring on the routing tracks (see ring_offsets.tcl); its M5 at
#   minimum width for the V4s at the ring's corners
####################################
define_pdn_grid -name {top} -voltage_domains {CORE} -pins {M5}

add_pdn_ring -grid {top} -layers {M5 M4} -widths {0.024 0.12} -spacings {0.072} \
  -core_offsets [asap7_ring_core_offsets M4 0.12 M5 0.024 0.084]

add_pdn_stripe -grid {top} -layer {M1} -width {0.018} -pitch {0.54} -offset {0} -followpins
add_pdn_stripe -grid {top} -layer {M2} -width {0.018} -pitch {0.54} -offset {0} -followpins

add_pdn_stripe -grid {top} -layer {M5} -width {0.024} -spacing {0.072} -pitch {2.976} -offset {1.5} \
  -extend_to_core_ring -snap_to_grid

add_pdn_connect -grid {top} -layers {M1 M2}
add_pdn_connect -grid {top} -layers {M2 M5} -min_width_layers {M3 M4} -ongrid {M4}
add_pdn_connect -grid {top} -layers {M4 M5}
