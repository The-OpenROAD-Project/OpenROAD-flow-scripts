# ==============================================================================
#  ____  _        _    ____ _____
# |  _ \| |      / \  / ___| ____|
# | |_) | |     / _ \| |   |  _|
# |  __/| |___ / ___ \ |___| |___
# |_|   |_____/_/   \_\____|_____|
#
place: $(RESULTS_DIR)/3_place.odb \
       $(RESULTS_DIR)/3_place.sdc
# ==============================================================================
# STEP 1: Global placement without placed IOs, timing-driven, and routability-driven.
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_1_place_gp_skip_io.odb: $(RESULTS_DIR)/2_floorplan.odb $(RESULTS_DIR)/2_floorplan.sdc $(LIB_FILES)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/global_place_skip_io.tcl -metrics $(LOG_DIR)/3_1_place_gp_skip_io.json) 2>&1 | tee $(LOG_DIR)/3_1_place_gp_skip_io.log

# STEP 2: IO placement (non-random)
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_2_place_iop.odb: $(RESULTS_DIR)/3_1_place_gp_skip_io.odb $(IO_CONSTRAINTS)
ifndef IS_CHIP
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/io_placement.tcl -metrics $(LOG_DIR)/3_2_place_iop.json) 2>&1 | tee $(LOG_DIR)/3_2_place_iop.log
else
	cp $< $@
endif

# STEP 3: Global placement with placed IOs, timing-driven, and routability-driven.
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_3_place_gp.odb: $(RESULTS_DIR)/3_2_place_iop.odb $(RESULTS_DIR)/2_floorplan.sdc $(LIB_FILES)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/global_place.tcl -metrics $(LOG_DIR)/3_3_place_gp.json) 2>&1 | tee $(LOG_DIR)/3_3_place_gp.log

# STEP 4: Resizing & Buffering
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_4_place_resized.odb: $(RESULTS_DIR)/3_3_place_gp.odb $(RESULTS_DIR)/2_floorplan.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/resize.tcl -metrics $(LOG_DIR)/3_4_resizer.json) 2>&1 | tee $(LOG_DIR)/3_4_resizer.log

clean_resize:
	rm -f $(RESULTS_DIR)/3_4_place_resized.odb

# STEP 5: Detail placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/3_5_place_dp.odb: $(RESULTS_DIR)/3_4_place_resized.odb
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/detail_place.tcl -metrics $(LOG_DIR)/3_5_opendp.json) 2>&1 | tee $(LOG_DIR)/3_5_opendp.log

$(RESULTS_DIR)/3_place.odb: $(RESULTS_DIR)/3_5_place_dp.odb
	cp $< $@

$(RESULTS_DIR)/3_place.sdc: $(RESULTS_DIR)/2_floorplan.sdc
	cp $< $@

# Clean Targets
#-------------------------------------------------------------------------------
clean_place:
	rm -f $(RESULTS_DIR)/3_*place*.odb
	rm -f $(RESULTS_DIR)/3_place.sdc
	rm -f $(RESULTS_DIR)/3_*.def $(RESULTS_DIR)/3_*.v
	rm -f $(REPORTS_DIR)/3_*
	rm -f $(LOG_DIR)/3_*


