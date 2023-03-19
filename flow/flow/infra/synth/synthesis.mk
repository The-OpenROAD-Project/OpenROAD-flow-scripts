# ==============================================================================
#  ______   ___   _ _____ _   _ _____ ____ ___ ____
# / ___\ \ / / \ | |_   _| | | | ____/ ___|_ _/ ___|
# \___ \\ V /|  \| | | | | |_| |  _| \___ \| |\___ \
#  ___) || | | |\  | | | |  _  | |___ ___) | | ___) |
# |____/ |_| |_| \_| |_| |_| |_|_____|____/___|____/
#
synth: versions.txt \
       $(RESULTS_DIR)/1_synth.v \
       $(RESULTS_DIR)/1_synth.sdc
# ==============================================================================


# Run Synthesis using yosys
#-------------------------------------------------------------------------------
SYNTH_SCRIPT ?= $(SCRIPTS_DIR)/synth.tcl

$(SYNTH_STOP_MODULE_SCRIPT):
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	($(TIME_CMD) $(YOSYS_CMD) $(YOSYS_FLAGS) -c $(HIER_REPORT_SCRIPT)) 2>&1 | tee $(LOG_DIR)/1_1_yosys_hier_report.log

ifeq ($(SYNTH_HIERARCHICAL), 1)
$(RESULTS_DIR)/1_1_yosys.v: $(SYNTH_STOP_MODULE_SCRIPT)
endif

$(RESULTS_DIR)/1_1_yosys.v: $(DONT_USE_LIBS) $(WRAPPED_LIBS) $(DONT_USE_SC_LIB) $(DFF_LIB_FILE) $(VERILOG_FILES) $(CACHED_NETLIST) $(LATCH_MAP_FILE) $(ADDER_MAP_FILE)
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	($(TIME_CMD) $(YOSYS_CMD) $(YOSYS_FLAGS) -c $(SYNTH_SCRIPT)) 2>&1 | tee $(LOG_DIR)/1_1_yosys.log

$(RESULTS_DIR)/1_synth.v: $(RESULTS_DIR)/1_1_yosys.v
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	cp $< $@

$(RESULTS_DIR)/1_synth.sdc: $(SDC_FILE)
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	cp $< $@

clean_synth:
	rm -f  $(RESULTS_DIR)/1_*.v $(RESULTS_DIR)/1_synth.sdc
	rm -f  $(REPORTS_DIR)/synth_*
	rm -f  $(LOG_DIR)/1_*
	rm -f  $(SYNTH_STOP_MODULE_SCRIPT)
	rm -rf _tmp_yosys-abc-*

