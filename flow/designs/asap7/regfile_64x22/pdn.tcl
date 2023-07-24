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
define_pdn_grid -name {top} -voltage_domains {CORE}
add_pdn_stripe -grid {top} -layer {M1} -width {0.018} -pitch {0.54} -offset {0} -followpins
add_pdn_stripe -grid {top} -layer {M2} -width {0.018} -pitch {0.54} -offset {0} -followpins

add_pdn_ring   -grid {top} -layers {M3 M4} -widths {0.09 0.12} -spacings {0.072 0.072} -core_offset {0.144 0.144}

add_pdn_stripe -grid {top} -layer {M3} -width {0.09}  -spacing {0.072} -pitch {2.16} -offset {1.080} -extend_to_core_ring
add_pdn_stripe -grid {top} -layer {M4} -width {0.12}  -spacing {0.072} -pitch {2.16} -offset {1.080} -extend_to_core_ring

add_pdn_connect -grid {top} -layers {M1 M2}
add_pdn_connect -grid {top} -layers {M2 M3}
add_pdn_connect -grid {top} -layers {M3 M4}
