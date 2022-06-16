import os
import siliconcompiler

openroad_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', '..'))

def make_docs():
    # TODO: Docs
    chip = siliconcompiler.Chip('<design>')
    setup(chip)
    return chip

####################################################
# PDK and Flow Setup
####################################################
def setup(chip):
    # Set the target name.
    chip.set('option', 'target', 'sky130hd_orflow')

    # Load PDK, flow, and libs.
    chip.load_pdk('sky130hd_orflow')
    chip.load_flow('orflow')
    chip.load_lib('sky130hd_orflow')

    # Set Chip object to use the loaded flow, pdk, lib.
    chip.set('option', 'flow', 'orflow')
    chip.set('option', 'pdk', 'skywater130')
    chip.set('asic', 'logiclib', 'sky130hd')

    chip.set('asic', 'logiclib', 'sky130hd')
    chip.set('asic', 'delaymodel', 'nldm')
    chip.set('asic', 'stackup', '5M1LI')
    chip.set('asic', 'minlayer', "m1")
    chip.set('asic', 'maxlayer', "m5")
    chip.set('asic', 'maxfanout', 5) # TODO: fix this
    chip.set('asic', 'maxlength', 21000)
    chip.set('asic', 'maxslew', 1.5e-9)
    chip.set('asic', 'maxcap', .1532e-12)
    chip.set('asic', 'rclayer', 'clk', 'm5')
    chip.set('asic', 'rclayer', 'data', 'm3')
    chip.set('asic', 'hpinlayer', "m3")
    chip.set('asic', 'vpinlayer', "m2")
    chip.set('asic', 'density', 10)
    chip.set('asic', 'aspectratio', 1)
    chip.set('asic', 'coremargin', 62.56)
    corner = 'typical'
    chip.set('constraint', 'worst', 'libcorner', corner)
    chip.set('constraint', 'worst', 'pexcorner', corner)
    chip.set('constraint', 'worst', 'mode', 'func')
    chip.add('constraint', 'worst', 'check', ['setup','hold'])

    # TODO: Add an 'objects' directory in the task dirs? Use 'outputs/' for now.
    env_vars = {
        # Defaults
        'SCRIPTS_DIR': os.path.join(openroad_dir, 'flow', 'scripts'),
        'UTILS_DIR': os.path.join(openroad_dir, 'flow', 'util'),
        'PLATFORM_DIR': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd'),
        # TODO: Many of these options could be driven by the schema once the poc is functional
        'GDS_FILES': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'gds', 'sky130_fd_sc_hd.gds'),
        'GDSOAS_FILES': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'gds', 'sky130_fd_sc_hd.gds'),
        'WRAPPED_GDSOAS': '',
        'GDS_LAYER_MAP': '',
        'STREAM_SYSTEM_EXT': 'gds',
        'TAPCELL_TCL': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'tapcell.tcl'),
        'FASTROUTE_TCL': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'fastroute.tcl'),
        'CLKGATE_MAP_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'cells_clkgate_hd.v'),
        'LATCH_MAP_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'cells_latch_hd.v'),
        'PDN_TCL': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'pdn.tcl'),
        #'KLAYOUT_LVS_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'lvs', 'FreePDK45.lylvs'),
        #'KLAYOUT_DRC_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'drc', 'FreePDK45.lydrc'),
        'PLATFORM': 'sky130hd',
        'SYNTH_ARGS': '-flatten',
        'ABC_DRIVER_CELL': 'sky130_fd_sc_hd__buf_1',
        'ABC_LOAD_IN_FF': '5',
        'ABC_AREA': '1',
        'DPO_MAX_DISPLACEMENT': '5 1',
        'PLACE_SITE': 'unithd',
        'TIEHI_CELL_AND_PORT': 'sky130_fd_sc_hd__conb_1 HI',
        'TIELO_CELL_AND_PORT': 'sky130_fd_sc_hd__conb_1 LO',
        'MIN_BUF_CELL_AND_PORTS': 'sky130_fd_sc_hd__buf_4 A X',
        'FILL_CELLS': 'sky130_fd_sc_hd__fill_1 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_8',
        'DONT_USE_CELLS': 'sky130_fd_sc_hd__probe_p_8 sky130_fd_sc_hd__probec_p_8 \
sky130_fd_sc_hd__lpflow_bleeder_1 \
sky130_fd_sc_hd__lpflow_clkbufkapwr_1 \
sky130_fd_sc_hd__lpflow_clkbufkapwr_16 \
sky130_fd_sc_hd__lpflow_clkbufkapwr_2 \
sky130_fd_sc_hd__lpflow_clkbufkapwr_4 \
sky130_fd_sc_hd__lpflow_clkbufkapwr_8 \
sky130_fd_sc_hd__lpflow_clkinvkapwr_1 \
sky130_fd_sc_hd__lpflow_clkinvkapwr_16 \
sky130_fd_sc_hd__lpflow_clkinvkapwr_2 \
sky130_fd_sc_hd__lpflow_clkinvkapwr_4 \
sky130_fd_sc_hd__lpflow_clkinvkapwr_8 \
sky130_fd_sc_hd__lpflow_decapkapwr_12 \
sky130_fd_sc_hd__lpflow_decapkapwr_3 \
sky130_fd_sc_hd__lpflow_decapkapwr_4 \
sky130_fd_sc_hd__lpflow_decapkapwr_6 \
sky130_fd_sc_hd__lpflow_decapkapwr_8 \
sky130_fd_sc_hd__lpflow_inputiso0n_1 \
sky130_fd_sc_hd__lpflow_inputiso0p_1 \
sky130_fd_sc_hd__lpflow_inputiso1n_1 \
sky130_fd_sc_hd__lpflow_inputiso1p_1 \
sky130_fd_sc_hd__lpflow_inputisolatch_1 \
sky130_fd_sc_hd__lpflow_isobufsrc_1 \
sky130_fd_sc_hd__lpflow_isobufsrc_16 \
sky130_fd_sc_hd__lpflow_isobufsrc_2 \
sky130_fd_sc_hd__lpflow_isobufsrc_4 \
sky130_fd_sc_hd__lpflow_isobufsrc_8 \
sky130_fd_sc_hd__lpflow_isobufsrckapwr_16 \
sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 \
sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 \
sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 \
sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 \
sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 \
sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 \
sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4',
        'CTS_BUF_CELL': 'sky130_fd_sc_hd__clkbuf_4',
        'FLOW_VARIANT': 'base',
        'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': '1',
        'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': '0',
        'RESYNTH_AREA_RECOVER': '0',
        'RESYNTH_TIMING_RECOVER': '0',
        'SYNTH_HIERARCHICAL': '0',
        'GPL_ROUTABILITY_DRIVEN': '1',
        'GPL_TIMING_DRIVEN': '1',
        'MIN_ROUTING_LAYER': 'met1',
        'IO_PLACER_V': 'met2',
        'IO_PLACER_H': 'met3',
        'WIRE_RC_LAYER': 'met3',
        'MAX_ROUTING_LAYER': 'met5',
        'PLACE_PINS_ARGS': '',
        'PLACE_DENSITY': '0.60',
        'NUM_CORES': '4', # TODO: Use nproc
        'LIB_FILES': ' '.join(chip.get('library', 'sky130hd', 'model', 'timing', 'nldm', 'typical')),
        # TODO: chip.get stackup, libtype
        'TECH_LEF': ' '.join(chip.get('pdk', chip.get('option', 'pdk'), 'aprtech', 'openroad', '5M1LI', 'unithd', 'lef')),
        'SC_LEF': ' '.join(chip.get('library', 'sky130hd', 'model', 'layout', 'lef', '5M1LI')),
        # TODO: Add an 'objects' directory in the task dirs? Use root dir for now.
        'OBJECTS_DIR': os.path.abspath(os.path.join(chip.get('option', 'builddir'), chip.get('design'), chip.get('option', 'jobname'))),
        'REPORTS_DIR': os.path.abspath(os.path.join(chip.get('option', 'builddir'), chip.get('design'), chip.get('option', 'jobname'))),
        'RESULTS_DIR': os.path.abspath(os.path.join(chip.get('option', 'builddir'), chip.get('design'), chip.get('option', 'jobname'))),
        'DONT_USE_LIBS': ' '.join(chip.get('library', 'sky130hd', 'model', 'timing', 'nldm', 'typical')),
        'DONT_USE_SC_LIB': ' '.join(chip.get('library', 'sky130hd', 'model', 'timing', 'nldm', 'typical')),
        # TODO: Run Python script to create these libs during import step.
        #'DONT_USE_LIBS': os.path.abspath('NangateOpenCellLibrary_typical.lib'),
        #'DONT_USE_SC_LIB': os.path.abspath('NangateOpenCellLibrary_typical.lib'),
        # Project-specific
        # TODO: Set areas from chip.get die/corearea, align to placement sites
        'DIE_AREA': '0 0 300 300',
        'CORE_AREA': '10 10 290 290',
        'DESIGN_NAME': chip.get('design'),
        'VERILOG_FILES': ' '.join(chip.get('input', 'verilog')),
        'SDC_FILE': ' '.join(chip.get('input', 'sdc')),
    }
    for k in chip.getkeys('flowgraph', 'orflow'):
        for key, val in env_vars.items():
            chip.set('tool', 'openroad', 'env', k, '0', key, val)


#########################
if __name__ == "__main__":
    chip = make_docs()
