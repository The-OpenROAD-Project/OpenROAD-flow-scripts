include $(dir $(DESIGN_CONFIG))/config_hier.mk

export FLOW_VARIANT = hier_netlist

export CACHED_NETLIST = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/ariane.v
