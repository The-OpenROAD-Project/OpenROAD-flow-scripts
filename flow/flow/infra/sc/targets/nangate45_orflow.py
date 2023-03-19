import os
import siliconcompiler
import sys

openroad_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', '..'))

mydir = os.path.dirname(__file__)
scdir = os.path.join(mydir, '..')
sys.path.append(os.path.join(scdir, 'util'))
import parse_target_config

def make_docs():
    # TODO: Docs
    chip = siliconcompiler.Chip('<design>')
    setup(chip)
    return chip

####################################################
# PDK and Flow Setup
####################################################
def setup(chip):
    # Collect basic values.
    design = chip.get('design')
    platform = 'nangate45'

    # Set the target name.
    chip.set('option', 'target', 'nangate45_orflow')

    # Load flow graph and PDK/liberty manifest values.
    chip.load_flow('orflow')
    chip.set('option', 'flow', 'orflow')

    # Set PDK/liberty values which cannot be inferred from platform config.mk
    # (stackup, libtype, naming consistency, etc)
    process = 'freepdk45'
    stackup = '10M'
    libtype = '10t'
    chip.set('option', 'pdk', process)
    chip.set('asic', 'libarch', libtype)
    chip.set('asic', 'logiclib', platform)
    chip.set('asic', 'stackup', stackup)
    chip.set('asic', 'delaymodel', 'nldm')
    foundry = 'virtual'
    wafersize = 300
    chip.set('pdk', process, 'foundry', foundry)
    chip.set('pdk', process, 'stackup', stackup)
    chip.set('pdk', process, 'wafersize', wafersize)

    # Load design and platform config values.
    chip = parse_target_config.parse(chip, platform)

    # Set some default environment variables for the OpenROAD flow (nangate45 platform).
    platform_dir = os.path.join(openroad_dir, 'flow', 'platforms', 'nangate45')
    job_dir = os.path.join(chip.get('option', 'builddir'),
                           chip.get('design'),
                           chip.get('option', 'jobname'))
    env_vars = {
        'SCRIPTS_DIR': os.path.join(openroad_dir, 'flow', 'scripts'),
        'UTILS_DIR': os.path.join(openroad_dir, 'flow', 'util'),
        'PLATFORM_DIR': platform_dir,

        # Default values not set in platform config.mk
        'STREAM_SYSTEM_EXT': 'gds',
        'SYNTH_ARGS': '-flatten',
        'PLACE_PINS_ARGS': '',
        'GPL_ROUTABILITY_DRIVEN': '1',
        'GPL_TIMING_DRIVEN': '1',
        'GDS_LAYER_MAP': '',
        'ABC_AREA': '0',
        'NUM_CORES': f'{len(os.sched_getaffinity(0))}',

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

    # Set default environment variables for every step in the flow.
    for step in chip.getkeys('flowgraph', 'orflow'):
        index = '0'
        for key, val in env_vars.items():
            tool = chip.get('flowgraph', 'orflow', step, index, 'tool')
            chip.set('tool', tool, 'env', step, index, key, val)


#########################
if __name__ == "__main__":
    chip = make_docs()
