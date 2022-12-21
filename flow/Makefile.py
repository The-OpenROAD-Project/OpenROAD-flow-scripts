import argparse
import glob
import os
import re
import shutil
import sys

import siliconcompiler

mydir = os.path.dirname(__file__)
scdir = os.path.join(mydir, 'scripts', 'sc')
sys.path.append(os.path.join(scdir, 'util'))
import parse_config_mk

def main():
    '''
    SiliconCompiler-based implementation of the OpenROAD build flow.

    This script mimics the Makefile-based build flow, running a series of TCL scripts and
    minor pre/post-processing based on platform and design parameters defined in 'config.mk' files.

    This script orchestrates the process of parsing config files, configuring a siliconcompiler.Chip
    object, and running the OpenROAD flow scripts.
    The 'siliconcompiler' Python module must be installed for this script to work:

        pip3 install siliconcompiler

    To build a design, run this file with the -DESIGN_CONFIG parameter set to
    the desired 'config.mk' file. Example:

        export SCPATH=./scripts/sc
        python Makefile.py -DESIGN_CONFIG=./designs/nangate45/gcd/config.mk

    Results and artifacts will be stored under 'build/[design]/', and the final GDS can be viewed with:

        sc-show -design [design]

    The following modules implement helper functions for this process, all under the `scripts/sc` dir:

    * `flows/orflow.py`:              Define the tasks which make up the flow (syn->floorplan->...)
    * `targets/[platform]_orflow.py`: Parse config.mk files, and set default values in the Chip object.
    ** `util/parse_*.py`:             Helper functions to parse platform/design config.mk fragments.
    * `tools/openroad/sc_apr.tcl`:    Wrapper TCL script to handle task-specific pre/post-processing.
    '''

    parser = argparse.ArgumentParser(description='Run OR flow through SiliconCompiler.')
    parser.add_argument('-DESIGN_CONFIG', required=True, help='Path to config.mk file configuring design')
    args = vars(parser.parse_args())

    # Parse values out of provided "config.mk" file
    config = parse_config_mk.parse(args['DESIGN_CONFIG'])
    # We'll use 'design' for finding the config.mk file in the target setup method, and
    # there is inconsistency between whether that corresponds to 'DESIGN_NAME' or 'DESIGN_NICKNAME'.
    # So, set design name based on file path.
    design_name_match = re.search(f'\/[a-zA-Z0-9_]+\/config.mk', args['DESIGN_CONFIG']).group(0)
    design = design_name_match[1:-len('/config.mk')]
    platform = config['PLATFORM']

    # Create a Chip object.
    chip = siliconcompiler.Chip(design)
    chip.set('option', 'scpath', scdir)
    chip.set('option', 'jobname', f'{design}_{platform}')

    # Load PDK, flow, and libs.
    if platform == 'nangate45':
        chip.load_target('nangate45_orflow')
    elif platform == 'sky130hd':
        chip.load_target('sky130hd_orflow')
    elif platform == 'sky130hs':
        chip.load_target('sky130hs_orflow')
    elif platform == 'asap7':
        chip.load_target('asap7_orflow')

    # Set KLayout export options.
    tool = 'klayout'
    step = 'or_export'
    if 'FILL_CONFIG' in chip.getkeys('tool', tool, 'env', step, '0'):
        fill_cfg = chip.get('tool', tool, 'env', step, '0', 'FILL_CONFIG')
    else:
        fill_cfg = ''
    if 'SEAL_GDS' in chip.getkeys('tool', tool, 'env', step, '0'):
        seal_gds = chip.get('tool', tool, 'env', step, '0', 'SEAL_GDS')
    else:
        seal_gds = ''
    gdsoas_in = ' '.join([os.path.abspath(gdsf) for gdsf in chip.get('tool', tool, 'env', step, '0', 'GDS_FILES').split()])
    out_file = os.path.join('outputs', f'{chip.get("design")}.{chip.get("tool", tool, "env", step, "0", "STREAM_SYSTEM_EXT")}')
    techf = '../../klayout.lyt' # TODO: objects_dir is currently top-level build root dir.
    layermap = chip.get('tool', tool, 'env', step, '0', 'GDS_LAYER_MAP')
    klayout_options = ['-zz',
                       '-rd', f'design_name={chip.get("design")}',
                       '-rd', 'in_def=inputs/6_final.def',
                       '-rd', f'in_files="{gdsoas_in}"',
                       '-rd', f'config_file={fill_cfg}',
                       '-rd', f'seal_file={seal_gds}',
                       '-rd', f'out_file={out_file}',
                       '-rd', f'tech_file={techf}',
                       '-rd', f'layer_map={layermap}',
                       '-rm']
    chip.set('tool', tool, 'option', step, '0', klayout_options)

    # For testing
    # TODO: put in run logic
    #chip.write_manifest(f'{design}.json')

    # Setup input/output file paths for individual tasks.
    WORKDIR_NAME = 'or_work'
    flow = chip.get('option', 'flow')
    for step in chip.getkeys('flowgraph', flow):
        for index in chip.getkeys('flowgraph', flow, step):
            tool = chip.get('flowgraph', flow, step, index, 'tool')
            if not tool in ['openroad', 'yosys', 'klayout']:
                continue
            taskdir = chip._getworkdir(step=step)
            chip.set('tool', tool, 'env', step, '0', 'RESULTS_DIR', os.path.join(taskdir, WORKDIR_NAME))
            # TODO: decide what to do about objects directory.

    # Build the design.
    chip.run()

    # Print results summary.
    chip.summary()

    # Symlink 'or_export/' task directory to 'export/' for sc-show viewing.
    or_export_dir = chip._getworkdir(step = 'or_export')[:-2]
    export_dir = or_export_dir.replace('or_export', 'export')
    os.symlink(or_export_dir, export_dir)

if __name__ == '__main__':
    # Usage: python Makefile.py -DESIGN_CONFIG=designs/[platform]/[design]/config.mk
    main()
