# Utilities
#===============================================================================
drc: $(REPORTS_DIR)/drc.rpt

$(REPORTS_DIR)/drc.rpt: $(RESULTS_DIR)/5_route.def
	innovus -execute "loadLefFile $(OBJECTS_DIR)/merged.lef ; \
	                  loadDefFile $<; \
	                  verify_drc -limit 10000 -report $(REPORTS_DIR)/drc.rpt; \
	                  exit" \
	                  -no_gui -no_logv
#; stty sane here breaks gnu parallel


print_cells:
	find ./logs/ -iname 1_1_yosys.log -exec sh -c "grep -iH 'Number of cells' {} | tail -1" \;

print_drc:
	find ./reports/ -iname drc.rpt -exec sh -c "grep -iH 'viol' {} | tail -1" \;

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

# Utility to print information tool version information
#-------------------------------------------------------------------------------
YOSYS_PATH := $(dir $(shell which yosys))
OPENROAD_PATH := $(dir $(shell which openroad))
TRITONROUTE_PATH := $(dir $(shell which TritonRoute))
.PHONY: versions.txt
versions.txt:
	-@echo "======================================================" > $(abspath $@)
	@openroad -version >> $(abspath $@)
	-@cd $(OPENROAD_PATH); echo OpenROAD `git diff --quiet || echo '*dirty*'` `git config --get remote.origin.url` >> $(abspath $@)
	-@cd $(OPENROAD_PATH); echo branch:`git rev-parse --abbrev-ref HEAD` `git rev-parse HEAD` >> $(abspath $@)
	-@cd $(OPENROAD_PATH); git submodule foreach --recursive 'echo $$path `git diff --quiet || echo -n '*dirty*'` branch:`git rev-parse --abbrev-ref HEAD` `git rev-parse HEAD`' >> $(abspath $@)
	-@echo "======================================================" >> $(abspath $@)
	@yosys -V >> $(abspath $@)
	-@cd $(YOSYS_PATH); echo Yosys `git diff --quiet || echo '*dirty*'` `git config --get remote.origin.url` >> $(abspath $@)
	-@cd $(YOSYS_PATH); echo branch:`git rev-parse --abbrev-ref HEAD` `git rev-parse HEAD` >> $(abspath $@)
	-@echo "======================================================" >> $(abspath $@)
	-@cd $(TRITONROUTE_PATH); echo TritonRoute `git diff --quiet || echo '*dirty*'` `git config --get remote.origin.url` >> $(abspath $@)
	-@cd $(TRITONROUTE_PATH); echo branch:`git rev-parse --abbrev-ref HEAD` `git rev-parse HEAD` >> $(abspath $@)
	-@echo "======================================================" >> $(abspath $@)
	@klayout -v >> $(abspath $@)
	-@echo "======================================================" >> $(abspath $@)
	-@sed -i '/Entering /d' $@


# Utility to create issues
#-------------------------------------------------------------------------------
# Run "make {script}_issue" where script is wildcarded from the scripts folder
#   e.g "make cts_issue"
# Set the ISSUE_TAG variable to rename the generated tar file
#-------------------------------------------------------------------------------
ISSUE_TAG ?= $(DESIGN_NAME)_$(PLATFORM)_$(shell date +"%Y-%m-%d_%H-%M")
ISSUE_SCRIPTS = $(patsubst %.tcl,%,$(notdir $(wildcard $(SCRIPTS_DIR)/*.tcl)))
ISSUE_CP_FILE_VARS = BLACKBOX_MAP_TCL BLACKBOX_V_FILE CTS_TECH_DIR GENERIC_TECH_LEF \
                     IP_GLOBAL_CFG LATCH_MAP_FILE LIB_FILES SC_LEF TECH_LEF \
                     TRACKS_INFO_FILE SDC_FILE VERILOG_FILES TAPCELL_TCL

$(foreach script,$(ISSUE_SCRIPTS),$(script)_issue): %_issue : versions.txt ./POST9.dat ./POWV9.dat
	# Creating runme.sh script
	@echo "#!/bin/bash"                    > runme.sh
	@echo "source vars.sh"                 >> runme.sh
	@echo "openroad $(SCRIPTS_DIR)/$*.tcl" >> runme.sh
	@chmod +x runme.sh

	# Creating vars.sh script
	-@rm -f vars.sh
	@$(foreach V, $(.VARIABLES), \
	  $(if $(filter-out environment% default automatic, $(origin $V)), \
	  echo export $V=\""$($V)\""  >> vars.sh ;) \
	)
	@sed -i '/export \./d' vars.sh

	# Archiving issue to $*_$(ISSUE_TAG).tar.gz
	@tar -czhf $*_$(ISSUE_TAG).tar.gz \
	    --xform='s|^|$*_$(ISSUE_TAG)/|S' $(LOG_DIR) \
	                                     $(OBJECTS_DIR) \
	                                     $(REPORTS_DIR) \
	                                     $(RESULTS_DIR) \
	                                     $(SCRIPTS_DIR) \
	                                     $(foreach var,$(ISSUE_CP_FILE_VARS),$($(var))) \
	                                     runme.sh vars.sh \
	                                     $^

clean_issues:
	rm -rf $(foreach issue, $(ISSUE_SCRIPTS), $(issue)_*.tar.gz)
	rm -rf vars.sh runme.sh
