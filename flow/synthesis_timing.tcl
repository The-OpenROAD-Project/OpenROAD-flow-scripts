set lib { platforms/asap7/lib/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz \
platforms/asap7/lib/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib \
platforms/asap7/lib/fakeram7_256x32.lib \
platforms/asap7/lib/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib \
platforms/asap7/lib/asap7sc7p5t_AO_RVT_SS_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_INVBUF_RVT_SS_nldm_220122.lib.gz \
platforms/asap7/lib/asap7sc7p5t_OA_RVT_SS_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_SEQ_RVT_SS_nldm_220123.lib \
platforms/asap7/lib/asap7sc7p5t_SIMPLE_RVT_SS_nldm_211120.lib.gz \
platforms/asap7/lib/fakeram7_256x32.lib \
platforms/asap7/lib/asap7sc7p5t_SEQ_RVT_SS_nldm_220123.lib \
platforms/asap7/lib/asap7sc7p5t_AO_RVT_TT_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_INVBUF_RVT_TT_nldm_220122.lib.gz \
platforms/asap7/lib/asap7sc7p5t_OA_RVT_TT_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib \
platforms/asap7/lib/asap7sc7p5t_SIMPLE_RVT_TT_nldm_211120.lib.gz \
platforms/asap7/lib/fakeram7_256x32.lib \
platforms/asap7/lib/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib }

foreach library $lib {
	read_liberty $library
}

read_verilog results/asap7/riscv32i/base/1_1_yosys.v
link_design riscv_top
read_sdc results/asap7/riscv32i/base/1_synth.sdc

source scripts/report_metrics.tcl
report_metrics synthesis
