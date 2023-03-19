# ==============================================================================
#   ____ _____ ____
#  / ___|_   _/ ___|
# | |     | | \___ \
# | |___  | |  ___) |
#  \____| |_| |____/
#
cts: $(RESULTS_DIR)/4_cts.odb \
     $(RESULTS_DIR)/4_cts.sdc
# ==============================================================================

# Run TritonCTS
# ------------------------------------------------------------------------------
$(RESULTS_DIR)/4_1_cts.odb: $(RESULTS_DIR)/3_place.odb $(RESULTS_DIR)/3_place.sdc
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/cts.tcl -metrics $(LOG_DIR)/4_1_cts.json) 2>&1 | tee $(LOG_DIR)/4_1_cts.log

# Filler cell insertion
# ------------------------------------------------------------------------------
$(RESULTS_DIR)/4_2_cts_fillcell.odb: $(RESULTS_DIR)/4_1_cts.odb
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/fillcell.tcl -metrics $(LOG_DIR)/4_2_cts_fillcell.json) 2>&1 | tee $(LOG_DIR)/4_2_cts_fillcell.log

$(RESULTS_DIR)/4_cts.sdc: $(RESULTS_DIR)/4_cts.odb

$(RESULTS_DIR)/4_cts.odb: $(RESULTS_DIR)/4_2_cts_fillcell.odb
	cp $< $@

clean_cts:
	rm -rf $(RESULTS_DIR)/4_*cts*.odb $(RESULTS_DIR)/4_cts.sdc $(RESULTS_DIR)/4_*.v $(RESULTS_DIR)/4_*.def
	rm -f  $(REPORTS_DIR)/4_*
	rm -f  $(LOG_DIR)/4_*


