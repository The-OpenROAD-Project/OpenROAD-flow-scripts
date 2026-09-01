# E12 step 1: dump RTL-MP's std-cell cluster partition, once.
#
# RTL-MP already builds a physical hierarchy -- std-cell clusters and
# bundled nets -- as the model its annealer works on. E12 reuses that
# partition as the scoring netlist instead of inventing one, so the
# clustered scorer grades the same abstraction the macro placer itself
# reasons about.
#
# rtl_macro_placer -keep_clustering_data commits the cluster tree to odb
# as a nested dbGroup tree that partitions the instances (VISUAL_DEBUG
# groups, which gpl ignores because they carry no region). Walking those
# groups is therefore the whole extraction: no new OpenROAD code, and no
# reimplementation of the clustering.
#
# This runs on the *base floorplan*, before any candidate's macro
# placement. Clustering is derived from connectivity and module
# hierarchy, not from macro positions, so one partition serves all
# candidates. That matters beyond saving time: because every candidate is
# scored through the identical coarsening, the distortion the reduction
# introduces is common-mode, and common-mode distortion does not create
# rank inversions. A partition re-derived per candidate would.

set e12_dir [file dirname [file normalize [info script]]]
source [file join $e12_dir e12_lib.tcl]

set ::e12_out [e12_env E12_OUT_DIR [e12_env RUN_OUTPUT_DIR ""]]
if { $::e12_out eq "" } {
  error "dump_clusters: set E12_OUT_DIR or declare out_dir"
}
file mkdir $::e12_out

set ::e12_work [e12_env E12_WORK [file join $::env(WORK_HOME) e12_work]]
set base_odb [e12_env E12_BASE_ODB [file join $::e12_out base_floorplan.odb]]
if { ![file exists $base_odb] } {
  error "dump_clusters: no base floorplan at $base_odb;\
    run the macro_e12 candidate generation first"
}

set ::env(KEEP_VARS) 1
set ::env(SKIP_REPORT_METRICS) 1
e12_redirect clusters

# Stage the archived base floorplan under the stem ORFS's macro_place
# stage loads, and let the stage script do the loading: load_design also
# reads liberty, the SDC and the platform setup, none of which a bare
# read_db would do.
foreach ext {odb sdc} {
  file copy -force [file rootname $base_odb].$ext \
    [file join $::env(RESULTS_DIR) 2_1_floorplan.$ext]
}

# A full RTL-MP run is required: -keep_clustering_data only commits the
# tree that the run actually builds. Run it through ORFS's own
# macro_place.tcl rather than calling the placer directly, so the halos,
# target utilization and blockage settings are the production ones -- a
# partition built under different settings would not be the partition the
# production placer reasons about, and the whole premise of E12 is that it
# reuses RTL-MP's own abstraction.
#
# The resulting macro placement is discarded; this process never writes
# the design back.
e12_wrap_placer [list -keep_clustering_data]
set t0 [clock clicks -milliseconds]
if { [catch { e12_step macro_place.tcl } err] } {
  error "dump_clusters: macro placement failed: $err\n\
    note MPL-0049 is raised if any instance is left ungrouped"
}
set mpl_s [expr { ([clock clicks -milliseconds] - $t0) / 1000.0 }]

set block [ord::get_db_block]

# Leaf groups only: an interior node's instances are already accounted
# for by its descendants.
#
# dbBlock::getGroups() returns EVERY group in the block, not just the
# roots of the tree, so recursing from each entry reaches the same leaf
# through itself and through each of its ancestors -- which silently
# counted every instance twice on swerv_wrapper (203718 rows for 101831
# movables). Select leaves directly from the flat list instead; no
# recursion is needed or wanted.
set leaves {}
foreach group [$block getGroups] {
  if { [llength [$group getGroups]] == 0 } {
    lappend leaves $group
  }
}

# Build the assignment and check it really is a partition. A cluster
# model that double-assigns an instance is not a coarsening of the
# netlist, and gpl would take the last declaration silently, so this
# fails loudly instead.
set assignment [dict create]
set conflicts {}
foreach group [lsort -command {apply {{a b} {string compare [$a getName] [$b getName]}}} $leaves] {
  set cname [$group getName]
  foreach inst [$group getInsts] {
    set iname [$inst getName]
    if { [dict exists $assignment $iname] } {
      set previous [lindex [dict get $assignment $iname] 0]
      if { $previous ne $cname } {
        lappend conflicts "$iname in $previous and $cname"
      }
      continue
    }
    dict set assignment $iname [list $cname [$inst getId]]
  }
}
if { [llength $conflicts] > 0 } {
  error "dump_clusters: [llength $conflicts] instances assigned to more\
    than one cluster, e.g. [lindex $conflicts 0]"
}

# Coverage is measured over the instances the scorer will actually
# cluster -- movable, non-macro -- because that is the population the
# reduction ratio is about. Macros appear in the tree too and are
# harmless here: the scorer filters them out.
set movable 0
set covered 0
set uncovered {}
foreach inst [$block getInsts] {
  if { [[$inst getMaster] isBlock] || [$inst isFixed] } {
    continue
  }
  incr movable
  if { [dict exists $assignment [$inst getName]] } {
    incr covered
  } elseif { [llength $uncovered] < 5 } {
    lappend uncovered [$inst getName]
  }
}

# Sorted by cluster name, then by odb id within a cluster, so the file is
# a pure function of the database.
set rows {}
dict for {iname entry} $assignment {
  lassign $entry cname id
  lappend rows [list $cname $id $iname]
}
set rows [lsort -index 1 -integer [lsort -index 0 -ascii $rows]]

set fp [open [file join $::e12_out clusters.txt] w]
puts $fp "# <cluster_name> <inst_id> <inst_name>"
puts $fp "# leaf clusters from rtl_macro_placer -keep_clustering_data"
foreach row $rows {
  puts $fp [join $row " "]
}
close $fp

e12_write_leaf [file join $::e12_out clusters.json] [list \
  leaf_clusters [llength $leaves] \
  clustered_insts [dict size $assignment] \
  movable_insts $movable \
  movable_covered $covered \
  mpl_s $mpl_s]
puts "e12: [llength $leaves] leaf clusters, [dict size $assignment]\
  instances assigned, $covered of $movable movable instances covered\
  (${mpl_s}s)"
if { [llength $uncovered] > 0 } {
  puts "e12: uncovered movables (first few): $uncovered"
}
exit 0
