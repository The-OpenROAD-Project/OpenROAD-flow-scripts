import os
import shutil
import siliconcompiler

openroad_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', '..', '..'))

def main():
    ll = 'INFO'
    chip = siliconcompiler.Chip('heartbeat', loglevel=ll)      # create chip object
    chip.set('input', 'verilog', os.path.abspath('heartbeat.v'))   # define list of source files
    chip.set('input', 'sdc', os.path.abspath('heartbeat.sdc'))     # set constraints file

    # Load PDK, flow, and libs.
    chip.load_pdk('freepdk45_orflow')
    chip.load_lib('nangate45_orflow')
    chip.set('option', 'pdk', 'freepdk45')
    chip.set('asic', 'logiclib', 'nangate45')

    # Set project-specific values
    chip.set('asic', 'stackup', '10M')
    chip.set('asic', 'delaymodel', 'nldm')
    chip.set('asic', 'minlayer', "m1")
    chip.set('asic', 'maxlayer', "m10")
    chip.set('asic', 'maxfanout', 64)
    chip.set('asic', 'maxlength', 1000)
    chip.set('asic', 'maxslew', 0.2e-9)
    chip.set('asic', 'maxcap', 0.2e-12)
    chip.set('asic', 'rclayer', 'clk', "m5")
    chip.set('asic', 'rclayer', 'data',"m3")
    chip.set('asic', 'hpinlayer', "m3")
    chip.set('asic', 'vpinlayer', "m2")
    chip.set('asic', 'density', 10)
    chip.set('asic', 'aspectratio', 1)
    chip.set('asic', 'coremargin', 1.9)
    # Set timing corners.
    corner = 'typical'
    chip.set('constraint','worst','libcorner', corner)
    chip.set('constraint','worst','pexcorner', corner)
    chip.set('constraint','worst','mode', 'func')
    chip.set('constraint','worst','check', ['setup','hold'])

    # Load the flow.
    chip.load_flow('orflow')
    chip.set('option', 'flow', 'orflow')

    # Set 'run_all.tcl' as the script to run in the OpenROAD step.
    #chip.set('tool', 'openroad', 'script', 'orflow', '0',
    #         os.path.abspath(os.path.join(openroad_dir, 'flow', 'scripts', 'run_all.tcl')))

    # Step 1: Import / Synthesis
    # TODO: Is there a better way to copy/rename files mid-flow?
    jdir = os.path.join(chip.get('option', 'builddir'), chip.get('design'), chip.get('option', 'jobname'))
    chip.set('option', 'steplist', ['import', 'syn'])
    chip.run()
    shutil.copy(os.path.join(jdir, '1_1_yosys.v'), os.path.join(jdir, '1_synth.v'))
    shutil.copy(chip.get('input', 'sdc')[0], os.path.join(jdir, '1_synth.sdc'))

    # Step 2: Floorplan
    chip.set('option', 'steplist', ['init_floorplan', 'io_place_rand', 'tdms_place', 'macro_place', 'tapcell', 'pdn'])
    chip.run()
    shutil.copy(os.path.join(jdir, '2_6_floorplan_pdn.odb'), os.path.join(jdir, '2_floorplan.odb'))

    # Step 3: Placement
    chip.set('option', 'steplist', ['gp_skip_io', 'io_place', 'global_place', 'resize', 'detail_place'])
    chip.run()
    shutil.copy(os.path.join(jdir, '3_5_place_dp.odb'), os.path.join(jdir, '3_place.odb'))
    shutil.copy(os.path.join(jdir, '2_floorplan.sdc'), os.path.join(jdir, '3_place.sdc'))

    # Step 4: CTS / Fill
    chip.set('option', 'steplist', ['clock_tree_syn', 'fillcells'])
    chip.run()
    shutil.copy(os.path.join(jdir, '4_2_cts_fillcell.odb'), os.path.join(jdir, '4_cts.odb'))
    shutil.copy(os.path.join(jdir, '4_cts.sdc'), os.path.join(jdir, '5_route.sdc'))

    # Step 5: Route
    chip.set('option', 'steplist', ['global_route', 'detail_route'])
    chip.run()
    shutil.copy(os.path.join(jdir, '5_route.odb'), os.path.join(jdir, '6_1_fill.odb'))
    shutil.copy(os.path.join(jdir, '5_route.sdc'), os.path.join(jdir, '6_1_fill.sdc'))

    # Step 6: Export
    process = chip.get('asic', 'pdk')
    # KLayout tech LEF needs modifying. TODO: Also add equivalent of $ADDITIONAL_LEFS (macros)
    stackup = chip.get('pdk', process, 'stackup')[0]
    libtype = '10t' # TODO: Where to get this in schema?
    tool = 'klayout'
    base_lyt = chip.get('pdk', process, 'layermap', tool, 'def', 'gds', stackup)[0]
    base_lyp = chip.get('pdk', process, 'display', tool, stackup)[0]
    tlef = chip.get('library', 'nangate45', 'model', 'layout', 'lef', stackup)[0]
    shutil.copy(base_lyp, os.path.join(jdir, 'klayout.lyp'))
    with open(base_lyt, 'r') as rf:
        with open(os.path.join(jdir, 'klayout.lyt'), 'w') as wf:
            for l in rf.readlines():
                if not '<lef-files>' in l:
                    wf.write(l)
                else:
                    wf.write(f'   <lef-files>{tlef}</lef-files>\n')
    chip.set('option', 'steplist', ['final_report', 'export'])
    chip.run()

    chip.summary()                                # print results summary
    chip.show()                                   # show layout file

if __name__ == '__main__':
    main()
