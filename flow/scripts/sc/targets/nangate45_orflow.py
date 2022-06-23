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
    process = 'freepdk45'
    stackup = '10M'
    libtype = '10t'
    libname = 'nangate45'
    chip.set('option', 'flow', 'orflow')
    chip.set('option', 'pdk', process)
    chip.set('asic', 'logiclib', libname)

    # Set project-specific values
    chip.set('asic', 'stackup', stackup)
    chip.set('asic', 'delaymodel', 'nldm')
    chip.set('asic', 'minlayer', "metal2")
    chip.set('asic', 'maxlayer', "metal10")
    chip.set('asic', 'maxfanout', 64)
    chip.set('asic', 'maxlength', 1000)
    chip.set('asic', 'maxslew', 0.2e-9)
    chip.set('asic', 'maxcap', 0.2e-12)
    chip.set('asic', 'rclayer', 'clk', "metal5")
    chip.set('asic', 'rclayer', 'data',"metal3")
    chip.set('asic', 'hpinlayer', "metal3")
    chip.set('asic', 'vpinlayer', "metal2")
    chip.set('asic', 'density', 10)
    chip.set('asic', 'aspectratio', 1)
    chip.set('asic', 'coremargin', 1.9)
    # Set timing corners.
    corner = 'typical'
    chip.set('constraint','worst','libcorner', corner)
    chip.set('constraint','worst','pexcorner', corner)
    chip.set('constraint','worst','mode', 'func')
    chip.set('constraint','worst','check', ['setup','hold'])

    # Set default environment variables for the OpenROAD flow (nangate45 platform).
    platform_dir = os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45')
    job_dir = os.path.join(chip.get('option', 'builddir'),
                           chip.get('design'),
                           chip.get('option', 'jobname'))
    env_vars = {
        'SCRIPTS_DIR': os.path.join(openroad_dir, 'flow', 'scripts'),
        'UTILS_DIR': os.path.join(openroad_dir, 'flow', 'util'),
        'PLATFORM_DIR': platform_dir,
        'GDS_FILES': os.path.join(platform_dir, 'gds', 'NangateOpenCellLibrary.gds'),
        'GDSOAS_FILES': os.path.join(platform_dir, 'gds', 'NangateOpenCellLibrary.gds'),
        'WRAPPED_GDSOAS': '',
        'GDS_LAYER_MAP': '',
        'STREAM_SYSTEM_EXT': 'gds',
        'CL_FILE': os.path.join(platform_dir, 'cdl', 'NangateOpenCellLibrary.cdl'),
        'TEMPLATE_PGA_CFG': os.path.join(platform_dir, 'template_pga.cfg'),
        'RCX_RULES': os.path.join(platform_dir, 'rcx_patterns.rules'),
        'TAPCELL_TCL': os.path.join(platform_dir, 'tapcell.tcl'),
        'FASTROUTE_TCL': os.path.join(platform_dir, 'fastroute.tcl'),
        'CLKGATE_MAP_FILE': os.path.join(platform_dir, 'cells_clkgate.v'),
        'LATCH_MAP_FILE': os.path.join(platform_dir, 'cells_latch.v'),
        'ADDER_MAP_FILE': os.path.join(platform_dir, 'cells_adders.v'),
        'PDN_TCL': os.path.join(platform_dir, 'grid_strategy-M1-M4-M7.tcl'),
        'KLAYOUT_LVS_FILE': os.path.join(platform_dir, 'lvs', 'FreePDK45.lylvs'),
        'KLAYOUT_DRC_FILE': os.path.join(platform_dir, 'drc', 'FreePDK45.lydrc'),
        'ABC_DRIVER_CELL': ' '.join(chip.get('library', libname, 'asic', 'cells', 'driver')),
        'PLACE_SITE': chip.getkeys('library', libname, 'asic', 'footprint')[0],
        'TIEHI_CELL_AND_PORT': chip.get('library', libname, 'asic', 'cells', 'tie')[0],
        'TIELO_CELL_AND_PORT': chip.get('library', libname, 'asic', 'cells', 'tie')[1],
        'MIN_BUF_CELL_AND_PORTS': ' '.join(chip.get('library', libname, 'asic', 'cells', 'buf')),
        'MACRO_PLACE_HALO': ' '.join(chip.get('pdk', process, 'var', 'openroad', stackup, 'macro_place_halo')[0]),
        'MACRO_PLACE_CHANNEL': ' '.join(chip.get('pdk', process, 'var', 'openroad', stackup, 'macro_place_channel')[0]),
        'FILL_CELLS': ' '.join(chip.get('library', libname, 'asic', 'cells', 'filler')),
        'DONT_USE_CELLS': ' '.join(chip.get('library', libname, 'asic', 'cells', 'ignore')),
        'CTS_BUF_CELL': ' '.join(chip.get('library', libname, 'asic', 'cells', 'clkbuf')),
        'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': chip.get('pdk', process, 'var', 'openroad', stackup, 'pad_global_place')[0],
        'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': chip.get('pdk', process, 'var', 'openroad', stackup, 'pad_detail_place')[0],
        'MIN_ROUTING_LAYER': chip.get('asic', 'minlayer'),
        'IO_PLACER_V': chip.get('asic', 'vpinlayer'),
        'IO_PLACER_H': chip.get('asic', 'hpinlayer'),
        'WIRE_RC_LAYER': chip.get('asic', 'rclayer', 'data'),
        'MAX_ROUTING_LAYER': chip.get('asic', 'maxlayer'),
        'PLACE_DENSITY': chip.get('pdk', process, 'var', 'openroad', stackup, 'place_density')[0],
        'LIB_FILES': ' '.join(chip.get('library', libname, 'model', 'timing', 'nldm', 'typical')),
        'TECH_LEF': ' '.join(chip.get('pdk', process, 'aprtech', 'openroad', stackup, libtype, 'lef')),
        'SC_LEF': ' '.join(chip.get('library', libname, 'model', 'layout', 'lef', stackup)),
        'DONT_USE_LIBS': ' '.join(chip.get('library', libname, 'model', 'timing', 'nldm', 'typical')),
        'DONT_USE_SC_LIB': ' '.join(chip.get('library', libname, 'model', 'timing', 'nldm', 'typical')),

        'PLATFORM': libname,
        'PROCESS': '45',
        'SYNTH_ARGS': '-flatten',
        'ABC_LOAD_IN_FF': '3.898',
        'ABC_AREA': '1',
        'DPO_MAX_DISPLACEMENT': '5 1',
        'FLOW_VARIANT': 'base',
        'RESYNTH_AREA_RECOVER': '0',
        'RESYNTH_TIMING_RECOVER': '0',
        'SYNTH_HIERARCHICAL': '0',
        'GPL_ROUTABILITY_DRIVEN': '1',
        'GPL_TIMING_DRIVEN': '1',
        'PLACE_PINS_ARGS': '',
        'GDS_ALLOW_EMPTY': 'fakeram.*',
        'NUM_CORES': '4', # TODO: Use nproc
        'DIE_AREA': '0 0 300 300',
        'CORE_AREA': '10 10 290 290',

        # Project-specific
        'DESIGN_NAME': chip.get('design'),
        'VERILOG_FILES': ' '.join(chip.get('input', 'verilog')),
        'SDC_FILE': ' '.join(chip.get('input', 'sdc')),

        # Default location for generated files: job root directory. May be overridden later.
        'OBJECTS_DIR': os.path.abspath(job_dir),
        'REPORTS_DIR': os.path.abspath(job_dir),
        'RESULTS_DIR': os.path.abspath(job_dir),
    }

    # Set default environment variables for every step in the flow.
    for k in chip.getkeys('flowgraph', 'orflow'):
        for key, val in env_vars.items():
            chip.set('tool', 'openroad', 'env', k, '0', key, val)


#########################
if __name__ == "__main__":
    chip = make_docs()
