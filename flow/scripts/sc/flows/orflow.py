import os
import siliconcompiler
import re

openroad_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', '..'))

def make_docs():
    # TODO: Docs

    chip = siliconcompiler.Chip('<topmodule>')
    chip.set('option', 'flow', 'orflow')
    setup(chip)

    return chip

###########################################################################
# Flowgraph Setup
############################################################################
def setup(chip, flowname='orflow'):
    '''
    Setup function for 'orflow' implementation of the OpenROAD-flow-scripts build process.

    Args:
        chip (object): SC Chip object

    TODO: Fully support all environment variables used by the scripts
    '''

    # Set mandatory mode
    chip.set('option', 'mode', 'asic')

    # Set showtools for sc-show
    chip.set('option', 'showtool', 'def', 'klayout')
    chip.set('option', 'showtool', 'gds', 'klayout')

    # Setup empty 'import' stage with a single-node OpenROAD task to run 'run_all.tcl'
    # TODO: Use the 'import' step to parse config.mk file env vars.
    # TODO: Split up individual TCL scripts into sc tasks?
    flow = 'orflow'
    flowpipe = {
        'import': ['nop', ''],
        'syn': ['openroad', 'yosys.tcl'], # (synthesis is done via OpenROAD TCL that calls yosys)
        'init_floorplan': ['openroad', 'floorplan.tcl'],
        'io_place_rand': ['openroad', 'io_placement_random.tcl'],
        'tdms_place': ['openroad', 'tdms_place.tcl'],
        'macro_place': ['openroad', 'macro_place.tcl'],
        'tapcell': ['openroad', 'tapcell.tcl'],
        'pdn': ['openroad', 'pdn.tcl'],
        'gp_skip_io': ['openroad', 'global_place_skip_io.tcl'],
        'io_place': ['openroad', 'io_placement.tcl'],
        'global_place': ['openroad', 'global_place.tcl'],
        'resize': ['openroad', 'resize.tcl'],
        'detail_place': ['openroad', 'detail_place.tcl'],
        'clock_tree_syn': ['openroad', 'cts.tcl'],
        'fillcells': ['openroad', 'fillcell.tcl'],
        'global_route': ['openroad', 'global_route.tcl'],
        'detail_route': ['openroad', 'detail_route.tcl'],
        'final_report': ['openroad', 'final_report.tcl'],
        # Like yosys, KLayout GDS-streaming script is run through an OpenROAD tcl script
        'export': ['openroad', 'klayout.tcl'],
    }
    last_step = ''
    for k,v in flowpipe.items():
        chip.node(flow, k, v[0])
        if last_step:
            chip.edge(flow, last_step, k)
        if v[1]:
            chip.set('tool', v[0], 'script', k, '0',
                     os.path.abspath(os.path.join(openroad_dir, 'flow', 'scripts', v[1])))
            chip.set('tool', v[0], 'refdir', k, '0', os.path.join('tools', v[0]))
        last_step = k

    # TODO: Place these in a target file for nangate45/orfs, if it's too verbose/PDK-specific?
    # TODO: Add an 'objects' directory in the task dirs? Use 'outputs/' for now.
    env_vars = {
        # Defaults
        'SCRIPTS_DIR': os.path.join(openroad_dir, 'flow', 'scripts'),
        'UTILS_DIR': os.path.join(openroad_dir, 'flow', 'util'),
        'PLATFORM_DIR': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45'),
        # TODO: Many of these options could be driven by the schema once the poc is functional
        'GDS_FILES': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45', 'gds', 'NangateOpenCellLibrary.gds'),
        'GDSOAS_FILES': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45', 'gds', 'NangateOpenCellLibrary.gds'),
        'WRAPPED_GDSOAS': '',
        'GDS_LAYER_MAP': '',
        'STREAM_SYSTEM_EXT': 'gds',
        'TAPCELL_TCL': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45', 'tapcell.tcl'),
        'FASTROUTE_TCL': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45', 'fastroute.tcl'),
        'CLKGATE_MAP_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45', 'cells_clkgate.v'),
        'LATCH_MAP_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45', 'cells_latch.v'),
        'PDN_TCL': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45', 'grid_strategy-M1-M4-M7.tcl'),
        'KLAYOUT_LVS_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45', 'lvs', 'FreePDK45.lylvs'),
        'KLAYOUT_DRC_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45', 'drc', 'FreePDK45.lydrc'),
        'PLATFORM': 'nangate45',
        'SYNTH_ARGS': '-flatten',
        'ABC_DRIVER_CELL': 'BUF_X1',
        'ABC_LOAD_IN_FF': '3.898',
        'ABC_AREA': '1',
        'DPO_MAX_DISPLACEMENT': '5 1',
        'PLACE_SITE': 'FreePDK45_38x28_10R_NP_162NW_34O',
        'TIEHI_CELL_AND_PORT': 'LOGIC1_X1 Z',
        'TIELO_CELL_AND_PORT': 'LOGIC0_X1 Z',
        'MIN_BUF_CELL_AND_PORTS': 'BUF_X1 A Z',
        'FILL_CELLS': 'FILLCELL_X1 FILLCELL_X2 FILLCELL_X4 FILLCELL_X8 FILLCELL_X16 FILLCELL_X32',
        'DONT_USE_CELLS': 'TAPCELL_X1 FILLCELL_X1 AOI211_X1 OAI211_X1',
        'CTS_BUF_CELL': 'BUF_X4',
        'FLOW_VARIANT': 'base',
        'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': '0',
        'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': '0',
        'RESYNTH_AREA_RECOVER': '0',
        'RESYNTH_TIMING_RECOVER': '0',
        'SYNTH_HIERARCHICAL': '0',
        'GPL_ROUTABILITY_DRIVEN': '1',
        'GPL_TIMING_DRIVEN': '1',
        'MIN_ROUTING_LAYER': 'metal2',
        'IO_PLACER_V': 'metal2',
        'IO_PLACER_H': 'metal3',
        'WIRE_RC_LAYER': 'metal3',
        'MAX_ROUTING_LAYER': 'metal10',
        'PLACE_PINS_ARGS': '',
        'PLACE_DENSITY': '0.30',
        'NUM_CORES': '4', # TODO: Use nproc
        'LIB_FILES': ' '.join(chip.get('library', 'nangate45', 'model', 'timing', 'nldm', 'typical')),
        # TODO: chip.get stackup, libtype
        'TECH_LEF': ' '.join(chip.get('pdk', chip.get('option', 'pdk'), 'aprtech', 'openroad', '10M', '10t', 'lef')),
        'SC_LEF': ' '.join(chip.get('library', 'nangate45', 'model', 'layout', 'lef', '10M')),
        # TODO: Add an 'objects' directory in the task dirs? Use root dir for now.
        'OBJECTS_DIR': os.path.abspath(os.path.join(chip.get('option', 'builddir'), chip.get('design'), chip.get('option', 'jobname'))),
        'REPORTS_DIR': os.path.abspath(os.path.join(chip.get('option', 'builddir'), chip.get('design'), chip.get('option', 'jobname'))),
        'RESULTS_DIR': os.path.abspath(os.path.join(chip.get('option', 'builddir'), chip.get('design'), chip.get('option', 'jobname'))),
        'DONT_USE_LIBS': ' '.join(chip.get('library', 'nangate45', 'model', 'timing', 'nldm', 'typical')),
        'DONT_USE_SC_LIB': ' '.join(chip.get('library', 'nangate45', 'model', 'timing', 'nldm', 'typical')),
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
    for k, v in flowpipe.items():
        for key, val in env_vars.items():
            chip.set('tool', 'openroad', 'env', k, '0', key, val)

    # Set default goal
    for step in chip.getkeys('flowgraph', flow):
        chip.set('flowgraph', flow, step, '0', 'goal', 'errors', 0)
