exec klayout -zz -rd design_name=$::env(DESIGN_NAME) \
	         -rd in_def=$(RESULTS_DIR)/6_final.def \
	         -rd in_gds="$(GDS_FILES) $(WRAPPED_GDS)" \
	         -rd config_file=$(FILL_CONFIG) \
	         -rd seal_gds="$(SEAL_GDS)" \
	         -rd out_gds=$@ \
	         -rd tech_file=$(OBJECTS_DIR)/klayout.lyt \
	         -rm $(UTILS_DIR)/def2gds.py
