# E12 step 2: the clustered scorer.
#
# Score one candidate by spreading RTL-MP's std-cell clusters around that
# candidate's fixed macros and reading half-perimeter wirelength. The
# whole solve is stock gpl:
#
#   placement_cluster {inst ...}   makes N instances one movable
#                                 (gpl builds one GCell per cluster and
#                                 measures pin offsets against the
#                                 cluster centre, so intra-cluster nets
#                                 collapse and inter-cluster nets are
#                                 measured centre-to-centre -- bundled
#                                 nets, for free)
#   global_placement -overflow    stops the Nesterov solve early
#
# Nothing here reimplements a field solver, which is deliberate: the
# object being graded has to be the solver that would actually ship, not
# a model of it.
#
# Macros stay fixed instances with their real masters, so macro pin
# geometry is exact. Clustering would otherwise smear precisely the pins
# the live KPI reads. The instances within E12_HALO_HOPS of a macro pin
# are additionally kept out of every cluster, so they remain individual
# movables with exact offsets -- halo-flat coarsening, expressed purely
# as an omission.
#
# Report-only: the score is read out of odb after the solve and this
# process exits. It never writes the design back. One candidate per
# process is mandatory, not stylistic -- gpl's Replace::reset() does not
# clear its cluster list, and gpl does write GCell locations into odb.

set e12_dir [file dirname [file normalize [info script]]]
source [file join $e12_dir e12_lib.tcl]

set ::e12_out [e12_env E12_OUT_DIR [e12_env RUN_OUTPUT_DIR ""]]
if { $::e12_out eq "" } {
  error "score_clustered: set E12_OUT_DIR or declare out_dir"
}
set tag [e12_env E12_TAG ""]
if { $tag eq "" } {
  error "score_clustered: set E12_TAG to the candidate tag (eg cand_s0)"
}
set ::e12_work [e12_env E12_WORK [file join $::env(WORK_HOME) e12_work]]
set cand_odb [e12_env E12_CAND_ODB [file join $::e12_out $tag.odb]]
set base_sdc [e12_env E12_BASE_SDC [file join $::e12_out base_floorplan.sdc]]
set clusters_txt [e12_env E12_CLUSTERS [file join $::e12_out clusters.txt]]
foreach f [list $cand_odb $base_sdc $clusters_txt] {
  if { ![file exists $f] } {
    error "score_clustered: missing $f"
  }
}

# Pre-registered primary configuration. These are not per-design knobs:
# the hop count is a small integer justified by the fidelity argument
# above, the overflow target is a dimensionless placement invariant
# validated once against the archived trajectories, and the large-net
# threshold mirrors the value RTL-MP's own clustering uses. See README.md
# -- any run that departs from these is exploratory, not a gate result.
set hops [e12_env E12_HALO_HOPS 1]
set overflow [e12_env E12_OVERFLOW 0.6]
set large_net [e12_env E12_LARGE_NET_THRESHOLD 50]
set bin_grid_count [e12_env E12_BIN_GRID_COUNT 0]

# Thread count is a determinism control, not a tuning knob: the same
# candidate scored at different thread counts must produce a
# bit-identical score. gpl's density scatter accumulates into int64 bins,
# so the sum is over a fixed multiset and is thread-count invariant by
# construction; this exists so that claim is checked rather than assumed.
set threads [e12_env E12_THREADS 0]
if { $threads > 0 } {
  set_thread_count $threads
}

# Enter through ORFS's own loading path rather than calling read_db:
# load_design also reads liberty, the SDC and the platform setup, and
# load.tcl is where the ORFS helper procs this script uses come from
# (place_density_with_lb_addon among them). The candidate is staged under
# the stem the macro-placement stage writes, and its SDC is the base
# floorplan's -- macro placement does not change constraints.
set ::env(KEEP_VARS) 1
set ::env(SKIP_REPORT_METRICS) 1
e12_redirect $tag
source $::env(SCRIPTS_DIR)/load.tcl
set stem 2_2_floorplan_macro
file copy -force $cand_odb [file join $::env(RESULTS_DIR) $stem.odb]
file copy -force $base_sdc [file join $::env(RESULTS_DIR) $stem.sdc]
load_design $stem.odb $stem.sdc

set block [ord::get_db_block]

# --------------------------------------------------------------------
# Halo-flat set and the macro cone, from one traversal.

set t0 [clock clicks -milliseconds]
set bfs [e12_macro_bfs $block $hops $large_net]
set halo_ids [e12_halo_flat_ids $bfs $hops]
set macro_ids [dict get $bfs macros]
set cone_net_ids [dict get $bfs cone_nets$hops]
set bfs_s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]

set excluded {}
foreach id $halo_ids {
  dict set excluded $id 1
}
foreach id $macro_ids {
  dict set excluded $id 1
}

# --------------------------------------------------------------------
# Declare the clusters.

set t0 [clock clicks -milliseconds]
set fp [open $clusters_txt r]
set cluster_members [dict create]
set cluster_order {}
set unresolved 0
while { [gets $fp line] >= 0 } {
  if { [string index $line 0] eq "#" || [string trim $line] eq "" } {
    continue
  }
  set cname [lindex $line 0]
  # The instance name is the remainder of the line, not just field 3, so
  # a name containing a space cannot silently truncate.
  set iname [join [lrange $line 2 end] " "]

  # Match by name, not by odb id. clusters.txt is written from the base
  # floorplan database and consumed against a candidate's, and while
  # macro placement creates no instances, an id is an internal handle
  # whose stability across databases is not something to bet a
  # measurement on. Names come from the netlist and are stable by
  # construction.
  set inst [$block findInst $iname]
  if { $inst eq "NULL" || $inst eq "" } {
    incr unresolved
    continue
  }
  if { [dict exists $excluded [$inst getId]] } {
    continue
  }
  if { [[$inst getMaster] isBlock] || [$inst isFixed] } {
    continue
  }
  if { ![dict exists $cluster_members $cname] } {
    lappend cluster_order $cname
  }
  dict lappend cluster_members $cname $inst
}
close $fp

# An unresolved name means the partition and the candidate disagree about
# the netlist, which would silently leave those cells as their own
# movables and quietly weaken the reduction. Fail instead.
if { $unresolved > 0 } {
  error "score_clustered: $unresolved instance names in $clusters_txt\
    do not exist in $cand_odb -- the cluster partition and the candidate\
    were not built from the same netlist"
}

# A cluster of one instance is not a reduction, it is just a rename, and
# gpl logs one message per declared cluster; skip them.
set declared 0
set clustered_insts 0
foreach cname [lsort -ascii $cluster_order] {
  set members [dict get $cluster_members $cname]
  if { [llength $members] < 2 } {
    continue
  }
  gpl::placement_cluster_cmd $members
  incr declared
  incr clustered_insts [llength $members]
}
set cluster_s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]
puts "e12: $tag declared $declared clusters over $clustered_insts\
  instances, $hops-hop halo keeps [llength $halo_ids] flat"

# --------------------------------------------------------------------
# The solve.

set cell_pad [e12_env CELL_PAD_IN_SITES_GLOBAL_PLACEMENT 0]
set gp_args [list -density [place_density_with_lb_addon] \
  -pad_left $cell_pad -pad_right $cell_pad \
  -force_center_initial_place \
  -overflow $overflow]
if { $bin_grid_count > 0 } {
  lappend gp_args -bin_grid_count $bin_grid_count
}

set t0 [clock clicks -milliseconds]
set diverged 0
if { [catch { global_placement {*}$gp_args } err] } {
  puts stderr "e12: $tag global_placement failed: $err"
  set diverged 1
}
set gpl_s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]

# --------------------------------------------------------------------
# Readout.
#
# Two scores off the same final placement. Full HPWL is the flat rung's
# scalar. Macro-cone HPWL restricts the sum to the nets within the halo
# BFS, on the argument that a score whose magnitude is dominated by
# wirelength the KPI never reads is spending its resolution in the wrong
# place. Which of the two ranks better is a measurement, not a
# preference, and it costs one extra pass over odb.
set all_nets [e12_signal_nets $block]
set hpwl_dbu [e12_hpwl_dbu $all_nets]

set cone_nets {}
foreach id $cone_net_ids {
  set net [odb::dbNet_getNet $block $id]
  if { $net ne "NULL" && $net ne "" } {
    lappend cone_nets $net
  }
}
set cone_hpwl_dbu [e12_hpwl_dbu $cone_nets]

e12_write_leaf [file join $::e12_out $tag.clustered.json] [list \
  tag $tag \
  hpwl_dbu $hpwl_dbu \
  cone_hpwl_dbu $cone_hpwl_dbu \
  diverged $diverged \
  halo_hops $hops \
  overflow_target $overflow \
  bin_grid_count $bin_grid_count \
  large_net_threshold $large_net \
  threads $threads \
  clusters_declared $declared \
  clustered_insts $clustered_insts \
  halo_flat_insts [llength $halo_ids] \
  macros [llength $macro_ids] \
  signal_nets [llength $all_nets] \
  cone_nets [llength $cone_nets] \
  bfs_s $bfs_s \
  cluster_s $cluster_s \
  gpl_s $gpl_s \
  vmhwm_kb [e12_vmhwm_kb]]

puts "e12: $tag hpwl $hpwl_dbu dbu, cone $cone_hpwl_dbu dbu,\
  gpl ${gpl_s}s, diverged $diverged"
exit 0
