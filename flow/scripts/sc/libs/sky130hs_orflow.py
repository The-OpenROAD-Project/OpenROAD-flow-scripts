import os
import siliconcompiler

def make_docs():
    '''
    Skywater130 standard cell library.
    '''
    chip = siliconcompiler.Chip('<design>')
    setup(chip)
    return chip

def setup(chip):
    foundry = 'skywater'
    process = 'skywater130'
    stackup = '5M1LI'
    version = 'v0_0_2'
    libname = 'sky130hs'
    libtype = 'unit'
    corner = 'typical'

    libdir = os.path.join(os.path.dirname(__file__), '..', '..', '..', 'platforms', libname)

    lib = siliconcompiler.Chip(libname)

    # version
    lib.set('package', 'version', version)

    # list of stackups supported
    lib.set('asic', 'stackup', stackup)

    # list of pdks supported
    lib.set('asic', 'pdk', process)

    # footprint/type/sites
    lib.set('asic', 'libarch', libtype)
    lib.set('asic', 'footprint', libtype, 'symmetry', 'Y')
    lib.set('asic', 'footprint', libtype, 'size', (0.46,2.72))

    # model files
    lib.add('model', 'timing', 'nldm', corner,
            os.path.abspath(os.path.join(libdir, 'lib', 'sky130_fd_sc_hs__tt_025C_1v80.lib')))
    lib.add('model', 'layout', 'lef', stackup,
            os.path.abspath(os.path.join(libdir, 'lef', 'sky130_fd_sc_hs_merged.lef')))
    lib.add('model', 'layout', 'gds', stackup,
            os.path.abspath(os.path.join(libdir, 'gds', 'sky130_fd_sc_hs.gds')))

    # Techmap
    lib.add('asic', 'file', 'yosys', 'techmap',
            os.path.abspath(os.path.join(libdir, 'cells_latch_hs.v')))

    # Power grid specifier
    lib.set('asic', 'pgmetal', 'm1')

    # clock buffers
    lib.add('asic', 'cells', 'clkbuf', 'sky130_fd_sc_hs__clkbuf_4')

    # hold cells
    lib.add('asic', 'cells', 'hold', 'sky130_fd_sc_hs__buf_1')

    # filler
    lib.add('asic', 'cells', 'filler', ['sky130_fd_sc_hs__fill_1',
                                         'sky130_fd_sc_hs__fill_2',
                                         'sky130_fd_sc_hs__fill_4',
                                         'sky130_fd_sc_hs__fill_8'])

    # Tapcell
    lib.add('asic', 'cells','tap', 'sky130_fd_sc_hs__tapvpwrvgnd_1')

    # Endcap
    lib.add('asic', 'cells', 'endcap', 'sky130_fd_sc_hs__decap_4')

    # Ignore / "don't use" cells.
    lib.add('asic', 'cells', 'ignore', [])

    # TODO: should probably fill these in, but they're currently unused by
    # OpenROAD flow
    #driver
    lib.add('asic', 'cells', 'driver', 'sky130_fd_sc_hs__buf_1')

    # buffer cell
    lib.add('asic', 'cells', 'buf', ['sky130_fd_sc_hs__buf_4 A X'])

    # tie cells
    lib.add('asic', 'cells', 'tie', ['sky130_fd_sc_hs__conb_1 HI',
                                      'sky130_fd_sc_hs__conb_1 LO'])

    chip.import_library(lib)

#########################
if __name__ == "__main__":

    lib = make_docs()
    lib.write_manifest('sky130.tcl')
