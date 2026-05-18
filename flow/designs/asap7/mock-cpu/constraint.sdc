# mock-cpu: multi-clock async-FIFO bridge macro.
#
# PR #4170 idiom (multi-clock variant): optimization targets use
# set_max_delay -ignore_clock_latency so hold-fixing does not invent
# phantom budgets against the deep clock tree's insertion delay. See
# flow/platforms/asap7/constraints.sdc lines 1-56 for the single-clock
# rationale; this file can't `source` that template because mock-cpu
# has two async clocks.
#
# The IO optimization targets below are deliberately surgical:
# set_max_delay from top-level ports to fifo_in/<pin> and from
# fifo_out/<pin> to top-level ports, rather than -to [all_registers] /
# -from [all_registers]. Functionally equivalent for this topology
# (all IO paths begin/end at the FIFO), but it exercises more flow
# features — SYNTH_KEEP_MODULES hierarchy preservation, hierarchical
# get_pins selection, and io2fifo/fifo2io path grouping. Intentional
# regression coverage; do not "simplify" back to [all_registers].
#
# (* keep_hierarchy *) on the fifo1 module (src/fifo/fifo1.v) preserves
# the FIFO instance boundary through Yosys flattening so the fifo_in/<pin>
# and fifo_out/<pin> paths below resolve. An RTL attribute is used rather
# than SYNTH_KEEP_MODULES because the latter matches exact module names
# and hierarchy elaboration specializes fifo1 into $paramod$<hash>\fifo1
# before SYNTH_KEEP_MODULES runs.
#
# FIFO RTL: Cummings SNUG 2002 — gray-coded pointers, 2-FF synchronizers
# (sync_r2w, sync_w2r). Metastability handled by construction.
# https://gist.github.com/brabect1/7695ead3d79be47576890bbcd61fe426

source $::env(SDC_FILE_EXTRA)

set sdc_version 2.0

set clk_period 333
set clk2_period 1000

set clk1_name clk
create_clock -name $clk1_name -period $clk_period \
  -waveform [list 0 [expr $clk_period/2]] [get_ports $clk1_name]
set_clock_uncertainty 10 [get_clocks $clk1_name]

set clk2_name clk_uncore
create_clock -name $clk2_name -period $clk2_period \
  -waveform [list 0 [expr $clk2_period/2]] [get_ports $clk2_name]
set_clock_uncertainty 10 [get_clocks $clk2_name]

set_clock_groups -group $clk1_name -group $clk2_name -asynchronous -allow_paths

# Async reset distribution.
set_false_path -from [get_ports *rst_n]
set_false_path -to [get_ports *rst_n]

# Timing firewall: surgical port <-> FIFO boundary optimization targets.
# Internal 1024-stage pipeline is reg2reg, constrained by the clock
# period alone. IO paths end/begin at the FIFO boundary — no further.
set io_target 80

set fifo_in_wdata [get_pins fifo_in/wdata[*]]
set fifo_in_winc [get_pins fifo_in/winc]
set fifo_out_rinc [get_pins fifo_out/rinc]

# Port -> FIFO. -to on a hierarchical instance input pin is accepted:
# OpenSTA traverses into the instance and finds the leaf endpoint.
set_max_delay -ignore_clock_latency $io_target \
  -from [get_ports wdata*] -to $fifo_in_wdata
set_max_delay -ignore_clock_latency $io_target \
  -from [get_ports winc] -to $fifo_in_winc
set_max_delay -ignore_clock_latency $io_target \
  -from [get_ports rinc] -to $fifo_out_rinc

# FIFO -> Port. The symmetric surgical form -from $fifo_out_<pin>
# hits STA-1554 ("not a valid start point") because a hierarchical
# instance output pin has no implicit launch clock. Use
# [all_registers] instead — OPENROAD_HIERARCHICAL=1 plus the fifo1
# keep_hierarchy makes [all_registers] enumerate leaf flops inside
# fifo_out (fifomem and pointer-sync flops) whose Q pins are valid
# start points, matching the platform template's single-clock form.
# rdata is excluded here; it's false_path'd at the bottom.
set_max_delay -ignore_clock_latency $io_target \
  -from [all_registers] -to [get_ports rempty]
set_max_delay -ignore_clock_latency $io_target \
  -from [all_registers] -to [get_ports wfull]

group_path -name io2fifo \
  -from [all_inputs -no_clocks] \
  -to [list $fifo_in_wdata $fifo_in_winc $fifo_out_rinc]
group_path -name reg2out -from [all_registers] -to [all_outputs]
group_path -name reg2reg -from [all_registers] -to [all_registers]

# Dual-clock FIFO CDC: bound combinational delay on pointer-sync paths
# (sync_r2w, sync_w2r) to the fastest clock period, ignore clock
# latency (deep tree), and declare hold false — gray-coded pointers
# and 2-FF synchronizers handle metastability by construction.
set cdc_max_delay $clk_period
set_max_delay $cdc_max_delay -from $clk1_name -to $clk2_name -ignore_clock_latency
set_max_delay $cdc_max_delay -from $clk2_name -to $clk1_name -ignore_clock_latency
set_false_path -hold -from $clk1_name -to $clk2_name
set_false_path -hold -from $clk2_name -to $clk1_name

# rdata port has no launch FF on the IO side. It's driven
# combinationally by fifo_out.fifomem (mem[raddr]):
#   clk-clocked fifomem flops  -> rdata (wclk launch path)
#   clk_uncore-clocked rbin    -> raddr -> mem mux -> rdata (rclk launch)
# Both are "valid when rempty is low" by FIFO protocol, not a
# single-cycle timing. Declare every path to rdata as false — normal
# FIFO deployments would put an FF on rdata in the consumer domain.
set_false_path -to [get_ports rdata*]
