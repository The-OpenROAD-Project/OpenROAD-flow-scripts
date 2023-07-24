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

# return regular expression
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

#--------------------------------------------------------------------------------
set block [ord::get_db_block]

# create array for IO pins on top, bottom, left and right
# each entry construct can be of one of the following
# 	start <starting point for the following pin list>
# 	pitch <pin ptich / spacing to use>
# 	<pin>
# 	<pin>
set pinGroups(right) [ list \
  "pitch $::env(PLACE_PIN_PITCH)" \
  "start 15" \
  "W0_clk" \
  "break 1" \
  "W0_en" \
  "W0_mask" \
  "break 1" \
  "W0_addr" \
  "break 1" \
  "W0_data" \
  "break 2" \
  "R0_clk" \
  "break 1" \
  "R0_en" \
  "break 1" \
  "R0_addr" \
  "break 1" \
  "R0_data" \
]


# process pin grouppings from instruction above
# go thru each item in the pin grouping and issue 
# the ORFS constraint
foreach side [array names pinGroups] {
  set pStart 0
  set pStop  0
  set pitch  0
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
    set pins  [match_pins ${ex}.*]
    set pStop [expr $pStart + ($pitch * ([llength $pins] + 2))]
    set_io_pin_constraint -region ${side}:${pStart}-${pStop} -pin_names $pins
    set pStart [expr $pStop + $pitch]
  }
}
