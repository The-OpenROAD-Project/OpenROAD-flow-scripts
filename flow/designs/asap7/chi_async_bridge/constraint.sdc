# chi_async_bridge: two clocks with no phase relation, and the bridge
# between them. README.md says what each constraint is for.
set sdc_version 2.0

# The core clock: the period at which XiangShan's own bridge, hardened
# alone through this flow, just fails at global route (-1.4 ps, on the
# core half's async queue sink read path), and so does this design
# (README.md, Results). Above it both close; the flow meets every target
# down to here.
set clk_period 300
# The NoC clock: an unrelated period, about 0.3 times the core's frequency.
# The two never align, and nothing here depends on the ratio.
set noc_clk_period 1021

create_clock -name clk -period $clk_period [get_ports clock]
create_clock -name noc_clk -period $noc_clk_period [get_ports noc_clock]

# ---- The crossing ----------------------------------------------------
# The clocks are asynchronous, but the paths between them are still
# timed: each must take less than one period of the clock it starts on,
# measured from its first flop's clock pin, without the clock tree. For
# a Gray-coded pointer that keeps every bit within one write of the
# others; the data, read only after its pointer has been synchronised,
# meets it with room to spare. No hold check between the clocks: there
# is no edge to hold against.
set_clock_groups -asynchronous -allow_paths -group clk -group noc_clk
set_max_delay -ignore_clock_latency $clk_period \
  -from [get_clocks clk] -to [get_clocks noc_clk]
set_max_delay -ignore_clock_latency $noc_clk_period \
  -from [get_clocks noc_clk] -to [get_clocks clk]
set_false_path -hold -from [get_clocks clk] -to [get_clocks noc_clk]
set_false_path -hold -from [get_clocks noc_clk] -to [get_clocks clk]

# noc_reset is asynchronous; each half releases it through its own
# reset synchroniser (reset_gen.sv), whose flops it sets directly.
set_false_path -from [get_ports noc_reset]

# ---- The ports -------------------------------------------------------
# Budgeted with set_max_delay, in the shape of $PLATFORM_DIR/constraints.sdc
# but not with its numbers: that file gives a single-clock macro a fixed
# 80 ps per port path, sized for a small macro. Here each domain's ports
# get 80 % of that domain's period, a choice of this file: the tile's
# ports at the core period, the NoC's (noc_*) at the NoC period. That
# file creates one clock, so it is not sourced here.
set tile_in {}
set noc_in {}
foreach p [all_inputs -no_clocks] {
  set name [get_full_name $p]
  if { $name eq "noc_reset" } {
    continue
  } elseif { [string match noc_* $name] } {
    lappend noc_in $p
  } else {
    lappend tile_in $p
  }
}
set tile_out {}
set noc_out {}
foreach p [all_outputs] {
  if { [string match noc_* [get_full_name $p]] } {
    lappend noc_out $p
  } else {
    lappend tile_out $p
  }
}
foreach {ins outs period} [list $tile_in $tile_out $clk_period \
  $noc_in $noc_out $noc_clk_period] {
  set_max_delay -ignore_clock_latency [expr { $period * 0.8 }] \
    -from $ins -to [all_registers]
  set_max_delay -ignore_clock_latency [expr { $period * 0.8 }] \
    -from [all_registers] -to $outs
  # Through a domain without a flop: the NoC's ready reaches its flitv
  # through one gate (chi_async_bridge_sink.sv, tx_flitv).
  set_max_delay [expr { $period * 0.8 }] -from $ins -to $outs
}

group_path -name in2reg -from [all_inputs -no_clocks] -to [all_registers]
group_path -name reg2out -from [all_registers] -to [all_outputs]
group_path -name reg2reg -from [all_registers] -to [all_registers]
group_path -name in2out -from [all_inputs -no_clocks] -to [all_outputs]

# ---- The synchronisers ------------------------------------------------
# A synchroniser's flops resolve metastability in the time a period
# leaves them, so the step from one to the next is kept short: a
# clock-to-output, one inverter (asap7's flop with asynchronous set and
# reset has only an inverted output) and a setup, about four FO4 at this
# flow's 14.37 ps. Five FO4 is the budget.
set sync_hop_max 72

# This is the one constraint that names instances, and a name that
# matches nothing would make OpenSTA warn and drop it (STA-0101,
# STA-0471). So the names are checked first, against the netlist this
# file is read with, which is the synthesised one: the flow stops here
# if synthesis has renamed, merged or restructured a synchroniser.
#
# In that netlist a chain flop is named, as timing analysis spells it,
#   <instance path>.bit_[<bit>].sync[<stage>]$_DFF_PP<init>_
# (flattened with '.', yosys's cell type appended; the database escapes
# the brackets, timing analysis does not); sync[SYNC-1] takes the
# asynchronous input, sync[0] is the output.
set sync_stages 3
set depth 16
if { [info exists ::env(VERILOG_TOP_PARAMS)] } {
  foreach {k v} $::env(VERILOG_TOP_PARAMS) {
    if { $k eq "DEPTH" } { set depth $v }
  }
}
# 6 flit queues and 6 credit queues, each with a pointer synchroniser in
# both halves, of log2(DEPTH)+1 bits; and 7 handshakes into each half.
set pointer_bits [expr { int(round(log($depth) / log(2))) + 1 }]
set expect_chains [expr { 2 * 12 * $pointer_bits + 2 * 7 }]

proc sync_check_fail { msg } {
  error "constraint.sdc: synchronisers: $msg"
}

# The one input pin an output pin's net drives, or {} if it drives more.
proc sync_only_load { pin } {
  set loads [get_pins -quiet -of_objects [get_nets -of_objects $pin] \
    -filter "direction == input"]
  if { [llength $loads] != 1 } { return {} }
  return $loads
}

proc sync_output { cell } {
  return [get_pins -of_objects $cell -filter "direction == output"]
}

set chains [dict create]
foreach cell [get_cells -quiet {*_gray.bit_* *sync_link.bit_*}] {
  set name [get_full_name $cell]
  if { ![regexp {^(.*)\.sync\[([0-9]+)\]} $name -> chain stage] } {
    sync_check_fail "unexpected cell name $name"
  }
  dict set chains $chain $stage $cell
}
if { [dict size $chains] != $expect_chains } {
  sync_check_fail "expected $expect_chains chains, found [dict size $chains]"
}
set sync_hops {}
dict for {chain stages} $chains {
  if { [dict size $stages] != $sync_stages } {
    sync_check_fail "$chain has [dict size $stages] stages, not $sync_stages"
  }
  for { set s [expr { $sync_stages - 1 }] } { $s > 0 } { incr s -1 } {
    set from [dict get $stages $s]
    set to [get_full_name [dict get $stages [expr { $s - 1 }]]]
    # The output, at most one single-input cell, then the next flop,
    # and nothing else on the way.
    set load [sync_only_load [sync_output $from]]
    if { $load ne {} && [get_full_name [get_cells -of_objects $load]] ne $to } {
      set inv [get_cells -of_objects $load]
      if { [llength [get_pins -of_objects $inv -filter "direction == input"]] == 1 } {
        set load [sync_only_load [sync_output $inv]]
      } else {
        set load {}
      }
    }
    if { $load eq {} || [get_full_name [get_cells -of_objects $load]] ne $to } {
      sync_check_fail "[get_full_name $from] does not drive $to alone"
    }
    lappend sync_hops $from [dict get $stages [expr { $s - 1 }]]
  }
}
foreach {from to} $sync_hops {
  set_max_delay -ignore_clock_latency $sync_hop_max -from $from -to $to
}
