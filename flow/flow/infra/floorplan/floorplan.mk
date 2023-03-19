# ==============================================================================
#  _____ _     ___   ___  ____  ____  _        _    _   _
# |  ___| |   / _ \ / _ \|  _ \|  _ \| |      / \  | \ | |
# | |_  | |  | | | | | | | |_) | |_) | |     / _ \ |  \| |
# |  _| | |__| |_| | |_| |  _ <|  __/| |___ / ___ \| |\  |
# |_|   |_____\___/ \___/|_| \_\_|   |_____/_/   \_\_| \_|
#
floorplan: $(RESULTS_DIR)/2_floorplan.odb \
           $(RESULTS_DIR)/2_floorplan.sdc
# ==============================================================================

ifneq ($(FOOTPRINT),)
IS_CHIP = 1
else ifneq ($(FOOTPRINT_TCL),)
IS_CHIP = 1
endif

# STEP 1: Translate verilog to odb
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_1_floorplan.odb: $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS) $(FOOTPRINT) $(SIG_MAP_FILE) $(FOOTPRINT_TCL)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/floorplan.tcl -metrics $(LOG_DIR)/2_1_floorplan.json) 2>&1 | tee $(LOG_DIR)/2_1_floorplan.log


# STEP 2: IO Placement (random)
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_2_floorplan_io.odb: $(RESULTS_DIR)/2_1_floorplan.odb $(IO_CONSTRAINTS)
ifndef IS_CHIP
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/io_placement_random.tcl -metrics $(LOG_DIR)/2_2_floorplan_io.json) 2>&1 | tee $(LOG_DIR)/2_2_floorplan_io.log
else
	cp $< $@
endif

# STEP 3: Timing Driven Mixed Sized Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_3_floorplan_tdms.odb: $(RESULTS_DIR)/2_2_floorplan_io.odb $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(LIB_FILES)
ifeq ($(MACRO_PLACEMENT),)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/tdms_place.tcl -metrics $(LOG_DIR)/2_3_tdms.json) 2>&1 | tee $(LOG_DIR)/2_3_tdms_place.log
else
	$(info [INFO][FLOW] Using manual macro placement file $(MACRO_PLACEMENT))
	cp $< $@
endif

# STEP 4: Macro Placement
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_4_floorplan_macro.odb: $(RESULTS_DIR)/2_3_floorplan_tdms.odb $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(MACRO_PLACEMENT) $(MACRO_PLACEMENT_TCL)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/macro_place.tcl -metrics $(LOG_DIR)/2_4_mplace.json) 2>&1 | tee $(LOG_DIR)/2_4_mplace.log

# STEP 5: Tapcell and Welltie insertion
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_5_floorplan_tapcell.odb: $(RESULTS_DIR)/2_4_floorplan_macro.odb $(TAPCELL_TCL)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/tapcell.tcl -metrics $(LOG_DIR)/2_5_tapcell.json) 2>&1 | tee $(LOG_DIR)/2_5_tapcell.log


# STEP 6: PDN generation
#-------------------------------------------------------------------------------
$(RESULTS_DIR)/2_6_floorplan_pdn.odb: $(RESULTS_DIR)/2_5_floorplan_tapcell.odb $(PDN_CFG) $(PDN_TCL)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/pdn.tcl -metrics $(LOG_DIR)/2_6_pdn.json) 2>&1 | tee $(LOG_DIR)/2_6_pdn.log

$(RESULTS_DIR)/2_floorplan.odb: $(RESULTS_DIR)/2_6_floorplan_pdn.odb
	cp $< $@

$(RESULTS_DIR)/2_floorplan.sdc: $(RESULTS_DIR)/2_1_floorplan.odb


clean_floorplan:
	rm -f $(RESULTS_DIR)/2_*floorplan*.odb $(RESULTS_DIR)/2_floorplan.sdc $(RESULTS_DIR)/2_*.v $(RESULTS_DIR)/2_*.def
	rm -f $(REPORTS_DIR)/2_*
	rm -f $(LOG_DIR)/2_*

