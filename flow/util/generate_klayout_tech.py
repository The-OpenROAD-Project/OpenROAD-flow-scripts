"""Generate klayout .lyt tech file from platform template.

Replaces <lef-files> and <map-file> elements with actual paths.
No klayout dependency - pure XML manipulation using stdlib.
"""

import argparse
import os
import re


def replace_lef_files(content, lef_files):
    """Replace the <lef-files>...</lef-files> element(s) with new ones.

    The original .lyt template has a single <lef-files> element inside
    <reader-options><lefdef>. We replace it with one <lef-files> element
    per LEF file, matching the existing sed-based behavior.
    """
    replacement = "".join("<lef-files>{}</lef-files>".format(f) for f in lef_files)
    return re.sub(r"<lef-files>.*?</lef-files>", replacement, content)


def replace_map_files(content, map_files):
    """Replace the <map-file>...</map-file> or <map-file/> element(s) with new ones."""
    if not map_files:
        return content
    replacement = "".join("<map-file>{}</map-file>".format(f) for f in map_files)
    content = re.sub(r"<map-file>.*?</map-file>", replacement, content)
    content = re.sub(r"<map-file\s*/>", replacement, content)
    return content


def generate_klayout_tech(
    template_lyt,
    output_lyt,
    lef_files,
    reference_dir,
    map_files,
    use_relative_paths,
):
    """Generate a klayout .lyt file from a platform template.

    Args:
        template_lyt: Path to the platform .lyt template file.
        output_lyt: Path to write the generated .lyt file.
        lef_files: List of LEF file paths to include.
        reference_dir: Directory to compute relative paths from.
        map_files: List of map file paths.
        use_relative_paths: If True, compute paths relative to reference_dir.
    """
    with open(template_lyt, "r") as f:
        content = f.read()

    # Write absolute (not relative, not realpath'd) LEF paths into the LYT.
    # Klayout's Layout.read(def, layout_options) follows the symlinked input
    # DEF to its realpath at the bare execroot and resolves relative
    # <lef-files> entries from there.  Sibling intermediates like
    # objects/klayout_tech.lef don't exist at the bare execroot during
    # action execution -- they're only at the per-action sandbox -- so
    # resolution fails with errno=2.  Plain abspath (NOT realpath, which
    # would chase Bazel input-file symlinks back out to the bare execroot)
    # keeps klayout pointed at the in-sandbox file.  reference_dir is now
    # unused for LEFs.
    resolved_lefs = [os.path.abspath(f) for f in lef_files]

    content = replace_lef_files(content, resolved_lefs)

    resolved_maps = [os.path.abspath(f) for f in map_files]
    content = replace_map_files(content, resolved_maps)

    with open(output_lyt, "w") as f:
        f.write(content)


def main():
    parser = argparse.ArgumentParser(
        description="Generate klayout .lyt tech file from platform template."
    )
    parser.add_argument(
        "--template", required=True, help="Path to platform .lyt template"
    )
    parser.add_argument("--output", required=True, help="Output .lyt file path")
    parser.add_argument(
        "--lef-files", nargs="*", default=[], help="LEF files to include"
    )
    parser.add_argument(
        "--reference-dir",
        required=True,
        help="Directory for computing relative paths",
    )
    parser.add_argument(
        "--map-files", nargs="*", default=[], help="Map files to include"
    )
    parser.add_argument(
        "--use-relative-paths",
        action="store_true",
        help="Use paths relative to reference-dir",
    )
    args = parser.parse_args()

    generate_klayout_tech(
        template_lyt=args.template,
        output_lyt=args.output,
        lef_files=args.lef_files,
        reference_dir=args.reference_dir,
        map_files=args.map_files,
        use_relative_paths=args.use_relative_paths,
    )


if __name__ == "__main__":
    main()
