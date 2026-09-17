# Without this the server still comes up, just with no heat maps, and the error
# scrolls past above the URL - which reads as "the heatmaps are broken" rather
# than "this binary does not have the feature".
if {[llength [info commands web_load_chiplet_heatmap]] == 0} {
  puts stderr "\[ERROR\] This OpenROAD build has no 'web_load_chiplet_heatmap'."
  puts stderr "        Check the version banner above against the commit you expect."
  puts stderr "        Note that build_openroad.sh runs 'git submodule update' unless"
  puts stderr "        given --no_init, which resets tools/OpenROAD to the pinned commit."
  exit 1
}

read_db $env(DB_PATH)

set csv_files [lsort [glob -nocomplain $env(HEATMAP_DIR)/*/*_overall_risk.csv]]

if {[llength $csv_files] == 0} {
  puts "\[WARNING\] No risk maps under $env(HEATMAP_DIR). Run 'make generate_risk_map' first."
}

# Each CSV names the chiplet it belongs to in its header row, so the server
# resolves and transforms it into the right place in the stack. The returned
# short name is what the viewer's Heat Maps panel keys on.
foreach csv_file $csv_files {
  set short_name [web_load_chiplet_heatmap $csv_file]
  puts "Loaded heatmap: $csv_file -> $short_name"
}
