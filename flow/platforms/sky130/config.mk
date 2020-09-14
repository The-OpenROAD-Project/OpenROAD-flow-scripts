# Process node
export PROCESS = 130
export LIBRARY ?= hd

include ./platforms/$(PLATFORM)/config_$(LIBRARY).mk 
