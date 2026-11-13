# KLayout DRC and LVS decks in Python

`make drc` and `make lvs` run a platform's KLayout deck. A deck written in
Python (`KLAYOUT_DRC_FILE` or `KLAYOUT_LVS_FILE` ending in `.py`) runs with
the `klayout` Python module from pip, which the ORFS Python requirements
install. A deck written in KLayout's Ruby DRC language (`.lydrc`, `.lylvs`)
needs the KLayout application.

The decks ORFS runs are Python: asap7, nangate45, sky130hd and
ihp-sg13g2 (`sg13g2_minimal`) DRC, and sky130hd and ihp-sg13g2 LVS.

## Ruby decks are deprecated

A Ruby deck still runs, through the KLayout application, and `make drc` and
`make lvs` print a warning when they run one. The ORFS installer installs
only the `klayout` Python module, so whoever uses a Ruby deck installs the
KLayout application themselves ([KLayout](https://www.klayout.de/build.html)).
To work with the ORFS installer, convert the deck to Python. There is no
schedule for removing Ruby support; that is up to the ORFS maintainers.

The Python module does not include Ruby, and KLayout will not add it
([KLayout/klayout#1772](https://github.com/KLayout/klayout/issues/1772)).
The DRC language is a thin layer over `klayout.db`'s `Region`, `Edges` and
`EdgePairs`, so a deck translates to Python line by line
([KLayout/klayout#1980](https://github.com/KLayout/klayout/issues/1980)).

## Converting a deck

`flow/util/klayout_drc.py` is that layer for the operations ORFS's decks
use, with the DRC language's defaults: `input` and `polygons`, the checks
(`width`, `space`, `separation`, `enclosing`, `overlap`, `notch`,
`isolated`), the selections (`with_area`, `with_angle`, `with_density`
over tiles, `interacting`, `inside`, ...), boolean operations, `sized`,
`connect` with `antenna_check`, and `output`. `flow/util/klayout_lvs.py`
adds `connect_global`, `extract_devices`, `same_circuits` and `compare`
for LVS. The decks in
`flow/platforms/*/drc/*_drc.py` and `flow/platforms/*/lvs/` are
worked examples next to the Ruby they replaced (in git history).
`flow/platforms/ihp-sg13g2/lvs/sg13g2_lvs.py` shows what a deck's own Ruby
classes become: `RBA::GenericDeviceExtractor`, `RBA::GenericDeviceCombiner`,
`RBA::NetlistSpiceReaderDelegate` and device class subclasses translate to
the `klayout.db` classes of the same names, with the same callbacks
(`setup`, `get_connectivity`, `extract_devices`, `combine_devices`,
`parse_element`, `element`); `super()` calls the base implementation, as
Ruby's `super` does.

1. Translate the deck statement by statement into a `*_drc.py` that uses
   `klayout_drc`; keep the rule names, so the report categories match.
2. Check it against the Ruby deck with `flow/util/klayout_compare_decks.py`,
   on the platform's layout and on a copy with shapes added that break the
   rules (width, space, enclosure, density, antenna):

   ```shell
   python3 flow/util/klayout_compare_decks.py \
     --ruby-deck=<deck>.lydrc --python-deck=<deck>_drc.py \
     --in-gds=results/<platform>/<design>/base/6_final.gds --out-dir=<dir>
   ```

   It runs the Ruby deck in the KLayout application, the Python deck with
   the module, and compares the violations per category, count and markers.
3. Point `KLAYOUT_DRC_FILE` at the Python deck.

The conversion of ORFS's decks found a bug kept as is: in the sky130hd deck,
`if backend_flow = CU` assigns rather than compares, so its copper-only
rules never ran; the Python deck keeps `CU = False`.

ihp-sg13g2's Ruby LVS deck never ran in ORFS. Its `config.mk` line was
commented out and named a file that did not exist; the deck reads its
inputs from `-rd input=`, `schematic=`, `topcell=` and `report=`, which
`make lvs` does not pass; and the CDL that `make` wrote left out the decap
cells that are in the layout. The Python deck gets its inputs from `klayout_lvs.py`, and
`flow/scripts/cdl.tcl` writes the CDL with `-include_fillers`.

What only the KLayout application has is dropped: `RBA::CellView::active`
(a deck run from the GUI on the open layout) and file dialogs.
