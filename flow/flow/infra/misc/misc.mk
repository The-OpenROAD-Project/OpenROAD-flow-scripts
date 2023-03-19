# ==============================================================================
#  __  __ ___ ____   ____
# |  \/  |_ _/ ___| / ___|
# | |\/| || |\___ \| |
# | |  | || | ___) | |___
# |_|  |_|___|____/ \____|
#
# ==============================================================================

all: $(SDC_FILE) $(WRAPPED_LIBS) $(DONT_USE_LIBS) $(OBJECTS_DIR)/klayout.lyt $(WRAPPED_GDSOAS) $(DONT_USE_SC_LIB)
	mkdir -p $(RESULTS_DIR) $(LOG_DIR) $(REPORTS_DIR)
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/run_all.tcl -metrics $(LOG_DIR)/run_all.json) 2>&1 | tee $(LOG_DIR)/run_all.log

clean:
	@echo
	@echo "Make clean disabled."
	@echo "Use make clean_all or clean individual steps:"
	@echo "  clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish"
	@echo

clean_all: clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish clean_metadata
	rm -rf $(OBJECTS_DIR)

nuke: clean_test clean_issues
	rm -rf ./results ./logs ./reports ./objects
	rm -rf layer_*.mps macrocell.list *best.plt *_pdn.def dummy.guide
	rm -rf *.rpt *.rpt.old *.def.v pin_dumper.log
	rm -rf versions.txt


# DEF/GDS/OAS viewer shortcuts
#-------------------------------------------------------------------------------
RESULTS_ODB = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.odb)))
RESULTS_DEF = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.def)))
RESULTS_GDS = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.gds)))
RESULTS_OAS = $(notdir $(sort $(wildcard $(RESULTS_DIR)/*.oas)))
$(foreach file,$(RESULTS_DEF) $(RESULTS_GDS) $(RESULTS_OAS),klayout_$(file)): klayout_%: $(OBJECTS_DIR)/klayout.lyt
	$(KLAYOUT_CMD) -nn $(OBJECTS_DIR)/klayout.lyt $(RESULTS_DIR)/$*

gui_floorplan: gui_2_floorplan.odb
gui_place: gui_3_place.odb
gui_cts: gui_4_cts.odb
gui_route: gui_5_route.odb
gui_final: gui_6_final.odb

$(foreach file,$(RESULTS_DEF),gui_$(file)): gui_%:
	DEF_FILE=$(RESULTS_DIR)/$* $(OPENROAD_GUI_CMD) $(SCRIPTS_DIR)/gui.tcl

$(foreach file,$(RESULTS_ODB),gui_$(file)): gui_%:
	ODB_FILE=$(RESULTS_DIR)/$* $(OPENROAD_GUI_CMD) $(SCRIPTS_DIR)/gui.tcl

# Write a def for the corresponding odb
$(foreach file,$(RESULTS_ODB),$(file).def): %.def:
	ODB_FILE=$(RESULTS_DIR)/$* DEF_FILE=$(RESULTS_DIR)/$@ $(OPENROAD_CMD) $(SCRIPTS_DIR)/write_def.tcl
#
# Write a verilog for the corresponding odb
$(foreach file,$(RESULTS_ODB),$(file).v): %.v:
	ODB_FILE=$(RESULTS_DIR)/$* VERILOG_FILE=$(RESULTS_DIR)/$@ $(OPENROAD_CMD) $(SCRIPTS_DIR)/write_verilog.tcl

all_defs : $(foreach file,$(RESULTS_ODB),$(file).def)
all_verilog : $(foreach file,$(RESULTS_ODB),$(file).v)

handoff : all_defs all_verilog

print-%  : ; @echo $* = $($*)

# Utilities
#-------------------------------------------------------------------------------
include $(UTILS_DIR)/utils.mk
export PRIVATE_DIR ?= ../../private_tool_scripts
-include $(PRIVATE_DIR)/private.mk
