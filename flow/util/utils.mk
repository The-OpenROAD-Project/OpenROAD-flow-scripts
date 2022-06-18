# Utilities
#===============================================================================

metadata: $(REPORTS_DIR)/metadata-$(FLOW_VARIANT)-check.log

clean_metadata:
	rm -f $(REPORTS_DIR)/metadata-$(FLOW_VARIANT)-check.log
	rm -f $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json

.PHONY: update_metadata update_rules update_ok
update_ok: update_metadata update_rules

update_metadata: $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json
	cp -f $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json \
	      $(DESIGN_DIR)/metadata-$(FLOW_VARIANT)-ok.json

update_rules:
	$(UTILS_DIR)/genRuleFile.py $(DESIGN_DIR) --variant $(FLOW_VARIANT) --failing --tighten

update_rules_force:
	$(UTILS_DIR)/genRuleFile.py $(DESIGN_DIR) --variant $(FLOW_VARIANT) --update

$(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json:
	echo $(DESIGN_DIR) > $(REPORTS_DIR)/design-dir.txt
	$(UTILS_DIR)/genMetrics.py -d $(DESIGN_NICKNAME) \
		-p $(PLATFORM) \
		-v $(FLOW_VARIANT) \
		-o $@ 2>&1 | tee $(REPORTS_DIR)/gen-metrics-$(FLOW_VARIANT)-check.log

RULES_DESIGN = $(dir $(DESIGN_CONFIG))rules-$(FLOW_VARIANT).json

$(REPORTS_DIR)/metadata-$(FLOW_VARIANT)-check.log: $(REPORTS_DIR)/metadata-$(FLOW_VARIANT).json
	$(UTILS_DIR)/checkMetadata.py -m $< -r $(RULES_DESIGN) 2>&1 | tee $@

#-------------------------------------------------------------------------------

write_net_rc: $(RESULTS_DIR)/6_net_rc.csv

#$(RESULTS_DIR)/6_net_rc.csv: $(RESULTS_DIR)/4_cts.odb $(RESULTS_DIR)/6_final.spef
$(RESULTS_DIR)/6_net_rc.csv:
	($(TIME_CMD) $(OPENROAD_CMD) $(UTILS_DIR)/write_net_rc_script.tcl) 2>&1 | tee $(LOG_DIR)/6_write_net_rc.log

correlate_rc: $(RESULTS_DIR)/6_net_rc.csv
	$(UTILS_DIR)/correlateRC.py $(RESULTS_DIR)/6_net_rc.csv

# TODO Make always wants to redo designs with this rule, regardless of which variations are tried.
#	$(MAKE) DESIGN_CONFIG=$$config write_net_rc; \
#$(foreach config,$(wildcard designs/$(PLATFORM)/*/config.mk),$(MAKE) DESIGN_CONFIG=$(config) write_net_rc; )
correlate_platform_rc:
	for config in designs/$(PLATFORM)/*/config.mk; do \
	  design=$$(basename $$(dirname $$config)); \
	  make DESIGN_CONFIG=./$$config results/$(PLATFORM)/$$design/base/6_net_rc.csv; \
	done
	$(UTILS_DIR)/correlateRC.py $$(find results/$(PLATFORM)/*/base -name 6_net_rc.csv)

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
ISSUE_TAG ?= $(DESIGN_NICKNAME)_$(PLATFORM)_$(FLOW_VARIANT)_$(shell date +"%Y-%m-%d_%H-%M")
ISSUE_SCRIPTS = $(patsubst %.tcl,%,$(notdir $(sort $(wildcard $(SCRIPTS_DIR)/*.tcl))))
ISSUE_CP_DESIGN_FILE_VARS = SDC_FILE \
                            VERILOG_FILES \
                            CACHED_NETLIST \
                            FOOTPRINT_TCL \
                            FOOTPRINT \
                            SIG_MAP_FILE \
                            IO_CONSTRAINTS \
                            MACRO_PLACEMENT \
                            RTLMP_CONFIG_FILE \
                            DFF_LIB_FILE

ISSUE_CP_PLATFORM_FILE_VARS = LIB_FILES \
                              SC_LEF \
                              TECH_LEF \
                              ADDITIONAL_LEFS \
                              CLKGATE_MAP_FILE \
                              ADDER_MAP_FILE \
                              LATCH_MAP_FILE \
                              CDL_FILE \
                              MAKE_TRACKS \
                              POST_FLOORPLAN_TCL \
                              TAPCELL_TCL \
                              PDN_CFG \
                              PDN_TCL \
                              POST_PDN_TCL \
                              POST_CTS_TCL \
                              PRE_GLOBAL_ROUTE \
                              FASTROUTE_TCL \
                              POST_DETAIL_ROUTE_TCL \
                              RCX_RULES \
                              FILL_CONFIG

ISSUE_CP_FILE_VARS = $(ISSUE_CP_DESIGN_FILE_VARS)
ifndef EXCLUDE_PLATFORM
ISSUE_CP_FILE_VARS += $(ISSUE_CP_PLATFORM_FILE_VARS)
ISSUE_CP_FILES_PLATFORM = $(PLATFORM_DIR)/*.tcl $(PLATFORM_DIR)/*.cfg
endif

VARS_BASENAME = vars-$(DESIGN_NICKNAME)-$(PLATFORM)-$(FLOW_VARIANT)
RUN_ME_SCRIPT = run-me-$(DESIGN_NICKNAME)-$(PLATFORM)-$(FLOW_VARIANT).sh

ISSUE_CP_FILES = $(foreach var,$(ISSUE_CP_FILE_VARS),$($(var))) \
                 $(ISSUE_CP_FILES_PLATFORM) \
                 $(UTILS_DIR)/def2stream.py \
                 $(RUN_ME_SCRIPT) \
                 $(VARS_BASENAME).sh \
                 $(VARS_BASENAME).tcl \
                 $(VARS_BASENAME).gdb

$(foreach script,$(ISSUE_SCRIPTS),$(script)_issue): %_issue : versions.txt
	# Creating $(RUN_ME_SCRIPT) script
	@echo "#!/usr/bin/env bash"                     >  $(RUN_ME_SCRIPT)
	@echo "source $(VARS_BASENAME).sh"              >> $(RUN_ME_SCRIPT)
	@echo "openroad -no_init $(SCRIPTS_DIR)/$*.tcl" >> $(RUN_ME_SCRIPT)
	@chmod +x $(RUN_ME_SCRIPT)

	# Creating $(VARS_BASENAME).sh/tcl script
	-@rm -f $(VARS_BASENAME).sh $(VARS_BASENAME).tcl $(VARS_BASENAME).gdb
	@$(foreach V, $(.VARIABLES), \
	    $(if $(filter-out environment% default automatic, $(origin $V)), \
	      echo export $V="'$($V)'" >> $(VARS_BASENAME).sh ; \
	     ) \
	)
	@$(foreach V, $(.VARIABLES), \
	    $(if $(filter-out environment% default automatic, $(origin $V)), \
	      echo set env\($V\) \""$($V)\"" >> $(VARS_BASENAME).tcl ; \
	     ) \
	)
	@$(foreach V, $(.VARIABLES), \
	    $(if $(filter-out environment% default automatic, $(origin $V)), \
	      echo set env $V "$($V)" >> $(VARS_BASENAME).gdb ; \
	     ) \
	)
	# remove variables starting with a dot
	@sed -i -e '/export \./d' $(VARS_BASENAME).sh
	@sed -i -e '/set env(\./d' $(VARS_BASENAME).tcl
	@sed -i -e '/set env \./d' $(VARS_BASENAME).gdb
	# remove non portable commands
	@sed -i '/TIME_CMD/d' $(VARS_BASENAME).sh
	@sed -i '/TIME_CMD/d' $(VARS_BASENAME).tcl
	@sed -i '/TIME_CMD/d' $(VARS_BASENAME).gdb
	# remove QT variable
	@sed -i '/QT_QPA_PLATFORM/d' $(VARS_BASENAME).sh
	@sed -i '/QT_QPA_PLATFORM/d' $(VARS_BASENAME).tcl
	@sed -i '/QT_QPA_PLATFORM/d' $(VARS_BASENAME).gdb

# This requires gnu-tar to support --xform
	# Archiving issue to $*_$(ISSUE_TAG).tar.gz
	@tar --ignore-failed-read -czhf $*_$(ISSUE_TAG).tar.gz \
	    --xform='s|^|$*_$(ISSUE_TAG)/|S' \
	    $(LOG_DIR) \
	    $(OBJECTS_DIR) \
	    $(REPORTS_DIR) \
	    $(RESULTS_DIR) \
	    $(SCRIPTS_DIR) \
	    $(shell for f in $(ISSUE_CP_FILES); do echo $$f; done | sort | uniq) \
	    $^

ifdef EXCLUDE_PLATFORM
	# Remove liberty and lef files from tar file
	@gunzip -f $*_$(ISSUE_TAG).tar.gz
	@tar --list --file $*_$(ISSUE_TAG).tar | grep -iE "*.(lib|lef|tlef)$$" | xargs -r tar --delete --file $*_$(ISSUE_TAG).tar
	@gzip $*_$(ISSUE_TAG).tar
endif

	@if [ ! -z $${COPY_ISSUE+x} ]; then \
	    mkdir -p $${COPY_ISSUE} ; \
	    cp $*_$(ISSUE_TAG).tar.gz $${COPY_ISSUE} ; \
	fi

clean_issues:
	rm -rf $(foreach issue, $(ISSUE_SCRIPTS), $(issue)_*.tar.gz)
	rm -rf $(VARS_BASENAME).sh $(RUN_ME_SCRIPT)

$(RESULTS_DIR)/6_final_only_clk.def: $(RESULTS_DIR)/6_final.def
	$(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/deleteNonClkNets.tcl

$(RESULTS_DIR)/6_final_no_power.def: $(RESULTS_DIR)/6_final.def
	$(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/deletePowerNets.tcl


gallery: $(RESULTS_DIR)/6_final_no_power.def $(RESULTS_DIR)/6_final_only_clk.def
	($(TIME_CMD) klayout -z -nc -rx -rd gallery_json=util/gallery.json \
	        -rd results_path=$(RESULTS_DIR) \
	        -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	        -rm $(UTILS_DIR)/createGallery.py) 2>&1 | tee $(LOG_DIR)/6_1_merge.log

view_cells:
	$(OPENROAD_GUI_CMD) $(SCRIPTS_DIR)/view_cells.tcl

## Quick access to command line
command:
	$(OPENROAD_NO_EXIT_CMD)

## Provide easy access to debugging
ifdef GDB
OPENROAD_EXE := gdb --args $(OPENROAD_EXE)
endif

## Provide easy way to run valgrind
ifdef VALGRIND
OPENROAD_EXE := valgrind $(VALGRIND_ARGS) $(OPENROAD_EXE)
endif

## Convert RVE DRC database to JSON
convert_rve: $(OBJECTS_DIR)/drc.json

$(OBJECTS_DIR)/drc.json: $(DRC_FILE)
ifneq ($(DRC_FILE),)
	$(KLAYOUT_CMD) -z -rd in_drc="$<" \
	        -rd out_file="$@" \
	        -rm $(UTILS_DIR)/convertDrc.py
else
	@echo "No DRC_FILE defined."
endif

# Update the clock period sdc based on the worst slack reported by the final
# (post global route) timing.
update_sdc_clocks: $(RESULTS_DIR)/route.guide
	cp $(RESULTS_DIR)/updated_clks.sdc $(SDC_FILE)
