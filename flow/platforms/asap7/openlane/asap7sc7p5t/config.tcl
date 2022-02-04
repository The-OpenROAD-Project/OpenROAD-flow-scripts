set current_folder [file dirname [file normalize [info script]]]
# Technology lib

set libs_ref "$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)"

set libs_tech "$::env(PDK_ROOT)/$::env(PDK)/libs.tech"

set ::env(LIB_FASTEST) ""
set ::env(LIB_TYPICAL) ""
set ::env(LIB_SLOWEST) ""

set lib_path "$libs_ref/lib"
foreach lib {"AO" "INVBUF" "OA" "SEQ" "SIMPLE"} {
    append ::env(LIB_FASTEST) "$lib_path/asap7sc7p5t_${lib}_RVT_FF_nldm_201020.lib "
    append ::env(LIB_TYPICAL) "$lib_path/asap7sc7p5t_${lib}_RVT_TT_nldm_201020.lib "
    append ::env(LIB_SLOWEST) "$lib_path/asap7sc7p5t_${lib}_RVT_SS_nldm_201020.lib "
}

set ::env(LIB_SYNTH) $::env(LIB_TYPICAL)
set ::env(LIB_RESIZER_OPT) $::env(LIB_SYNTH)

set ::env(DFF_LIB_SYNTH) "$lib_path/asap7sc7p5t_SEQ_RVT_TT_nldm_201020.lib"

set ::env(LIB_CTS) $::env(LIB_TYPICAL)

# Placement site for core cells
# This can be found in the technology lef
set ::env(PLACE_SITE) "asap7sc7p5t"
set ::env(PLACE_SITE_WIDTH) 0.054
set ::env(PLACE_SITE_HEIGHT) 0.270

# welltap and endcap cells
set ::env(FP_WELLTAP_CELL) "TAPCELL_ASAP7_75t_R"
set ::env(FP_ENDCAP_CELL) "TAPCELL_ASAP7_75t_R"

# defaults (can be overridden by designs):
set ::env(SYNTH_DRIVING_CELL) "BUFx2_ASAP7_75t_R"
set ::env(SYNTH_DRIVING_CELL_PIN) "Y"
set ::env(SYNTH_CAP_LOAD) "4.61057" ; # femtofarad INVx8_ASAP7_75t_R pin A cap
set ::env(SYNTH_MIN_BUF_PORT) "BUFx2_ASAP7_75t_R A Y"
set ::env(SYNTH_TIEHI_PORT) "TIEHIx1_ASAP7_75t_R H"
set ::env(SYNTH_TIELO_PORT) "TIELOx1_ASAP7_75t_R L"

# cts defaults
set ::env(CTS_ROOT_BUFFER) BUFx4_ASAP7_75t_R
set ::env(CELL_CLK_PORT) CLK

# Placement defaults
set ::env(PL_LIB) $::env(LIB_TYPICAL)

# Fillcell insertion
set ::env(FILL_CELL) "FILLERxp5_ASAP7_75t_R"
set ::env(DECAP_CELL) "DECAPx1_ASAP7_75t_R"
set ::env(RE_BUFFER_CELL) ""

set ::env(CELL_PAD) 2
set ::env(CELL_PAD_EXCLUDE) ""

# Clk Buffers info CTS data
set ::env(ROOT_CLK_BUFFER) BUFx4_ASAP7_75t_R
set ::env(CLK_BUFFER) BUFx4_ASAP7_75t_R
set ::env(CLK_BUFFER_INPUT) A
set ::env(CLK_BUFFER_OUTPUT) Y
set ::env(CTS_CLK_BUFFER_LIST) "BUFx4_ASAP7_75t_R"
set ::env(FP_PDN_RAIL_WIDTH) 0.48
# Determined from BUFx24_ASAP7_75t_R
set ::env(CTS_MAX_CAP) 1474.56
set ::env(DEFAULT_MAX_TRAN) 320

set ::env(PDN_CFG) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/grid_strategy-M2-M5-M7.cfg"
