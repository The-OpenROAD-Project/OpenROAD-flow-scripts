fastroute -output_file $::env(RESULTS_DIR)/route.guide \
          -max_routing_layer $::env(MAX_ROUTING_LAYER) \
          -unidirectional_routing true \
          -layers_adjustments {{2 0} {3 0.15} {4 0.15} {5 0.15} {6 0.15}}  \
          -overflow_iterations 100 \
	  -layers_pitches {{2 0.37} {3 0.48} {4 0.74} {5 0.96} {6 3.33}} \
	  -verbose 2 \
