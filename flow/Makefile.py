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

    # Load PDK, flow, and libs.
    platform = config['PLATFORM']
    if platform == 'nangate45':
        chip.load_target('nangate45_orflow')
    elif platform == 'sky130hd':
        chip.load_target('sky130hd_orflow')

    print(config)

    # TODO: should we actually fill out stuff in the schema, or just pass
    # everything through?
    for step in chip.getkeys('tool', 'openroad', 'env'):
        for key, val in config.items():
            chip.set('tool', 'openroad', 'env', step, '0', key, val)

    # TODO: should we create OR specific targets that then load associated PDKs/libs?
    #platform = config['PLATFORM']
    #chip.load_target(f'{platform}_or')

    # For testing
    # TODO: put in run logic
    #chip.write_manifest(f'{design}.json')

    # Step 1: Import / Synthesis
    # TODO: Is there a better way to copy/rename files mid-flow?
    chip.set('option', 'steplist',
             ['import', 'syn'])
    chip.run()
    shutil.copy(os.path.join(jdir, '1_1_yosys.v'), os.path.join(jdir, '1_synth.v'))
    shutil.copy(chip.get('input', 'sdc')[0], os.path.join(jdir, '1_synth.sdc'))

    # ORFS pre-processing steps (Done after 'import' to ensure dir structure exists)
    jdir = os.path.join(chip.get('option', 'builddir'),
                        chip.get('design'),
                        chip.get('option', 'jobname'))
    process = chip.get('option', 'pdk')
    stackup = chip.get('pdk', process, 'stackup')[0]
    # KLayout tech LEF needs modifying. TODO: Also add equivalent of $ADDITIONAL_LEFS (macros)
    tool = 'klayout'
    base_lyt = chip.get('pdk', process, 'layermap', tool, 'def', 'gds', stackup)[0]
    base_lyp = chip.get('pdk', process, 'display', tool, stackup)[0]
    tlef = chip.get('library', platform, 'model', 'layout', 'lef', stackup)[0]
    shutil.copy(base_lyp, os.path.join(jdir, 'klayout.lyp'))
    with open(base_lyt, 'r') as rf:
        with open(os.path.join(jdir, 'klayout.lyt'), 'w') as wf:
            for l in rf.readlines():
                if not '<lef-files>' in l:
                    wf.write(l)
                else:
                    wf.write(f'   <lef-files>{tlef}</lef-files>\n')

    # Step 2: Floorplan
    chip.set('option', 'steplist',
             ['init_floorplan', 'io_place_rand', 'tdms_place', 'macro_place', 'tapcell', 'pdn'])
    chip.run()
    shutil.copy(os.path.join(jdir, '2_6_floorplan_pdn.odb'), os.path.join(jdir, '2_floorplan.odb'))

    # Step 3: Placement
    chip.set('option', 'steplist',
             ['gp_skip_io', 'io_place', 'global_place', 'resize', 'detail_place'])
    chip.run()
    shutil.copy(os.path.join(jdir, '3_5_place_dp.odb'), os.path.join(jdir, '3_place.odb'))
    shutil.copy(os.path.join(jdir, '2_floorplan.sdc'), os.path.join(jdir, '3_place.sdc'))

    # Step 4: CTS / Fill
    chip.set('option', 'steplist',
             ['clock_tree_syn', 'fillcells'])
    chip.run()
    shutil.copy(os.path.join(jdir, '4_2_cts_fillcell.odb'), os.path.join(jdir, '4_cts.odb'))
    shutil.copy(os.path.join(jdir, '4_cts.sdc'), os.path.join(jdir, '5_route.sdc'))

    # Step 5: Route
    chip.set('option', 'steplist',
             ['global_route', 'detail_route'])
    chip.run()
    shutil.copy(os.path.join(jdir, '5_route.odb'), os.path.join(jdir, '6_1_fill.odb'))
    shutil.copy(os.path.join(jdir, '5_route.sdc'), os.path.join(jdir, '6_1_fill.sdc'))

    # Step 6: Export
    chip.set('option', 'steplist',
             ['final_report', 'export'])
    chip.run()

    chip.summary()                                # print results summary
    chip.show()                                   # show layout file

if __name__ == '__main__':
    main()
