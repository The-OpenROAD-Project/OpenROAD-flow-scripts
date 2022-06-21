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
    chip.set('option', 'target', 'nangate45_orflow')

    # Load PDK, flow, and libs.
    chip.load_pdk('freepdk45_orflow')
    chip.load_flow('orflow')
    chip.load_lib('nangate45_orflow')

    # Set Chip object to use the loaded flow, pdk, lib.
    chip.set('option', 'flow', 'orflow')
    chip.set('option', 'pdk', 'freepdk45')
    chip.set('asic', 'logiclib', 'nangate45')

    # Set project-specific values
    chip.set('asic', 'stackup', '10M')
    chip.set('asic', 'delaymodel', 'nldm')
    chip.set('asic', 'minlayer', "m1")
    chip.set('asic', 'maxlayer', "m10")
    chip.set('asic', 'maxfanout', 64)
    chip.set('asic', 'maxlength', 1000)
    chip.set('asic', 'maxslew', 0.2e-9)
    chip.set('asic', 'maxcap', 0.2e-12)
    chip.set('asic', 'rclayer', 'clk', "m5")
    chip.set('asic', 'rclayer', 'data',"m3")
    chip.set('asic', 'hpinlayer', "m3")
    chip.set('asic', 'vpinlayer', "m2")
    chip.set('asic', 'density', 10)
    chip.set('asic', 'aspectratio', 1)
    chip.set('asic', 'coremargin', 1.9)
    # Set timing corners.
    corner = 'typical'
    chip.set('constraint','worst','libcorner', corner)
    chip.set('constraint','worst','pexcorner', corner)
    chip.set('constraint','worst','mode', 'func')
    chip.set('constraint','worst','check', ['setup','hold'])

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
        'MACRO_PLACE_HALO': '22.4 15.12',
        'MACRO_PLACE_CHANNEL': '18.8 19.95',
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
        'GDS_ALLOW_EMPTY': 'fakeram.*',
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
    for k in chip.getkeys('flowgraph', 'orflow'):
        for key, val in env_vars.items():
            chip.set('tool', 'openroad', 'env', k, '0', key, val)


#########################
if __name__ == "__main__":
    chip = make_docs()
