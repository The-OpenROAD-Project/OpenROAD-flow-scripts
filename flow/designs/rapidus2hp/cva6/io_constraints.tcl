# left (bottom to top)
# cvxif_req_o
# axi_req_o - noc_req_o in ours
# scan_output - doesn't exist in ours
set_io_pin_constraint -group -order -region left:20-38.7 -pin_names {cvxif_req_o*}
set_io_pin_constraint -group -order -region left:38.8-90.2 -pin_names {noc_req_o*}

# right (bottom to top)
# scan_input - doesn't exist in ours
# test_mode - doesn't exist in ours
# scan_enable - doesn't exist in ours
# axi_resp_i - noc_resp_i in ours
# cvxif_resp_i
# debug_req_i
# time_irq_i
# ipi_i
# irq_i
# hart_id_i
# boot_addr_i
# rst_ni
# clk_i
set_io_pin_constraint -group -order -region right:5-31.4 -pin_names {noc_resp_i*}
set_io_pin_constraint -group -order -region right:31.5-73.1 -pin_names {cvxif_resp_i*}
set_io_pin_constraint -group -order -region right:73.3-73.7 -pin_names {debug_req_i time_irq_i ipi_i}
set_io_pin_constraint -group -order -region right:74-74.3 -pin_names {irq_i*}
set_io_pin_constraint -group -order -region right:74.5-82 -pin_names {hart_id_i*}
set_io_pin_constraint -group -order -region right:82.2-89.8 -pin_names {boot_addr_i*}
set_io_pin_constraint -group -order -region right:89.9-90.3 -pin_names {rst_n_i clk_i}

# don't exist in reference design implementation - does it make us I/O bound?
# put a third of them on the top, a third on the bottom, and let the placer
# decide where to put the remaining third
set num_rvfi_probes_ports 4295
set third_rvfi_probes_ports [expr $num_rvfi_probes_ports / 3]
set top_group {}
for { set i 0 } { $i < $third_rvfi_probes_ports } { incr i } {
    lappend top_group "rvfi_probes_o\[$i\]"
}
set bottom_group {}
for {} { $i < [expr $third_rvfi_probes_ports * 2]} { incr i } {
    lappend bottom_group "rvfi_probes_o\[$i\]"
}

set_io_pin_constraint -group -order -region bottom:* -pin_names $top_group
set_io_pin_constraint -group -order -region top:* -pin_names $bottom_group
