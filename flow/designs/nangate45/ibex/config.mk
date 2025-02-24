export DESIGN_NICKNAME = ibex
export DESIGN_NAME = ibex_core
export PLATFORM    = nangate45



export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_alu.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_branch_predict.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_compressed_decoder.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_controller.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_core.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_counter.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_cs_registers.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_csr.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_decoder.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_dummy_instr.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_ex_block.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_fetch_fifo.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_icache.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_id_stage.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_if_stage.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_load_store_unit.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_multdiv_fast.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_multdiv_slow.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_pmp.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_prefetch_buffer.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_register_file_ff.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_register_file_fpga.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_register_file_latch.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ibex_wb_stage.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_badbit_ram_1p.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_clock_gating.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_generic_clock_gating.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_generic_ram_1p.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_lfsr.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_ram_1p.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_secded_28_22_dec.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_secded_28_22_enc.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_secded_39_32_dec.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_secded_39_32_enc.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_secded_72_64_dec.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_secded_72_64_enc.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/prim_xilinx_clock_gating.v




export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION ?= 50
export PLACE_DENSITY_LB_ADDON = 0.20
export TNS_END_PERCENT        = 100

