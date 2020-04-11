# Utilities
#===============================================================================
grep_cells:
	find ./logs/ -iname 1_1_yosys.log -exec sh -c "grep -iH 'Number of cells' {} | tail -1" \;

grep_util:
	find ./reports/ -iname 6_final_report.rpt -exec sh -c "grep -iH 'Design area' {} | tail -1" \;

metadata: $(REPORTS_DIR)/metadata-check.log

clean_metadata:
	rm -f $(REPORTS_DIR)/metadata-check.log
	rm -f $(REPORTS_DIR)/metadata.json

$(REPORTS_DIR)/metadata.json:
	$(UTILS_DIR)/genMetadata.py -f ./ -d $(DESIGN_NICKNAME) -p $(PLATFORM) -o $@

RULES = $(dir $(DESIGN_CONFIG))$(DESIGN_NICKNAME)_rules.json

$(REPORTS_DIR)/metadata-check.log: $(REPORTS_DIR)/metadata.json
	if test -f $(RULES); then \
	  $(UTILS_DIR)/checkMetadata.py -m $< -r $(RULES) | tee $@; \
	else \
	  echo "No rules" | tee $@; \
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
