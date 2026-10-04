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


def enclosing_module(mem: schema.Memory) -> str | None:
    """The module whose body simulates this memory, demangled.

    yosys writes a parameterized module as "$paramod$<hash>\\<name>" or
    "$paramod\\<name>\\<param>=<value>"; the module is the component after
    the first backslash in both forms.
    """
    model = mem.behavioral_model or {}
    module = model.get("module")
    if not module:
        return None
    if module.startswith("$paramod"):
        parts = module.split("\\")
        return parts[1] if len(parts) > 1 else None
    return module.lstrip("\\")


def judge(mem: schema.Memory) -> tuple[bool, str]:
    """Return (idiomatic, reason)."""
    # Only a memory that *is* a module can be converted: conversion works
    # by blackboxing the module so the generated liberty view replaces its
    # behavioral body. A memory inferred inside a larger module has no
    # module to blackbox, so converting it would generate a macro nothing
    # instantiates and report a conversion that did not happen.
    enclosing = enclosing_module(mem)
    if enclosing is not None and enclosing != mem.name:
        return (
            False,
            f"inferred inside module {enclosing} rather than being one; "
            "an inline array is the design asking for flip-flops. "
            "Instantiate the memory as its own module to convert it",
        )
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
