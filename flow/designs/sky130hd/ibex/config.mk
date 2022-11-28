export DESIGN_NAME = ibex
export DESIGN_TOP_NAME = ibex_core
export PLATFORM    = sky130hd

export VERILOG_FILES = ./designs/src/$(DESIGN_NAME)/ibex_alu.v \
            ./designs/src/$(DESIGN_NAME)/ibex_branch_predict.v \
            ./designs/src/$(DESIGN_NAME)/ibex_compressed_decoder.v \
            ./designs/src/$(DESIGN_NAME)/ibex_controller.v \
            ./designs/src/$(DESIGN_NAME)/ibex_core.v \
            ./designs/src/$(DESIGN_NAME)/ibex_counter.v \
            ./designs/src/$(DESIGN_NAME)/ibex_cs_registers.v \
            ./designs/src/$(DESIGN_NAME)/ibex_csr.v \
            ./designs/src/$(DESIGN_NAME)/ibex_decoder.v \
            ./designs/src/$(DESIGN_NAME)/ibex_dummy_instr.v \
            ./designs/src/$(DESIGN_NAME)/ibex_ex_block.v \
            ./designs/src/$(DESIGN_NAME)/ibex_fetch_fifo.v \
            ./designs/src/$(DESIGN_NAME)/ibex_icache.v \
            ./designs/src/$(DESIGN_NAME)/ibex_id_stage.v \
            ./designs/src/$(DESIGN_NAME)/ibex_if_stage.v \
            ./designs/src/$(DESIGN_NAME)/ibex_load_store_unit.v \
            ./designs/src/$(DESIGN_NAME)/ibex_multdiv_fast.v \
            ./designs/src/$(DESIGN_NAME)/ibex_multdiv_slow.v \
            ./designs/src/$(DESIGN_NAME)/ibex_pmp.v \
            ./designs/src/$(DESIGN_NAME)/ibex_prefetch_buffer.v \
            ./designs/src/$(DESIGN_NAME)/ibex_register_file_ff.v \
            ./designs/src/$(DESIGN_NAME)/ibex_register_file_fpga.v \
            ./designs/src/$(DESIGN_NAME)/ibex_register_file_latch.v \
            ./designs/src/$(DESIGN_NAME)/ibex_wb_stage.v \
            ./designs/src/$(DESIGN_NAME)/prim_badbit_ram_1p.v \
            ./designs/src/$(DESIGN_NAME)/prim_clock_gating.v \
            ./designs/src/$(DESIGN_NAME)/prim_generic_clock_gating.v \
            ./designs/src/$(DESIGN_NAME)/prim_generic_ram_1p.v \
            ./designs/src/$(DESIGN_NAME)/prim_lfsr.v \
            ./designs/src/$(DESIGN_NAME)/prim_ram_1p.v \
            ./designs/src/$(DESIGN_NAME)/prim_secded_28_22_dec.v \
            ./designs/src/$(DESIGN_NAME)/prim_secded_28_22_enc.v \
            ./designs/src/$(DESIGN_NAME)/prim_secded_39_32_dec.v \
            ./designs/src/$(DESIGN_NAME)/prim_secded_39_32_enc.v \
            ./designs/src/$(DESIGN_NAME)/prim_secded_72_64_dec.v \
            ./designs/src/$(DESIGN_NAME)/prim_secded_72_64_enc.v \
            ./designs/src/$(DESIGN_NAME)/prim_xilinx_clock_gating.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

# Adders degrade ibex setup repair
export ADDER_MAP_FILE :=

export CORE_UTILIZATION = 40
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export PLACE_DENSITY_LB_ADDON = 0.2

export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute_base.tcl
