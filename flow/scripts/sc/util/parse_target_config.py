import glob
import os
import siliconcompiler
import sys

import parse_config_mk

mydir = os.path.dirname(__file__)
designs_root = os.path.abspath(os.path.join(mydir, '..', '..', '..', 'designs'))
platforms_root = os.path.abspath(os.path.join(mydir, '..', '..', '..', 'platforms'))

def parse(chip, platform):
    '''Parse platform and design env variables to prepare for building a design.'''

    design = chip.get('design')
    design_cfg = os.path.join(designs_root, platform, design, 'config.mk')
    platform_cfg = os.path.join(platforms_root, platform, 'config.mk')

    # Initial pass: Read design config.
    config = parse_config_mk.parse(design_cfg)
    # Substitutions for some values which may not be set.
    repls = {}
    # Set DESIGN_NICKNAME = DESIGN if not already set.
    if not 'DESIGN_NICKNAME' in config:
        repls['DESIGN_NICKNAME'] = config['DESIGN_NAME']
    # Set PLATFORM_DIR if not already set.
    if not 'PLATFORM_DIR' in config:
        repls['PLATFORM_DIR'] = os.path.join(platforms_root, config['PLATFORM'])
    if not 'CORNER' in config:
        if config['PLATFORM'] == 'asap7':
            repls['CORNER'] = 'BC'
        else:
            repls['CORNER'] = 'typical'

    # Second pass: Re-read design config.
    # Set replacement value in os.environ so that the Makefile parser uses it.
    for k, v in repls.items():
        os.environ[k] = v
    # Re-parse the design's config.mk
    config = parse_config_mk.parse(design_cfg)
    # Update 'config' dictionary with the substitutions used to generate it.
    for k, v in repls.items():
        config[k] = v

    # Read in default platform configs
    for k, v in config.items():
        os.environ[k] = v
    os.environ['PLATFORM_DIR'] = os.path.join(platforms_root, platform)
    # We'll calculate ABC_CLOCK_PERIOD_IN_PS later, and its shell call appears to mess with 'make -s'
    os.environ['ABC_CLOCK_PERIOD_IN_PS'] = '0'
    platform_config = parse_config_mk.parse(platform_cfg)

    # Convert to absolute paths where necessary.
    if 'RCX_RULES' in platform_config:
        platform_config['RCX_RULES'] = os.path.abspath(platform_config['RCX_RULES'])
    for key, val in platform_config.items():
        if key.endswith('_DFF_LIB_FILE'):
            platform_config[key] = os.path.abspath(val)
        elif key.endswith('LIB_FILES'):
            platform_config[key] = ' '.join([os.path.abspath(vf) for vf in val.split()])

    # Final pass: Read design config with default platform values and previous replacements.
    for k, v in config.items():
        os.environ.pop(k)
    for k, v in repls.items():
        os.environ[k] = v
    for k, v in platform_config.items():
        os.environ[k] = v
    config = parse_config_mk.parse(design_cfg)
    for k, v in repls.items():
        config[k] = v

    # Convert source files to absolute paths b/c sc commands run in a different build dir.
    abs_sources = ['VERILOG_INCLUDE_DIRS', 'ADDITIONAL_LEFS', 'ADDITIONAL_LIBS',
                   'LIB_FILES', 'ADDITIONAL_GDS_FILES', 'MACRO_PLACEMENT']
    for skey in abs_sources:
        if skey in config.keys():
            src_list = [os.path.abspath(vf) for vf in config[skey].split()]
            config[skey] = ' '.join(src_list)
    # Special cases: Verilog sources and constraint file.
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

    # Merge design and platform configs. If a value is in both, design has the correct value
    # due to the way that the Makefile parser discards 'before' environment variables.
    merged_config = config
    for k, v in platform_config.items():
        if not k in merged_config:
            merged_config[k] = v

    # Calculate clock period to use for yosys abc. Should be first clock entry in the constraints file.
    ps_scale = 1 if platform == 'asap7' else 1000
    if (not 'ABC_CLOCK_PERIOD_IN_PS' in merged_config) and (os.path.isfile(chip.get('input', 'sdc')[0])):
        with open(chip.get('input', 'sdc')[0], 'r') as sdcf:
            for l in sdcf.readlines():
                if l.startswith('set clk_period '):
                    # "set clk_period x.yz \n": extract "x.yz" as float
                    p = float(l[len('set clk_period ') : ].strip())
                    merged_config['ABC_CLOCK_PERIOD_IN_PS'] = f'{p * ps_scale}'
                    break
                elif '-period ' in l:
                    # "create_clock ... -period  x.yz ... \n": extract "x.yz" as float.
                    lv = l.split()
                    p = float(lv[lv.index('-period') + 1])
                    merged_config['ABC_CLOCK_PERIOD_IN_PS'] = f'{p * ps_scale}'
                    break

    for step in chip.getkeys('flowgraph', 'orflow'):
        index = '0'
        tool = chip.get('flowgraph', 'orflow', step, index, 'tool')
        # "Don't use" libraries get pre-processed. TODO: Currently placed in build dir root.
        # Also, 'markDontUse.py' is called from TCL; might be easier to do that pp here.
        mod_lib_base = os.path.abspath(os.path.join(chip.get('option', 'builddir'),
                                                    config['DESIGN_NAME'],
                                                    chip.get('option', 'jobname')))
        libs = merged_config['LIB_FILES'].split()
        dontuse_l = []
        for lf in libs:
            dontuse_l.append(os.path.join(mod_lib_base, f'{os.path.split(lf)[1]}-mod.lib'))
        merged_config['DONT_USE_LIBS'] = ' '.join(dontuse_l)
        merged_config['DONT_USE_SC_LIB'] = os.path.join('..', '..', 'merged.lib')

        # Set config environment values to be set during sc flow.
        for key, val in merged_config.items():
            chip.set('tool', tool, 'env', step, index, key, val.strip())
            # TODO: Update remaining PDK/lib values from environment variables in the Chip manifest.
            schema_repls = {
                'PLACE_DENSITY': 'place_density',
                'CELL_PAD_IN_SITES_GLOBAL_PLACEMENT': 'pad_global_place',
                'CELL_PAD_IN_SITES_DETAIL_PLACEMENT': 'pad_detail_place',
                'MACRO_PLACE_HALO': 'macro_place_halo',
                'MACRO_PLACE_CHANNEL': 'macro_place_channel',
            }
            if key in schema_repls.keys():
                chip.set('tool', tool, 'var', step, index, schema_repls[key], val)

    # Debug: print final environment variables.
    chip.logger.debug(merged_config)

    # TODO: Update remaining PDK/lib values from environment variables in the Chip manifest.
    chip.set('option', 'mode', 'asic')
    chip.set('design', merged_config['DESIGN_NAME'])
    stackup = chip.get('asic', 'stackup')
    libtype = chip.get('asic', 'libarch')
    process = chip.get('option', 'pdk')

    # Read minimal PDK values into sc manifest.
    chip.set('pdk', process, 'node', merged_config['PROCESS'])
    for tool in ('openroad', 'klayout'):
        chip.add('pdk', process, 'aprtech', tool, stackup, libtype, 'lef',
                 os.path.abspath(merged_config['TECH_LEF']))
    chip.set('pdk', process, 'layermap', 'klayout', 'def', 'gds', stackup,
             os.path.abspath(merged_config['KLAYOUT_TECH_FILE']))
    # TODO: Assuming that .lyp file prefix matches .lyt
    chip.set('pdk', process, 'display', 'klayout', stackup,
             os.path.abspath(f'{merged_config["KLAYOUT_TECH_FILE"][:-1]}p'))

    # Read minimal liberty values into sc manifest.
    plib_name = chip.get('asic', 'logiclib')[0]
    platform_lib = siliconcompiler.Chip(plib_name)
    platform_lib.set('asic', 'libarch', libtype)
    platform_lib.set('asic', 'footprint', merged_config['PLACE_SITE'], 'symmetry', 'Y')
    platform_lib.add('model', 'layout', 'lef', stackup, os.path.abspath(merged_config['SC_LEF']))
    for lf in merged_config['GDS_FILES'].split():
        platform_lib.add('model', 'layout', 'gds', stackup, os.path.abspath(lf))
    for lf in merged_config['LIB_FILES'].split():
        platform_lib.add('model', 'timing', 'nldm', merged_config['CORNER'],
                         os.path.abspath(lf))
    chip.import_library(platform_lib)

    return chip
