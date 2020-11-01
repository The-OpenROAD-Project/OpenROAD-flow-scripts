# Process node
export PROCESS = 130
export LIBRARY ?= hs

include ./platforms/$(PLATFORM)/config_$(LIBRARY).mk 
