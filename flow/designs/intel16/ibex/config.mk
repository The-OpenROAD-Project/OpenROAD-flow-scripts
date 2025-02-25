DESIGN_PDK_HOME              := $(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

export DESIGN_NICKNAME = ibex
export DESIGN_NAME = ibex_core
export PLATFORM    = intel16

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

export SDC_FILE      = $(DESIGN_DIR)/constraint.sdc

export CORE_UTILIZATION = 30
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export PLACE_DENSITY = uniform
export SKIP_PIN_SWAP = 1
