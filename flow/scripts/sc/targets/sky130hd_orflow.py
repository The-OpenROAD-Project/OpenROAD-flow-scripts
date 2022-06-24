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
    process = 'skywater130'
    stackup = '5M1LI'
    libname = 'sky130hd'
    libtype = 'unithd'
    chip.set('option', 'flow', 'orflow')
    chip.set('option', 'pdk', process)
    chip.set('asic', 'logiclib', libname)

    chip.set('asic', 'delaymodel', 'nldm')
    chip.set('asic', 'stackup', stackup)
    chip.set('asic', 'minlayer', "met1")
    chip.set('asic', 'maxlayer', "met5")
    chip.set('asic', 'maxfanout', 5) # TODO: fix this
    chip.set('asic', 'maxlength', 21000)
    chip.set('asic', 'maxslew', 1.5e-9)
    chip.set('asic', 'maxcap', .1532e-12)
    chip.set('asic', 'rclayer', 'clk', 'met5')
    chip.set('asic', 'rclayer', 'data', 'met3')
    chip.set('asic', 'hpinlayer', "met3")
    chip.set('asic', 'vpinlayer', "met2")
    chip.set('asic', 'density', 10)
    chip.set('asic', 'aspectratio', 1)
    chip.set('asic', 'coremargin', 62.56)
    corner = 'typical'
    chip.set('constraint', 'worst', 'libcorner', corner)
    chip.set('constraint', 'worst', 'pexcorner', corner)
    chip.set('constraint', 'worst', 'mode', 'func')
    chip.add('constraint', 'worst', 'check', ['setup','hold'])

    # Set default environment variables for the OpenROAD flow (sky130hd platform).
    platform_dir = os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd')
    job_dir = os.path.join(chip.get('option', 'builddir'),
                           chip.get('design'),
                           chip.get('option', 'jobname'))
    env_vars = {
        # Defaults
        'SCRIPTS_DIR': os.path.join(openroad_dir, 'flow', 'scripts'),
        'UTILS_DIR': os.path.join(openroad_dir, 'flow', 'util'),
        'PLATFORM_DIR': platform_dir,
        # TODO: Many of these options could be driven by the schema once the poc is functional
        'GDS_FILES': os.path.join(platform_dir, 'gds', 'sky130_fd_sc_hd.gds'),
        'GDSOAS_FILES': os.path.join(platform_dir, 'gds', 'sky130_fd_sc_hd.gds'),
        'WRAPPED_GDSOAS': '',
        'GDS_LAYER_MAP': '',
        'STREAM_SYSTEM_EXT': 'gds',
        'FILL_CONFIG': os.path.join(platform_dir, 'fill.json'),
        'TEMPLATE_PGA_CFG': os.path.join(platform_dir, 'template_pga.cfg'),
        'RCX_RULES': os.path.join(platform_dir, 'rcx_patterns.rules'),
        'TAPCELL_TCL': os.path.join(platform_dir, 'tapcell.tcl'),
        'FASTROUTE_TCL': os.path.join(platform_dir, 'fastroute.tcl'),
        'CLKGATE_MAP_FILE': os.path.join(platform_dir, 'cells_clkgate_hd.v'),
        'LATCH_MAP_FILE': os.path.join(platform_dir, 'cells_latch_hd.v'),
        'ADDER_MAP_FILE': os.path.join(platform_dir, 'cells_adders_hd.v'),
        'PDN_TCL': os.path.join(platform_dir, 'pdn.tcl'),
        #'KLAYOUT_LVS_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'lvs', 'FreePDK45.lylvs'),
        #'KLAYOUT_DRC_FILE': os.path.join(openroad_dir, 'flow', 'platforms', 'sky130hd', 'drc', 'FreePDK45.lydrc'),
        'ABC_DRIVER_CELL': ' '.join(chip.get('library', libname, 'asic', 'cells', 'driver')),
        'PLACE_SITE': chip.get('library', libname, 'asic', 'libarch'),
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
        'WIRE_RC_LAYER': chip.get('asic', 'rclayer', 'data'),
        'MAX_ROUTING_LAYER': chip.get('asic', 'maxlayer'),
        'PLACE_DENSITY': chip.get('pdk', process, 'var', 'openroad', stackup, 'place_density')[0],
        'LIB_FILES': ' '.join(chip.get('library', libname, 'model', 'timing', 'nldm', 'typical')),
        'TECH_LEF': ' '.join(chip.get('pdk', process, 'aprtech', 'openroad', stackup, libtype, 'lef')),
        'SC_LEF': ' '.join(chip.get('library', libname, 'model', 'layout', 'lef', stackup)),
        'DONT_USE_LIBS': ' '.join(chip.get('library', libname, 'model', 'timing', 'nldm', 'typical')),
        'DONT_USE_SC_LIB': ' '.join(chip.get('library', libname, 'model', 'timing', 'nldm', 'typical')),
        'PLATFORM': libname,
        'PROCESS': '130',
        'SYNTH_ARGS': '-flatten',
        'ABC_LOAD_IN_FF': '5',
        'ABC_AREA': '1',
        'DPO_MAX_DISPLACEMENT': '5 1',
        'FLOW_VARIANT': 'base',
        'CELL_PAD_IN_SITES': '4',
        'RESYNTH_AREA_RECOVER': '0',
        'RESYNTH_TIMING_RECOVER': '0',
        'SYNTH_HIERARCHICAL': '0',
        'GPL_ROUTABILITY_DRIVEN': '1',
        'GPL_TIMING_DRIVEN': '1',
        'PLACE_PINS_ARGS': '',
        'SEAL_GDS': '',
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
    for k in chip.getkeys('flowgraph', 'orflow'):
        for key, val in env_vars.items():
            if k == 'or_yosys':
                chip.set('tool', 'yosys', 'env', k, '0', key, val)
            elif k == 'or_export':
                chip.set('tool', 'klayout', 'env', k, '0', key, val)
            else:
                chip.set('tool', 'openroad', 'env', k, '0', key, val)


#########################
if __name__ == "__main__":
    chip = make_docs()
