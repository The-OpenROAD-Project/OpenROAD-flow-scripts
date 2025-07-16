# left (bottom to top)
set_io_pin_constraint -group -order -region left:4.09-40.70 -pin_names {cvxif_req_o[*]}
set_io_pin_constraint -group -order -region left:40.85-90.13 -pin_names {noc_req_o[*]}

# right (bottom to top)
# The intervals have been expanded based on pin placer feedback
set_io_pin_constraint -group -order -region right:5.25-45.34 -pin_names {noc_resp_i[*]}
set_io_pin_constraint -group -order -region right:45.62-93.07 -pin_names {cvxif_resp_i[*]}
set_io_pin_constraint -group -order -region right:93.32-93.73 \
  -pin_names {
    debug_req_i time_irq_i ipi_i
  }
set_io_pin_constraint -group -order -region right:94.01-94.28 -pin_names {irq_i[*]}
set_io_pin_constraint -group -order -region right:94.51-102.01 -pin_names {hart_id_i[*]}
set_io_pin_constraint -group -order -region right:102.25-109.74 -pin_names {boot_addr_i[*]}
set_io_pin_constraint -group -order -region right:109.99-110.25 -pin_names {rst_ni clk_i}

# The rvfi_probes_o pins don't exist in reference design implementation
# put a third of them on the top, a third on the bottom, and let the placer
# decide where to put the remaining third
set num_rvfi_probes_ports 4295
set third_rvfi_probes_ports [expr $num_rvfi_probes_ports / 3]
set top_group {}
for { set i 0 } { $i < $third_rvfi_probes_ports } { incr i } {
  lappend top_group "rvfi_probes_o\[$i\]"
}
set bottom_group {}
for { } { $i < $third_rvfi_probes_ports * 2 } { incr i } {
  lappend bottom_group "rvfi_probes_o\[$i\]"
}


set_io_pin_constraint -group -order -region bottom:* -pin_names $top_group
set_io_pin_constraint -group -order -region top:* -pin_names $bottom_group
