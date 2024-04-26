set timing_paths [ find_timing_paths \
 -from [all_registers] -to [all_registers] \
 -endpoint_count 10000 -path_delay max
]
set python_script [open "|python3 scripts/histogram.py 2>@1" w]
puts $python_script [[[[[ord::get_db] getChip] getBlock] getTopModule] getName]
puts $python_script [[get_clocks -regex .*] period]
foreach path $timing_paths {
    puts $python_script [get_property $path slack]
}
close $python_script
