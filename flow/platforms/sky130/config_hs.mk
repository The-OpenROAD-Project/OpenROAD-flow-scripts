# Set the TIEHI/TIELO cells
# These are used in yosys synthesis to avoid logical 1/0's in the netlist
export TIEHI_CELL_AND_PORT = sky130_fd_sc_hs__conb_1 HI
export TIELO_CELL_AND_PORT = sky130_fd_sc_hs__conb_1 LO

# Used in synthesis
export MIN_BUF_CELL_AND_PORTS = sky130_fd_sc_hs__buf_4 A X

# Used in synthesis
export MAX_FANOUT ?= 100

# Blackbox verilog file
# List all standard cells and cells yosys should treat as blackboxes here
export BLACKBOX_V_FILE = ./platforms/$(PLATFORM)/sky130_fd_sc_hs.blackbox.v

# Yosys mapping files
export LATCH_MAP_FILE = ./platforms/$(PLATFORM)/cells_latch_hs.v
export CLKGATE_MAP_FILE = ./platforms/$(PLATFORM)/cells_clkgate_hs.v
export BLACKBOX_MAP_TCL = ./platforms/$(PLATFORM)/blackbox_map.tcl

# Placement site for core cells
# This can be found in the technology lef
export PLACE_SITE = unit

# Track information for generating DEF tracks
export TRACKS_INFO_FILE = ./platforms/$(PLATFORM)/tracks_hs.info

export IP_GLOBAL_CFG = ./platforms/$(PLATFORM)/IP_global.cfg

export TECH_LEF = ./platforms/$(PLATFORM)/lef/sky130_fd_sc_hs.tlef
export SC_LEF = ./platforms/$(PLATFORM)/lef/sky130_fd_sc_hs_merged.lef

export LIB_FILES = ./platforms/$(PLATFORM)/lib/sky130_fd_sc_hs__tt_025C_1v80.lib \
                     $(ADDITIONAL_LIBS)
export GDS_FILES = $(wildcard ./platforms/$(PLATFORM)/gds/*.gds) \
                     $(ADDITIONAL_GDS_FILES)

# Cell padding in SITE widths to ease rout-ability
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4

# Endcap and Welltie cells
export TAPCELL_TCL = ./platforms/$(PLATFORM)/tapcell.tcl

# TritonCTS options
export CTS_BUF_CELL   = sky130_fd_sc_hs__buf_1
export CTS_MAX_SLEW   = 1.5e-9
export CTS_MAX_CAP    = .2e-12
export CTS_TECH_DIR   = ./platforms/$(PLATFORM)/tritonCTShs

# FastRoute options
export MIN_ROUTING_LAYER = 1
export MAX_ROUTING_LAYER = 5

# IO Pin fix margin
export IO_PIN_MARGIN = 70

# Layer to use for parasitics estimations
export WIRE_RC_LAYER = met3

# KLayout technology file
export KLAYOUT_TECH_FILE = ./platforms/$(PLATFORM)/$(PLATFORM).lyt

# Dont use cells to ease congestion
# Specify at least one filler cell if none

export DONT_USE_CELLS += \
sky130_fd_sc_hs__dfrtp_4 \
sky130_fd_sc_hs__dfstp_2 \
sky130_fd_sc_hs__sdfbbn_2 \
sky130_fd_sc_hs__sdfxtp_2 \
sky130_fd_sc_hs__dfxtp_2 \
sky130_fd_sc_hs__sdfrtp_2 \
sky130_fd_sc_hs__dfsbp_2 \
sky130_fd_sc_hs__dlymetal6s4s_1 \
sky130_fd_sc_hs__dlygate4sd3_1 \
sky130_fd_sc_hs__dlrbp_2 \
sky130_fd_sc_hs__dlxbn_2 \
sky130_fd_sc_hs__dlrtp_2 \
sky130_fd_sc_hs__dlygate4sd2_1 \
sky130_fd_sc_hs__sdfrbp_2 \
sky130_fd_sc_hs__dfrtp_2 \
sky130_fd_sc_hs__dlymetal6s6s_1 \
sky130_fd_sc_hs__sdfstp_2 \
sky130_fd_sc_hs__dlymetal6s2s_1 \
sky130_fd_sc_hs__dlxtn_2 \
sky130_fd_sc_hs__dlrtn_2 \
sky130_fd_sc_hs__sdfsbp_2 \
sky130_fd_sc_hs__sdfxbp_2 \
sky130_fd_sc_hs__clkbuf_1 \
sky130_fd_sc_hs__clkbuf_2 \
sky130_fd_sc_hs__clkbuf_4 \
sky130_fd_sc_hs__clkbuf_8 \
sky130_fd_sc_hs__clkbuf_16 \
sky130_fd_sc_hs__clkbuf_16 \
sky130_fd_sc_hs__clkbuf_4 \
sky130_fd_sc_hs__dfrtp_2 \
sky130_fd_sc_hs__dfstp_2 \
sky130_fd_sc_hs__dlrbp_2 \
sky130_fd_sc_hs__dlrtp_2 \
sky130_fd_sc_hs__dlxtn_2 \
sky130_fd_sc_hs__dlygate4sd3_1 \
sky130_fd_sc_hs__dlymetal6s4s_1 \
sky130_fd_sc_hs__sdfrbp_2 \
sky130_fd_sc_hs__sdfsbp_2 \
sky130_fd_sc_hs__sdfxbp_2 \
sky130_fd_sc_hs__clkdlybuf4s15_1 \
sky130_fd_sc_hs__clkdlybuf4s15_2 \
sky130_fd_sc_hs__clkdlybuf4s18_1 \
sky130_fd_sc_hs__clkdlybuf4s18_2 \
sky130_fd_sc_hs__clkdlybuf4s25_1 \
sky130_fd_sc_hs__clkdlybuf4s25_2 \
sky130_fd_sc_hs__clkdlybuf4s50_1 \
sky130_fd_sc_hs__clkdlybuf4s50_2 \
sky130_fd_sc_hs__clkinv_1 \
sky130_fd_sc_hs__clkinv_16 \
sky130_fd_sc_hs__clkinv_2 \
sky130_fd_sc_hs__clkinv_4 \
sky130_fd_sc_hs__clkinv_8 \
sky130_fd_sc_hs__clkinvlp_2 \
sky130_fd_sc_hs__clkinvlp_4 \
sky130_fd_sc_hs__decap_12 \
sky130_fd_sc_hs__decap_3 \
sky130_fd_sc_hs__decap_4 \
sky130_fd_sc_hs__decap_6 \
sky130_fd_sc_hs__decap_8 \
sky130_fd_sc_hs__dfbbn_1 \
sky130_fd_sc_hs__dfbbp_1 \
sky130_fd_sc_hs__dfrbp_1 \
sky130_fd_sc_hs__dfrtn_1 \
sky130_fd_sc_hs__dfrtp_1 \
sky130_fd_sc_hs__dfsbp_1 \
sky130_fd_sc_hs__dfstp_1 \
sky130_fd_sc_hs__dfxbp_1 \
sky130_fd_sc_hs__dfxtp_1 \
sky130_fd_sc_hs__diode_2 \
sky130_fd_sc_hs__dlclkp_1 \
sky130_fd_sc_hs__dlclkp_2 \
sky130_fd_sc_hs__dlclkp_4 \
sky130_fd_sc_hs__dlrbn_1 \
sky130_fd_sc_hs__dlrbn_2 \
sky130_fd_sc_hs__dlrbp_1 \
sky130_fd_sc_hs__dlrtn_1 \
sky130_fd_sc_hs__dlrtn_4 \
sky130_fd_sc_hs__dlrtp_1 \
sky130_fd_sc_hs__dlrtp_4 \
sky130_fd_sc_hs__dlxbn_1 \
sky130_fd_sc_hs__dlxbp_1 \
sky130_fd_sc_hs__dlxtn_1 \
sky130_fd_sc_hs__dlxtn_4 \
sky130_fd_sc_hs__dlxtp_1 \
sky130_fd_sc_hs__dlygate4sd1_1 \
sky130_fd_sc_hs__ebufn_1 \
sky130_fd_sc_hs__ebufn_2 \
sky130_fd_sc_hs__ebufn_4 \
sky130_fd_sc_hs__ebufn_8 \
sky130_fd_sc_hs__edfxbp_1 \
sky130_fd_sc_hs__edfxtp_1 \
sky130_fd_sc_hs__einvn_0 \
sky130_fd_sc_hs__einvn_1 \
sky130_fd_sc_hs__einvn_2 \
sky130_fd_sc_hs__einvn_4 \
sky130_fd_sc_hs__einvn_8 \
sky130_fd_sc_hs__einvp_1 \
sky130_fd_sc_hs__einvp_2 \
sky130_fd_sc_hs__einvp_4 \
sky130_fd_sc_hs__einvp_8 \
sky130_fd_sc_hs__fahcin_1 \
sky130_fd_sc_hs__fahcon_1 \
sky130_fd_sc_hs__lpflow_bleeder_1 \
sky130_fd_sc_hs__lpflow_clkbufkapwr_1 \
sky130_fd_sc_hs__lpflow_clkbufkapwr_16 \
sky130_fd_sc_hs__lpflow_clkbufkapwr_2 \
sky130_fd_sc_hs__lpflow_clkbufkapwr_4 \
sky130_fd_sc_hs__lpflow_clkbufkapwr_8 \
sky130_fd_sc_hs__lpflow_clkinvkapwr_1 \
sky130_fd_sc_hs__lpflow_clkinvkapwr_16 \
sky130_fd_sc_hs__lpflow_clkinvkapwr_2 \
sky130_fd_sc_hs__lpflow_clkinvkapwr_4 \
sky130_fd_sc_hs__lpflow_clkinvkapwr_8 \
sky130_fd_sc_hs__lpflow_decapkapwr_12 \
sky130_fd_sc_hs__lpflow_decapkapwr_3 \
sky130_fd_sc_hs__lpflow_decapkapwr_4 \
sky130_fd_sc_hs__lpflow_decapkapwr_6 \
sky130_fd_sc_hs__lpflow_decapkapwr_8 \
sky130_fd_sc_hs__lpflow_inputiso0n_1 \
sky130_fd_sc_hs__lpflow_inputiso0p_1 \
sky130_fd_sc_hs__lpflow_inputiso1n_1 \
sky130_fd_sc_hs__lpflow_inputiso1p_1 \
sky130_fd_sc_hs__lpflow_inputisolatch_1 \
sky130_fd_sc_hs__lpflow_isobufsrc_1 \
sky130_fd_sc_hs__lpflow_isobufsrc_16 \
sky130_fd_sc_hs__lpflow_isobufsrc_2 \
sky130_fd_sc_hs__lpflow_isobufsrc_4 \
sky130_fd_sc_hs__lpflow_isobufsrc_8 \
sky130_fd_sc_hs__lpflow_isobufsrckapwr_16 \
sky130_fd_sc_hs__lpflow_lsbuf_lh_isowell_4 \
sky130_fd_sc_hs__lpflow_lsbuf_lh_isowell_tap_1 \
sky130_fd_sc_hs__lpflow_lsbuf_lh_isowell_tap_2 \
sky130_fd_sc_hs__lpflow_lsbuf_lh_isowell_tap_4 \
sky130_fd_sc_hs__macro_sparecell \
sky130_fd_sc_hs__probe_s8p_8 \
sky130_fd_sc_hs__probec_s8p_8 \
sky130_fd_sc_hs__sdfbbn_1 \
sky130_fd_sc_hs__sdfbbp_1 \
sky130_fd_sc_hs__sdfrbp_1 \
sky130_fd_sc_hs__sdfrtn_1 \
sky130_fd_sc_hs__sdfrtp_1 \
sky130_fd_sc_hs__sdfrtp_4 \
sky130_fd_sc_hs__sdfsbp_1 \
sky130_fd_sc_hs__sdfstp_1 \
sky130_fd_sc_hs__sdfstp_4 \
sky130_fd_sc_hs__sdfxbp_1 \
sky130_fd_sc_hs__sdfxtp_1 \
sky130_fd_sc_hs__sdfxtp_4 \
sky130_fd_sc_hs__sdlclkp_1 \
sky130_fd_sc_hs__sdlclkp_2 \
sky130_fd_sc_hs__sdlclkp_4 \
sky130_fd_sc_hs__sedfxbp_1 \
sky130_fd_sc_hs__sedfxbp_2 \
sky130_fd_sc_hs__sedfxtp_1 \
sky130_fd_sc_hs__sedfxtp_2 \
sky130_fd_sc_hs__sedfxtp_4 \
sky130_fd_sc_hs__lpflow_lsbuf_lh_hl_isowell_tap_1 \
sky130_fd_sc_hs__lpflow_lsbuf_lh_hl_isowell_tap_2 \
sky130_fd_sc_hs__lpflow_lsbuf_lh_hl_isowell_tap_4 \
sky130_fd_sc_hs__clkdlyinv3sd1_1 \
sky130_fd_sc_hs__clkdlyinv3sd2_1 \
sky130_fd_sc_hs__clkdlyinv3sd3_1 \
sky130_fd_sc_hs__clkdlyinv5sd1_1 \
sky130_fd_sc_hs__clkdlyinv5sd2_1 \
sky130_fd_sc_hs__clkdlyinv5sd3_1 

# Define ABC driver and load
export ABC_DRIVER_CELL = sky130_fd_sc_hs__buf_1
export ABC_LOAD_IN_FF = 5
export ABC_CLOCK_PERIOD_IN_PS = 10

# Define default PDN config
export PDN_CFG ?= ./platforms/$(PLATFORM)/pdn.cfg

# Define fastRoute tcl
export FASTROUTE_TCL = ./platforms/$(PLATFORM)/fastroute.tcl

# Template definition for power grid analysis
export TEMPLATE_PGA_CFG ?= ./platforms/sky130/template_pga.cfg

export PLACE_DENSITY ?= 0.50

# Define Hold Buffer
export HOLD_BUF_CELL = sky130_fd_sc_hs__buf_1

# IO Placer pin layers
export IO_PLACER_H = 4
export IO_PLACER_V = 3

# keep with gf
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 4
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

# Define fill cells
export FILL_CELLS = sky130_fd_sc_hs__fill_1 sky130_fd_sc_hs__fill_2 sky130_fd_sc_hs__fill_4 sky130_fd_sc_hs__fill_8

# resizer repair_long_wires -max_length
export MAX_WIRE_LENGTH = 21000

