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
    config = parse_config_mk.parse(args['DESIGN_CONFIG'])
    design = config['DESIGN_NAME']

    print(config)

    chip = siliconcompiler.Chip(design)
    chip.set('option', 'scpath', scdir)

    # TODO: should we actually fill out stuff in the schema, or just pass
    # everything through?
    for key, val in config.items():
        chip.set('option', 'env', key, val)

    # TODO: should we create OR specific targets that then load associated PDKs/libs?
    #platform = config['PLATFORM']
    #chip.load_target(f'{platform}_or')

    # For testing
    # TODO: put in run logic
    chip.write_manifest(f'{design}.json')

if __name__ == '__main__':
    main()
