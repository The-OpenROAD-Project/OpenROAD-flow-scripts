exec klayout -zz -rd design_name=$::env(DESIGN_NAME) \
             -rd in_def=$::env(RESULTS_DIR)/5_route.def \
             -rd in_gds=[join $::env(GDS_FILES)] \
             -rd out_gds=$::env(RESULTS_DIR)/6_final.gds \
             -rd tech_file=$::env(OBJECTS_DIR)/klayout.lyt \
             -rm $::env(UTILS_DIR)/def2gds.py
