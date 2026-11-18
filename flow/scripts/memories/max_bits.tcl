# Log every inferred memory with its dimensions. With mock set, shrink each
# memory over max_bits to one row, kept as a module when keep_mocked is set;
# otherwise stop with an error naming every memory over max_bits that has a
# write port. Returns the mocked memories as a list of {module width size}.
proc synth_memory_max_bits { max_bits mock keep_mocked } {
  memory_collect
  set mocked {}
  set over {}
  foreach path [split [string trim [tee -q -s result.string select -list t:\$mem_v2]] "\n"] {
    set index [string first "/" $path]
    set module [string range $path 0 [expr { $index - 1 }]]
    set instance [string range $path [expr { $index + 1 }] end]

    set width [rtlil::get_param -uint $module $instance WIDTH]
    set size [rtlil::get_param -uint $module $instance SIZE]
    set rom [expr { [rtlil::get_param -uint $module $instance WR_PORTS] == 0 }]
    set nbits [expr { $width * $size }]
    puts "Memory $path has dimensions $size x $width = $nbits[expr { $rom ? ", a ROM" : "" }]"
    if { $nbits <= $max_bits } {
      continue
    }
    if { $mock } {
      rtlil::set_param -uint $module $instance SIZE 1
      puts "Shrunk memory $path from $size rows to 1"
      lappend mocked [list $module $width $size]
      if { $keep_mocked } {
        select -module $module
        setattr -mod -set keep_hierarchy 1
        select -clear
      }
    } elseif { !$rom } {
      lappend over "$path $size x $width = $nbits"
    }
  }
  if { [llength $over] > 0 } {
    error "Memories over SYNTH_MEMORY_MAX_BITS=$max_bits, which would go into\
      flip-flops: [join $over {, }]. Put them in macros (AUTO_MEMORIES,\
      fakeram), mock them (SYNTH_MOCK_LARGE_MEMORIES=1) or raise the limit."
  }
  return $mocked
}
