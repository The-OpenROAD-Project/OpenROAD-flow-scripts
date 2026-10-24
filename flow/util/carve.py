#!/usr/bin/env python3
"""Carve identical tiles out of a flat module, leave the remainder as the parent.

The input is yosys's JSON of one flat module (read, `proc`, `flatten`,
`memory`, `opt`). A spec names, for each tile, the registers it owns (its
seeds) and how the nets on its boundary map to the tile's ports. Each
tile takes its seeds and every combinational cell in their input cones,
back to a register it does not own or a port of the module. Every tile
is checked to cut the same boundary, then replaced by an instance of one
module built from the first tile's cells. Nothing else changes: the RTL
is not edited, no cell is added or duplicated, and the remainder of the
module stays the parent, its ports as they were.

That the other tiles compute what the first one does is not checked
here. The carved design's equivalence to the input, kepler-formal's
combinational check between registers matched by name (lec_names, the
census), proves the carve and the reuse in one go, and a tile with one
port broken must be refuted.

The spec is JSON:

  {"module": "aes_column",
   "tiles": [{"instance": "u_col0",
              "seeds": [{"net": "sa00"}, {"net": "text_out", "lsb": 96, "width": 32}],
              "ports": [{"net": "sa11", "port": "row1_in"},
                        {"net": "text_in", "lsb": 96, "width": 32, "port": "text_in"}]},
             ...]}

A seed entry {"prefix": "if_stage_i."} takes every register under that
instance path; a tile's "confine" keeps its cones inside the instance, so
its inputs are the instance's own; "auto_ports": true names its ports
after the parent's nets, for a macro that exists once. --spec may be
given several times: one carve after the other, each its own module.

A seed or port entry takes the bits [lsb, lsb + width) of a net; without
lsb and width, all of them. Port bit i is net bit lsb + i. A seed may be
logic too, such as a slice of a register file's read multiplexer.
A port entry's "port_lsb" puts it at that bit of a wider port, and
"via": "D" names the D inputs of the registers driving the net instead. A tile's
"tie" lists inputs of the first tile that are constant 0 at this one,
the top row of a systolic array: synthesis folded their logic, and the
tile becomes the first tile's module with them tied. A tile's
"unread" lists outputs of the first tile that nothing reads at this one,
the last column of a systolic array: synthesis removed their registers,
the tile is still the first tile's module, and the outputs stay open; the
tile lists the seeds it lacks last. Optional: "stops", entries whose bits end every cone, so logic shared by
all tiles (an address decoder) stays in the parent and reaches each tile
through a port; "split_bitwise": true splits wide gates and multiplexers
per bit, so tiles can own some bits each.
"""

import argparse
import copy
import json
import re
import sys

# Registers: data ports scale with WIDTH, the rest are one bit for the cell.
FLOPS = {
    "$dff": ("D", "Q"),
    "$dffe": ("D", "Q"),
    "$sdff": ("D", "Q"),
    "$sdffe": ("D", "Q"),
    "$sdffce": ("D", "Q"),
    "$adff": ("D", "Q"),
    "$adffe": ("D", "Q"),
}
# Per-bit values of a flop, sliced with it.
FLOP_VALUE_PARAMS = ("SRST_VALUE", "ARST_VALUE")


def param_int(value):
    """yosys JSON writes an integer parameter as a binary string, MSB first."""
    if isinstance(value, int):
        return value
    return int(value, 2)


def split_flops(module):
    """Every multi-bit register as one cell per bit, so tiles can own bits."""
    cells = module["cells"]
    for name in sorted(cells):
        cell = cells[name]
        if cell["type"] not in FLOPS:
            continue
        width = param_int(cell["parameters"]["WIDTH"])
        if width == 1:
            continue
        del cells[name]
        for i in range(width):
            bit = copy.deepcopy(cell)
            bit["parameters"]["WIDTH"] = format(1, "032b")
            for p in FLOP_VALUE_PARAMS:
                if p in bit["parameters"]:
                    v = cell["parameters"][p]
                    # MSB first: bit i is the (width - 1 - i)th character
                    bit["parameters"][p] = v[len(v) - 1 - i]
            for port in FLOPS[cell["type"]]:
                bit["connections"][port] = [cell["connections"][port][i]]
            cells["%s[%d]" % (name, i)] = bit


def net_bits(module, entry):
    """The bits an entry of the spec names, in order.

    With "via": "D", the D inputs of the registers whose outputs are the
    net's bits: a register's input where elaboration left it no name.
    """
    nets = module["netnames"]
    # a list names one net by its aliases: yosys keeps one name of a
    # net that has several, and which one depends on how they sort
    names = entry["net"] if isinstance(entry["net"], list) else [entry["net"]]
    found = [n for n in names if n in nets]
    if not found:
        raise ValueError("no net %s" % " or ".join(names))
    bits = nets[found[0]]["bits"]
    if entry.get("via") == "D":
        q = {}
        for cell in module["cells"].values():
            if cell["type"] in FLOPS:
                for i, b in enumerate(cell["connections"]["Q"]):
                    q[b] = cell["connections"]["D"][i]
        missing = [b for b in bits if b not in q]
        if missing:
            raise ValueError(
                "%s: %d bits are no register's output" % (found[0], len(missing))
            )
        bits = [q[b] for b in bits]
    lsb = entry.get("lsb", 0)
    width = entry.get("width", len(bits) - lsb)
    if lsb + width > len(bits):
        raise ValueError("%s has %d bits, not %d" % (found[0], len(bits), lsb + width))
    return bits[lsb : lsb + width]


class Graph:
    """Who drives each bit of a module, and which cells read it."""

    def __init__(self, module):
        self.driver = {}
        self.readers = {}
        for name, cell in module["cells"].items():
            for port, bits in cell["connections"].items():
                for b in bits:
                    if isinstance(b, str):
                        continue
                    if cell["port_directions"][port] == "output":
                        self.driver[b] = name
                    else:
                        self.readers.setdefault(b, set()).add(name)
        self.inputs = set()
        self.outputs = set()
        for port in module["ports"].values():
            bits = {b for b in port["bits"] if not isinstance(b, str)}
            (self.inputs if port["direction"] == "input" else self.outputs).update(bits)


def cone(module, graph, seeds, stops=frozenset(), confine=None):
    """The seed cells and every combinational cell in their input cones.

    A cone stops at a register, a port of the module and a bit in `stops`;
    with `confine`, an instance path, also at any cell outside it: the
    tile is that instance's registers and the logic in front of them, its
    inputs the instance's own.
    """
    cells = module["cells"]
    owned = set(seeds)
    todo = list(seeds)
    while todo:
        name = todo.pop()
        cell = cells[name]
        for port, bits in cell["connections"].items():
            if cell["port_directions"][port] != "input":
                continue
            for b in bits:
                if b in stops:
                    continue
                d = graph.driver.get(b)
                if d is None or d in owned or cells[d]["type"] in FLOPS:
                    continue
                # yosys's flatten names a cell $flatten\<path>.<name>
                if confine and not (
                    d.startswith(confine) or d.startswith("$flatten\\" + confine)
                ):
                    continue
                owned.add(d)
                todo.append(d)
    return owned


def seed_cells(module, graph, tile):
    """The cells driving the tile's seed bits: its registers, or logic it owns."""
    seeds = set()
    for entry in tile["seeds"]:
        if "prefix" in entry:
            seeds |= prefix_registers(module, entry["prefix"])
            continue
        for b in net_bits(module, entry):
            d = graph.driver.get(b)
            if d is None:
                raise ValueError(
                    "%s: seed bit %s has no driver" % (tile["instance"], b)
                )
            seeds.add(d)
    return seeds


def prefix_registers(module, prefix):
    """Every register whose cell or output net is under an instance path."""
    named = set()
    for name, net in module["netnames"].items():
        if name.startswith(prefix):
            named.update(b for b in net["bits"] if not isinstance(b, str))
    out = set()
    for name, cell in module["cells"].items():
        if cell["type"] not in FLOPS:
            continue
        if (
            name.startswith(prefix)
            or name.startswith("$flatten\\" + prefix)
            or set(cell["connections"]["Q"]) & named
        ):
            out.add(name)
    if not out:
        raise ValueError("no register under %s" % prefix)
    return out


# Cells whose bit i depends only on the inputs' bit i (and a shared select).
BITWISE = ("$and", "$or", "$xor", "$xnor", "$not", "$mux", "$pmux", "$bmux")


def split_bitwise(module):
    """Every multi-bit bitwise cell and multiplexer as one cell per bit.

    So that tiles which each own some bits of a wide gate or multiplexer,
    such as a register file's slices of one read multiplexer, can own them.
    """
    cells = module["cells"]
    for name in sorted(cells):
        cell = cells[name]
        t = cell["type"]
        if t not in BITWISE:
            continue
        c = cell["connections"]
        width = len(c["Y"])
        if width == 1:
            continue
        if t in ("$and", "$or", "$xor", "$xnor") and not (
            len(c["A"]) == len(c["B"]) == width
        ):
            continue
        if t == "$not" and len(c["A"]) != width:
            continue
        del cells[name]
        for i in range(width):
            bit = copy.deepcopy(cell)
            conn = bit["connections"]
            conn["Y"] = [c["Y"][i]]
            if t in ("$mux", "$pmux", "$bmux"):
                n = len(c["B"]) // width if t == "$pmux" else len(c["A"]) // width
                if t == "$mux":
                    conn["A"], conn["B"] = [c["A"][i]], [c["B"][i]]
                    bit["parameters"]["WIDTH"] = format(1, "032b")
                elif t == "$pmux":
                    conn["A"] = [c["A"][i]]
                    conn["B"] = [c["B"][j * width + i] for j in range(n)]
                    bit["parameters"]["WIDTH"] = format(1, "032b")
                else:
                    conn["A"] = [c["A"][j * width + i] for j in range(n)]
                    bit["parameters"]["WIDTH"] = format(1, "032b")
            else:
                conn["A"] = [c["A"][i]]
                bit["parameters"]["A_WIDTH"] = format(1, "032b")
                if "B" in conn:
                    conn["B"] = [c["B"][i]]
                    bit["parameters"]["B_WIDTH"] = format(1, "032b")
                bit["parameters"]["Y_WIDTH"] = format(1, "032b")
            cells["%s[%d]" % (name, i)] = bit


def boundary(module, graph, owned):
    """(inputs, outputs): bits the tile reads from outside and drives to it."""
    cells = module["cells"]
    ins, outs = set(), set()
    for name in owned:
        cell = cells[name]
        for port, bits in cell["connections"].items():
            for b in bits:
                if isinstance(b, str):
                    continue
                if cell["port_directions"][port] == "output":
                    if b in graph.outputs or graph.readers.get(b, set()) - owned:
                        outs.add(b)
                elif graph.driver.get(b) not in owned:
                    ins.add(b)
    return ins, outs


def auto_ports(module, bits):
    """{bit: (port, index)}: a port per parent net, named after it, its
    bits in the net's order; for a macro that exists once."""
    by_net = {}
    for b in sorted(bits):
        name = bit_name(module, b)
        net, idx = name.rsplit("[", 1)
        by_net.setdefault(net, []).append((int(idx[:-1]), b))
    mapping = {}
    used = set()
    for net, idx_bits in sorted(by_net.items()):
        port = re.sub(r"[^A-Za-z0-9_]", "_", net).strip("_") or "p"
        while port in used:
            port += "_"
        used.add(port)
        for i, (_, b) in enumerate(sorted(idx_bits)):
            mapping[b] = (port, i)
    return mapping


def port_map(module, tile, bits):
    """{bit: (port, index)} for every boundary bit, from the spec's ports."""
    if tile.get("auto_ports"):
        return auto_ports(module, bits)
    mapping = {}
    taken = {}
    for entry in tile["ports"]:
        base = entry.get("port_lsb", 0)
        for i, b in enumerate(net_bits(module, entry), base):
            if b in bits and b not in mapping:
                if (entry["port"], i) in taken:
                    raise ValueError(
                        "%s: %s[%d] maps two boundary bits"
                        % (tile["instance"], entry["port"], i)
                    )
                taken[(entry["port"], i)] = b
                mapping[b] = (entry["port"], i)
    missing = sorted(b for b in bits if b not in mapping)
    if missing:
        names = names_of(module, missing[:8])
        raise ValueError(
            "%s: %d boundary bits have no port, e.g. %s"
            % (tile["instance"], len(missing), names)
        )
    return mapping


def names_of(module, bits):
    """A readable name per bit, for messages."""
    found = {}
    for name, net in sorted(
        module["netnames"].items(), key=lambda kv: kv[1].get("hide_name", 0)
    ):
        for i, b in enumerate(net["bits"]):
            if b in bits and b not in found:
                found[b] = "%s[%d]" % (name, i)
    return [found.get(b, str(b)) for b in bits]


def interface(mapping, ins, outs):
    """{port: (direction, width)} the tile shows its parent."""
    ports = {}
    for b, (port, i) in mapping.items():
        direction = "output" if b in outs else "input"
        d, w = ports.get(port, (direction, 0))
        if d != direction:
            raise ValueError("port %s is both input and output" % port)
        ports[port] = (direction, max(w, i + 1))
    return ports


def build_module(module, owned, mapping, ports):
    """The tile's module: its cells as they are, ports by the spec."""
    cells = {n: copy.deepcopy(module["cells"][n]) for n in sorted(owned)}
    used = {
        b
        for c in cells.values()
        for bits in c["connections"].values()
        for b in bits
        if not isinstance(b, str)
    }
    mod_ports = {}
    for port, (direction, width) in sorted(ports.items()):
        bits = [None] * width
        for b, (p, i) in mapping.items():
            if p == port:
                bits[i] = b
        if None in bits:
            raise ValueError("port %s has a gap at bit %d" % (port, bits.index(None)))
        mod_ports[port] = {"direction": direction, "bits": bits}
    netnames = {}
    for port, p in mod_ports.items():
        netnames[port] = {"hide_name": 0, "bits": p["bits"], "attributes": {}}
    inside = used - set(mapping)
    for name, net in module["netnames"].items():
        bits = [b for b in net["bits"] if b in inside]
        if name in netnames or not bits:
            continue
        # a net partly inside keeps its name for the bits that are
        netnames[name] = {
            "hide_name": net.get("hide_name", 0),
            "bits": bits,
            "attributes": {},
        }
    return {"attributes": {}, "ports": mod_ports, "cells": cells, "netnames": netnames}


def carve(design, top, spec, gold=None):
    """Rewrite `design` in place; return the census.

    `gold`, a dict, receives a copy of the design with its registers split
    per bit and nothing carved: the reference for the equivalence test.
    """
    module = design["modules"][top]
    split_flops(module)
    if spec.get("split_bitwise"):
        split_bitwise(module)
    if gold is not None:
        gold.update(copy.deepcopy(design))
    graph = Graph(module)
    stops = frozenset(b for e in spec.get("stops", []) for b in net_bits(module, e))
    cones = []
    claimed = {}
    for tile in spec["tiles"]:
        owned = cone(
            module, graph, seed_cells(module, graph, tile), stops, tile.get("confine")
        )
        for name in owned:
            if name in claimed:
                raise ValueError(
                    "cell %s is in %s and %s" % (name, claimed[name], tile["instance"])
                )
            claimed[name] = tile["instance"]
        cones.append((tile, owned))
    tiles = []
    for k, (tile, owned) in enumerate(cones):
        ins, outs = boundary(module, graph, owned)
        if k == 0 and not tile.get("auto_ports"):
            # the module every tile instantiates exports every output its
            # spec names, read outside or not: a tile elsewhere in the
            # array may need one this tile's neighbours do not read
            for entry in tile["ports"]:
                for b in net_bits(module, entry):
                    if graph.driver.get(b) in owned:
                        outs.add(b)
        mapping = port_map(module, tile, ins | outs)
        tiles.append((tile, owned, mapping, interface(mapping, ins, outs), ins, outs))

    first = tiles[0]
    for tile, owned, _, ports, _, _ in tiles[1:]:
        # outputs nothing reads, whose registers synthesis already removed,
        # and inputs that are constants, whose logic synthesis folded
        unread = set(tile.get("unread", [])) | set(tile.get("tie", []))
        expected = {p: v for p, v in first[3].items() if p not in unread}
        if {p: v for p, v in ports.items() if p not in unread} != expected or set(
            ports
        ) - set(first[3]):
            raise ValueError(
                "%s cuts a different boundary than %s"
                % (tile["instance"], first[0]["instance"])
            )
        if unread:
            continue
        if types(module, owned) != types(module, first[1]):
            raise ValueError(
                "%s has other cells than %s" % (tile["instance"], first[0]["instance"])
            )

    name = spec["module"]
    if name in design["modules"]:
        raise ValueError("module %s exists" % name)
    design["modules"][name] = build_module(module, first[1], first[2], first[3])

    next_bit = [
        1
        + max(
            b
            for c in module["cells"].values()
            for bits in c["connections"].values()
            for b in bits
            if not isinstance(b, str)
        )
    ]
    census = {
        "module": name,
        "tiles": [],
        "types": types(module, first[1]),
        "lec_names": lec_names(module, design["modules"][name], tiles),
    }
    for tile, owned, mapping, ports, ins, outs in tiles:
        census["tiles"].append(
            {
                "instance": tile["instance"],
                "cells": len(owned),
                "registers": sum(
                    1 for n in owned if module["cells"][n]["type"] in FLOPS
                ),
                "pins_in": len(ins),
                "pins_out": len(outs),
            }
        )
        connections = {p: [None] * w for p, (_, w) in first[3].items()}
        for b, (p, i) in mapping.items():
            connections[p][i] = b
        for p, bits in connections.items():
            for i, b in enumerate(bits):
                if b is None:
                    if first[3][p][0] == "output":
                        # an unread output: a net of its own, read by nothing
                        bits[i] = next_bit[0]
                        next_bit[0] += 1
                    elif p in tile.get("tie", []):
                        # a constant input: the first tile's logic with it
                        # tied, which the equivalence test checks
                        bits[i] = "0"
                    else:
                        raise ValueError(
                            "%s: input %s[%d] is not connected"
                            % (tile["instance"], p, i)
                        )
        for n in owned:
            del module["cells"][n]
        module["cells"][tile["instance"]] = {
            "hide_name": 0,
            "type": name,
            "parameters": {},
            "attributes": {},
            "port_directions": {p: d for p, (d, _) in first[3].items()},
            "connections": connections,
        }
    chain(module, design["modules"][name], spec, next_bit)
    census["parent_cells"] = len(module["cells"]) - len(tiles)
    census["parent_registers"] = sum(
        1 for c in module["cells"].values() if c["type"] in FLOPS
    )
    return census


def chain(module, tile_module, spec, next_bit):
    """Pass nets every tile reads from one tile to the next.

    For routing by abutment a macro in the middle of an array cannot reach
    the parent, so the clock and the other nets every tile reads enter one
    tile and leave it again for the next: spec "chain", a list of
    [input port, output port]; a tile's "chain_from", the tile its inputs
    come from. A tile without one reads the parent's net. "south" names
    output ports a tile also passes to the parent's registers named in
    its "south_registers" (net names: the registers fed from them, and
    those fed from those), so a clock that ran through the tiles reaches
    the registers the tiles' results go to. Inside the module an output
    is its input, so after flattening every chained net is the net it was.
    """
    pairs = [tuple(p) for p in spec.get("chain", []) + spec.get("south", [])]
    if not pairs:
        return
    ports = tile_module["ports"]
    for pin, pout in pairs:
        if pin not in ports:
            raise ValueError("chain: the tile has no port %s" % pin)
        ports[pout] = {"direction": "output", "bits": list(ports[pin]["bits"])}
        tile_module["netnames"][pout] = {
            "hide_name": 0,
            "bits": list(ports[pin]["bits"]),
            "attributes": {},
        }
    cells = module["cells"]

    def fresh(n):
        bits = list(range(next_bit[0], next_bit[0] + n))
        next_bit[0] += n
        return bits

    for tile in spec["tiles"]:
        inst = cells[tile["instance"]]
        for pin, pout in pairs:
            inst["port_directions"][pout] = "output"
            inst["connections"].setdefault(pout, None)
    for tile in spec["tiles"]:
        src = tile.get("chain_from")
        inst = cells[tile["instance"]]
        for pin, pout in [tuple(p) for p in spec.get("chain", [])]:
            if src:
                bits = fresh(len(inst["connections"][pin]))
                cells[src]["connections"][pout] = bits
                inst["connections"][pin] = bits
    for tile in spec["tiles"]:
        inst = cells[tile["instance"]]
        for pin, pout in pairs:
            if inst["connections"][pout] is None:
                inst["connections"][pout] = fresh(len(inst["connections"][pin]))
        # the parent's registers downstream of the tile's results take
        # their clock from the tile's south output
        nets = tile.get("south_registers", [])
        if not nets:
            continue
        seen = set()
        for e in nets:
            seen.update(b for b in net_bits(module, e) if not isinstance(b, str))
        regs = []
        grew = True
        while grew:
            grew = False
            for n, c in cells.items():
                if (
                    c["type"] in FLOPS
                    and n not in regs
                    and set(c["connections"]["D"]) & seen
                ):
                    regs.append(n)
                    seen.update(c["connections"]["Q"])
                    grew = True
        for pin, pout in [tuple(p) for p in spec.get("south", [])]:
            for n in regs:
                cells[n]["connections"]["CLK"] = list(inst["connections"][pout])


def lec_names(module, tile_module, tiles):
    """{flattened tile net bit: the reference's name for it}, for every seed bit.

    Every tile is the first tile's module, so after flattening the carved
    design a register of tile c drives a net named after the module's own
    net under c's instance. The k-th seed bit of every tile is the same
    register of the module; the equivalence test names it after tile c's
    own k-th seed bit in the reference.
    """
    first = tiles[0][0]
    out = {}
    # the first tile is its module's own cells: each register's output
    # has the same bit in both, named in each
    for n in tiles[0][1]:
        cell = module["cells"][n]
        if cell["type"] in FLOPS:
            for b in cell["connections"]["Q"]:
                out["%s.%s" % (first["instance"], bit_name(tile_module, b))] = bit_name(
                    module, b
                )
    if len(tiles) == 1:
        return out
    inner = [
        bit_name(tile_module, b) for e in first["seeds"] for b in net_bits(module, e)
    ]
    for tile, _, _, _, _, _ in tiles[1:]:
        # a tile with unread outputs lists the seeds it lacks last, so the
        # seeds it has line up with the first tile's
        gold = [bit_name(module, b) for e in tile["seeds"] for b in net_bits(module, e)]
        for name, g in zip(inner, gold):
            out["%s.%s" % (tile["instance"], name)] = g
    return out


def bit_name(module, bit):
    """`net[i]` for a bit: the first public name, else the first name."""
    best = None
    for name, net in sorted(module["netnames"].items()):
        if bit in net["bits"]:
            cand = (net.get("hide_name", 0), name, net["bits"].index(bit))
            if best is None or cand < best:
                best = cand
    if best is None:
        raise ValueError("bit %s has no name" % bit)
    return "%s[%d]" % (best[1], best[2])


def types(module, owned):
    """{cell type: count}, to tell tiles apart cheaply."""
    count = {}
    for n in owned:
        t = module["cells"][n]["type"]
        count[t] = count.get(t, 0) + 1
    return count


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument(
        "--json", required=True, help="yosys write_json of the flat design"
    )
    parser.add_argument("--top", required=True)
    parser.add_argument(
        "--spec", required=True, action="append", help="carve specs, applied in order"
    )
    parser.add_argument("--out", required=True, help="the carved design, yosys JSON")
    parser.add_argument("--census", required=True, help="cells and pins per tile, JSON")
    parser.add_argument(
        "--gold", help="the design uncarved, registers split per bit, yosys JSON"
    )
    args = parser.parse_args(argv)
    with open(args.json) as f:
        design = json.load(f)
    gold = {}
    censuses = []
    try:
        for i, path in enumerate(args.spec):
            with open(path) as f:
                spec = json.load(f)
            censuses.append(carve(design, args.top, spec, gold if i == 0 else None))
    except ValueError as e:
        print("carve: %s" % e, file=sys.stderr)
        return 1
    # one census: the first spec's, the others' tiles and register names added
    census = dict(censuses[0])
    for c in censuses[1:]:
        census["tiles"] = census["tiles"] + c["tiles"]
        census["lec_names"] = dict(census["lec_names"], **c["lec_names"])
        census["parent_cells"] = c["parent_cells"]
        census["parent_registers"] = c["parent_registers"]
    census["modules"] = [c["module"] for c in censuses]
    with open(args.out, "w") as f:
        json.dump(design, f)
    with open(args.census, "w") as f:
        json.dump(census, f, indent=1, sort_keys=True)
    if args.gold:
        with open(args.gold, "w") as f:
            json.dump(gold, f)
    t = census["tiles"][0]
    print(
        "carve: %d x %s, %d cells, %d registers, %d pins in, %d out; parent %d cells, %d registers"
        % (
            len(census["tiles"]),
            census["module"],
            t["cells"],
            t["registers"],
            t["pins_in"],
            t["pins_out"],
            census["parent_cells"],
            census["parent_registers"],
        )
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
