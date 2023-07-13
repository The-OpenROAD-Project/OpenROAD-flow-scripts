proc natural_sort {list} {
    return [lsort -command natural_compare $list]
}
# Custom comparison function
proc natural_compare {str1 str2} {
    set list1 [split $str1]
    set list2 [split $str2]
    set len [expr {min([llength $list1], [llength $list2])}]
    for {set i 0} {$i < $len} {incr i} {
        set part1 [lindex $list1 $i]
        set part2 [lindex $list2 $i]
        if {$part1 ne $part2} {
            if {[string is integer -strict $part1] && [string is integer -strict $part2]} {
                return [expr {$part1 - $part2}]
            } else {
                return [string compare $part1 $part2]
            }
        }
    }
    return [expr {[llength $list1] - [llength $list2]}]  ;# If all parts are equal, compare by length
}


proc match_pins { regex } {
    set pins {}
    # The regex for get_ports is not the tcl regex
    foreach pin [get_ports -regex .*] {
        set input [get_property $pin name]
        # We want the Tcl regex
        if {![regexp $regex $input]} {
            continue
        }
        lappend pins [get_property $pin name]
    }
    return [natural_sort $pins]
}

set block [ord::get_db_block]

set m4pitch 0.048
set m5pitch 0.048

array set pinGroups [list]
set pinGroups(top) [ list \
  "pitch $m5pitch" \
  "start 500" \
  "io_debug_req" \
  "io_debug_resp" \
  "io_interrupts" \
]

set pinGroups(left) [ list \
  "pitch $m4pitch" \
  "start 200" \
  "io_l2_axi4_0_ar" \
  "io_l2_axi4_0_aw" \
  "io_l2_axi4_0_b" \
  "io_l2_axi4_0_r" \
  "io_l2_axi4_0_w" \
]

set pinGroups(right) [ list \
  "pitch $m4pitch" \
  "start 200" \
  "io_mem_axi4_0_ar" \
  "io_mem_axi4_0_aw" \
  "io_mem_axi4_0_b" \
  "io_mem_axi4_0_r" \
  "io_mem_axi4_0_w" \
  "break 50" \
  "io_mmio_axi4_0_ar" \
  "io_mmio_axi4_0_aw" \
  "io_mmio_axi4_0_b" \
  "io_mmio_axi4_0_r" \
  "io_mmio_axi4_0_w" \
]


foreach side [array names pinGroups] {
  set pStart 0
  set pStop 0
  set pitch 0
  foreach ex $pinGroups($side) {
    if { [regexp {pitch (\S+)} $ex - number] } {
      set pitch $number
      continue
    }
    if { [regexp {start (\d+)} $ex - number] } {
      set pStart $number
      set pStop  $number
      continue
    }
    if { [regexp {break (\d+)} $ex - number] } {
      set pStart [expr $pStart + $number]
      continue
    }
    #set pins [concat {*}[match_pins ${ex}.*]]
    set pins [match_pins ${ex}.*]
    set pStop [expr $pStart + (($pitch * 8) *  [llength $pins])]
    set_io_pin_constraint -region ${side}:${pStart}-${pStop} -pin_names $pins
    set pStart [expr $pStop + ($pitch * 20)]
  }
}

#place_pins -hor_layer M4 -ver_layer M5
