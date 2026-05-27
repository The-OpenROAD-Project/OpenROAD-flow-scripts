source $::env(SCRIPTS_DIR)/util.tcl

source $::env(SCRIPTS_DIR)/report_metrics.tcl

proc load_design { design_file sdc_file } {
  # Do not reload if design is already loaded
  set db [ord::get_db]
  if { [$db getChip] != "NULL" && [[$db getChip] getBlock] != "NULL" } {
    return
  }

  source_env_var_if_exists PLATFORM_TCL

  source $::env(SCRIPTS_DIR)/read_liberty.tcl

  # Read design files
  set ext [file extension $design_file]
  if { $ext == ".v" } {
    read_lef $::env(TECH_LEF)
    read_lef $::env(SC_LEF)
    if { [env_var_exists_and_non_empty ADDITIONAL_LEFS] } {
      foreach lef $::env(ADDITIONAL_LEFS) {
        read_lef $lef
      }
    }
    read_verilog $::env(RESULTS_DIR)/$design_file
    log_cmd link_design {*}[hier_options] $::env(DESIGN_NAME)
  } elseif { $ext == ".odb" } {
    log_cmd read_db {*}[hier_options] $::env(RESULTS_DIR)/$design_file
    # When the parent's synth_odb stage was run against stub macro
    # LEFs (port-only, no geometry — see synth_odb.tcl's
    # ORFS_WRITE_SYNTH_STUBS path), 1_synth.odb carries those stub
    # masters as 1×1 frozen blocks. Read the real ADDITIONAL_LEFS
    # here so lefin augments them in place: width/height/class/site
    # get updated to the real LEF values, and pin geometry is
    # attached to the existing dbMTerms (whose directions came
    # from the stub).
    #
    # Per-LEF gating: only re-read LEFs whose primary MACRO is
    # currently a 1×1 stub. ADDITIONAL_LEFS at floorplan may also
    # contain non-stub macros (e.g. behavioral memories whose real
    # LEF was already read at synth time and is fully baked into
    # 1_synth.odb). Re-reading those would duplicate pin geometry
    # (lefin's pin handler leaves existing dbMTerms in place but
    # still adds the new geometry boxes). 1×1 is a unique stub
    # marker — synth_odb.tcl always writes SIZE 1 BY 1 in stub LEFs
    # and real macros are orders of magnitude larger.
    #
    # NOTE: this path is currently experimental. lefin updates the
    # dbMaster width/height in place, but each dbInst's cached
    # bbox was initialised at create time from the 1×1 stub master
    # dims and OpenROAD has no public API to refresh that bbox. As
    # a result, floorplan/place still see macros as 1×1 boxes and
    # CTS fails with EST-0092. A future fix in OpenROAD (e.g. a
    # dbInst::resetBox() or dbInst::setMaster() that reinitialises
    # the cached bbox from the master) is needed to unlock the
    # full PD flow against synth-stage stub masters.
    if { [info exists ::env(ORFS_AUGMENT_STUB_MASTERS)] \
         && $::env(ORFS_AUGMENT_STUB_MASTERS) == "1" \
         && [env_var_exists_and_non_empty ADDITIONAL_LEFS] } {
      set stub_master_names {}
      foreach lib [$db getLibs] {
        foreach master [$lib getMasters] {
          if { [$master getWidth] == 1 && [$master getHeight] == 1 } {
            lappend stub_master_names [$master getName]
          }
        }
      }
      foreach lef $::env(ADDITIONAL_LEFS) {
        set fh [open $lef r]
        set is_stub_lef 0
        while { [gets $fh line] >= 0 } {
          if { [regexp {^\s*MACRO\s+([A-Za-z_][A-Za-z0-9_]*)} $line - mname] } {
            if { [lsearch -exact $stub_master_names $mname] >= 0 } {
              set is_stub_lef 1
            }
            break
          }
        }
        close $fh
        if { $is_stub_lef } {
          read_lef $lef
        }
      }

      # Re-set each dbInst's location to itself so OpenROAD has a
      # chance to recompute the bbox from the (now-augmented) master
      # dims. This is the only public refresh trigger today; if/when
      # OpenROAD adds an explicit bbox refresh API, switch to that.
      set block [ord::get_db_block]
      if { $block != "NULL" } {
        foreach inst [$block getInsts] {
          set master [$inst getMaster]
          set mname [$master getName]
          if { [lsearch -exact $stub_master_names $mname] >= 0 } {
            set loc [$inst getLocation]
            $inst setLocation [lindex $loc 0] [lindex $loc 1]
          }
        }
      }
    }
  } else {
    error "Unrecognized input file $design_file"
  }

  # Read SDC file
  log_cmd read_sdc $::env(RESULTS_DIR)/$sdc_file

  if { [file exists $::env(PLATFORM_DIR)/derate.tcl] } {
    log_cmd source $::env(PLATFORM_DIR)/derate.tcl
  }

  if { [env_var_exists_and_non_empty LAYER_PARASITICS_FILE] } {
    log_cmd source $::env(LAYER_PARASITICS_FILE)
  } else {
    log_cmd source $::env(PLATFORM_DIR)/setRC.tcl
  }

  if { [env_var_equals LIB_MODEL CCS] } {
    puts "Using CCS delay calculation"
    log_cmd set_delay_calculator prima
  }
}
