# Utilities
#===============================================================================
.PHONY: metadata
metadata: finish
	@echo $(DESIGN_DIR) > $(REPORTS_DIR)/design-dir.txt
	@$(UTILS_DIR)/genMetrics.py -d $(DESIGN_NICKNAME) \
		-p $(PLATFORM) \
		-v $(FLOW_VARIANT) \
		-o $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json 2>&1 \
		| tee $(REPORTS_DIR)/gen-metrics-$(FLOW_VARIANT)-check.log
	@$(UTILS_DIR)/checkMetadata.py \
		-m $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json \
		-r $(dir $(DESIGN_CONFIG))rules-$(FLOW_VARIANT).json 2>&1 \
		| tee $(REPORTS_DIR)/metadata-$(FLOW_VARIANT)-check.log

.PHONY: clean_metadata
clean_metadata:
	rm -f $(REPORTS_DIR)/metadata-$(FLOW_VARIANT)-check.log
	rm -f $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json

.PHONY: update_ok
update_ok: update_rules

.PHONY: update_metadata
update_metadata:
	cp -f $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json \
	      $(DESIGN_DIR)/metadata-$(FLOW_VARIANT)-ok.json

.PHONY: update_rules
update_rules:
	$(UTILS_DIR)/genRuleFile.py $(DESIGN_DIR) \
		--reference $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json \
		--variant $(FLOW_VARIANT) \
		--failing \
		--tighten

.PHONY: update_rules_force
update_rules_force:
	$(UTILS_DIR)/genRuleFile.py $(DESIGN_DIR) --variant $(FLOW_VARIANT) --update

.PHONY: update_metadata_autotuner
update_metadata_autotuner:
	@$(UTILS_DIR)/genMetrics.py -d $(DESIGN_NICKNAME) \
		-p $(PLATFORM) \
		-v $(FLOW_VARIANT) \
		-o $(DESIGN_DIR)/metadata-$(FLOW_VARIANT)-at.json -x

#-------------------------------------------------------------------------------

.PHONY: write_net_rc
write_net_rc: $(RESULTS_DIR)/6_net_rc.csv

#$(RESULTS_DIR)/6_net_rc.csv: $(RESULTS_DIR)/4_cts.odb $(RESULTS_DIR)/6_final.spef
$(RESULTS_DIR)/6_net_rc.csv:
	($(TIME_CMD) $(OPENROAD_CMD) $(UTILS_DIR)/write_net_rc_script.tcl) 2>&1 | tee $(LOG_DIR)/6_write_net_rc.log

.PHONY: correlate_rc
correlate_rc: $(RESULTS_DIR)/6_net_rc.csv
	$(UTILS_DIR)/correlateRC.py $(RESULTS_DIR)/6_net_rc.csv

# TODO Make always wants to redo designs with this rule, regardless of which variations are tried.
#	$(MAKE) DESIGN_CONFIG=$$config write_net_rc; \
#$(foreach config,$(wildcard designs/$(PLATFORM)/*/config.mk),$(MAKE) DESIGN_CONFIG=$(config) write_net_rc; )
.PHONY: correlate_platform_rc
correlate_platform_rc:
	for config in designs/$(PLATFORM)/*/config.mk; do \
	  design=$$(basename $$(dirname $$config)); \
	  make DESIGN_CONFIG=./$$config results/$(PLATFORM)/$$design/base/6_net_rc.csv; \
	done
	$(UTILS_DIR)/correlateRC.py $$(find results/$(PLATFORM)/*/base -name 6_net_rc.csv)

# Run test using gnu parallel
#-------------------------------------------------------------------------------
TEST_SCRIPT ?= $(TEST_DIR)/core_tests.sh
.PHONY: run_test
run_test:
	parallel --sshloginfile $(TEST_DIR)/nodes.txt \
	         --timeout 21600 \
	         --workdir `pwd` < $(TEST_SCRIPT) \
	         --joblog $(TEST_DIR)/parallel.log

.PHONY: clean_test
clean_test:
	rm -rf $(TEST_DIR)/logs
	rm -rf $(TEST_DIR)/parallel.log

# Utility to create issues
#-------------------------------------------------------------------------------
# Run "make {script}_issue" where script is wildcarded from the scripts folder
#   e.g "make cts_issue"
# Set the ISSUE_TAG variable to rename the generated tar file
#-------------------------------------------------------------------------------
ISSUE_SCRIPTS = $(patsubst %.tcl,%,$(notdir $(sort $(wildcard $(SCRIPTS_DIR)/*.tcl))))
define \n


endef

define get_variables
$(foreach V, $(.VARIABLES),$(if $(filter-out $(1), $(origin $V)), $(if $(filter-out .% %QT_QPA_PLATFORM% %TIME_CMD% KLAYOUT% GENERATE_ABSTRACT_RULE% do-step% do-copy% OPEN_GUI% OPEN_GUI_SHORTCUT% SUB_MAKE% UNSET_VARS% export%, $(V)), $V$ )))
endef

export UNSET_VARIABLES_NAMES := $(call get_variables,command% line environment% default automatic)
export ISSUE_VARIABLES_NAMES := $(sort $(filter-out \n get_variables, $(call get_variables,environment% default automatic)))
export ISSUE_VARIABLES := $(foreach V, $(ISSUE_VARIABLES_NAMES), $(if $($V),$V=$($V),$V='')${\n})
export COMMAND_LINE_ARGS := $(foreach V,$(.VARIABLES),$(if $(filter command% line, $(origin $V)),$(V)))

$(foreach script,$(ISSUE_SCRIPTS),$(script)_issue): %_issue : versions.txt
	$(UTILS_DIR)/makeIssue.sh $*

.PHONY: clean_issues
clean_issues:
	rm -f $(foreach issue, $(ISSUE_SCRIPTS), $(issue)_*.tar.gz)
	rm -f vars*.sh vars*.tcl vars*.gdb run-me*.sh

$(RESULTS_DIR)/6_final_only_clk.def: $(RESULTS_DIR)/6_final.def
	$(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/deleteNonClkNets.tcl

$(RESULTS_DIR)/6_final_no_power.def: $(RESULTS_DIR)/6_final.def
	$(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/deletePowerNets.tcl


.PHONY: gallery
gallery: $(RESULTS_DIR)/6_final_no_power.def $(RESULTS_DIR)/6_final_only_clk.def
	($(TIME_CMD) klayout -z -nc -rx -rd gallery_json=util/gallery.json \
	        -rd results_path=$(RESULTS_DIR) \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/createGallery.py) 2>&1 | tee $(LOG_DIR)/6_1_merge.log

.PHONY: view_cells
view_cells:
	$(OPENROAD_GUI_CMD) $(SCRIPTS_DIR)/view_cells.tcl

## Quick access to command line
.PHONY: command
command:
	$(OPENROAD_NO_EXIT_CMD)

## Provide easy access to debugging
ifdef GDB
export OPENROAD_EXE := gdb --args $(OPENROAD_EXE)
endif

## Provide easy way to run valgrind
ifdef VALGRIND
export OPENROAD_EXE := valgrind $(VALGRIND_ARGS) $(OPENROAD_EXE)
endif

## Convert RVE DRC database to JSON
.PHONY: convert_rve
convert_rve: $(REPORTS_DIR)/drc.json

$(REPORTS_DIR)/drc.json: $(DRC_FILE)
ifneq ($(DRC_FILE),)
	$(KLAYOUT_CMD) -z -rd in_drc="$<" \
	        -rd out_file="$@" \
	        -rm $(UTILS_DIR)/convertDrc.py
else
	@echo "No DRC_FILE defined."
endif

# Update the clock period sdc based on the worst slack reported by the final
# (post global route) timing.
.PHONY: update_sdc_clocks
update_sdc_clocks: $(RESULTS_DIR)/route.guide
	cp $(RESULTS_DIR)/updated_clks.sdc $(SDC_FILE)

# Set yosys-abc clock period to first "clk_period" value or "-period" value found in sdc file
ifeq ($(origin ABC_CLOCK_PERIOD_IN_PS), undefined)
   ifneq ($(wildcard $(SDC_FILE)),)
      export ABC_CLOCK_PERIOD_IN_PS := $(shell sed -nE "s/^set\s+clk_period\s+(\S+).*|.*-period\s+(\S+).*/\1\2/p" $(SDC_FILE) | head -1 | awk '{print $$1}')
   endif
endif
