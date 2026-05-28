####################################
# global connections
####################################
add_global_connection -net {vdd} -inst_pattern {.*} -pin_pattern {^vdd$} -power
add_global_connection -net {vss} -inst_pattern {.*} -pin_pattern {^vss$} -ground
global_connect
####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {vdd} -ground {vss}
####################################
# standard cell grid (backside power: just BPR followpins for now)
####################################
define_pdn_grid -name {grid} -voltage_domains {CORE} -pins {BPR}
add_pdn_stripe -grid {grid} -layer {BPR} -width {0.032} -pitch {0.144} -offset {0} -followpins
