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
    gdsoas_in = ' '.join([chip.get('tool', tool, 'env', step, '0', 'GDS_FILES')])
    out_file = os.path.join('outputs', f'{chip.get("design")}.{chip.get("tool", tool, "env", step, "0", "STREAM_SYSTEM_EXT")}')
    techf = '../../klayout.lyt' # TODO: objects_dir is currently top-level build root dir.
    layermap = chip.get('tool', tool, 'env', step, '0', 'GDS_LAYER_MAP')
    klayout_options = ['-zz',
                       '-rd', f'design_name={chip.get("design")}',
                       '-rd', 'in_def=inputs/6_final.def',
                       '-rd', f'in_files={gdsoas_in}',
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
    main()
