#!/usr/bin/env python3
"""SYNTH_VERILOG_SURGERY for asap7/tpu: the array carved into abutted tiles.

  surgery.py CARVE_PY WRAP_PARENT_PY --out-dir DIR -- tpu.sv tpu_array.sv tpu_pe.sv

CARVE_PY and WRAP_PARENT_PY are flow/util's carve.py and wrap_parent.py,
named in SYNTH_VERILOG_SURGERY after this script so that synthesis
declares every file the surgery reads.

Elaborates tpu with yosys's read_slang, carves its 8 x 8 array of
processing elements into 16 identical tiles of 2 x 2 (flow/util/carve.py:
the design's own cells regrouped, no RTL edited, no cell added), and moves
the rest of tpu into a module of its own (flow/util/wrap_parent.py), so
that tpu is instances only:

  tpu_block   a tile, 2 x 2 processing elements
  tpu_rest    the rest of tpu: the skew and deskew registers, the clock
              root, the weights in; built as a C-shaped macro whose notch
              holds the tiles
  tpu         one tpu_rest and 16 tpu_block, wires only

The netlist is the copy of tpu.sv; the copies of the other two sources
are empty. Each flow of the design (tpu, tpu_block, tpu_rest) synthesises
its own module from it.

Each tile holds its processing elements' weight, partial-sum and
activation registers and their input cones. Its ports face its
neighbours: activations in on the west and out on the east, weights and
partial sums in on the north and out on the south. The clock, reset and
load enable run through the tiles with the activations: each row's
westmost tile reads tpu_rest's, every other tile its west neighbour's,
and the bottom row's tiles clock the deskew registers below them.
"""

import argparse
import importlib.util
import json
import os
import subprocess
import sys
import tempfile

N = 8
BLOCK = (2, 2)


def pe(i, j, reg):
    return "u_array.g_pe_row[%d].g_pe_col[%d].u_pe.%s" % (i, j, reg)


# A register between two PEs has a name in each, and yosys keeps
# whichever sorts first: with two-digit rows or columns that is the
# neighbour's. A spec names such a net by both.
def a_east(n, i, j):
    """A PE's activation register, also its east neighbour's a_west."""
    if j + 1 < n:
        return [pe(i, j, "a_east"), pe(i, j + 1, "a_west")]
    return pe(i, j, "a_east")


def w(n, i, j):
    """A PE's weight register, also the PE below's w_north."""
    if i + 1 < n:
        return [pe(i, j, "w"), pe(i, j, "w_south"), pe(i + 1, j, "w_north")]
    return [pe(i, j, "w"), pe(i, j, "w_south")]


def spec(n, r, c):
    def psum(i, j):
        # the last row's partial sums carry the deskew's names
        if i == n - 1:
            return "g_deskew[%d].cin" % j
        return [pe(i, j, "psum_south"), pe(i + 1, j, "psum_north")]

    tiles = []
    for bi in range(n // r):
        for bj in range(n // c):
            rows = range(bi * r, bi * r + r)
            cols = range(bj * c, bj * c + c)
            last_col = bj * c + c - 1 == n - 1
            seeds = []
            for i in rows:
                for j in cols:
                    seeds += [{"net": w(n, i, j)}, {"net": psum(i, j)}]
            # activation registers, those of the block's last column last:
            # a block at the array's east edge has none of those
            seeds += [
                {"net": a_east(n, i, j)} for i in rows for j in cols if j != cols[-1]
            ]
            if not last_col:
                seeds += [{"net": a_east(n, i, cols[-1])} for i in rows]
            ports = []
            for k, i in enumerate(rows):
                if bj == 0:
                    # the skew registers' outputs have no name of their
                    # own: the inputs of the first column's registers
                    ports.append(
                        {
                            "net": a_east(n, i, 0),
                            "via": "D",
                            "port": "a_in",
                            "port_lsb": 8 * k,
                        }
                    )
                else:
                    ports.append(
                        {
                            "net": a_east(n, i, cols[0] - 1),
                            "port": "a_in",
                            "port_lsb": 8 * k,
                        }
                    )
                if not last_col:
                    ports.append(
                        {
                            "net": a_east(n, i, cols[-1]),
                            "port": "a_out",
                            "port_lsb": 8 * k,
                        }
                    )
            for k, j in enumerate(cols):
                if bi == 0:
                    ports.append(
                        {
                            "net": "w_data",
                            "lsb": 8 * j,
                            "width": 8,
                            "port": "w_in",
                            "port_lsb": 8 * k,
                        }
                    )
                else:
                    ports.append(
                        {
                            "net": w(n, rows[0] - 1, j),
                            "port": "w_in",
                            "port_lsb": 8 * k,
                        }
                    )
                    ports.append(
                        {
                            "net": psum(rows[0] - 1, j),
                            "port": "psum_in",
                            "port_lsb": 32 * k,
                        }
                    )
                ports.append(
                    {"net": w(n, rows[-1], j), "port": "w_out", "port_lsb": 8 * k}
                )
                ports.append(
                    {"net": psum(rows[-1], j), "port": "psum_out", "port_lsb": 32 * k}
                )
            ports += [
                {"net": "clk", "port": "clk"},
                {"net": "rst", "port": "rst"},
                {"net": "w_valid", "port": "w_valid"},
            ]
            t = {"instance": "u_b%d_%d" % (bi, bj), "seeds": seeds, "ports": ports}
            unread = (["a_out"] if last_col else []) + (
                ["w_out"] if bi == n // r - 1 else []
            )
            if unread:
                t["unread"] = unread
            if bi == 0:
                t["tie"] = ["psum_in"]
            # the clock, reset and load enter each block row at its west
            # end and run east with the activations, tile to tile
            if bj > 0:
                t["chain_from"] = "u_b%d_%d" % (bi, bj - 1)
            # the bottom row's clock runs on into the deskew registers
            # its results go to
            if bi == n // r - 1:
                t["south_registers"] = [{"net": psum(n - 1, j)} for j in cols]
            tiles.append(t)

    # the template: below the top row (its partial-sum adders are real),
    # left of the last column where there is one (its activation outputs
    # exist); a bottom block exports its weight outputs all the same
    def rank(t):
        return ("tie" in t, "a_out" in t.get("unread", []))

    tiles.sort(key=rank)
    return {
        "module": "tpu_block",
        "stops": [{"net": "g_skew[0].din"}],
        "tiles": tiles,
        "chain": [["clk", "clk_out"], ["rst", "rst_out"], ["w_valid", "w_valid_out"]],
        "south": [["clk", "clk_south"]],
    }


def yosys(script):
    subprocess.run([os.environ["YOSYS_EXE"], "-q", "-p", script], check=True)


def slang():
    """read_slang is built into yosys from 0.67; before, it is the slang
    plugin, found on YOSYS_PLUGIN_PATH as synth_preamble.tcl finds it."""
    probe = subprocess.run(
        [os.environ["YOSYS_EXE"], "-p", "help read_slang"],
        capture_output=True,
        text=True,
        check=True,
    )
    return "plugin -i slang; " if "No such command" in probe.stdout else ""


def load(path):
    name = os.path.splitext(os.path.basename(path))[0]
    spec_ = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec_)
    spec_.loader.exec_module(module)
    return module


def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument("carve_py")
    parser.add_argument("wrap_parent_py")
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("files", nargs="+")
    args = parser.parse_args(argv)
    carve = load(args.carve_py)
    wrap_parent = load(args.wrap_parent_py)
    names = sorted(os.path.basename(f) for f in args.files)
    if names != ["tpu.sv", "tpu_array.sv", "tpu_pe.sv"]:
        sys.exit("surgery.py: expected tpu.sv, tpu_array.sv, tpu_pe.sv, got %s" % names)
    with tempfile.TemporaryDirectory(dir=args.out_dir) as work:
        flat = os.path.join(work, "flat.json")
        yosys(
            slang()
            + "read_slang --top tpu %s; hierarchy -top tpu; proc; flatten; memory; "
            "opt -purge; write_json %s" % (" ".join(args.files), flat)
        )
        with open(flat) as f:
            design = json.load(f)
        carve.carve(design, "tpu", spec(N, *BLOCK))
        wrap_parent.wrap(design, "tpu", "tpu_rest")
        carved = os.path.join(work, "carved.json")
        with open(carved, "w") as f:
            json.dump(design, f)
        yosys(
            "read_json %s; hierarchy -check -top tpu; write_verilog -noattr %s"
            % (carved, os.path.join(args.out_dir, "tpu.sv"))
        )
    for name in ["tpu_array.sv", "tpu_pe.sv"]:
        with open(os.path.join(args.out_dir, name), "w") as f:
            f.write("// carved into tpu.sv by surgery.py\n")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
