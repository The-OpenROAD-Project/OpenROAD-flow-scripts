####################################
# global connections
####################################
add_global_connection -net {VDD} -pin_pattern {^VDD$} -power
add_global_connection -net {VDD} -pin_pattern {^VDDPE$}
add_global_connection -net {VDD} -pin_pattern {^VDDCE$}
#add_global_connection -net {VDD} -pin_pattern {VPWR}
#add_global_connection -net {VDD} -pin_pattern {VPB}
add_global_connection -net {VSS} -pin_pattern {^VSS$} -ground
add_global_connection -net {VSS} -pin_pattern {^VSSE$}
#add_global_connection -net {VSS} -pin_pattern {VGND}
#add_global_connection -net {VSS} -pin_pattern {VNB}
global_connect
#add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
#add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDPE$}
#add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDCE$}
#add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPWR}
#add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPB}
#add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
#add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSSE$}
#add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VGND}
#add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VNB}
####################################
####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
#proc####################################
# standard c#ell grid
####################################
define_pdn_grid -name {grid} -voltage_domains {CORE}
add_pdn_ring -grid {grid} -layers {Metal5 TopMetal1} -widths {5.0} -spacings {2.0} -core_offsets {4.5} -connect_to_pads
add_pdn_stripe -grid {grid} -layer {Metal1}     -width {0.48}  -pitch {7.56} -offset {0}      -followpins -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {Metal5}     -width {2.200} -pitch {75.6} -offset {13.600}             -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {TopMetal1}  -width {1.800} -pitch {75.6} -offset {13.570}             -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {Metal1 Metal5}
add_pdn_connect -grid {grid} -layers {Metal5 TopMetal1}
####################################
