import argparse
import os
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
    # TODO: filled this out based on ./designs/nangate45/gcd/config.mk
    # There are more possible variables and likely more complex possible values
    # (such as multiple Verilog files)
    config = parse_config_mk.parse(args['DESIGN_CONFIG'])
    design = config['DESIGN_NAME']
    verilog_path = config['VERILOG_FILES']
    sdc_path = config['SDC_FILE']
    core_left, core_bottom, core_right, core_top = config['CORE_AREA'].split(' ')
    die_left, die_bottom, die_right, die_top = config['DIE_AREA'].split(' ')
    platform = config['PLATFORM']

    # Currently unused: ADDER_MAP_FILE (blank for gcd), ABC_AREA (not sure meaning?)
    print(config)

    chip = siliconcompiler.Chip(design)
    chip.set('option', 'scpath', scdir)

    chip.set('input', 'verilog', verilog_path)
    chip.set('input', 'sdc', sdc_path)
    chip.set('asic', 'diearea', [(die_left, die_bottom), (die_right, die_top)])
    chip.set('asic', 'corearea', [(core_left, core_bottom), (core_right, core_top)])

    # TODO: create OR specific targets
    #chip.load_target(f'{platform}_or')

    # For testing, TODO: put in run logic
    chip.write_manifest(f'{design}.json')

if __name__ == '__main__':
    main()
