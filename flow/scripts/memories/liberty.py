#!/usr/bin/env python3
"""Emit a Liberty (.lib) view for a memory macro.

The structural shape (bus() umbrellas WITH per-bit pin() siblings,
quoted simple type names, per-port clock pins carrying
min/max_clock_tree_path arcs) follows what OpenROAD's abstract writer
produces for a hardened block. The per-bit pins are load-bearing: a
bus() block without per-bit pin records makes yosys's bus elaboration
silently drop bit connections at parent instances of the macro, leaving
the synthesized parent with only scalar clk/en pins on every memory.

internal_power() records use power_lut_template — OpenSTA's
report_power -saif looks power templates up in the power-template
registry, and a power table declared under lu_table_template is
silently read as zero.

Timing values come from simple parametric predictors (log2(rows) decode
depth, √bits bit-line/sense scaling), conservative and monotonic. Two
variants are emitted per memory: the regular .lib with a predicted
clock-tree insertion delay, and a _pre_layout.lib with ideal clock
(insertion = 0) for pre-CTS consumers.
"""

from __future__ import annotations

import math
import re

import schema
import sram_area_model
from pdk_asap7 import PdkParams

_FUNCTION_ORDER = {
    "addr": 0,
    "en": 1,
    "wmode": 2,
    "mask": 3,
    "data_in": 4,
    "data_out": 5,
    "clk": 6,
}
_SUBWORD_INDEX_RE = re.compile(r"_(\d+)$")


def _subword_index(name: str) -> int:
    m = _SUBWORD_INDEX_RE.search(name)
    return int(m.group(1)) if m else -1


def ordered_port_groups(mem: schema.Memory) -> list[tuple[str, list[schema.Pin]]]:
    """Group pins by port id, in canonical order.

    Ports are ordered R, W, RW by index; pins within a port follow the
    firtool convention order (addr, en, wmode, mask, data, clk), with
    subword-split pins ordered by their index.
    """
    groups: dict[str, list[schema.Pin]] = {}
    for p in mem.pins:
        groups.setdefault(p.port_id, []).append(p)

    def port_key(port_id: str) -> tuple[int, int]:
        if port_id.startswith("RW"):
            return (2, int(port_id[2:]))
        if port_id.startswith("R"):
            return (0, int(port_id[1:]))
        return (1, int(port_id[1:]))

    out: list[tuple[str, list[schema.Pin]]] = []
    for port_id in sorted(groups, key=port_key):
        pins = sorted(
            groups[port_id],
            key=lambda p: (_FUNCTION_ORDER[p.function], _subword_index(p.name), p.name),
        )
        out.append((port_id, pins))
    return out


def _is_bus(pin: schema.Pin) -> bool:
    return pin.width > 1 and pin.function in ("addr", "data_in", "data_out", "mask")


# ---------------------------------------------------------------------------
# Parametric predictors (picoseconds, µm², fJ, pW).
# ---------------------------------------------------------------------------


def _scale_tech(tech_nm: int) -> float:
    return tech_nm / 7.0


def predict_access_ps(rows: int, bits: int, ports_total: int, tech_nm: int) -> float:
    s = _scale_tech(tech_nm)
    rows_eff = max(rows, 2)
    bits_eff = max(bits, 1)
    # Decoder + bitline + sense amp scaling.
    base = 80.0 * s
    base += 8.0 * s * math.log2(rows_eff)
    base += 3.0 * s * math.sqrt(bits_eff)
    base += 2.0 * s * max(ports_total - 1, 0)
    return base


def predict_setup_ps(tech_nm: int) -> float:
    return 12.0 * _scale_tech(tech_nm)


def predict_hold_ps(tech_nm: int) -> float:
    return 6.0 * _scale_tech(tech_nm)


def predict_transition_ps(tech_nm: int) -> float:
    return 7.0 * _scale_tech(tech_nm)


def predict_clk_period_ps(
    rows: int, bits: int, ports_total: int, tech_nm: int
) -> float:
    return max(
        predict_access_ps(rows, bits, ports_total, tech_nm)
        + predict_setup_ps(tech_nm)
        + 30.0,
        150.0 * _scale_tech(tech_nm),
    )


def predict_ck_insertion_ps(tech_nm: int) -> float:
    return 80.0 * _scale_tech(tech_nm)


def predict_area_um2(mem: schema.Memory, tech_nm: int) -> float:
    return sram_area_model.sram_area_um2(
        rows=max(mem.rows, 1),
        cols=max(mem.bits, 1),
        # An RW port counts as both a read and a write port for the
        # multi-port factor.
        read_ports=mem.read_ports + mem.rw_ports,
        write_ports=mem.write_ports + mem.rw_ports,
        tech_nm=tech_nm,
        write_mask_lanes=mem.mask_lanes,
    )


def predict_dimensions_um(area_um2: float) -> tuple[float, float]:
    return sram_area_model.sram_dimensions_um(area_um2, aspect_ratio=0.5)


def predict_read_energy_fj(rows: int, bits: int, tech_nm: int) -> float:
    s = _scale_tech(tech_nm)
    return (1.5 + 0.25 * math.log2(max(rows, 2))) * max(bits, 1) * s


def predict_write_energy_fj(rows: int, bits: int, tech_nm: int) -> float:
    s = _scale_tech(tech_nm)
    return (2.5 + 0.30 * math.log2(max(rows, 2))) * max(bits, 1) * s


def predict_leakage_pw(rows: int, bits: int, ports_total: int, tech_nm: int) -> float:
    s = _scale_tech(tech_nm)
    rows_eff = max(rows, 2)
    bits_eff = max(bits, 1)
    # Leakage scales with bitcell count + sense amp count per port.
    return (rows_eff * bits_eff * 0.05 + ports_total * bits_eff * 2.0) * s


# ---------------------------------------------------------------------------
# .lib emit
# ---------------------------------------------------------------------------


def emit_lib(
    mem: schema.Memory, params: PdkParams, *, ck_insertion_ps: float | None = None
) -> str:
    """Return Liberty text for `mem`.

    `ck_insertion_ps` overrides the predicted clock-tree insertion
    delay. Pass 0.0 for the pre-layout (ideal-clock) variant; None for
    the default prediction.
    """
    name = mem.name
    tech_nm = params.tech_nm
    ports_total = mem.total_ports()

    access_ps = predict_access_ps(mem.rows, mem.bits, ports_total, tech_nm)
    setup_ps = predict_setup_ps(tech_nm)
    hold_ps = predict_hold_ps(tech_nm)
    trans_ps = predict_transition_ps(tech_nm)
    clk_period_ps = predict_clk_period_ps(mem.rows, mem.bits, ports_total, tech_nm)
    ck_ins_ps = (
        ck_insertion_ps
        if ck_insertion_ps is not None
        else predict_ck_insertion_ps(tech_nm)
    )
    area = predict_area_um2(mem, tech_nm)
    leak_pw = predict_leakage_pw(mem.rows, mem.bits, ports_total, tech_nm)
    read_e = predict_read_energy_fj(mem.rows, mem.bits, tech_nm)
    write_e = predict_write_energy_fj(mem.rows, mem.bits, tech_nm)
    avg_edge_e = (read_e + write_e) / 2.0
    per_bit_e = max(read_e / max(mem.bits, 1), 0.5)

    groups = ordered_port_groups(mem)

    lines: list[str] = []
    a = lines.append

    a(f"library ({name}) {{")
    a('  comment                        : "";')
    a("  delay_model                    : table_lookup;")
    a("  simulation                     : false;")
    a("  capacitive_load_unit (1,fF);")
    a("  leakage_power_unit             : 1pW;")
    a('  current_unit                   : "1mA";')
    a('  pulling_resistance_unit        : "1kohm";')
    a('  time_unit                      : "1ps";')
    a('  voltage_unit                   : "1v";')
    a("  library_features(report_delay_calculation);")
    a("")
    a("  input_threshold_pct_rise : 50;")
    a("  input_threshold_pct_fall : 50;")
    a("  output_threshold_pct_rise : 50;")
    a("  output_threshold_pct_fall : 50;")
    a("  slew_lower_threshold_pct_rise : 10;")
    a("  slew_lower_threshold_pct_fall : 10;")
    a("  slew_upper_threshold_pct_rise : 90;")
    a("  slew_upper_threshold_pct_fall : 90;")
    a("  slew_derate_from_library : 1.0;")
    a("")
    a("")
    a("  nom_process                    : 1.0;")
    a("  nom_temperature                : 0.0;")
    a(f"  nom_voltage                    : {params.nom_voltage};")
    a("")
    a(f"  default_cell_leakage_power : {leak_pw:.6g};")
    a(f"  default_max_transition : {trans_ps * 4:.6g};")
    a("")
    a("  lu_table_template(template_1) {")
    a("    variable_1 : total_output_net_capacitance;")
    a('    index_1("1.0, 2.0");')
    a("  }")
    a("  lu_table_template(constraint_template) {")
    a("    variable_1 : related_pin_transition;")
    a("    variable_2 : constrained_pin_transition;")
    a('    index_1("0.001, 0.1");')
    a('    index_2("0.001, 0.1");')
    a("  }")
    a("  power_lut_template(power_template) {")
    a("    variable_1 : input_transition_time;")
    a('    index_1("0.001, 0.1");')
    a("  }")

    # type ("name") — quoted simple pin name, NOT scoped.
    for _port_id, pins in groups:
        for pin in pins:
            if _is_bus(pin):
                a(f'  type ("{pin.name}") {{')
                a("    base_type : array;")
                a("    data_type : bit;")
                a(f"    bit_width : {pin.width};")
                a(f"    bit_from : {pin.width - 1};")
                a("    bit_to : 0;")
                a("  }")

    a(f'  cell ("{name}") {{')
    a(f"    area : {area:.4f};")
    a("    interface_timing : true;")
    a("    memory() {")
    a("      type : ram;")
    a(f"      address_width : {max(mem.addr_w, 1)};")
    a(f"      word_width : {max(mem.bits, 1)};")
    a("    }")
    # PG-as-input pins keep the parent's PDN checker quiet.
    a('    pin ("VDD") {')
    a("      direction : input;")
    a("      capacitance : 0.0000;")
    a("    }")
    a('    pin ("VSS") {')
    a("      direction : input;")
    a("      capacitance : 0.0000;")
    a("    }")

    for _port_id, pins in groups:
        clk_pins = [p for p in pins if p.function == "clk"]
        clk_pn = clk_pins[0].name
        a(f'    pin ("{clk_pn}") {{')
        a("      direction : input;")
        a("      clock : true;")
        a("      capacitance : 2;")
        a(f"      min_period : {clk_period_ps:.4f};")
        a("      internal_power() {")
        a('        when : "1";')
        a("        rise_power(power_template) {")
        a(f'          values ("{avg_edge_e:.4f}, {avg_edge_e:.4f}");')
        a("        }")
        a("        fall_power(power_template) {")
        a(f'          values ("{avg_edge_e:.4f}, {avg_edge_e:.4f}");')
        a("        }")
        a("      }")
        for ttype in ("min_clock_tree_path", "max_clock_tree_path"):
            a("      timing() {")
            a("        timing_sense : positive_unate;")
            a(f"        timing_type : {ttype};")
            a("        cell_rise(scalar) {")
            a(f'          values("{ck_ins_ps:.4f}");')
            a("        }")
            a("        cell_fall(scalar) {")
            a(f'          values("{ck_ins_ps:.4f}");')
            a("        }")
            a("      }")
        a("    }")

        for pin in pins:
            if pin.function == "clk":
                continue
            if _is_bus(pin):
                # Bus umbrella + per-bit pin records. The bus-close `}`
                # lives at 4-space indent (sibling of the inner pins),
                # matching OpenROAD's abstract-writer shape.
                a(f'    bus ("{pin.name}") {{')
                a(f"      bus_type : {pin.name};")
                a(f"      direction : {pin.direction};")
                a("      capacitance : 0.0000;")
                for bit in range(pin.width - 1, -1, -1):
                    bit_name = f"{pin.name}[{bit}]"
                    if pin.direction == "output":
                        a(f'    pin ("{bit_name}") {{')
                        a("      direction : output;")
                        a("      capacitance : 0.0000;")
                        a("      timing() {")
                        a(f'        related_pin : "{clk_pn}";')
                        a("        timing_type : rising_edge;")
                        a("        timing_sense : non_unate;")
                        a("        cell_rise(scalar) {")
                        a(f'          values("{access_ps:.4f}");')
                        a("        }")
                        a("        cell_fall(scalar) {")
                        a(f'          values("{access_ps:.4f}");')
                        a("        }")
                        a("        rise_transition(scalar) {")
                        a(f'          values("{trans_ps:.4f}");')
                        a("        }")
                        a("        fall_transition(scalar) {")
                        a(f'          values("{trans_ps:.4f}");')
                        a("        }")
                        a("      }")
                        a("    }")
                    else:
                        a(f'    pin ("{bit_name}") {{')
                        a("      direction : input;")
                        a("      capacitance : 1;")
                        a("      timing() {")
                        a(f'        related_pin : "{clk_pn}";')
                        a("        timing_type : setup_rising;")
                        a("        rise_constraint(scalar) {")
                        a(f'          values("{setup_ps:.4f}");')
                        a("        }")
                        a("        fall_constraint(scalar) {")
                        a(f'          values("{setup_ps:.4f}");')
                        a("        }")
                        a("      }")
                        a("      timing() {")
                        a(f'        related_pin : "{clk_pn}";')
                        a("        timing_type : hold_rising;")
                        a("        rise_constraint(scalar) {")
                        a(f'          values("{hold_ps:.4f}");')
                        a("        }")
                        a("        fall_constraint(scalar) {")
                        a(f'          values("{hold_ps:.4f}");')
                        a("        }")
                        a("      }")
                        a("      internal_power() {")
                        a(f'        related_pin : "{clk_pn}";')
                        a('        when : "1";')
                        a("        rise_power(power_template) {")
                        a(f'          values ("{per_bit_e:.4f}, {per_bit_e:.4f}");')
                        a("        }")
                        a("        fall_power(power_template) {")
                        a(f'          values ("{per_bit_e:.4f}, {per_bit_e:.4f}");')
                        a("        }")
                        a("      }")
                        a("    }")
                a("    }")  # close bus
            else:
                # Scalar pin (en, wmode, 1-bit mask lane, 1-bit data).
                a(f'    pin ("{pin.name}") {{')
                a(f"      direction : {pin.direction};")
                a("      capacitance : 1;")
                if pin.direction == "output":
                    a("      timing() {")
                    a(f'        related_pin : "{clk_pn}";')
                    a("        timing_type : rising_edge;")
                    a("        timing_sense : non_unate;")
                    a("        cell_rise(scalar) {")
                    a(f'          values("{access_ps:.4f}");')
                    a("        }")
                    a("        cell_fall(scalar) {")
                    a(f'          values("{access_ps:.4f}");')
                    a("        }")
                    a("        rise_transition(scalar) {")
                    a(f'          values("{trans_ps:.4f}");')
                    a("        }")
                    a("        fall_transition(scalar) {")
                    a(f'          values("{trans_ps:.4f}");')
                    a("        }")
                    a("      }")
                else:
                    a("      timing() {")
                    a(f'        related_pin : "{clk_pn}";')
                    a("        timing_type : setup_rising;")
                    a("        rise_constraint(scalar) {")
                    a(f'          values("{setup_ps:.4f}");')
                    a("        }")
                    a("        fall_constraint(scalar) {")
                    a(f'          values("{setup_ps:.4f}");')
                    a("        }")
                    a("      }")
                    a("      timing() {")
                    a(f'        related_pin : "{clk_pn}";')
                    a("        timing_type : hold_rising;")
                    a("        rise_constraint(scalar) {")
                    a(f'          values("{hold_ps:.4f}");')
                    a("        }")
                    a("        fall_constraint(scalar) {")
                    a(f'          values("{hold_ps:.4f}");')
                    a("        }")
                    a("      }")
                    a("      internal_power() {")
                    a(f'        related_pin : "{clk_pn}";')
                    a('        when : "1";')
                    a("        rise_power(power_template) {")
                    a(f'          values ("{per_bit_e:.4f}, {per_bit_e:.4f}");')
                    a("        }")
                    a("        fall_power(power_template) {")
                    a(f'          values ("{per_bit_e:.4f}, {per_bit_e:.4f}");')
                    a("        }")
                    a("      }")
                a("    }")
    a("  }")  # close cell
    a("}")  # close library
    a("")
    return "\n".join(lines)
