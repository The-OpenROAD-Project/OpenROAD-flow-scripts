# Utilities
#===============================================================================

metadata: $(REPORTS_DIR)/metadata-check.log

clean_metadata:
	rm -f $(REPORTS_DIR)/metadata-check.log
	rm -f $(REPORTS_DIR)/metadata.json

$(REPORTS_DIR)/metadata.json:
	$(UTILS_DIR)/genMetrics.py -f ./ -d $(DESIGN_NICKNAME) -p $(PLATFORM) -o $@

RULES_DESIGN = $(dir $(DESIGN_CONFIG))rules.json
RULES_GLOBAL = $(UTILS_DIR)/rules-global.json
GOLD_METADATA = $(dir $(DESIGN_CONFIG))metadata-ok.json

$(REPORTS_DIR)/metadata-check.log: $(REPORTS_DIR)/metadata.json
	if test -f $(RULES_DESIGN); then \
	  $(UTILS_DIR)/checkMetadata.py -m $< -r $(RULES_DESIGN) $(RULES_GLOBAL) -g $(GOLD_METADATA) | tee $@; \
	else \
	  $(UTILS_DIR)/checkMetadata.py -m $< -r $(RULES_GLOBAL)  -g $(GOLD_METADATA) | tee $@; \
	fi


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
ISSUE_SCRIPTS = $(patsubst %.tcl,%,$(notdir $(sort $(wildcard $(SCRIPTS_DIR)/*.tcl))))
ISSUE_CP_FILE_VARS = BLACKBOX_MAP_TCL BLACKBOX_V_FILE CTS_TECH_DIR GENERIC_TECH_LEF \
                     IP_GLOBAL_CFG LATCH_MAP_FILE LIB_FILES SC_LEF TECH_LEF \
                     TRACKS_INFO_FILE SDC_FILE VERILOG_FILES TAPCELL_TCL CACHED_NETLIST \
                     FOOTPRINT SIG_MAP_FILE PDN_CFG ADDITIONAL_LEFS SETRC_FILE

$(foreach script,$(ISSUE_SCRIPTS),$(script)_issue): %_issue : versions.txt
	# Creating runme.sh script
	@echo "#!/bin/bash"                             > runme.sh
	@echo "source vars.sh"                          >> runme.sh
	@echo "openroad -no_init $(SCRIPTS_DIR)/$*.tcl" >> runme.sh
	@chmod +x runme.sh

	# Creating vars.sh/tcl script
	-@rm -f vars.sh vars.tcl vars.gdb
	@$(foreach V, $(.VARIABLES), \
	  $(if $(filter-out environment% default automatic, $(origin $V)), \
	  echo export $V=\""$($V)\""  >> vars.sh ; \
	  echo set env\($V\) \""$($V)\""     >> vars.tcl ; \
	  echo set env $V "$($V)"     >> vars.gdb ;) \
	)
	@sed -i '/export \./d' vars.sh
	@sed -i -e 's/ \// /g' -e 's/"\//"/' vars.sh
	@sed -i '/set env(\./d' vars.tcl
	@sed -i -e 's/ \// /g' -e 's/"\//"/' vars.tcl
	@sed -i '/set env \./d' vars.gdb
	@sed -i -e 's/ \// /g' -e 's/"\//"/' vars.gdb

	# Archiving issue to $*_$(ISSUE_TAG).tar.gz
	@tar -czhf $*_$(ISSUE_TAG).tar.gz \
	    --xform='s|^|$*_$(ISSUE_TAG)/|S' $(LOG_DIR) \
	                                     $(OBJECTS_DIR) \
	                                     $(REPORTS_DIR) \
	                                     $(RESULTS_DIR) \
	                                     $(SCRIPTS_DIR) \
	                                     $(foreach var,$(ISSUE_CP_FILE_VARS),$($(var))) \
	                                     runme.sh vars.sh vars.tcl vars.gdb \
	                                     $^

vars.tcl:
	-@rm -f vars.sh vars.tcl vars.gdb
	@$(foreach V, $(.VARIABLES), \
	$(if $(filter-out environment% default automatic, $(origin $V)), \
	echo export $V=\""$($V)\""  >> vars.sh ; \
	echo set env\($V\) \""$($V)\""     >> vars.tcl ; \
	echo set env $V "$($V)"     >> vars.gdb ;) \
	)
	@sed -i '/export \./d' vars.sh
	@sed -i -e 's/ \// /g' -e 's/"\//"/' vars.sh
	@sed -i '/set env(\./d' vars.tcl
	@sed -i -e 's/ \// /g' -e 's/"\//"/' vars.tcl
	@sed -i '/set env \./d' vars.gdb
	@sed -i -e 's/ \// /g' -e 's/"\//"/' vars.gdb

clean_issues:
	rm -rf $(foreach issue, $(ISSUE_SCRIPTS), $(issue)_*.tar.gz)
	rm -rf vars.sh runme.sh

$(RESULTS_DIR)/6_final_only_clk.def: $(RESULTS_DIR)/6_final.def
	$(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/deleteNonClkNets.tcl

$(RESULTS_DIR)/6_final_no_power.def: $(RESULTS_DIR)/6_final.def
	$(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/deletePowerNets.tcl


gallery: $(RESULTS_DIR)/6_final_no_power.def $(RESULTS_DIR)/6_final_only_clk.def
	($(TIME_CMD) klayout -z -nc -rx -rd gallery_json=util/gallery.json \
	        -rd results_path=$(RESULTS_DIR) \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/createGallery.py) 2>&1 | tee $(LOG_DIR)/6_1_merge.log
