klayout -zz -rd design_name=$::env(DESIGN_NAME) \
        -rd in_lef=[file normalize $::env(OBJECTS_DIR)/merged.lef] \
        -rd in_def=$::env(RESULTS_DIR)/5_route.def \
        -rd in_gds=[join $::env(GDS_FILES)] \
        -rd out_gds=$::env(RESULTS_DIR)/6_final.gds \
        -rd map_file=./platforms/$::env(PLATFORM)/layermap.txt \
        -rm $::env(UTILS_DIR)/def2gds.py
