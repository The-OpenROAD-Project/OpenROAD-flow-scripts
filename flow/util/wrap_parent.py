#!/usr/bin/env python3
"""The parent as a macro: a carved top's own cells moved into a module.

  wrap_parent.py IN.json OUT.json TOP PARENT

Reads yosys JSON of a carved design (carve.py's output, read back with
`proc`) whose top TOP instantiates the tiles. Writes TOP as instances
only: PARENT, a new module holding every cell of TOP that is not a tile,
and the tiles. TOP's ports stay PARENT's. Every tile pin bit on a net the
parent touches (a parent cell, a port of TOP, a constant) gets a port of
PARENT of its own, `<instance>__<pin>`, so each sits where its one tile
pin is and the two abut pin on pin; a constant a tile reads is driven
from inside PARENT, since TOP has no cell to tie it. Nets between tiles
alone stay in TOP.
"""

import json
import sys


def is_const(b):
    return isinstance(b, str)


def wrap(design, top, parent):
    mods = design["modules"]
    t = mods[top]
    tiles = {n: c for n, c in t["cells"].items() if c["type"] in mods}
    own = {n: c for n, c in t["cells"].items() if n not in tiles}

    def direction(cell, pin):
        return mods[cell["type"]]["ports"][pin]["direction"]

    touched = set()
    for p in t["ports"].values():
        touched.update(p["bits"])
    for c in own.values():
        for bits in c["connections"].values():
            touched.update(bits)

    used = [b for p in t["ports"].values() for b in p["bits"] if not is_const(b)]
    for c in t["cells"].values():
        used += [
            b for bits in c["connections"].values() for b in bits if not is_const(b)
        ]
    fresh = [max(used + [1]) + 1]

    def new_bit():
        fresh[0] += 1
        return fresh[0] - 1

    ports = {n: dict(p) for n, p in t["ports"].items()}
    cells = dict(own)
    rest_conn = {n: p["bits"] for n, p in t["ports"].items()}
    new_tiles = {}
    for name in sorted(tiles):
        cell = tiles[name]
        conn = {}
        for pin, bits in cell["connections"].items():
            if not any(is_const(b) or b in touched for b in bits):
                conn[pin] = bits
                continue
            d = direction(cell, pin)
            outer = []
            inner = []
            joined = list(bits)
            for k, b in enumerate(bits):
                if not is_const(b) and b not in touched:
                    # a bit only tiles share stays in TOP
                    continue
                o = new_bit()
                outer.append(o)
                joined[k] = o
                if is_const(b):
                    # a constant from inside the parent: a buffer of it,
                    # which synthesis turns into a tie cell
                    y = new_bit()
                    cells["$tie$%s$%s$%d" % (name, pin, len(inner))] = {
                        "type": "$pos",
                        "parameters": {
                            "A_SIGNED": "0",
                            "A_WIDTH": "1",
                            "Y_WIDTH": "1",
                        },
                        "port_directions": {"A": "input", "Y": "output"},
                        "connections": {"A": [b], "Y": [y]},
                    }
                    inner.append(y)
                else:
                    inner.append(b)
            port = "%s__%s" % (name, pin)
            ports[port] = {
                "direction": "output" if d == "input" else "input",
                "bits": inner,
            }
            rest_conn[port] = outer
            conn[pin] = joined
        new_tiles[name] = dict(cell, connections=conn)

    netnames = {
        n: v
        for n, v in t.get("netnames", {}).items()
        if all(is_const(b) or b in touched for b in v["bits"])
    }
    mods[parent] = {
        "attributes": {},
        "ports": ports,
        "cells": cells,
        "netnames": netnames,
    }
    inst = {
        "type": parent,
        "parameters": {},
        "attributes": {},
        "port_directions": {n: p["direction"] for n, p in ports.items()},
        "connections": rest_conn,
    }
    top_nets = {n: v for n, v in t.get("netnames", {}).items() if n in t["ports"]}
    mods[top] = {
        "attributes": t.get("attributes", {}),
        "ports": t["ports"],
        "cells": dict(new_tiles, u_rest=inst),
        "netnames": top_nets,
    }
    return design


def main(argv):
    src, out, top, parent = argv
    with open(src) as f:
        design = json.load(f)
    with open(out, "w") as f:
        json.dump(wrap(design, top, parent), f, indent=1)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
