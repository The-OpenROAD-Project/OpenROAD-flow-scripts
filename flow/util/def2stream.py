try:
    import pya
except ImportError:
    pya = None

import re
import sys
import os


def merge_gds(
    pya_mod,
    tech_file,
    layer_map,
    in_def,
    design_name,
    in_files,
    seal_file,
    out_file,
    allow_empty="",
    allow_empty_cells=frozenset(),
):
    """Merge DEF and GDS/OAS files into a single stream file.

    Args:
        pya_mod: The pya module (klayout Python API).
        tech_file: Path to klayout technology file.
        layer_map: Path to layer map file (empty string if none).
        in_def: Path to input DEF file.
        design_name: Top-level design name.
        in_files: Space-separated string of GDS/OAS files to merge.
        seal_file: Path to seal ring GDS/OAS file (empty string if none).
        out_file: Path to output GDS/OAS file.
        allow_empty: Regex pattern for cells allowed to be empty.
        allow_empty_cells: Names of cells allowed to be empty.

    Returns:
        Number of errors encountered.
    """
    errors = 0

    # Load technology file
    tech = pya_mod.Technology()
    tech.load(tech_file)
    layout_options = tech.load_layout_options
    if len(layer_map) > 0:
        layout_options.lefdef_config.map_file = layer_map

    # Load def file
    main_layout = pya_mod.Layout()
    print("[INFO] Reporting cells prior to loading DEF ...")
    for i in main_layout.each_cell():
        print("[INFO] '{0}'".format(i.name))

    main_layout.read(in_def, layout_options)

    # Clear cells
    top_cell_index = main_layout.cell(design_name).cell_index()

    # remove orphan cell BUT preserve cell with VIA_
    #  - KLayout is prepending VIA_ when reading DEF that instantiates LEF's via
    for i in main_layout.each_cell():
        if i.cell_index() != top_cell_index:
            if not i.name.startswith("VIA_") and not i.name.endswith("_DEF_FILL"):
                i.clear()

    # Load in the gds to merge
    for fil in in_files.split():
        print("\t{0}".format(fil))
        main_layout.read(fil)

    # Copy the top level only to a new layout
    top_only_layout = pya_mod.Layout()
    top_only_layout.dbu = main_layout.dbu
    top = top_only_layout.create_cell(design_name)
    top.copy_tree(main_layout.cell(design_name))

    missing_cell = False
    regex = re.compile(allow_empty) if allow_empty else None

    if allow_empty:
        print(f"[INFO] GDS_ALLOW_EMPTY={allow_empty}")

    for i in top_only_layout.each_cell():
        if i.is_empty():
            missing_cell = True
            if regex is not None and regex.match(i.name):
                print(
                    "[WARNING] LEF Cell '{0}' ignored. Matches GDS_ALLOW_EMPTY.".format(
                        i.name
                    )
                )
            elif i.name in allow_empty_cells:
                print(
                    "[WARNING] LEF Cell '{0}' ignored. AUTO_MEMORIES generated"
                    " its views; it has no GDS.".format(i.name)
                )
            else:
                print(
                    "[ERROR] LEF Cell '{0}' has no matching GDS/OAS cell."
                    " Cell will be empty.".format(i.name)
                )
                errors += 1

    if not missing_cell:
        print("[INFO] All LEF cells have matching GDS/OAS cells")

    orphan_cell = False
    for i in top_only_layout.each_cell():
        if i.name != design_name and i.parent_cells() == 0:
            orphan_cell = True
            print("[ERROR] Found orphan cell '{0}'".format(i.name))
            errors += 1

    if not orphan_cell:
        print("[INFO] No orphan cells in the final layout")

    if seal_file:
        top_cell = top_only_layout.top_cell()

        top_only_layout.read(seal_file)

        for cell in top_only_layout.top_cells():
            if cell != top_cell:
                print(
                    "[INFO] Merging '{0}' as child of '{1}'".format(
                        cell.name, top_cell.name
                    )
                )
                top.insert(pya_mod.CellInstArray(cell.cell_index(), pya_mod.Trans()))

    # Write out the GDS
    top_only_layout.write(out_file)

    return errors


def auto_memories_cells(environ):
    """The modules AUTO_MEMORIES turned into macros.

    Their LEF and liberty views are generated and they have no GDS, so
    they are empty in the merged layout by design.
    """
    if environ.get("AUTO_MEMORIES") != "1":
        return frozenset()
    # do-auto-memories always writes the list, empty when nothing was
    # converted; without it the merge cannot tell a generated macro from
    # a cell whose GDS is missing.
    results_dir = environ.get("RESULTS_DIR")
    if not results_dir:
        raise RuntimeError("AUTO_MEMORIES=1 but RESULTS_DIR is not set")
    path = os.path.join(results_dir, "memories", "blackboxes.txt")
    if not os.path.isfile(path):
        raise RuntimeError(
            f"AUTO_MEMORIES=1 but {path} is missing; do-auto-memories writes it"
        )
    with open(path, encoding="utf-8") as f:
        return frozenset(line.split()[0] for line in f if line.strip())


# When run via klayout -r, globals tech_file, layer_map, in_def, etc.
# are set by klayout's -rd mechanism.
if pya is not None:
    try:
        # These globals are set by klayout -rd flags
        sys.exit(
            merge_gds(
                pya_mod=pya,
                tech_file=tech_file,  # noqa: F821 - set by klayout -rd
                layer_map=layer_map,  # noqa: F821
                in_def=in_def,  # noqa: F821
                design_name=design_name,  # noqa: F821
                in_files=in_files,  # noqa: F821
                seal_file=seal_file,  # noqa: F821
                out_file=out_file,  # noqa: F821
                allow_empty=os.environ.get("GDS_ALLOW_EMPTY", ""),
                allow_empty_cells=auto_memories_cells(os.environ),
            )
        )
    except NameError:
        # Not running under klayout -r, pya available but no -rd globals
        pass
