export PLATFORM               = rapidus2hp

export DESIGN_NAME            = hercules_is_int

export SRC_HOME = /platforms/Rapidus/designs/hercules_is_int
export VERILOG_FILES          = $(SRC_HOME)/hercules_issue/verilog/hercules_is_defines.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_flush_compare.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_gcbfwd.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_gclfwd.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_gcxfwd.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_gfwd.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_grbt_bnk.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_grbt.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_grf_bnk_rd.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_grf_bnk.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_grf_bnk_wr.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_grf.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_int_comm.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_int_ela.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_int_fwd.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_int_pipe.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_int.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq2_age.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq2_entry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq2_ncentry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq2.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq_age.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq_dep.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq_entry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq_free_list.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq_ncentry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_lsq_top_dep.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_ls_uop_ctl_dec.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mx0_entry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mx0.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mx1_entry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mx1.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mxq_age.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mxq_dep.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mxq_free_list.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mxq_ncentry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mxq_slow_age.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mxq_slow_dep.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_mxq_top_dep.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_params.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_pcrf_bnk.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_pcrf.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_resc_cnt1s_4b.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_resc_ix.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_resc_ls.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_resc_tag.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_stid_compare.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_sxq_age.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_sxq_dep.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_sxq_entry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_sxq_free_list.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_sxq_ncentry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_sxq_slow_age.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_sxq_slow_dep.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_sxq.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_sxq_top_dep.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vec_comm.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vec_ela.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vec_pipe.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vec_res_ctl.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vec.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vrbt_rmux.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vrbt.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vrbt_wmux.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vrf_port_arb.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vxq_age.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vxq_entry.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vxq_free_list.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vxq_pipe.sv \
	$(SRC_HOME)/hercules_issue/verilog/hercules_is_vxq.sv \
	$(SRC_HOME)/shared/verilog/hercules_ccpass.sv \
	$(SRC_HOME)/shared/verilog/hercules_core_defines.sv \
	$(SRC_HOME)/shared/verilog/hercules_dffr_rstval.sv \
	$(SRC_HOME)/shared/verilog/hercules_dffr.sv \
	$(SRC_HOME)/shared/verilog/hercules_dff.sv \
	$(SRC_HOME)/shared/verilog/hercules_ecc_chk.sv \
	$(SRC_HOME)/shared/verilog/hercules_ecc_correct.sv \
	$(SRC_HOME)/shared/verilog/hercules_ecc_gen.sv \
	$(SRC_HOME)/shared/verilog/hercules_ecc_matrix.sv \
	$(SRC_HOME)/shared/verilog/hercules_ecc_syndrome_correct.sv \
	$(SRC_HOME)/shared/verilog/hercules_ela_defines.sv \
	$(SRC_HOME)/shared/verilog/hercules_fcvt64.sv \
	$(SRC_HOME)/shared/verilog/hercules_flush_compare.sv \
	$(SRC_HOME)/shared/verilog/hercules_flush_type_defines.sv \
	$(SRC_HOME)/shared/verilog/hercules_header.sv \
	$(SRC_HOME)/shared/verilog/hercules_ifid_lsm_regcnt_armthm.sv \
	$(SRC_HOME)/shared/verilog/hercules_ifid_lsm_regcnt_neon.sv \
	$(SRC_HOME)/shared/verilog/hercules_ifid_lsm_regcnt.sv \
	$(SRC_HOME)/shared/verilog/hercules_ifid_mop_t16_iqual.sv \
	$(SRC_HOME)/shared/verilog/hercules_ifid_mop_t32p_iqual.sv \
	$(SRC_HOME)/shared/verilog/hercules_ifid_mq_props.sv \
	$(SRC_HOME)/shared/verilog/hercules_invmask64.sv \
	$(SRC_HOME)/shared/verilog/hercules_lsl2_defines.sv \
	$(SRC_HOME)/shared/verilog/hercules_params.sv \
	$(SRC_HOME)/shared/verilog/hercules_pdp_period.sv \
	$(SRC_HOME)/shared/verilog/hercules_pdp_tracker_ls.sv \
	$(SRC_HOME)/shared/verilog/hercules_pdp_tracker.sv \
	$(SRC_HOME)/shared/verilog/hercules_plru_arb.sv \
	$(SRC_HOME)/shared/verilog/hercules_plru_order.sv \
	$(SRC_HOME)/shared/verilog/hercules_pmu_defines.sv \
	$(SRC_HOME)/shared/verilog/hercules_shared_params.sv \
	$(SRC_HOME)/models/cells/generic/hercules_ck_gate.sv \
	$(SRC_HOME)/models/cells/generic/hercules_nand_gate.sv \
	$(SRC_HOME)/models/cells/generic/hercules_nor_gate.sv

export VERILOG_INCLUDE_DIRS =  $(SRC_HOME)/hercules_issue/verilog \
	$(SRC_HOME)/shared/verilog \
	$(SRC_HOME)/models/cells/generic

export VERILOG_DEFINES += 

export ADDITIONAL_LEFS = 
export ADDITIONAL_LIBS += 

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/prects.sdc

# Must be defined before the ifeq's
export SYNTH_HDL_FRONTEND  = slang
export SYNTH_HIERARCHICAL ?= 0

export CORE_UTILIZATION       = 35

export CORE_MARGIN            = 2
export MACRO_PLACE_HALO       = 2 2

export PLACE_DENSITY          = 0.58

# a smoketest for this option, there are a
# few last gasp iterations
export SKIP_LAST_GASP ?= 1

# For use with SYNTH_HIERARCHICAL
export SYNTH_MINIMUM_KEEP_SIZE ?= 40000
