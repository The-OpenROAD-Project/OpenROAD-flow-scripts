
set design_rams {
  swerv {2048x39 256x34 64x21}
  bp_be_top {64x96 512x64 64x15}
  tinyRocket {64x32 1024x32}
  black_parrot {64x7 64x96 512x64 256x95 64x15}
  bp_multi_top {64x7 32x64 64x96 512x64 256x96 64x15}
  bp_fe_top {64x7 64x96 512x64}
}

set results_dir "~/import/fakeram/results"
set flow_dir "~/import/flow/flow/platforms/nangate45"

proc make_fakeram_links {} {
  global design_rams flow_dir

  foreach {design sizes} $design_rams {
    cd $flow_dir/$design
    foreach size $sizes {
      file delete fakeram45_$size.lib
      file delete fakeram45_$size.lef
      file link -symbolic fakeram45_$size.lib \
        ../../../platforms/nangate45/lib/fakeram45_$size.lib
      file link -symbolic fakeram45_$size.lef \
        ../../../platforms/nangate45/lef/fakeram45_$size.lef
    }
  }
}

proc copy_fakeram_results {} {
  global design_rams results_dir flow_dir

  foreach {design sizes} $design_rams {
    foreach size $sizes {
      file copy -force $results_dir/fakeram45_$size/fakeram45_$size.lib $flow_dir/lib/fakeram45_$size.lib
      file copy -force $results_dir/fakeram45_$size/fakeram45_$size.lef $flow_dir/lef/fakeram45_$size.lef
    }
  }
}
