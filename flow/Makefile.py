import argparse
import glob
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
        v_in_list = []
        for vf in config.pop('VERILOG_FILES').split():
            if '*' in vf:
                for gf in glob.glob(vf):
                    v_in_list.append(os.path.abspath(gf))
            else:
                v_in_list.append(os.path.abspath(vf))
        chip.set('input', 'verilog', v_in_list)
    if 'VERILOG_FILES_BLACKBOX' in config.keys():
        v_in_list = []
        for vf in config.pop('VERILOG_FILES_BLACKBOX').split():
            if '*' in vf:
                for gf in glob.glob(vf):
                    v_in_list.append(os.path.abspath(gf))
            else:
                v_in_list.append(os.path.abspath(vf))
        config['VERILOG_FILES_BLACKBOX'] = ' '.join(v_in_list)
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

    # Calculate clock period to use for yosys abc. Should be first clock entry in the constraints file.
    if (not 'ABC_CLOCK_PERIOD_IN_PS' in config) and (os.path.isfile(chip.get('input', 'sdc')[0])):
        with open(chip.get('input', 'sdc')[0], 'r') as sdcf:
            for l in sdcf.readlines():
                if l.startswith('set clk_period '):
                    # "set clk_period x.yz \n": extract "x.yz" as float
                    p = float(l[len('set clk_period ') : ].strip())
                    config['ABC_CLOCK_PERIOD_IN_PS'] = f'{p * 1000}'
                    break
                elif '-period ' in l:
                    # "create_clock ... -period  x.yz ... \n": extract "x.yz" as float.
                    lv = l.split()
                    p = float(lv[lv.index('-period') + 1])
                    config['ABC_CLOCK_PERIOD_IN_PS'] = f'{p * 1000}'
                    break

    tools = ['yosys', 'openroad', 'klayout']
    for tool in tools:
        for k in chip.getkeys('tool', tool, 'env'):
            for key in chip.getkeys('tool', tool, 'env', k, '0'):
                # Some env vars should be appended to and/or modified.
                if (key == 'LIB_FILES') and ('ADDITIONAL_LIBS' in config):
                    val = chip.get('tool', tool, 'env', k, '0', key)
                    # Liberty files get pre-processed to
                    chip.set('tool', tool, 'env', k, '0', key, f'{val} {config["ADDITIONAL_LIBS"]}')
                elif (key == 'DONT_USE_LIBS'):
                    # "Don't use" libraries get pre-processed. TODO: Currently placed in build dir root.
                    # Also, 'markDontUse.py' is called from TCL; might be easier to do that pp here.
                    mod_lib_base = os.path.abspath(os.path.join(chip.get('option', 'builddir'),
                                                                chip.get('design'),
                                                                chip.get('option', 'jobname')))
                    libs = [chip.get('tool', tool, 'env', k, '0', key)]
                    if 'ADDITIONAL_LIBS' in config:
                        libs = libs + config['ADDITIONAL_LIBS'].split()
                    dontuse_l = []
                    for lf in libs:
                        dontuse_l.append(os.path.join(mod_lib_base, f'{os.path.split(lf)[1]}-mod.lib'))
                    dontuse = ' '.join(dontuse_l)
                    chip.set('tool', tool, 'env', k, '0', key, dontuse)
                    chip.set('tool', tool, 'env', k, '0', 'DONT_USE_SC_LIB', dontuse_l[0])
            for key, val in config.items():
                # Some env vars should be appended to.
                if not key in ['DONT_USE_LIBS', 'LIB_FILES', 'DONT_USE_SC_LIB']:
                    chip.set('tool', tool, 'env', k, '0', key, val)

    # Set KLayout export options.
    tool = 'klayout'
    step = 'or_export'
    fill_cfg = chip.get('tool', tool, 'env', step, '0', 'FILL_CONFIG')
    seal_gds = chip.get('tool', tool, 'env', step, '0', 'SEAL_GDS')
    gdsoas_in = ' '.join([chip.get('tool', tool, 'env', step, '0', 'GDSOAS_FILES'),
                          chip.get('tool', tool, 'env', step, '0', 'WRAPPED_GDSOAS')])
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
