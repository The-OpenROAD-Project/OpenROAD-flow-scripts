export DESIGN_NICKNAME = ibex
export DESIGN_NAME = ibex_core
export PLATFORM    = nangate45

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_pkg.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_alu.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_compressed_decoder.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_controller.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_cs_registers.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_counter.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_decoder.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_ex_block.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_id_stage.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_if_stage.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_wb_stage.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_load_store_unit.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_multdiv_slow.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_multdiv_fast.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_prefetch_buffer.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_fetch_fifo.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_pmp.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_csr.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_core.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_register_file_ff.sv \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/syn/rtl/prim_clock_gating.v

export VERILOG_INCLUDE_DIRS = \
    $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/vendor/lowrisc_ip/prim/rtl/

export SYNTH_USE_SLANG = 1

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION ?= 50
export PLACE_DENSITY_LB_ADDON = 0.20
export TNS_END_PERCENT        = 100

