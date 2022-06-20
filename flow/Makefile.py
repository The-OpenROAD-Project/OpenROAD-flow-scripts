import argparse
import os
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
    design = config['DESIGN_NAME']

    # Perform variable substitution where required.
    repls = {}
    # Set DESIGN_NICKNAME = DESIGN if not already set.
    if not 'DESIGN_NICKNAME' in config:
        repls['DESIGN_NICKNAME'] = design
    # Set PLATFORM_DIR if not already set.
    if not 'PLATFORM_DIR' in config:
        repls['PLATFORM_DIR'] = os.path.abspath(os.path.join(mydir, 'platforms', config['PLATFORM']))

    if repls:
        # Set replacement value in os.environ so that the Makefile parser uses it.
        for k, v in repls.items():
            os.environ[k] = v
        # Re-parse the Makefile
        config = parse_config_mk.parse(args['DESIGN_CONFIG'])
        # Update 'config' dictionary with the substitutions used to generate it.
        for k, v in repls.items():
            config[k] = v

    chip = siliconcompiler.Chip(design)
    chip.set('option', 'scpath', scdir)

    # Extract sources, and convert to absolute paths b/c sc commands run in a different build dir.
    if 'SDC_FILE' in config.keys():
        sdc_in = os.path.abspath(config.pop('SDC_FILE'))
        chip.set('input', 'sdc', sdc_in)
    if 'VERILOG_FILES' in config.keys():
        v_in_list = [os.path.abspath(vf) for vf in config.pop('VERILOG_FILES').split()]
        chip.set('input', 'verilog', v_in_list)
    if 'VERILOG_INCLUDE_DIRS' in config.keys():
        v_inc_dirs = [os.path.abspath(vf) for vf in config['VERILOG_INCLUDE_DIRS'].split()]
        config['VERILOG_INCLUDE_DIRS'] = ' '.join(v_inc_dirs)
    # TODO: Set lef/libs in schema
    if 'ADDITIONAL_LEFS' in config.keys():
        lef_in_list = [os.path.abspath(lf) for lf in config['ADDITIONAL_LEFS'].split()]
        config['ADDITIONAL_LEFS'] = ' '.join(lef_in_list)
    if 'ADDITIONAL_LIBS' in config.keys():
        lib_in_list = [os.path.abspath(lf) for lf in config['ADDITIONAL_LIBS'].split()]
        config['ADDITIONAL_LIBS'] = ' '.join(lib_in_list)
    if 'ADDITIONAL_GDS_FILES' in config.keys():
        gds_in_list = [os.path.abspath(gf) for gf in config['ADDITIONAL_GDS_FILES'].split()]
        config['ADDITIONAL_GDS_FILES'] = ' '.join(gds_in_list)
    if 'MACRO_PLACEMENT' in config.keys():
        config['MACRO_PLACEMENT'] = os.path.abspath(config['MACRO_PLACEMENT'])

    # Load PDK, flow, and libs.
    platform = config['PLATFORM']
    if platform == 'nangate45':
        chip.load_target('nangate45_orflow')
    elif platform == 'sky130hd':
        chip.load_target('sky130hd_orflow')

    chip.logger.debug(config)

    # For testing
    # TODO: put in run logic
    #chip.write_manifest(f'{design}.json')

    # Setup input/output file paths for individual tasks.
    WORKDIR_NAME = 'or_work'
    flow = chip.get('option', 'flow')
    for step in chip.getkeys('flowgraph', flow):
        for index in chip.getkeys('flowgraph', flow, step):
            tool = chip.get('flowgraph', flow, step, index, 'tool')
            if tool != 'openroad':
                continue
            taskdir = chip._getworkdir(step=step)
            chip.set('tool', 'openroad', 'env', step, '0', 'RESULTS_DIR', os.path.join(taskdir, WORKDIR_NAME))
            # TODO: decide what to do about objects directory.

    # Build the design.
    chip.run()

    chip.summary()                                # print results summary
    chip.show()                                   # show layout file

if __name__ == '__main__':
    main()
