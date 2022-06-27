import os
import siliconcompiler

openroad_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', '..'))

def make_docs():
    # TODO: Docs
    chip = siliconcompiler.Chip('<design>')

####################################################
# PDK and Flow Setup
####################################################
def setup(chip):
    # Set the target name.
    chip.set('option', 'target', 'asap7_orflow')

    # Load PDK, flow, and libs.
    chip.load_pdk('asap7_orflow')
    chip.load_flow('orflow')
    chip.load_lib('asap7sc7p5t_orflow')

    # Set Chip object to use the loaded flow, pdk, lib.
    process = 'asap7'
    stackup = '10M'
    libtype = '7p5t'
    group = 'asap7sc7p5t'
    libname = f'{group}_rvt'
    chip.set('option', 'flow', 'orflow')
    chip.set('option', 'pdk', process)
    chip.set('asic', 'logiclib', libname)

    # Set project-specific values
    chip.set('asic', 'delaymodel', 'nldm')
    chip.set('asic', 'stackup', stackup)
    chip.set('asic', 'minlayer', "M2")
    chip.set('asic', 'maxlayer', "M7")
    chip.set('asic', 'maxfanout', 64)
    chip.set('asic', 'maxlength', 1000)
    chip.set('asic', 'maxslew', 0.2e-9)
    chip.set('asic', 'maxcap', 0.2e-12)
    chip.set('asic', 'rclayer', 'clk', "M5")
    chip.set('asic', 'rclayer', 'data',"M3")
    chip.set('asic', 'hpinlayer', "M4")
    chip.set('asic', 'vpinlayer', "M5")
    chip.set('asic', 'density', 10)
    chip.set('asic', 'aspectratio', 1)
    chip.set('asic', 'coremargin', 0.270)
    # Set timing corners.
    corner = 'BC'
    chip.set('constraint','worst','libcorner', corner)
    chip.set('constraint','worst','pexcorner', corner)
    chip.set('constraint','worst','mode', 'func')
    chip.set('constraint','worst','check', ['setup','hold'])

    # Set default environment variables for the OpenROAD flow (asap7 platform).
    platform_dir = os.path.join(openroad_dir, 'flow', 'platforms', 'asap7')
    job_dir = os.path.join(chip.get('option', 'builddir'),
                           chip.get('design'),
                           chip.get('option', 'jobname'))
    env_vars = {
        'SCRIPTS_DIR': os.path.join(openroad_dir, 'flow', 'scripts'),
        'UTILS_DIR': os.path.join(openroad_dir, 'flow', 'util'),
        'PLATFORM_DIR': platform_dir,
        'GDS_FILES': os.path.join(platform_dir, 'gds', 'asap7sc7p5t_27_R_1x_201211.gds'),
        'GDSOAS_FILES': os.path.join(platform_dir, 'gds', 'asap7sc7p5t_27_R_1x_201211.gds'),
        'WRAPPED_GDSOAS': '',
        'GDS_LAYER_MAP': '',
        'STREAM_SYSTEM_EXT': 'gds',
        'FILL_CONFIG': '',
        'MAKE_TRACKS': os.path.join(platform_dir, 'openRoad', 'make_tracks.tcl'),
        'SET-RC_TCL': os.path.join(platform_dir, 'setRC.tcl'),
        #'CDL_FILE': '',
        #'TEMPLATE_PGA_CFG': '',
        'RCX_RULES': os.path.join(platform_dir, 'rcx_patterns.rules'),
        'TAPCELL_TCL': os.path.join(platform_dir, 'openRoad', 'tapcell.tcl'),
        #'FASTROUTE_TCL': '',
        'CLKGATE_MAP_FILE': os.path.join(platform_dir, 'yoSys', 'cells_clkgate.v'),
        'LATCH_MAP_FILE': os.path.join(platform_dir, 'yoSys', 'cells_latch.v'),
        'ADDER_MAP_FILE': os.path.join(platform_dir, 'yoSys', 'cells_adders.v'),
        'BLACKBOX_V_FILE': os.path.join(platform_dir, 'yoSys', 'asap7sc7p5t.blackbox.v'),
        'BLACKBOX_MAP_TCL': os.path.join(platform_dir, 'yoSys', 'blackbox_map.tcl'),
        'PDN_TCL': os.path.join(platform_dir, 'openRoad', 'pdn', 'grid_strategy-M2-M5-M7.tcl'),
        'ABC_DRIVER_CELL': ' '.join(chip.get('library', libname, 'asic', 'cells', 'driver')),
        'PLACE_SITE': chip.getkeys('library', libname, 'asic', 'footprint')[0],
        'TIEHI_CELL_AND_PORT': chip.get('library', libname, 'asic', 'cells', 'tie')[0],
        'TIELO_CELL_AND_PORT': chip.get('library', libname, 'asic', 'cells', 'tie')[1],
        'MIN_BUF_CELL_AND_PORTS': ' '.join(chip.get('library', libname, 'asic', 'cells', 'buf')),
        'MACRO_PLACE_HALO': ' '.join(chip.get('pdk', process, 'var', 'openroad', stackup, 'macro_place_halo')),
        'MACRO_PLACE_CHANNEL': ' '.join(chip.get('pdk', process, 'var', 'openroad', stackup, 'macro_place_channel')),
        'FILL_CELLS': ' '.join(chip.get('library', libname, 'asic', 'cells', 'filler')),
        'DONT_USE_CELLS': ' '.join(chip.get('library', libname, 'asic', 'cells', 'ignore')),
        'CTS_BUF_CELL': ' '.join(chip.get('library', libname, 'asic', 'cells', 'clkbuf')),
        'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': chip.get('pdk', process, 'var', 'openroad', stackup, 'pad_global_place')[0],
        'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': chip.get('pdk', process, 'var', 'openroad', stackup, 'pad_detail_place')[0],
        'MIN_ROUTING_LAYER': chip.get('asic', 'minlayer'),
        'IO_PLACER_V': chip.get('asic', 'vpinlayer'),
        'IO_PLACER_H': chip.get('asic', 'hpinlayer'),
        'MAX_ROUTING_LAYER': chip.get('asic', 'maxlayer'),
        'PLACE_DENSITY': chip.get('pdk', process, 'var', 'openroad', stackup, 'place_density')[0],
        'TECH_LEF': ' '.join(chip.get('pdk', process, 'aprtech', 'openroad', stackup, libtype, 'lef')),
        'SC_LEF': ' '.join(chip.get('library', libname, 'model', 'layout', 'lef', stackup)),

        'PLATFORM': process,
        'PROCESS': '7',
        'BC_TEMPERATURE': '25C',
        'TC_TEMPERATURE': '0C',
        'WC_TEMPERATURE': '100C',
        'SYNTH_ARGS': '-flatten',
        'ABC_LOAD_IN_FF': '3.898',
        'ABC_AREA': '0',
        'DPO_MAX_DISPLACEMENT': '5 1',
        'FLOW_VARIANT': 'base',
        'RESYNTH_AREA_RECOVER': '0',
        'RESYNTH_TIMING_RECOVER': '0',
        'SYNTH_HIERARCHICAL': '0',
        'GPL_ROUTABILITY_DRIVEN': '1',
        'GPL_TIMING_DRIVEN': '1',
        'PLACE_PINS_ARGS': '',
        'SEAL_GDS': '',
        'CTS_BUF_DISTANCE': '60',
        'NUM_CORES': f'{len(os.sched_getaffinity(0))}',
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
        'SYNTH_STOP_MODULE_SCRIPT': os.path.join(job_dir, 'mark_hier_stop_modules.tcl'),
    }

    corners = {
        'BC': 'FF',
        'WC': 'SS',
        'TC': 'TT',
    }
    post = 'nldm_201020.lib'
    for corner, abrv in corners.items():
        env_vars[f'{corner}_LIB_FILES'] = ' '.join(chip.get('library', libname, 'model', 'timing', 'nldm', corner))
        env_vars[f'{corner}_DONT_USE_LIBS'] = ' '.join(chip.get('library', libname, 'model', 'timing', 'nldm', corner))

    # Set default environment variables for every step in the flow.
    for step in chip.getkeys('flowgraph', 'orflow'):
        index = '0'
        for key, val in env_vars.items():
            tool = chip.get('flowgraph', 'orflow', step, index, 'tool')
            chip.set('tool', tool, 'env', step, index, key, val)


#########################
if __name__ == "__main__":
    chip = make_docs()
