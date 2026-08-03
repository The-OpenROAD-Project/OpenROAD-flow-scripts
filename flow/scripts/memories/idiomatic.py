#!/usr/bin/env python3
"""Decide which detected memories are idiomatic as ASAP7 SRAM macros.

A memory below these floors is cheaper as flip-flops than as an SRAM
macro (the macro pays a fixed control/decode/sense-amp floor), and a
memory with too many ports has no single-macro implementation in
ordinary SRAM compilers. Rejected memories keep `idiomatic: false` plus
a reason in memories.json and synthesize as flops.

The thresholds are deliberately simple, first-pass policy. Banking and
multi-port decomposition (splitting a too-wide/too-ported memory across
several macros) are not handled — a future extension. A user who wants
a rejected memory converted anyway overrides it via a `.memories` file
listed in ADDITIONAL_MEMORIES.
"""

from __future__ import annotations

import schema

MIN_ROWS = 16
MIN_BITS_TOTAL = 256
MAX_TOTAL_PORTS = 4


def judge(mem: schema.Memory) -> tuple[bool, str]:
    """Return (idiomatic, reason)."""
    if mem.bits < 1:
        return False, "no data pins"
    if mem.rows < MIN_ROWS:
        return False, f"depth {mem.rows} below macro floor {MIN_ROWS}"
    total_bits = mem.rows * mem.bits
    if total_bits < MIN_BITS_TOTAL:
        return (
            False,
            f"capacity {total_bits} bits below macro floor " f"{MIN_BITS_TOTAL}",
        )
    if mem.total_ports() > MAX_TOTAL_PORTS:
        return (
            False,
            f"{mem.total_ports()} ports exceeds single-macro "
            f"limit {MAX_TOTAL_PORTS}",
        )
    return True, "meets ASAP7 macro floors"


def apply(memories: list[schema.Memory]) -> None:
    for mem in memories:
        mem.idiomatic, mem.reason = judge(mem)
