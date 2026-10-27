"""AUTO_MEMORIES_REGFILES through OpenROAD's generate_ram.

A register-file spec (KEYS below) is translated to
generate_ram_netlist's options, and the generated RAM, a block named
<module>_ram, stands in for the RTL module through a wrapper written in
the module's place: its ports, from the design's yosys JSON, connected
to generate_ram's (clk, rst_n, D0, we0, addr_w0, addr_r0, Q0, ...), an
active-high reset inverted for an active-low flop. The wrapper is
always inlined; the RAM is

- inlined: its netlist follows the wrapper in <module>.v;
- mode netlist: a macro with its periphery unplaced, which
  regfile_dissolve.tcl dissolves after macro placement from
  <module>_ram.v (one instance a line) and <module>_ram.place;
- mode macro: a macro kept to the end.

The flops take the RTL's names where the spec gives them (store_name,
read_reg_name), for equivalence checking: renamed in the database from
generate_ram's own. With `periphery verilog` generate_ram writes the
periphery as a Verilog module, <module>_ram, around the core,
<module>_ram_core, which is then what is inlined or the macro. A macro
kept to the end (mode macro) gets its pins from OpenROAD's pin placer on
the spec's pin layers, its liberty from write_timing_model and its
power from rails on its rows and straps with the VDD and VSS pins
(power_rails, power_layer, power_width, power_pitch, power_offset;
asap7's by default).
"""

from __future__ import annotations

import json
import math
import os
import re
import subprocess
from pathlib import Path

# the longest a word's bits may run in a row before it is folded, um
WORD_SPAN_UM = 150

# the keys a spec may have: a misspelt one is refused, not ignored
KEYS = {
    "module",
    "mode",
    "words",
    "bits",
    "clock",
    "read",
    "read_banked",
    "write",
    "write_priority",
    "write_style",
    "zero_word",
    "banks",
    "bank_columns",
    "bank_order",
    "bank_column_layout",
    "read_latency",
    "bit_folds",
    "async_reset",
    "reset",
    "unused",
    "store_name",
    "read_reg_name",
    "cell",
    "periphery",
    "pin_layer",
    "pin_layer_h",
    "pin_layer_v",
    "tap_columns",
    "service_sites",
    "power_rails",
    "power_rail_width",
    "power_layer",
    "power_width",
    "power_pitch",
    "power_offset",
}

# a spec's `cell <role> <master>` roles, as generate_ram's -cells names them
CELL_ROLES = {
    "inv": "inv",
    "and2": "and2",
    "or2": "or2",
    "ao22": "ao22",
    "aoi22": "aoi22",
    "nand2": "nand2",
    "nor2": "nor2",
    "icg": "clock_gate",
    "tie_hi": "tie",
    "buffer": "buffer",
}


# AUTO_MEMORIES is asap7's
DEFAULT_CELLS = {
    "aoi22": "AOI22xp5_ASAP7_75t_R",
    "nand2": "NAND2xp5_ASAP7_75t_R",
    "nor2": "NOR2x1_ASAP7_75t_R",
    "buffer": "BUFx2_ASAP7_75t_R",
}


def parse(spec: Path) -> list[list[str]]:
    """The spec's lines as [key, value, ...], comments and blanks out."""
    lines = []
    for line in spec.read_text().splitlines():
        words = line.split("#", 1)[0].split()
        if words:
            lines.append(words)
    return lines


def _values(lines: list[list[str]], key: str) -> list[list[str]]:
    return [line[1:] for line in lines if line[0] == key]


def _one(lines: list[list[str]], key: str, default: str = "") -> str:
    values = _values(lines, key)
    return values[-1][0] if values and values[-1] else default


def check(spec: Path) -> None:
    """Refuse a spec with a key this translation does not read."""
    for line in parse(spec):
        if line[0] not in KEYS:
            raise SystemExit(f"regfile_ram: {spec}: unknown key `{line[0]}`")


def _address_bits(words: int) -> int:
    return max(1, math.ceil(math.log2(words)))


def _args(lines: list[list[str]], block: str, shape: str) -> list[str]:
    """generate_ram_netlist's options for the spec."""
    words = int(_one(lines, "words"))
    bits = int(_one(lines, "bits"))
    folds = int(_one(lines, "bit_folds", "1"))
    cells = {line[1]: line[2] for line in lines if line[0] == "cell"}
    async_reset = _values(lines, "async_reset")
    storage = cells.get("flop_r" if async_reset else "flop")
    args = [
        "-name",
        block,
        "-mask_size",
        str(-(-bits // folds)),
        "-word_size",
        str(bits),
        "-num_words",
        str(words),
        "-r_ports",
        str(len(_values(lines, "read"))),
        "-w_ports",
        str(len(_values(lines, "write"))),
        "-write_style",
        _one(lines, "write_style", "mux"),
        # a balanced AND2 tree per word: the row decoder's chain is
        # slower on a register file's read path
        "-decoder",
        "word",
    ]
    if len(_values(lines, "write")) > 1:
        # two ports writing one word in a cycle: OR their data by
        # default, as firtool's register files do
        args += ["-write_priority", _one(lines, "write_priority", "or")]
    if int(_one(lines, "bank_columns", "1")) > 1 and not _values(
        lines, "bank_column_layout"
    ):
        # a row's words each contiguous: interleaved, a word's selects and
        # write enables run the whole row (XiangShan's RobEntryFile: 6,483
        # slew violations in a parent, against 608)
        args += ["-bank_column_layout", "contiguous"]
    if storage:
        args += ["-storage_cell", storage]
    if folds > 1:
        # a word's bits in folds rows, a slice each
        args += ["-bit_folds", str(folds)]
    if _values(lines, "read_banked"):
        args += ["-rb_ports", str(len(_values(lines, "read_banked")))]
    for key in (
        "zero_word",
        "banks",
        "bank_columns",
        "bank_order",
        "bank_column_layout",
    ):
        if _values(lines, key):
            args += [f"-{key}", _one(lines, key)]
    # the spec's read_latency, a key shared with structured_gen's specs,
    # is generate_ram's read address register
    if _values(lines, "read_latency"):
        args += ["-register_read_address", _one(lines, "read_latency")]
    if async_reset:
        args += ["-reset_value", "0"]
    # asap7 cells where the spec names none, and a buffer for the select
    # buffers (the smallest asap7 buffer is the hold buffer HB1xp67)
    cells = DEFAULT_CELLS | cells
    roles = [
        f"{CELL_ROLES[role]} {master}"
        for role, master in cells.items()
        if role in CELL_ROLES
    ]
    if roles:
        args += ["-cells", "{" + " ".join(roles) + "}"]
    # service columns: `service_sites` empty sites after
    # every `tap_columns` storage columns, room for a parent's buffers in
    # the array; 40 by default in a macro kept to the end, else none
    sites = int(_one(lines, "service_sites", "40" if shape == "macro" else "0"))
    if sites > 0:
        every = _one(lines, "tap_columns", "8")
        args += ["-service_columns", f"{{{every} {sites}}}"]
    if _one(lines, "periphery") == "verilog":
        args += ["-periphery", "verilog", "-pin_layer", _one(lines, "pin_layer", "M4")]
    elif shape == "netlist":
        args += ["-periphery", "unplaced", "-pin_layer", _one(lines, "pin_layer", "M4")]
    return args


# The second session's Tcl: the generated block's ports, and for a macro
# its views, from its database.
_VIEWS_TCL = r"""
set block [ord::get_db_block]
set f [open {out}/{block}.ports w]
foreach term [$block getBTerms] {{
  if {{[$term getSigType] in {{POWER GROUND}}}} {{ continue }}
  puts $f "[$term getName] [$term getIoType]"
}}
close $f
"""

_MACRO_TCL = r"""
# the netlist, one instance a line, as regfile_dissolve.tcl reads it
set f [open {out}/{block}.v w]
foreach inst [$block getInsts] {{
  set conns {{}}
  foreach it [$inst getITerms] {{
    set net [$it getNet]
    if {{$net eq "NULL" || [$net getSigType] in {{POWER GROUND}}}} {{ continue }}
    lappend conns ".[[$it getMTerm] getName](\\[$net getName] )"
  }}
  puts $f "[[$inst getMaster] getName] \\[$inst getName] ([join $conns {{, }}]);"
}}
close $f
# where each placed cell is, as the generator laid it out
set f [open {out}/{block}.place w]
foreach inst [$block getInsts] {{
  if {{![$inst isPlaced]}} {{ continue }}
  lassign [$inst getLocation] x y
  puts $f "[$inst getName] $x $y [$inst getOrient]"
}}
close $f
write_abstract_lef {out}/{block}.lef
# a liberty of its area and pins: a blackbox to synthesis
set dbu [[ord::get_db_tech] getDbUnitsPerMicron]
set die [$block getDieArea]
set area [expr {{double([$die dx]) / $dbu * [$die dy] / $dbu}}]
set f [open {out}/{block}.lib w]
puts $f "library({block}) {{"
puts $f "  delay_model : table_lookup;"
puts $f "  time_unit : \"1ns\";"
puts $f "  voltage_unit : \"1V\";"
puts $f "  current_unit : \"1uA\";"
puts $f "  leakage_power_unit : \"1uW\";"
puts $f "  capacitive_load_unit (1,pf);"
puts $f "  pulling_resistance_unit : \"1kohm\";"
set buses [dict create]
foreach term [$block getBTerms] {{
  if {{[$term getSigType] in {{POWER GROUND}}}} {{ continue }}
  set name [$term getName]
  set dir [expr {{[$term getIoType] eq "INPUT" ? "input" : "output"}}]
  if {{[regexp {{^(.*)\[(\d+)\]$}} $name -> base index]}} {{
    set hi [expr {{[dict exists $buses $base] ? max([lindex [dict get $buses $base] 1], $index) : $index}}]
    dict set buses $base [list $dir $hi]
  }} else {{
    dict set buses $name [list $dir -1]
  }}
}}
set widths {{}}
dict for {{name info}} $buses {{
  set hi [lindex $info 1]
  if {{$hi >= 0 && [lsearch $widths [expr {{$hi + 1}}]] < 0}} {{ lappend widths [expr {{$hi + 1}}] }}
}}
foreach w $widths {{
  puts $f "  type ({block}_bus_$w) {{ base_type : array; data_type : bit; bit_width : $w; bit_from : [expr {{$w - 1}}]; bit_to : 0; downto : true; }}"
}}
puts $f "  cell({block}) {{"
puts $f "    area : $area;"
puts $f "    is_macro_cell : true;"
puts $f "    dont_touch : true;"
dict for {{name info}} $buses {{
  lassign $info dir hi
  if {{$hi < 0}} {{
    puts $f "    pin($name) {{ direction : $dir; capacitance : 0.001; }}"
  }} else {{
    puts $f "    bus($name) {{ bus_type : {block}_bus_[expr {{$hi + 1}}]; direction : $dir; capacitance : 0.001; }}"
  }}
}}
puts $f "  }}"
puts $f "}}"
close $f
"""


def _word_at(lines: list[list[str]], row: int, w: int) -> int:
    """The word generate_ram (-decoder word) puts at (row, word in the
    row): RamGen::wordAt."""
    words = int(_one(lines, "words"))
    banks = int(_one(lines, "banks", "1"))
    columns = int(_one(lines, "bank_columns", "1"))
    per_bank = words // banks
    bank = (row // per_bank) * columns + w
    i = row % per_bank
    if _one(lines, "bank_order", "contiguous") == "interleaved":
        return i * banks + bank
    return bank * per_bank + i


def _renames(lines: list[list[str]]) -> list[tuple[str, str]]:
    """generate_ram's flop names to the spec's store_name and
    read_reg_name, the RTL's names for equivalence checking."""
    renames = []
    words = int(_one(lines, "words"))
    bits = int(_one(lines, "bits"))
    columns = int(_one(lines, "bank_columns", "1"))
    store = _one(lines, "store_name")
    per_fold = bits // int(_one(lines, "bit_folds", "1"))
    if store:
        for row in range(words // columns):
            for w in range(columns):
                word = _word_at(lines, row, w)
                if word == int(_one(lines, "zero_word", "-1")):
                    continue
                for bit in range(bits):
                    renames.append(
                        (
                            f"storage_{row}_{w}_{bit // per_fold * per_fold}"
                            f".bit{bit}.bit",
                            store.replace("{word}", str(word)).replace(
                                "{bit}", str(bit)
                            ),
                        )
                    )
    reg = _one(lines, "read_reg_name")
    # (with the periphery as Verilog the address registers are in the
    # wrapper, under generate_ram's names)
    if (
        reg
        and _one(lines, "read_latency", "0") != "0"
        and _one(lines, "periphery") != "verilog"
    ):
        banks = int(_one(lines, "banks", "1"))
        a = _address_bits(words)
        ab = _address_bits(words // banks)
        # generate_ram's ports: writes, then plain reads, then each banked
        # read port's banks; the spec's read ports, plain and banked, in
        # the order it lists them
        first_read = len(_values(lines, "write"))
        plain = len(_values(lines, "read"))
        spec_port = 0
        plain_seen = 0
        banked_seen = 0
        for line in lines:
            if line[0] == "read":
                p = first_read + plain_seen
                plain_seen += 1
                for i in range(a):
                    renames.append(
                        (
                            f"decoder_p{p}.addr_reg_p{p}_a{i}",
                            reg.replace("{port}", str(spec_port))
                            .replace("{bank}", "0")
                            .replace("{bit}", str(i)),
                        )
                    )
                spec_port += 1
            elif line[0] == "read_banked":
                for b in range((len(line) - 1) // 2):
                    p = first_read + plain + banked_seen * banks + b
                    for i in range(ab):
                        renames.append(
                            (
                                f"decoder_p{p}.addr_reg_p{p}_a{i}",
                                reg.replace("{port}", str(spec_port))
                                .replace("{bank}", str(b))
                                .replace("{bit}", str(i)),
                            )
                        )
                banked_seen += 1
                spec_port += 1
    return renames


def _module_ports(yosys_json: Path, module: str) -> dict[str, tuple[str, int]]:
    """The RTL module's ports, name -> (direction, width), from the
    design's yosys JSON; empty where it does not have the module."""
    if not yosys_json.exists():
        return {}
    modules = json.loads(yosys_json.read_text()).get("modules", {})
    for name, body in modules.items():
        if name.lstrip("\\") == module:
            return {
                port: (info["direction"], len(info["bits"]))
                for port, info in body.get("ports", {}).items()
            }
    return {}


def _buses(port_lines: list[str]) -> dict[str, tuple[str, int]]:
    """generate_ram's ports, base name -> (direction, width)."""
    buses: dict[str, tuple[str, int]] = {}
    for line in port_lines:
        name, io = line.split()
        base, width = name, 1
        if name.endswith("]") and "[" in name:
            base = name[: name.rindex("[")]
            width = int(name[name.rindex("[") + 1 : -1]) + 1
        direction = "input" if io == "INPUT" else "output"
        old = buses.get(base, (direction, 0))[1]
        buses[base] = (direction, max(old, width))
    return buses


def _wrapper(
    lines: list[list[str]],
    module: str,
    block: str,
    ram_ports: dict[str, tuple[str, int]],
    rtl_ports: dict[str, tuple[str, int]],
) -> str:
    """The module the RTL's stands in for: its ports to generate_ram's."""
    words = int(_one(lines, "words"))
    bits = int(_one(lines, "bits"))
    banks = int(_one(lines, "banks", "1"))
    conns: dict[str, str] = {}
    widths: dict[str, tuple[str, int]] = {}

    def port(name: str, direction: str, width: int) -> str:
        widths.setdefault(name, rtl_ports.get(name, (direction, width)))
        return name

    def fit(name: str, width: int) -> str:
        """An RTL address as wide as generate_ram's."""
        have = widths[name][1]
        if have == width:
            return name
        if have > width:
            return f"{name}[{width - 1}:0]"
        return f"{{{width - have}'b0, {name}}}"

    conns["clk"] = port(_one(lines, "clock", "clock"), "input", 1)
    # ports the RTL has and the array ignores, any number a line
    for key in ("reset", "unused"):
        for values in _values(lines, key):
            for name in values:
                port(name, "input", 1)
    for values in _values(lines, "async_reset"):
        name = port(values[0], "input", 1)
        low = values[1] == "low" if len(values) > 1 else True
        if "rst_n" in ram_ports:
            conns["rst_n"] = name if low else f"~{name}"
        else:
            conns["rst"] = f"~{name}" if low else name
    reads = _values(lines, "read")
    a = _address_bits(words)
    for i, (addr, data) in enumerate(reads):
        conns[f"addr_r{i}"] = fit(port(addr, "input", a), a)
        conns["Q" if len(reads) == 1 else f"Q{i}"] = port(data, "output", bits)
    writes = _values(lines, "write")
    for w, values in enumerate(writes):
        suffix = "" if len(writes) == 1 else str(w)
        conns[f"addr_w{suffix}"] = fit(port(values[0], "input", a), a)
        conns[f"D{suffix}"] = port(values[1], "input", bits)
        conns[f"we{suffix}"] = (
            port(values[2], "input", 1) if len(values) > 2 else "1'b1"
        )
    ab = _address_bits(words // banks)
    for k, values in enumerate(_values(lines, "read_banked")):
        for b in range(len(values) // 2):
            conns[f"addr_rb{k}_b{b}"] = fit(port(values[2 * b], "input", ab), ab)
            conns[f"Qrb{k}_b{b}"] = port(values[2 * b + 1], "output", bits)
    for name in ram_ports:
        if name not in conns:
            raise SystemExit(
                f"regfile_ram: {module}: generate_ram's port {name} has no "
                "counterpart in the spec"
            )
    # the spec's ports are the module's: a stray or missing one would be
    # left unconnected in the parent, not refused
    if rtl_ports:
        stray = sorted(set(widths) - set(rtl_ports))
        missing = sorted(set(rtl_ports) - set(widths))
        if stray or missing:
            raise SystemExit(
                f"regfile_ram: {module}: the spec's ports are not the "
                f"module's: not in the module {stray}, not in the spec "
                f"{missing} (list ports the array ignores with `unused`)"
            )
        data = [values[1] for values in reads + writes] + [
            name for values in _values(lines, "read_banked") for name in values[1::2]
        ]
        for name in data:
            if rtl_ports[name][1] != bits:
                raise SystemExit(
                    f"regfile_ram: {module}: {name} is "
                    f"{rtl_ports[name][1]} bits, the spec's words {bits}"
                )
    # the RTL's ports in its own order where the JSON has them
    order = list(rtl_ports) or list(widths)
    for name in widths:
        if name not in order:
            order.append(name)
    decl = []
    for name in order:
        direction, width = widths[name] if name in widths else rtl_ports[name]
        decl.append(f"  {direction} {'' if width == 1 else f'[{width - 1}:0] '}{name}")
    body = ",\n".join(decl)
    inst = ",\n".join(f"    .{p}({c})" for p, c in conns.items())
    return (
        f"// generated by regfile_ram.py: {module} as generate_ram's {block}\n"
        f"module {module} (\n{body}\n);\n  {block} ram (\n{inst}\n  );\nendmodule\n"
    )


def _module_header_ports(verilog: str, module: str) -> dict[str, tuple[str, int]]:
    """A module's ports, name -> (direction, width), from its header."""
    body = verilog[verilog.index(f"module {module} (") :]
    body = body[: body.index(");")]
    ports = {}
    for line in body.splitlines():
        words = line.strip().rstrip(",").split()
        if words and words[0] in ("input", "output"):
            width = 1
            if len(words) == 3 and words[1].startswith("["):
                width = int(words[1][1 : words[1].index(":")]) + 1
            ports[words[-1]] = (words[0], width)
    return ports


def generate(
    spec: Path,
    module: str,
    shape: str,
    openroad: str,
    lefs: list[Path],
    out_dir: Path,
) -> dict:
    """Build the spec's RAM, shape inline, netlist or macro; return what
    the flow lists: the block, and whether it is a macro and dissolves."""
    lines = parse(spec)
    ram = f"{module}_ram"
    # -periphery verilog: the block is the core, the periphery a module
    verilog_periphery = _one(lines, "periphery") == "verilog"
    block = f"{ram}_core" if verilog_periphery else ram
    periphery_v = out_dir / f"{ram}.periphery.v"
    libs = os.environ.get("LIB_FILES", "").split()
    if not libs:
        raise SystemExit("regfile_ram: generate_ram needs LIB_FILES")
    reads = "".join(f"read_liberty {lib}\n" for lib in libs)
    gen = out_dir / f"{module}.generate.tcl"
    outline = out_dir / f"{block}.outline"

    def build(spec_lines: list[list[str]]) -> tuple[float, float]:
        gen.write_text(
            reads
            + "".join(f"read_lef {lef}\n" for lef in lefs)
            + "generate_ram_netlist "
            + " ".join(_args(spec_lines, ram, shape))
            + (f" -wrapper_verilog {periphery_v}" if verilog_periphery else "")
            + f"\nwrite_db {out_dir / f'{block}.odb'}\n"
            + "set die [[ord::get_db_block] getDieArea]\n"
            + f"set f [open {outline} w]\n"
            + 'puts $f "[$die dx] [$die dy] [[ord::get_db_tech] getDbUnitsPerMicron]"\n'
            + "close $f\n"
        )
        subprocess.check_call([openroad, "-exit", "-no_init", "-no_splash", str(gen)])
        width, height, _ = outline.read_text().split()
        return float(width), float(height)

    width, height = build(lines)
    # where the spec names no folds, fold a word into a power of two of
    # rows while
    #
    # - the array is more than 8 times as wide as tall, toward the square
    #   (XiangShan's IntRegFile, 12 reads and 9 writes, 48 to one); a strip
    #   of a few to one can be the shape that fits (riscv32i's, 6, sits
    #   under its FakeRAMs), so that alone does not fold;
    # - or one word's bits span more than WORD_SPAN_UM: its selects and
    #   write enables, driven from one cell, are that long, and a parent
    #   buffers them inside the full array, where nothing legalizes
    #   (XiangShan's RenameBufferFile, a word a row 258 um wide, failed;
    #   RobEntryFile at 74 um and IntRegFile at 96 um a word did not).
    #
    # A spec names bit_folds to choose.
    bits = int(_one(lines, "bits"))
    dbu = float(outline.read_text().split()[2])
    # the words side by side in a row, each contiguous (see _args) unless
    # the spec interleaves them, when a word spans the row
    row_words = (
        int(_one(lines, "bank_columns", "1"))
        if _one(lines, "bank_column_layout", "contiguous") == "contiguous"
        else 1
    )
    span_um = width / dbu / row_words
    if not _values(lines, "bit_folds"):
        folds = 1
        # a short last fold is allowed, an empty one is not
        while (
            folds * 2 <= bits
            and (folds * 2 - 1) * -(-bits // (folds * 2)) < bits
            and (
                (width > 8 * height and (folds * 2) ** 2 <= 2 * width / height)
                or span_um / folds > WORD_SPAN_UM
            )
        ):
            folds *= 2
        if folds > 1:
            lines = lines + [["bit_folds", str(folds)]]
            build(lines)
    views = out_dir / f"{module}.views.tcl"
    tcl = reads + f"read_db {out_dir / f'{block}.odb'}\n"
    # the RTL's flop names, for equivalence checking
    renames = _renames(lines)
    if renames:
        (out_dir / f"{block}.renames").write_text(
            "".join(f"{{{old}}} {{{new}}}\n" for old, new in renames)
        )
        tcl += (
            f"set f [open {out_dir / f'{block}.renames'} r]\n"
            "while {[gets $f line] >= 0} {\n"
            "  lassign $line old new\n"
            "  set inst [[ord::get_db_block] findInst $old]\n"
            '  if {$inst eq "NULL"} { error "regfile_ram: no $old to name $new" }\n'
            "  $inst rename $new\n"
            "}\n"
            "close $f\n"
        )
    tcl += _VIEWS_TCL.format(out=out_dir, block=block)
    if shape == "inline":
        tcl += f"write_verilog {out_dir / f'{block}.netlist.v'}\n"
    else:
        if shape == "macro":
            # a macro kept to the end: its pins on its edges, by the pin
            # placer
            h = _one(lines, "pin_layer", _one(lines, "pin_layer_h", "M4"))
            v = _one(lines, "pin_layer_v", "M5")
            # tracks on the two pin layers, from their own pitch
            for layer in (h, v):
                tcl += (
                    f"set l [[ord::get_db_tech] findLayer {layer}]\n"
                    "set u [[ord::get_db_tech] getDbUnitsPerMicron]\n"
                    "set p [expr {double([$l getPitch]) / $u}]\n"
                    "set o [expr {double([$l getOffset]) / $u}]\n"
                    f"make_tracks {layer} -x_offset $o -x_pitch $p"
                    " -y_offset $o -y_pitch $p\n"
                )
            # its power, as a hardened block's: rails on the rows, straps
            # with the VDD and VSS pins the parent's grid connects to
            # (asap7's BLOCK_grid_strategy.tcl, without its ring)
            rails = (_values(lines, "power_rails") or [["M1", "M2"]])[-1]
            rail_w = _one(lines, "power_rail_width", "0.018")
            strap = _one(lines, "power_layer", "M5")
            strap_w = _one(lines, "power_width", "0.12")
            pitch = _one(lines, "power_pitch", "2.976")
            offset = _one(lines, "power_offset", "1.5")
            tcl += (
                "set block [ord::get_db_block]\n"
                "foreach {name type} {VDD POWER VSS GROUND} {\n"
                "  set net [$block findNet $name]\n"
                '  if {$net eq "NULL"} { set net [odb::dbNet_create $block $name] }\n'
                "  $net setSpecial\n"
                "  $net setSigType $type\n"
                "}\n"
                "add_global_connection -net VDD -inst_pattern {.*}"
                " -pin_pattern {^VDD$} -power\n"
                "add_global_connection -net VSS -inst_pattern {.*}"
                " -pin_pattern {^VSS$} -ground\n"
                "global_connect\n"
                "set_voltage_domain -name CORE -power VDD -ground VSS\n"
                f"define_pdn_grid -name block -voltage_domains CORE -pins {strap}\n"
            )
            for rail in rails:
                tcl += (
                    f"add_pdn_stripe -grid block -layer {rail} -width {rail_w}"
                    " -followpins\n"
                )
            tcl += (
                f"add_pdn_stripe -grid block -layer {strap} -width {strap_w}"
                f" -pitch {pitch} -offset {offset} -extend_to_boundary\n"
            )
            for lo, hi in zip(rails + [strap], rails[1:] + [strap]):
                if lo != hi:
                    tcl += f"add_pdn_connect -grid block -layers {{{lo} {hi}}}\n"
            tcl += "pdngen\n"
            tcl += f"place_pins -hor_layers {h} -ver_layers {v}\n"
        tcl += _MACRO_TCL.format(out=out_dir, block=block)
        if shape == "macro":
            # and its timing, the block's own, for the parent's STA
            clock = "clk"
            tcl += (
                f"create_clock -name {clock} -period 1 [get_ports {clock}]\n"
                "estimate_parasitics -placement\n"
                f"write_timing_model {out_dir / f'{block}.lib'}\n"
            )
    views.write_text(tcl)
    subprocess.check_call([openroad, "-exit", "-no_init", "-no_splash", str(views)])
    if shape == "macro":
        # write_timing_model states no area; the flow costs a macro by it
        width, height, dbu = (float(v) for v in outline.read_text().split())
        lib = out_dir / f"{block}.lib"
        text = lib.read_text()
        text = re.sub(
            r"(cell\s*\(\s*\\?\"?" + re.escape(block) + r"\"?\s*\)\s*\{)",
            lambda m: m.group(1) + f"\n    area : {width * height / dbu / dbu:.4f};",
            text,
            count=1,
        )
        lib.write_text(text)
    core_ports = _buses((out_dir / f"{block}.ports").read_text().splitlines())
    ram_ports = core_ports
    periphery = ""
    if verilog_periphery:
        periphery = periphery_v.read_text()
        ram_ports = _module_header_ports(periphery, ram)
    rtl_ports = _module_ports(out_dir.parent / "memories_inferred.json", module)
    wrapper = _wrapper(lines, module, ram, ram_ports, rtl_ports)
    if periphery:
        wrapper += "\n" + periphery
    if shape == "inline":
        wrapper += "\n" + (out_dir / f"{block}.netlist.v").read_text()
    else:
        # the macro, a blackbox to synthesis
        decl = ",\n".join(
            f"  {d} {'' if w == 1 else f'[{w - 1}:0] '}{n}"
            for n, (d, w) in core_ports.items()
        )
        wrapper += f"\n(* blackbox *)\nmodule {block} (\n{decl}\n);\nendmodule\n"
    (out_dir / f"{module}.v").write_text(wrapper)
    return {
        "block": block,
        "macro": shape != "inline",
        "dissolve": shape == "netlist",
    }
