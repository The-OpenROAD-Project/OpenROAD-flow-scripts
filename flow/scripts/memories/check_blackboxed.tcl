# AUTO_MEMORIES: stop when a module synthesis was told to blackbox is not
# a black box of the design.
#
# read_slang's --blackboxed-module ignores a name it does not know. A
# name in blackboxes.txt that is not the module's definition -- a slang
# per-instance name, a typo, a module the sources no longer have -- leaves
# the memory's behavioral body in place, and the flow says so only much
# later, as a memory over SYNTH_MEMORY_MAX_BITS with no hint of why. Run
# after the sources are read; `names` is the blackboxes.txt list.
proc auto_memories_check_blackboxed { names } {
  if { [llength $names] == 0 } {
    return
  }
  # yosys lists an escaped module with its leading backslash (`\1d_ram`);
  # blackboxes.txt names it as read_slang takes it (`1d_ram`).
  set blackboxed {}
  foreach m [split [tee -q -s result.string select -list-mod =A:blackbox] "\n"] {
    set m [string trim $m]
    if { $m ne "" } {
      lappend blackboxed [regsub {^\\} $m {}]
    }
  }
  set missing {}
  foreach m $names {
    if { [lsearch -exact $blackboxed $m] < 0 } {
      lappend missing $m
    }
  }
  if { [llength $missing] > 0 } {
    error "AUTO_MEMORIES: not a black box of the design after reading the\
      sources, so its behavioral body would be synthesized:\
      [join $missing {, }]"
  }
}
