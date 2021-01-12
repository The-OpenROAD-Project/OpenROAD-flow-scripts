# Process node
export PROCESS = 130
export LIBRARY ?= hs


# Rules for metal fill
export FILL_CONFIG = ./platforms/$(PLATFORM)/fill.json

include ./platforms/$(PLATFORM)/config_$(LIBRARY).mk 
