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
# The M5 and M6 pitches are reduced to ensure all macros have straps over them
add_pdn_stripe -grid {top} -layer {M5} -width {0.12} -spacing {0.072} -pitch {6} -offset {0.300}
add_pdn_stripe -grid {top} -layer {M6} -width {0.288} -spacing {0.096} -pitch {6} -offset {0.513}
add_pdn_connect -grid {top} -layers {M1 M2}
add_pdn_connect -grid {top} -layers {M2 M5}
add_pdn_connect -grid {top} -layers {M5 M6}

####################################
# Element grid
####################################
# The halo around the macro prevents pdn from blocking pin access
define_pdn_grid -macro -cells Element -halo "1.0 1.0 1.0 1.0" -voltage_domains {CORE} -name ElementGrid
add_pdn_connect -grid {ElementGrid} -layers {M5 M6}
