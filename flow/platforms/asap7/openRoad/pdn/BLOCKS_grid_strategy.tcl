# Top level PDN for macros using BLOCK_grid_strategy.tcl
source $::env(SCRIPTS_DIR)/util.tcl

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
add_pdn_ring   -grid {top} -layers {M5 M6} -widths {0.504 0.544} -spacings {0.096} -core_offset {0.504}

add_pdn_stripe -grid {top} -layer {M5} -width {0.12}  -spacing {0.072} -pitch {2.16} -offset {1.50} -extend_to_core_ring
add_pdn_stripe -grid {top} -layer {M6} -width {0.288} -spacing {0.096} -pitch {4.32} -offset {1.504} -extend_to_core_ring

add_pdn_connect -grid {top} -layers {M1 M2}
add_pdn_connect -grid {top} -layers {M2 M5}
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

define_pdn_grid -macro -cells $macro_names \
    -halo "$::env(MACRO_ROWS_HALO_X) $::env(MACRO_ROWS_HALO_Y) $::env(MACRO_ROWS_HALO_X) $::env(MACRO_ROWS_HALO_Y)" \
    -voltage_domains {CORE} -name ElementGrid

add_pdn_connect -grid {ElementGrid} -layers {M5 M6}
