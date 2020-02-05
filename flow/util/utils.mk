# Utilities
#===============================================================================
drc: $(REPORTS_DIR)/drc.rpt
$(REPORTS_DIR)/drc.rpt: finish
	innovus -execute "loadLefFile $(OBJECTS_DIR)/merged.lef ; \
	                  loadDefFile $(RESULTS_DIR)/5_route.def; \
	                  verify_drc -limit 10000 -report $(REPORTS_DIR)/drc.rpt; \
	                  exit" \
	                  -no_gui -no_logv
#; stty sane here breaks gnu parallel

congestion: $(REPORTS_DIR)/congestion.rpt
$(REPORTS_DIR)/congestion.rpt: $(RESULTS_DIR)/4_cts.def
	innovus -execute "loadLefFile $(OBJECTS_DIR)/merged.lef ; \
	                  loadDefFile $<; \
	                  earlyGlobalRoute; \
	                  describeCongestion > $@; \
	                  reportCongestion -hotSpot -overflow >> $@; \
	                  exit" \
	                  -no_gui -no_logv
#; stty sane here breaks gnu parallel


grep_cells:
	find ./logs/ -iname 1_1_yosys.log -exec sh -c "grep -iH 'Number of cells' {} | tail -1" \;

grep_drc:
	find ./reports/ -iname drc.rpt -exec sh -c "grep -iH 'viol' {} | tail -1" \;

grep_congestion:
	find ./reports/ -iname congestion.rpt -exec sh -c "grep -iH 'congestion index' {} | tail -1" \;

grep_util:
	find ./reports/ -iname 6_final_report.rpt -exec sh -c "grep -iH 'Design area' {} | tail -1" \;

# Run test using gnu parallel
#-------------------------------------------------------------------------------
TEST_SCRIPT ?= $(TEST_DIR)/core_tests.sh
run_test:
	parallel --sshloginfile $(TEST_DIR)/nodes.txt \
	         --timeout 21600 \
	         --workdir `pwd` < $(TEST_SCRIPT) \
	         --joblog $(TEST_DIR)/parallel.log

clean_test:
	rm -rf $(TEST_DIR)/logs
	rm -rf $(TEST_DIR)/parallel.log

# Utility to create issues
#-------------------------------------------------------------------------------
# Run "make {script}_issue" where script is wildcarded from the scripts folder
#   e.g "make cts_issue"
# Set the ISSUE_TAG variable to rename the generated tar file
#-------------------------------------------------------------------------------
ISSUE_TAG ?= $(DESIGN_NICKNAME)_$(PLATFORM)_$(shell date +"%Y-%m-%d_%H-%M")
ISSUE_SCRIPTS = $(patsubst %.tcl,%,$(notdir $(wildcard $(SCRIPTS_DIR)/*.tcl)))
ISSUE_CP_FILE_VARS = BLACKBOX_MAP_TCL BLACKBOX_V_FILE CTS_TECH_DIR GENERIC_TECH_LEF \
                     IP_GLOBAL_CFG LATCH_MAP_FILE LIB_FILES SC_LEF TECH_LEF \
                     TRACKS_INFO_FILE SDC_FILE VERILOG_FILES TAPCELL_TCL DC_NETLIST \
                     FOOTPRINT SIG_MAP_FILE PDN_CFG

$(foreach script,$(ISSUE_SCRIPTS),$(script)_issue): %_issue : versions.txt
	# Creating runme.sh script
	@echo "#!/bin/bash"                             > runme.sh
	@echo "source vars.sh"                          >> runme.sh
	@echo "openroad -no_init $(SCRIPTS_DIR)/$*.tcl" >> runme.sh
	@chmod +x runme.sh

	# Creating vars.sh/tcl script
	-@rm -f vars.sh vars.tcl
	@$(foreach V, $(.VARIABLES), \
	  $(if $(filter-out environment% default automatic, $(origin $V)), \
	  echo export $V=\""$($V)\""  >> vars.sh ; \
	  echo set env\($V\) \""$($V)\""     >> vars.tcl ;) \
	)
	@sed -i '/export \./d' vars.sh
	@sed -i '/$(USER)/d' vars.sh
	@sed -i '/set env(\./d' vars.tcl
	@sed -i '/$(USER)/d' vars.tcl

	# Archiving issue to $*_$(ISSUE_TAG).tar.gz
	@tar -czhf $*_$(ISSUE_TAG).tar.gz \
	    --xform='s|^|$*_$(ISSUE_TAG)/|S' $(LOG_DIR) \
	                                     $(OBJECTS_DIR) \
	                                     $(REPORTS_DIR) \
	                                     $(RESULTS_DIR) \
	                                     $(SCRIPTS_DIR) \
	                                     $(foreach var,$(ISSUE_CP_FILE_VARS),$($(var))) \
	                                     runme.sh vars.sh vars.tcl \
	                                     $^

clean_issues:
	rm -rf $(foreach issue, $(ISSUE_SCRIPTS), $(issue)_*.tar.gz)
	rm -rf vars.sh runme.sh

explore:
	min_routing_layer=2 max_routing_layer=7 capacity_adjustment=0 unidirectional_routing=1 layers_adjustment1=0.9 layers_adjustment2=0.5 layers_adjustment3=0.5 layers_adjustment4=0.5 layers_adjustment5=0.5 layers_adjustment6=0.5 layers_adjustment7=0.5 openroad -no_init ./util/explore_route.tcl