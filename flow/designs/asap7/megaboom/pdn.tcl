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

add_pdn_ring   -grid {top} -layers {M6 M7} -widths {0.544 0.544} -spacings {0.5 0.5} -core_offset {0.144 0.144}
add_pdn_ring   -grid {top} -layers {M8 M9} -widths {0.544 0.544} -spacings {0.5 0.5} -core_offset {0.144 0.144}

add_pdn_stripe -grid {top} -layer {M5} -width {0.12}  -spacing {0.072} -pitch {2.16} -offset {1.080} -extend_to_core_ring
add_pdn_stripe -grid {top} -layer {M6} -width {0.16}  -spacing {0.072} -pitch {2.16} -offset {1.080} -extend_to_core_ring

add_pdn_stripe -grid {top} -layer {M7} -width {0.288} -spacing {0.072} -pitch {4.32} -offset {3.156} -extend_to_core_ring
add_pdn_stripe -grid {top} -layer {M8} -width {0.400} -spacing {0.072} -pitch {4.32} -offset {3.12} -extend_to_core_ring
add_pdn_stripe -grid {top} -layer {M9} -width {0.400} -spacing {0.072} -pitch {4.32} -offset {3.100} -extend_to_core_ring

add_pdn_connect -grid {top} -layers {M1 M2}
add_pdn_connect -grid {top} -layers {M2 M5}
add_pdn_connect -grid {top} -layers {M5 M6}
add_pdn_connect -grid {top} -layers {M6 M7}
add_pdn_connect -grid {top} -layers {M7 M8}
add_pdn_connect -grid {top} -layers {M8 M9}

####################################
# macro grid
####################################
# The halo around the macro prevents pdn from blocking pin access
define_pdn_grid -name {fakeram} -macro -cells {fake.*} -halo "3.0 3.0 3.0 3.0" -voltage_domains {CORE}
add_pdn_connect -grid {fakeram} -layers {M4 M5}


