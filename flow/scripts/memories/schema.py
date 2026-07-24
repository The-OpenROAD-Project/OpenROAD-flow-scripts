#!/usr/bin/env python3
"""The `.memories` file format: a JSON inventory of memory macros.

One `.memories` file (and the flow-generated `memories.json`) describes
memories at the module boundary: geometry, the full pin list with each
pin's function, the behavioral model the RTL provides, and whether the
memory is converted to a macro (`idiomatic`).

The file-based handoff is deliberate: everything downstream — synthesis
blackboxing, liberty/LEF consumption in later stages, build systems that
declare flow artifacts as transitive dependencies — keys off these files
rather than off in-process state.
"""

from __future__ import annotations

import json
from dataclasses import asdict, dataclass, field
from pathlib import Path

SCHEMA_VERSION = 1

PIN_FUNCTIONS = ("addr", "en", "wmode", "mask", "data_in", "data_out", "clk")
DIRECTIONS = ("input", "output")


class SchemaError(ValueError):
    pass


@dataclass
class Pin:
    name: str
    direction: str  # "input" / "output"
    width: int
    port_id: str  # "R0", "W1", "RW0", ...
    function: str  # one of PIN_FUNCTIONS


@dataclass
class Memory:
    name: str
    rows: int = 0
    bits: int = 0
    addr_w: int = 0
    read_ports: int = 0
    write_ports: int = 0
    rw_ports: int = 0
    # Total width of the per-port write mask, 0 if unmasked. Subword-split
    # mask pins (`W0_mask_0..3`) contribute one lane each.
    mask_lanes: int = 0
    pins: list[Pin] = field(default_factory=list)
    # The module whose RTL body simulates this memory: {"file", "module"}.
    behavioral_model: dict | None = None
    # True when the memory is converted to a macro (.lib/.lef emitted and
    # the module blackboxed); False leaves it to synthesize as flops.
    idiomatic: bool = False
    reason: str = ""

    def total_ports(self) -> int:
        return self.read_ports + self.write_ports + self.rw_ports

    def to_dict(self) -> dict:
        return asdict(self)


def _pin_from_dict(d: dict) -> Pin:
    try:
        pin = Pin(
            name=d["name"],
            direction=d["direction"],
            width=int(d["width"]),
            port_id=d["port_id"],
            function=d["function"],
        )
    except KeyError as e:
        raise SchemaError(f"pin record missing field {e}") from e
    if pin.direction not in DIRECTIONS:
        raise SchemaError(f"pin {pin.name}: bad direction '{pin.direction}'")
    if pin.function not in PIN_FUNCTIONS:
        raise SchemaError(
            f"pin {pin.name}: unknown function "
            f"'{pin.function}' (expected one of "
            f"{', '.join(PIN_FUNCTIONS)})"
        )
    if pin.width < 1:
        raise SchemaError(f"pin {pin.name}: width must be >= 1")
    if not pin.port_id:
        raise SchemaError(f"pin {pin.name}: empty port_id")
    return pin


def memory_from_dict(d: dict) -> Memory:
    if "name" not in d:
        raise SchemaError("memory record missing 'name'")
    mem = Memory(name=d["name"])
    for key in (
        "rows",
        "bits",
        "addr_w",
        "read_ports",
        "write_ports",
        "rw_ports",
        "mask_lanes",
    ):
        if key in d:
            setattr(mem, key, int(d[key]))
    if "pins" in d:
        mem.pins = [_pin_from_dict(p) for p in d["pins"]]
    if "behavioral_model" in d:
        mem.behavioral_model = d["behavioral_model"]
    if "idiomatic" in d:
        mem.idiomatic = bool(d["idiomatic"])
    if "reason" in d:
        mem.reason = str(d["reason"])
    return mem


def load(path: Path) -> list[Memory]:
    """Load a .memories / memories.json file."""
    try:
        doc = json.loads(path.read_text())
    except json.JSONDecodeError as e:
        raise SchemaError(f"{path}: not valid JSON: {e}") from e
    if not isinstance(doc, dict) or "memories" not in doc:
        raise SchemaError(f"{path}: expected an object with a 'memories' list")
    version = doc.get("version", SCHEMA_VERSION)
    if version != SCHEMA_VERSION:
        raise SchemaError(f"{path}: unsupported schema version {version}")
    return [memory_from_dict(m) for m in doc["memories"]]


def dump(memories: list[Memory], path: Path, platform: str) -> None:
    doc = {
        "version": SCHEMA_VERSION,
        "platform": platform,
        "memories": [m.to_dict() for m in sorted(memories, key=lambda m: m.name)],
    }
    path.write_text(json.dumps(doc, indent=2) + "\n")


def merge(detected: list[Memory], overrides: list[Memory]) -> list[Memory]:
    """Merge user-supplied entries onto the detected set.

    An override naming a detected memory replaces only the fields it
    carries (geometry and pins are kept from detection unless the
    override provides its own). An override naming an unknown memory is
    taken whole — it must then carry pins and geometry itself to be
    emittable.
    """
    by_name = {m.name: m for m in detected}
    for o in overrides:
        base = by_name.get(o.name)
        if base is None:
            by_name[o.name] = o
            continue
        if o.pins:
            base.pins = o.pins
        for key in (
            "rows",
            "bits",
            "addr_w",
            "read_ports",
            "write_ports",
            "rw_ports",
            "mask_lanes",
        ):
            value = getattr(o, key)
            if value:
                setattr(base, key, value)
        if o.behavioral_model is not None:
            base.behavioral_model = o.behavioral_model
        base.idiomatic = o.idiomatic
        if o.reason:
            base.reason = o.reason
    return list(by_name.values())


def validate_emittable(mem: Memory) -> None:
    """Raise SchemaError unless `mem` carries enough to emit .lib/.lef."""
    if not mem.pins:
        raise SchemaError(f"memory {mem.name}: no pins")
    if mem.rows < 1 or mem.bits < 1:
        raise SchemaError(
            f"memory {mem.name}: rows ({mem.rows}) and bits ({mem.bits}) "
            f"must be >= 1"
        )
    port_ids = {p.port_id for p in mem.pins}
    for port_id in port_ids:
        functions = {p.function for p in mem.pins if p.port_id == port_id}
        if "clk" not in functions:
            raise SchemaError(f"memory {mem.name}: port {port_id} has no clk pin")
        if "addr" not in functions:
            raise SchemaError(f"memory {mem.name}: port {port_id} has no addr pin")
        if not functions & {"data_in", "data_out"}:
            raise SchemaError(f"memory {mem.name}: port {port_id} has no data pin")
