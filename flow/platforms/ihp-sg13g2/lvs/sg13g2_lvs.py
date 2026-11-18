# ==========================================================================
# Copyright 2024 IHP PDK Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
# ==========================================================================

"""SG13G2 LVS rule deck, on the klayout Python module.

A line by line translation of IHP's Ruby runset, sg13g2.lvs and the
rule_decks/*.lvs files it includes (in git history), in their include
order; see flow/util/klayout_lvs.py and docs/user/KLayoutPythonDecks.md.

The switches are the defaults of the runset's driver, run_lvs.py, which
ORFS does not pass: deep mode, simplification and series/parallel
resistor combination on, everything else off. The extracted netlist
(target_netlist, written with CustomWriter) is not written; the .lvsdb
holds it.
"""

import re

import klayout_lvs
from klayout_drc import as_boxes, db, nm, um

THREADS = 1

# true: use net names instead of numbers
SPICE_WITH_NET_NAMES = True
# true: put in comments with details
SPICE_WITH_COMMENTS = False
NET_ONLY = False
TOP_LVL_PINS = False
COMBINE_DEVICES = False
PURGE = False
PURGE_NETS = False
SIMPLIFY = True
SERIES_RES = True
PARALLEL_RES = True

# $logger and $unit of the runset, set by lvs()
LOGGER = print
UNIT = 0.001

# The klayout objects hold the device classes, combiners and extractors
# by pointer; Python keeps them alive.
_keep = []


def _keep_alive(obj):
    _keep.append(obj)
    return obj


def _or(*values):
    """Ruby's a || b for parameter values: the first that is not nil."""
    for v in values:
        if v is not None:
            return v
    return None


# ================================================
# --------------- CUSTOM CLASSES ----------------
# ================================================

# custom_classes.lvs


def glob_to_case_insensitive_glob(glob):
    wildcards = ["*", "?"]
    pattern = ""
    for c in glob:
        if re.match(r"[A-Za-z]", c):
            pattern += "[%s%s]" % (c.upper(), c.lower())
        elif c in wildcards:
            pattern += c  # Keep wildcard characters as they are
        else:
            # Ruby's Regexp.escape
            pattern += re.sub(r"([.*?+^$|()\[\]{}\\/\- ])", r"\\\1", c)
    return pattern


# globals.lvs

PREFIX_MAP = {
    "sg13_lv_nmos": "M",
    "sg13_hv_nmos": "M",
    "sg13_lv_pmos": "M",
    "sg13_hv_pmos": "M",
    "rfnmos": "M",
    "rfnmosHV": "M",
    "rfpmos": "M",
    "rfpmosHV": "M",
    "npn13G2": "Q",
    "npn13G2L": "Q",
    "npn13G2V": "Q",
    "pnpMPA": "Q",
    "dantenna": "D",
    "dpantenna": "D",
    "schottky_nbl1": "D",
    "rsil": "R",
    "rppd": "R",
    "rhigh": "R",
    "lvsres": "R",
    "SVaricap": "C",
    "cap_cmim": "C",
    "rfcmim": "C",
    "diodevss_4kv": "D",
    "diodevss_2kv": "D",
    "diodevdd_4kv": "D",
    "diodevdd_2kv": "D",
    "idiodevss_4kv": "D",
    "idiodevss_2kv": "D",
    "idiodevdd_4kv": "D",
    "idiodevdd_2kv": "D",
    "nmoscl_2": "D",
    "nmoscl_4": "D",
    "ptap1": "R",
    "ntap1": "R",
    "inductor2": "L",
    "inductor3": "L",
}

CUSTOM_READER = ["M", "C", "R", "Q", "L", "D"]

RES_DEV = ["rsil", "rppd", "rhigh"]


# custom_reader.lvs


class CustomReader(db.NetlistSpiceReaderDelegate):
    # Cleanup sch for R, C elements
    def clean_sch(self, line, element):
        # Extracting parameters with values
        valid_params = re.findall(r"\b\w+\s*=\s*\S+\b", line)

        if element == "R":
            # For 2 term res [<nets> <model> <params>]
            num_terms = 3
        elif element == "C":
            # Determine number of terms based on component type
            if "varicap" in line.lower():
                num_terms = 5
            elif "rfcmim" in line.lower():
                num_terms = 4
            else:
                num_terms = 3

        line_no_param = " ".join(line.split()[:num_terms])
        return "%s %s" % (line_no_param.strip(), " ".join(valid_params))

    # Override parse_element method to handle exceptions gracefully
    def parse_element(self, line, element):
        try:
            # clean line: Ruby's line.delete('[]$\\/') deletes [, ], $
            # and /; the backslash escapes the slash
            line = re.sub(r"[\[\]$/]", "", line)
            # Prep sch for R, C
            if element in ("R", "C"):
                line = self.clean_sch(line, element)
            return super().parse_element(line, element)
        except RuntimeError:
            if element == "C":
                if "varicap" in line.lower():
                    return super().parse_element(line, "M")
                elif "rfcmim" in line.lower():
                    return super().parse_element(line, "Q")
                else:
                    return super().parse_element("%s C=1e-18" % line, element)
            elif element == "R":
                return super().parse_element("%s R=0" % line, element)
            elif element == "D":
                if "diodev" in line.lower() or "schottky" in line.lower():
                    return super().parse_element(line, "Q")
                else:
                    return super().parse_element(line, element)
            elif element == "L":
                if "inductor3" in line.lower():
                    return super().parse_element("%s L=0" % line, "M")
                else:
                    return super().parse_element("%s L=0" % line, element)
            else:
                return super().parse_element(line, element)

    # Override the element method to handle different types of elements
    def element(self, circuit, ele, name, model, value, nets, params):
        if ele in CUSTOM_READER:
            self.process_device(ele, circuit, name, model, nets, params)
        else:
            super().element(circuit, ele, name, model, value, nets, params)
        return True

    # Process device element
    def process_device(self, ele, circuit, name, model, nets, params):
        cls = circuit.netlist().device_class_by_name(model)
        if cls is None:
            cls = self.create_device_class(ele, circuit, model, len(nets))
        device = circuit.create_device(cls, name)
        self.connect_terminals(ele, device, model, nets)
        self.map_params(ele, device, model, params)

    # Create or retrieve the device class based on the element type, model
    # name, and number of nets.
    def create_device_class(self, ele, circuit, model, num_nets):
        if ele == "M":
            cls = db.DeviceClassMOS4Transistor()
        elif ele == "C":
            cls = self.create_capacitor(model, num_nets)
        elif ele == "R":
            cls = self.create_resistor(model, num_nets)
        elif ele == "Q":
            cls = self.create_bjt(model, num_nets)
        elif ele == "L":
            cls = DeviceCustomInd(model, num_nets - 1)
        elif ele == "D":
            cls = self.create_diode(model)
        else:
            raise ValueError("%s device with model %s is not supported" % (ele, model))
        cls.name = model
        circuit.netlist().add(_keep_alive(cls))
        return cls

    # Create a capacitor device class.
    def create_capacitor(self, model, num_nets):
        if "varicap" in model.lower():
            if num_nets != 4:
                raise ValueError("Varicap should have 4 nodes, please recheck")
            return DeviceCustomVaractor(model, num_nets - 1)
        else:
            if num_nets not in (2, 3):
                raise ValueError("Capacitor should have 2 or 3 nodes, please recheck")
            return DeviceCustomMIM(model)

    # Create a diode device class.
    def create_diode(self, model):
        if "diodev" in model.lower() or "schottky" in model.lower():
            return Esd3Term()
        elif "nmoscl" in model.lower():
            return Esd2Term()
        else:
            return EnDiode()

    # Create a resistor device class.
    def create_resistor(self, model, num_nets):
        if any(model.lower().startswith(res) for res in RES_DEV):
            return DeviceCustomRes(model, num_nets)
        elif num_nets == 2 and "tap" in model.lower():
            return db.DeviceClassDiode()
        elif num_nets == 2:
            return db.DeviceClassResistor()
        elif num_nets == 3:
            return db.DeviceClassResistorWithBulk()
        else:
            raise ValueError("Resistor should have two or three nodes, please recheck")

    # Create a bjt device class.
    def create_bjt(self, model, _num_nets):
        if "pnp" in model.lower():
            return CustomBJT3()
        else:
            return CustomBJT4()

    # Connect device terminals based on element type, device, model, and nets.
    def connect_terminals(self, ele, device, model, nets):
        term_list = self.terminal_list_for_element(ele, model, nets)
        for index, t in enumerate(term_list):
            device.connect_terminal(t, nets[index] if index < len(nets) else None)

    # Determine terminal list based on element type, model, and nets.
    def terminal_list_for_element(self, ele, model, nets):
        if ele == "M":
            return ["D", "G", "S", "B"]
        elif ele == "Q":
            return ["C", "B", "E"] if "pnp" in model.lower() else ["C", "B", "E", "S"]
        elif ele == "C":
            if "varicap" in model.lower():
                return self.gen_term_with_sub(model, len(nets))
            return self.gen_mim_terms(model)
        elif ele == "R":
            if any(model.lower().startswith(res) for res in RES_DEV):
                return self.gen_term_names(model, len(nets))
            elif "tap" in model.lower():
                return ["C", "A"]
            else:
                return ["A", "B", "W"] if len(nets) == 3 else ["A", "B"]
        elif ele == "D":
            if "diodevdd" in model.lower():
                return ["B", "E", "C"]
            elif "diodevss" in model.lower():
                return ["C", "E", "B"]
            elif "schottky" in model.lower():
                return ["E", "B", "C"]
            elif "nmoscl" in model.lower():
                return ["C", "A"]
            else:
                return ["A", "C"]
        elif ele == "L":
            return self.gen_term_with_sub(model, len(nets))
        else:
            return self.gen_term_names(model, len(nets))

    # Generate terminal names based on model and the number of nets.
    def gen_term_names(self, model, size):
        return ["%s_%d" % (model, i + 1) for i in range(size)]

    # Generate terminal names based on model and the number of nets.
    def gen_mim_terms(self, model):
        terms = ["mim_top", "mim_btm"]
        if "rfcmim" not in model.lower():
            return terms
        terms.append("mim_sub")  # Add sub terminal
        return terms

    # Generate terminal names based on model and the number of nets.
    def gen_term_with_sub(self, model, size):
        terms = ["%s_%d" % (model, i + 1) for i in range(size - 1)]
        terms.append("%s_sub" % model)  # Add sub terminal
        return terms

    # Map parameters based on the model type.
    def map_params(self, ele, device, model, params):
        if ele == "M":
            self.map_mos_params(device, params)
        elif ele == "Q":
            self.map_bjt_params(device, model, params)
        elif ele == "C":
            self.map_capacitor_params(device, model, params)
        elif ele == "R":
            self.map_resistor_params(device, model, params)
        elif ele == "D":
            self.map_diode_params(device, model, params)
        elif ele == "L":
            self.map_inductor_params(device, params)
        else:
            raise ValueError(
                "%s device with model %s is not supported, please recheck"
                % (ele, model)
            )

    # Map parameters for mos devices.
    def map_mos_params(self, device, params):
        p = params.get
        device.set_parameter("W", _or(p("W"), 0.0) * _or(p("M"), 1.0) * 1e6)
        device.set_parameter("L", _or(p("L"), 0.0) * 1e6)

    # Map parameters for a BJT device.
    def map_bjt_params(self, device, model, params):
        p = params.get
        if "pnp" in model.lower():
            device.set_parameter(
                "AE", _or(p("A"), _or(p("W"), 0.0) * _or(p("L"), 0.0)) * 1e12
            )
            device.set_parameter(
                "PE", _or(p("P"), (_or(p("W"), 0.0) + _or(p("L"), 0.0)) * 2) * 1e6
            )
        else:
            device.set_parameter(
                "AE", _or(p("AE"), _or(p("WE"), 0.0) * _or(p("LE"), 0.0)) * 1e12
            )
            device.set_parameter(
                "PE",
                _or(p("PE"), (_or(p("WE"), 0.0) + _or(p("LE"), 0.0)) * 2) * 1e6,
            )
        device.set_parameter("NE", _or(p("M"), p("NE"), 1.0))
        device.set_parameter("m", _or(p("M"), p("NE"), 1.0))

    # Map parameters for a diode device.
    def map_diode_params(self, device, model, params):
        p = params.get
        m = model.lower()
        if not ("diodev" in m or "schottky" in m or "nmoscl" in m):
            device.set_parameter(
                "A", _or(p("A"), _or(p("W"), 0.0) * _or(p("L"), 0.0)) * 1e12
            )
            device.set_parameter(
                "P", _or(p("P"), (_or(p("W"), 0.0) + _or(p("L"), 0.0)) * 2) * 1e6
            )
        device.set_parameter("m", _or(p("M"), 1.0))

    # Map parameters for a capacitor device.
    def map_capacitor_params(self, device, model, params):
        p = params.get
        device.set_parameter("w", _or(p("W"), 0.0) * 1e6)
        device.set_parameter("l", _or(p("L"), 0.0) * 1e6)
        if "cap_cmim" in model.lower():
            device.set_parameter("m", _or(p("M"), p("MF"), 1.0))
        if "mim" in model.lower():
            device.set_parameter(
                "A", _or(p("A"), _or(p("W"), 0.0) * _or(p("L"), 0.0)) * 1e12
            )
            device.set_parameter(
                "P", _or(p("P"), (_or(p("W"), 0.0) + _or(p("L"), 0.0)) * 2) * 1e6
            )
        if "rfcmim" not in model.lower():
            return
        device.set_parameter("wfeed", _or(p("WFEED"), 0.0) * 1e6)

    # Map parameters for a resistor device.
    def map_resistor_params(self, device, model, params):
        p = params.get
        if "tap" in model.lower():
            device.set_parameter(
                "A", _or(p("A"), _or(p("W"), 0.0) * _or(p("L"), 0.0)) * 1e12
            )
            device.set_parameter(
                "P",
                _or(p("P"), p("PERIM"), (_or(p("W"), 0.0) + _or(p("L"), 0.0)) * 2)
                * 1e6,
            )
        elif any(model.lower().startswith(res) for res in RES_DEV):
            device.set_parameter("w", _or(p("W"), 0.0) * 1e6)
            device.set_parameter("l", _or(p("L"), 0.0) * 1e6)
            device.set_parameter("ps", _or(p("PS"), 0.0) * 1e6)
            device.set_parameter("b", _or(p("B"), 0.0))
            device.set_parameter("m", _or(p("M"), 1.0))
        else:
            device.set_parameter(
                "W", _or(p("W"), p("WIDTH"), 0.0) * _or(p("M"), 1.0) * 1e6
            )
            device.set_parameter(
                "L", _or(p("L"), p("LENGTH"), 0.0) * _or(p("S"), 1.0) * 1e6
            )
            device.set_parameter(
                "R", _or(p("R"), 0.0) * _or(p("S"), 1.0) / _or(p("M"), 1.0)
            )

    # Map parameters for an inductor device.
    def map_inductor_params(self, device, params):
        p = params.get
        device.set_parameter("w", _or(p("W"), 0.0) * 1e6)
        device.set_parameter("s", _or(p("S"), 0.0) * 1e6)
        device.set_parameter("d", _or(p("D"), 0.0) * 1e6)
        device.set_parameter("nr_r", _or(p("NR_R"), 0.0))


# custom_devices.lvs


def add_parameters(dc, *names):
    for name in names:
        dc.add_parameter(db.DeviceParameterDefinition(name))


def add_terminals(dc, name, num, sub_en):
    for i in range(1, num + 1):
        terminal_name = "%s_%d" % (name, i)
        ter = dc.add_terminal(db.DeviceTerminalDefinition(terminal_name))
        ter.name = terminal_name
    if sub_en != 1:
        return
    terminal_name = "%s_sub" % name
    ter = dc.add_terminal(db.DeviceTerminalDefinition(terminal_name))
    ter.name = terminal_name


def set_combiner(dc, combiner):
    dc.combiner = combiner and _keep_alive(combiner)


class DeviceCustomRes(db.DeviceClassResistor):
    def __init__(self, name, num):
        super().__init__()
        self.clear_parameters()
        self.clear_terminals()
        add_parameters(self, "w", "l", "ps", "b")
        self.add_parameter(db.DeviceParameterDefinition("m", "multiplier", 1, True))
        if SERIES_RES or PARALLEL_RES:
            set_combiner(self, RESDeviceCombiner())
        else:
            set_combiner(self, None)
        add_terminals(self, name, num, 0)


class CustomBJT3(db.DeviceClassBJT3Transistor):
    def __init__(self):
        super().__init__()
        self.add_parameter(db.DeviceParameterDefinition("m", "multiplier", 1, True))
        set_combiner(self, BJTDeviceCombiner())
        self.enable_parameter("AE", True)
        self.enable_parameter("PE", True)
        self.enable_parameter("NE", True)


class CustomBJT4(db.DeviceClassBJT4Transistor):
    def __init__(self):
        super().__init__()
        self.add_parameter(db.DeviceParameterDefinition("m", "multiplier", 1, True))
        set_combiner(self, BJTDeviceCombiner())
        self.enable_parameter("AE", True)
        self.enable_parameter("PE", True)
        self.enable_parameter("NE", True)


class DeviceCustomInd(db.DeviceClassInductor):
    def __init__(self, name, num):
        super().__init__()
        self.clear_parameters()
        self.clear_terminals()
        self.clear_equivalent_terminal_ids()
        add_parameters(self, "w", "s", "d", "nr_r")
        add_terminals(self, name, num, 1)
        equal_ind_parameters = db.EqualDeviceParameters(
            self.parameter_id("w"), 0.0, 0.05
        )
        equal_ind_parameters += db.EqualDeviceParameters(
            self.parameter_id("s"), 0.0, 0.05
        )
        equal_ind_parameters += db.EqualDeviceParameters(
            self.parameter_id("d"), 0.0, 0.05
        )
        self.equal_parameters = equal_ind_parameters
        set_combiner(self, None)
        self.supports_serial_combination = False
        self.supports_parallel_combination = False


class DeviceCustomVaractor(db.DeviceClassCapacitorWithBulk):
    def __init__(self, name, num):
        super().__init__()
        self.clear_parameters()
        self.clear_terminals()
        add_parameters(self, "w", "l")
        add_terminals(self, name, num, 1)


class RES2(db.DeviceClassResistor):
    def __init__(self):
        super().__init__()
        self.enable_parameter("W", True)
        self.enable_parameter("L", True)
        self.enable_parameter("R", False)


class EnDiode(db.DeviceClassDiode):
    def __init__(self):
        super().__init__()
        equal_diode_parameters = db.EqualDeviceParameters(
            self.parameter_id("A"), 0.0, 0.01
        )
        equal_diode_parameters += db.EqualDeviceParameters(
            self.parameter_id("P"), 0.0, 0.01
        )
        self.equal_parameters = equal_diode_parameters
        set_combiner(self, DiodeDeviceCombiner())
        self.supports_serial_combination = True
        self.supports_parallel_combination = True
        self.add_parameter(db.DeviceParameterDefinition("m", "multiplier", 1, True))
        self.enable_parameter("A", True)
        self.enable_parameter("P", True)
        self.enable_parameter("m", True)


class CustomTap(db.DeviceClassDiode):
    def __init__(self):
        super().__init__()
        self.clear_parameters()
        self.add_parameter(db.DeviceParameterDefinition("A", "Area", 0, True))
        self.add_parameter(db.DeviceParameterDefinition("P", "Perimeter", 0, True))
        self.enable_parameter("A", True)
        self.enable_parameter("P", True)


class Esd3Term(db.DeviceClassBJT3Transistor):
    def __init__(self):
        super().__init__()
        self.clear_parameters()
        self.add_parameter(db.DeviceParameterDefinition("m", "area", 1, True))
        self.enable_parameter("m", True)


class Esd2Term(db.DeviceClassDiode):
    def __init__(self):
        super().__init__()
        self.clear_parameters()
        self.add_parameter(db.DeviceParameterDefinition("m", "area", 1, True))
        self.enable_parameter("m", True)


# custom_combiner.lvs


def same_net(a, b, name):
    a_net = a.net_for_terminal(name)
    b_net = b.net_for_terminal(name)
    same_po = None
    if a_net and b_net:
        same_po = a_net.expanded_name() == b_net.expanded_name()
    return bool(a_net and b_net and same_po)


def supp_parallel(a, b, net1, net2):
    a_net1 = a.net_for_terminal(net1)
    a_net2 = a.net_for_terminal(net2)
    b_net1 = b.net_for_terminal(net1)
    b_net2 = b.net_for_terminal(net2)
    if not (a_net1 and b_net1 and a_net2 and b_net2):
        return False
    same_po = (
        a_net1.expanded_name() == b_net1.expanded_name()
        and a_net2.expanded_name() == b_net2.expanded_name()
    )
    diff_po = (
        a_net1.expanded_name() == b_net2.expanded_name()
        and a_net2.expanded_name() == b_net1.expanded_name()
    )
    return same_po or diff_po


def supp_series(a, b, net1, net2):
    a_net1 = a.net_for_terminal(net1)
    a_net2 = a.net_for_terminal(net2)
    b_net1 = b.net_for_terminal(net1)
    b_net2 = b.net_for_terminal(net2)
    if not (a_net1 and b_net1 and a_net2 and b_net2):
        return False
    series_con_a1 = (
        a_net1.expanded_name() == b_net1.expanded_name()
        or a_net1.expanded_name() == b_net2.expanded_name()
    )
    series_con_a2 = (
        a_net2.expanded_name() == b_net1.expanded_name()
        or a_net2.expanded_name() == b_net2.expanded_name()
    )
    series_con = series_con_a1 or series_con_a2
    if series_con_a1:
        if a_net1.expanded_name() == b_net1.expanded_name():
            a.connect_terminal(0, b_net2)
        else:
            a.connect_terminal(0, b_net1)
    if series_con_a2:
        if a_net2.expanded_name() == b_net1.expanded_name():
            a.connect_terminal(1, b_net2)
        else:
            a.connect_terminal(1, b_net1)
    return series_con


def same_parameter(a, b, name):
    return abs(a.parameter(name) - b.parameter(name)) < 1e-9


class MIMCAPNDeviceCombiner(db.GenericDeviceCombiner):
    def combine_devices(self, a, b):
        if not (same_net(a, b, "mim_top") and same_net(a, b, "mim_btm")):
            return False
        if not (same_parameter(a, b, "w") and same_parameter(a, b, "l")):
            return False
        a.set_parameter("m", a.parameter("m") + b.parameter("m"))
        b.disconnect_terminal("mim_top")
        b.disconnect_terminal("mim_btm")
        if "rfcmim" in b.name.lower():
            b.disconnect_terminal("mim_sub")
        return True


class DiodeDeviceCombiner(db.GenericDeviceCombiner):
    def combine_devices(self, a, b):
        if not (same_net(a, b, "A") and same_net(a, b, "C")):
            return False
        if not (same_parameter(a, b, "A") and same_parameter(a, b, "P")):
            return False
        a.set_parameter("m", a.parameter("m") + b.parameter("m"))
        b.disconnect_terminal("A")
        b.disconnect_terminal("C")
        return True


class BJTDeviceCombiner(db.GenericDeviceCombiner):
    def combine_devices(self, a, b):
        bjt3_nets = ["C", "B", "E"]
        bjt4_nets = ["C", "B", "E", "S"]
        bjt_nets = bjt3_nets if "pnp" in a.device_class().name.lower() else bjt4_nets
        if not all(same_net(a, b, net) for net in bjt_nets):
            return False
        if not all(same_parameter(a, b, param) for param in ["AE", "PE"]):
            return False
        a.set_parameter("m", a.parameter("m") + b.parameter("m"))
        a.set_parameter("NE", a.parameter("NE") + b.parameter("NE"))
        for term in bjt_nets:
            b.disconnect_terminal(term)
        return True


class RESDeviceCombiner(db.GenericDeviceCombiner):
    def combine_devices(self, a, b):
        res_nets = [0, 1]  # Using id instead of names
        if supp_parallel(a, b, 0, 1):
            if not PARALLEL_RES:
                return False
            if not all(same_parameter(a, b, param) for param in ["w", "l", "ps", "b"]):
                return False
            a.set_parameter("m", a.parameter("m") + b.parameter("m"))
        elif supp_series(a, b, 0, 1):
            if not SERIES_RES:
                return False
            if not all(same_parameter(a, b, param) for param in ["w", "ps", "b", "m"]):
                return False
            a.set_parameter("l", a.parameter("l") + b.parameter("l"))
        else:
            return False
        for term in res_nets:
            b.disconnect_terminal(term)
        return True


# custom_extractor.lvs

# The Ruby runset passes RBA::Metrics::Projection as the second positional
# argument of space_check, notch_check and separation_check, which is
# whole_edges: true, with Euclidian metrics. These functions do the same.


def get_uniq_length(sel_edges):
    lengths = []
    for edge in sel_edges.each():
        if edge.length() not in lengths:
            lengths.append(edge.length())
    return lengths[0] if len(lengths) == 1 else 0.0


def get_min_max_length(sel_edges):
    lengths = [edge.length() for edge in sel_edges.each()]
    if not lengths:
        return None, None
    return min(lengths), max(lengths)


def _min(values):
    return min(values) if values else None


class GeneralNTerminalExtractor(db.GenericDeviceExtractor):
    def __init__(self, name, num):
        super().__init__()
        self.name = name
        self.num = num
        self.dev_name = name

    def setup(self):
        self.define_layers()
        name = self.name
        if any(name.lower().startswith(res) for res in RES_DEV):
            self.reg_dev = DeviceCustomRes(name, self.num)
        elif "varicap" in name.lower():
            self.reg_dev = DeviceCustomVaractor(name, self.num)
        elif name.lower().startswith("ind"):
            self.reg_dev = DeviceCustomInd(name, self.num)
        else:
            raise ValueError(
                "Custom-Class for %s device is not supported yet, please recheck" % name
            )
        self.register_device_class(_keep_alive(self.reg_dev))

    def get_connectivity(self, _layout, layers):
        dev = layers[0]
        ports = layers[1]
        meas_mk = layers[2]
        dev_mk = layers[3]

        conn = db.Connectivity()
        conn.connect(dev, dev)
        conn.connect(dev, dev_mk)
        conn.connect(dev, meas_mk)
        conn.connect(ports, dev_mk)
        conn.connect(meas_mk, dev_mk)

        if self.name.lower().startswith("ind") or "varicap" in self.name.lower():
            sub_mk = layers[4]
            conn.connect(sub_mk, dev_mk)
        return conn

    def extract_devices(self, layer_geometry):
        dev, ports, meas_mk, dev_mk, sub_mk = (list(layer_geometry) + [None])[:5]
        for region in dev_mk.merged().each():
            if ports.count() != self.num:
                LOGGER(
                    "%s device terminals (%d) don't touch device marker correctly"
                    % (self.dev_name, self.num)
                )
                LOGGER(
                    "No. of ports exist for %s is %d, should be %d"
                    % (self.dev_name, ports.count(), self.num)
                )
            else:
                device = self.create_device()
                self.set_device_parameters(device, region, dev, ports, meas_mk, dev_mk)
                self.define_and_sort_terminals(device, ports, sub_mk)

    def define_layers(self):
        self.define_layer("core", "core Layer")
        self.define_layer("ports", "Connect Terminal")
        self.define_layer("meas_mk", "Measuring parameters marker")
        self.define_layer("dev_mk", "Device Marker")
        if self.name.lower().startswith("ind") or "varicap" in self.name.lower():
            self.define_layer("sub_mk", "Substrate Marker")

    def set_device_parameters(self, device, region, dev, ports, meas_mk, dev_mk):
        name = self.name
        if any(name.lower().startswith(res) for res in RES_DEV):
            width, length, poly_sp, bends = self.calc_res_params(dev, ports, meas_mk)
            device.set_parameter("w", width * UNIT)
            device.set_parameter("l", length * UNIT)
            device.set_parameter("ps", poly_sp * UNIT)
            device.set_parameter("b", bends)
        elif "varicap" in name.lower():
            width, length = self.calc_varicap_params(dev, ports, meas_mk, dev_mk)
            device.set_parameter("w", width * UNIT)
            device.set_parameter("l", length * UNIT)
        elif name.lower().startswith("ind"):
            width, space, diameter, no_turns = self.calc_ind_params(
                dev, ports, meas_mk, dev_mk, region
            )
            device.set_parameter("w", width * UNIT)
            device.set_parameter("s", space * UNIT)
            device.set_parameter("d", diameter * UNIT)
            device.set_parameter("nr_r", no_turns)

    def calc_res_params(self, dev, ports, meas_mk):
        width_edges = dev.edges() & ports.edges()
        width = get_uniq_length(width_edges)
        length_edges = dev.edges().interacting(width_edges) - width_edges
        length, _ = get_min_max_length(length_edges)
        corners = meas_mk.interacting(dev).corners().not_interacting(ports).count()
        bends = corners // 4
        poly_sp = None
        if bends > 0:
            poly_sp_polygon = meas_mk.interacting(dev)
            poly_sp = self.get_notch_min(poly_sp_polygon, 10 * length)
            length = length + width
        width = _or(width, 0)
        length = _or(length, 0)
        poly_sp = _or(poly_sp, 0)
        bends = _or(bends, 0)
        return width, length, poly_sp, bends

    def calc_varicap_params(self, dev, _ports, meas_mk, _dev_mk):
        width_edges = dev.edges().not_interacting(meas_mk.edges())
        length, width = get_min_max_length(width_edges)
        width = _or(width, 0)
        length = _or(length, 0)
        return width, length

    def calc_ind_params(self, dev, ports, meas_mk, dev_mk, region):
        _, max_mk_len = get_min_max_length(dev_mk.edges())
        meas_sel = meas_mk.merged() & db.Region(region)
        width = self.get_width_val(meas_sel, max_mk_len)
        space = self.get_space_val(meas_sel, max_mk_len)
        no_turns_init = meas_mk.merged().count()
        no_turns = no_turns_init
        diam_extents = dev.extents().edges()
        diam_edge_exc = diam_extents.interacting(ports)
        diam_edge = diam_extents.not_interacting(diam_edge_exc)
        diameter = diam_edge.length()
        diameter = diameter - (2 * (no_turns - 1) * space) - (2 * no_turns * width)
        diameter = 0 if diameter < 0 else diameter
        width = _or(width, 0)
        space = _or(space, 0)
        diameter = _or(diameter, 0)
        no_turns = _or(no_turns, 1)
        return width, space, diameter, no_turns

    def define_and_sort_terminals(self, device, ports, sub_mk):
        name = self.name
        substrings = ["varicap"]
        sorted_ports = None
        for substring in substrings:
            if substring in name:
                sorted_ports = ports
                break  # Exit loop if a match is found
        if sorted_ports is None:
            sorted_ports = self.sort_polygons(ports)

        if name.lower().startswith("ind") or "varicap" in name.lower():
            if sub_mk.is_empty():
                LOGGER(
                    "Sub terminal for %s device doesn't exist, please recheck"
                    % self.dev_name
                )
                return None
            else:
                self.define_terminal(
                    device,
                    self.reg_dev.terminal_id("%s_sub" % name),
                    4,
                    sub_mk[0],
                )
        for i in range(1, self.num + 1):
            self.define_terminal(
                device,
                self.reg_dev.terminal_id("%s_%d" % (name, i)),
                1,
                sorted_ports[i - 1],
            )

    def sort_polygons(self, polygons):
        con_polygons = []
        for ports_pl in polygons.merged().each():
            con_edges = []
            for con_ed in ports_pl.each_edge():
                for pt in ([con_ed.x1, con_ed.y1], [con_ed.x2, con_ed.y2]):
                    if pt not in con_edges:
                        con_edges.append(pt)
            con_polygons.append(con_edges)
        sorted_ports_polygons = sorted(con_polygons, key=lambda pl: pl[0])
        sorted_ports = []
        for sorted_pl in sorted_ports_polygons:
            ports_pl = db.Polygon(
                [
                    db.Point(sorted_pl[0][0], sorted_pl[0][1]),
                    db.Point(sorted_pl[1][0], sorted_pl[1][1]),
                    db.Point(sorted_pl[2][0], sorted_pl[2][1]),
                    db.Point(sorted_pl[3][0], sorted_pl[3][1]),
                ]
            )
            sorted_ports.append(ports_pl)
        return sorted_ports

    def get_sep_val(self, sel_edges, sep_edges, sep_val):
        sep_paris = sel_edges.separation_check(sep_edges, sep_val, True)
        return _min([edge.distance() for edge in sep_paris.each()])

    def get_space_val(self, sel_polygon, sep_val):
        space_paris = sel_polygon.space_check(sep_val, True)
        return _min([edge.distance() for edge in space_paris.each()])

    def get_width_val(self, sel_polygon, width_val):
        width_paris = sel_polygon.width_check(
            width_val, metrics=db.Metrics.Projection, min_projection=10
        )
        width_values = [edge.distance() for edge in width_paris.each()]
        width_values = [v for v in width_values if v != 0]
        return _min(width_values)

    def get_notch_min(self, sel_polygon, sep_val):
        space_paris = sel_polygon.notch_check(sep_val, True)
        return _min([edge.distance() for edge in space_paris.each()])

    def get_notch_max(self, sel_polygon, sep_val):
        space_paris = sel_polygon.notch_check(sep_val, True)
        values = [edge.distance() for edge in space_paris.each()]
        return max(values) if values else None


# custom_mim_extractor.lvs


class DeviceCustomMIM(db.DeviceClassCapacitor):
    def __init__(self, name):
        super().__init__()
        self.clear_parameters()
        self.clear_terminals()
        self.clear_equivalent_terminal_ids()
        self.add_parameter(db.DeviceParameterDefinition("w", "width", 0, False))
        self.add_parameter(db.DeviceParameterDefinition("l", "length", 0, False))
        self.add_parameter(db.DeviceParameterDefinition("A", "area", 0, True))
        self.add_parameter(db.DeviceParameterDefinition("P", "perimeter", 0, True))
        self.add_parameter(db.DeviceParameterDefinition("m", "multiplier", 1, True))
        ter1 = self.add_terminal(db.DeviceTerminalDefinition("mim_top"))
        ter2 = self.add_terminal(db.DeviceTerminalDefinition("mim_btm"))
        ter1.name = "mim_top"
        ter2.name = "mim_btm"
        if "rfcmim" not in name.lower():
            return
        self.add_parameter(db.DeviceParameterDefinition("wfeed", "feed width", 0, True))
        sub_ter = self.add_terminal(db.DeviceTerminalDefinition("mim_sub"))
        sub_ter.name = "mim_sub"


class MIMCAPExtractor(db.GenericDeviceExtractor):
    def __init__(self, name):
        super().__init__()
        self.name = name
        self.dev_name = name

    def setup(self):
        self.define_layers()
        self.reg_dev = DeviceCustomMIM(self.name)
        if "rfcmim" in self.name.lower():
            set_combiner(self.reg_dev, None)
        else:
            set_combiner(self.reg_dev, MIMCAPNDeviceCombiner())
        self.register_device_class(_keep_alive(self.reg_dev))

    def get_connectivity(self, _layout, layers):
        dev = layers[0]
        top_mim = layers[1]
        btm_mim = layers[2]
        dev_mk = layers[3]
        meas_mk = layers[4]

        conn = db.Connectivity()
        conn.connect(dev, dev)
        conn.connect(dev, dev_mk)
        conn.connect(dev, meas_mk)
        conn.connect(top_mim, dev_mk)
        conn.connect(btm_mim, dev_mk)

        if "rfcmim" in self.name.lower():
            sub_mk = layers[5]
            conn.connect(sub_mk, dev_mk)
        return conn

    def extract_devices(self, layer_geometry):
        dev, top_mim, btm_mim, dev_mk, meas_mk, sub_mk = (
            list(layer_geometry) + [None]
        )[:6]
        for _region in dev_mk.merged().each():
            if top_mim.count() != 1:
                LOGGER(
                    "No. of ports exist for %s topmetal is %d, should be 1"
                    % (self.dev_name, top_mim.count())
                )
            elif btm_mim.count() != 1:
                LOGGER(
                    "No. of ports exist for %s btmmetal is %d, should be 1"
                    % (self.dev_name, btm_mim.count())
                )
            else:
                device = self.create_device()
                self.set_device_parameters(device, dev, dev_mk, meas_mk)
                self.define_terminals(device, top_mim, btm_mim, sub_mk)

    def define_layers(self):
        self.define_layer("core", "core Layer")
        self.define_layer("top_mim", "Connect Terminal for top mim")
        self.define_layer("btm_mim", "Connect Terminal for btm mim")
        self.define_layer("dev_mk", "Device Marker")
        self.define_layer("meas_mk", "Measuring parameters marker")
        if "rfcmim" not in self.name.lower():
            return
        self.define_layer("sub_mk", "Substrate layer")

    def set_device_parameters(self, device, dev, dev_mk, meas_mk):
        width, length, wfeed = self.calc_cmim_params(dev, dev_mk, meas_mk)
        if "rfcmim" in self.name.lower():
            device.set_parameter("l", width * UNIT)
            device.set_parameter("w", length * UNIT)
            device.set_parameter("wfeed", wfeed * UNIT)
        else:
            device.set_parameter("w", width * UNIT)
            device.set_parameter("l", length * UNIT)
        device.set_parameter("A", width * length * UNIT * UNIT)
        device.set_parameter("P", (width + length) * 2 * UNIT)

    def calc_cmim_params(self, dev, dev_mk, meas_mk):
        dev_edges = dev.edges()
        width_edges = dev_edges.with_angle(0, False)
        len_edges = dev_edges - width_edges
        width = get_uniq_length(width_edges)
        length = get_uniq_length(len_edges)
        wfeed_edges = meas_mk.edges() & dev_mk.edges()
        wfeed = get_uniq_length(wfeed_edges)
        width = _or(width, 0)
        length = _or(length, 0)
        wfeed = _or(wfeed, 0)
        return width, length, wfeed

    def define_terminals(self, device, top_mim, btm_mim, sub_mk):
        if "rfcmim" in self.name.lower():
            if sub_mk.is_empty():
                LOGGER(
                    "Sub terminal for %s device doesn't exist, please recheck"
                    % self.dev_name
                )
                return None
            else:
                self.define_terminal(
                    device, self.reg_dev.terminal_id("mim_sub"), 5, sub_mk[0]
                )
        self.define_terminal(device, self.reg_dev.terminal_id("mim_top"), 1, top_mim[0])
        self.define_terminal(device, self.reg_dev.terminal_id("mim_btm"), 2, btm_mim[0])


# ================================================================
# ------------------------- MAIN RUNSET --------------------------
# ================================================================


def lvs(deck):
    global LOGGER, UNIT
    LOGGER = deck.info
    UNIT = deck.dbu

    deck.info("Starting running SG13G2 Klayout LVS runset")

    # Instantiate a reader using the new delegate
    reader = db.NetlistSpiceReader(_keep_alive(CustomReader()))

    # === GET NETLIST ===
    deck.read_schematic(reader)

    # ================================================
    # ------------- LAYERS DEFINITIONS ---------------
    # ================================================

    # layers_definitions.lvs
    polygons_count = 0
    deck.info("Read in polygons from layers.")

    # Deep mode: the runset's flat mode would merge each input layer here
    def get_polygons(lay_no, lay_dt):
        return deck.polygons(lay_no, lay_dt)

    nodrc_drw = get_polygons(62, 0)
    count = nodrc_drw.count()
    deck.info(f"nodrc_drw has {count} polygons")
    polygons_count += count

    activ_drw = get_polygons(1, 0)
    activ_drw = activ_drw.not_(nodrc_drw)
    count = activ_drw.count()
    deck.info(f"activ_drw has {count} polygons")
    polygons_count += count

    activ_filler = get_polygons(1, 22)
    activ_filler = activ_filler.not_(nodrc_drw)
    count = activ_filler.count()
    deck.info(f"activ_filler has {count} polygons")
    polygons_count += count

    # activ org
    activ = activ_drw.join(activ_filler)
    count = activ.count()
    deck.info(f"activ has {count} polygons")

    activ_pin = get_polygons(1, 2)
    activ_pin = activ_pin.not_(nodrc_drw)
    count = activ_pin.count()
    deck.info(f"activ_pin has {count} polygons")
    polygons_count += count

    activ_mask = get_polygons(1, 20)
    activ_mask = activ_mask.not_(nodrc_drw)
    count = activ_mask.count()
    deck.info(f"activ_mask has {count} polygons")
    polygons_count += count

    activ_nofill = get_polygons(1, 23)
    activ_nofill = activ_nofill.not_(nodrc_drw)
    count = activ_nofill.count()
    deck.info(f"activ_nofill has {count} polygons")
    polygons_count += count

    activ_OPC = get_polygons(1, 26)
    activ_OPC = activ_OPC.not_(nodrc_drw)
    count = activ_OPC.count()
    deck.info(f"activ_OPC has {count} polygons")
    polygons_count += count

    activ_iOPC = get_polygons(1, 27)
    activ_iOPC = activ_iOPC.not_(nodrc_drw)
    count = activ_iOPC.count()
    deck.info(f"activ_iOPC has {count} polygons")
    polygons_count += count

    activ_noqrc = get_polygons(1, 28)
    activ_noqrc = activ_noqrc.not_(nodrc_drw)
    count = activ_noqrc.count()
    deck.info(f"activ_noqrc has {count} polygons")
    polygons_count += count

    biwind_drw = get_polygons(3, 0)
    biwind_drw = biwind_drw.not_(nodrc_drw)
    count = biwind_drw.count()
    deck.info(f"biwind_drw has {count} polygons")
    polygons_count += count

    biwind_OPC = get_polygons(3, 26)
    biwind_OPC = biwind_OPC.not_(nodrc_drw)
    count = biwind_OPC.count()
    deck.info(f"biwind_OPC has {count} polygons")
    polygons_count += count

    gatpoly_drw = get_polygons(5, 0)
    gatpoly_drw = gatpoly_drw.not_(nodrc_drw)
    count = gatpoly_drw.count()
    deck.info(f"gatpoly_drw has {count} polygons")
    polygons_count += count

    gatpoly_filler = get_polygons(5, 22)
    gatpoly_filler = gatpoly_filler.not_(nodrc_drw)
    count = gatpoly_filler.count()
    deck.info(f"gatpoly_filler has {count} polygons")
    polygons_count += count

    # gatpoly org
    gatpoly = gatpoly_drw.join(gatpoly_filler)
    count = gatpoly.count()
    deck.info(f"gatpoly has {count} polygons")

    gatpoly_pin = get_polygons(5, 2)
    gatpoly_pin = gatpoly_pin.not_(nodrc_drw)
    count = gatpoly_pin.count()
    deck.info(f"gatpoly_pin has {count} polygons")
    polygons_count += count

    gatpoly_nofill = get_polygons(5, 23)
    gatpoly_nofill = gatpoly_nofill.not_(nodrc_drw)
    count = gatpoly_nofill.count()
    deck.info(f"gatpoly_nofill has {count} polygons")
    polygons_count += count

    gatpoly_OPC = get_polygons(5, 26)
    gatpoly_OPC = gatpoly_OPC.not_(nodrc_drw)
    count = gatpoly_OPC.count()
    deck.info(f"gatpoly_OPC has {count} polygons")
    polygons_count += count

    gatpoly_iOPC = get_polygons(5, 27)
    gatpoly_iOPC = gatpoly_iOPC.not_(nodrc_drw)
    count = gatpoly_iOPC.count()
    deck.info(f"gatpoly_iOPC has {count} polygons")
    polygons_count += count

    gatpoly_noqrc = get_polygons(5, 28)
    gatpoly_noqrc = gatpoly_noqrc.not_(nodrc_drw)
    count = gatpoly_noqrc.count()
    deck.info(f"gatpoly_noqrc has {count} polygons")
    polygons_count += count

    cont_drw = get_polygons(6, 0)
    cont_drw = cont_drw.not_(nodrc_drw)
    count = cont_drw.count()
    deck.info(f"cont_drw has {count} polygons")
    polygons_count += count

    cont_OPC = get_polygons(6, 26)
    cont_OPC = cont_OPC.not_(nodrc_drw)
    count = cont_OPC.count()
    deck.info(f"cont_OPC has {count} polygons")
    polygons_count += count

    nsd_drw = get_polygons(7, 0)
    nsd_drw = nsd_drw.not_(nodrc_drw)
    count = nsd_drw.count()
    deck.info(f"nsd_drw has {count} polygons")
    polygons_count += count

    nsd_block = get_polygons(7, 21)
    nsd_block = nsd_block.not_(nodrc_drw)
    count = nsd_block.count()
    deck.info(f"nsd_block has {count} polygons")
    polygons_count += count

    metal1_drw = get_polygons(8, 0)
    metal1_drw = metal1_drw.not_(nodrc_drw)
    count = metal1_drw.count()
    deck.info(f"metal1_drw has {count} polygons")
    polygons_count += count

    metal1_filler = get_polygons(8, 22)
    metal1_filler = metal1_filler.not_(nodrc_drw)
    count = metal1_filler.count()
    deck.info(f"metal1_filler has {count} polygons")
    polygons_count += count

    metal1_slit = get_polygons(8, 24)
    metal1_slit = metal1_slit.not_(nodrc_drw)
    count = metal1_slit.count()
    deck.info(f"metal1_slit has {count} polygons")
    polygons_count += count

    # metal1 org
    metal1 = metal1_drw.join(metal1_filler).not_(metal1_slit)
    count = metal1.count()
    deck.info(f"metal1 has {count} polygons")

    metal1_pin = get_polygons(8, 2)
    metal1_pin = metal1_pin.not_(nodrc_drw)
    count = metal1_pin.count()
    deck.info(f"metal1_pin has {count} polygons")
    polygons_count += count

    metal1_mask = get_polygons(8, 20)
    metal1_mask = metal1_mask.not_(nodrc_drw)
    count = metal1_mask.count()
    deck.info(f"metal1_mask has {count} polygons")
    polygons_count += count

    metal1_nofill = get_polygons(8, 23)
    metal1_nofill = metal1_nofill.not_(nodrc_drw)
    count = metal1_nofill.count()
    deck.info(f"metal1_nofill has {count} polygons")
    polygons_count += count

    metal1_text = deck.labels(8, 25)
    metal1_text = metal1_text.not_(nodrc_drw)
    count = metal1_text.count()
    deck.info(f"metal1_text has {count} polygons")
    polygons_count += count

    metal1_OPC = get_polygons(8, 26)
    metal1_OPC = metal1_OPC.not_(nodrc_drw)
    count = metal1_OPC.count()
    deck.info(f"metal1_OPC has {count} polygons")
    polygons_count += count

    metal1_noqrc = get_polygons(8, 28)
    metal1_noqrc = metal1_noqrc.not_(nodrc_drw)
    count = metal1_noqrc.count()
    deck.info(f"metal1_noqrc has {count} polygons")
    polygons_count += count

    metal1_res = get_polygons(8, 29)
    metal1_res = metal1_res.not_(nodrc_drw)
    count = metal1_res.count()
    deck.info(f"metal1_res has {count} polygons")
    polygons_count += count

    metal1_iprobe = get_polygons(8, 33)
    metal1_iprobe = metal1_iprobe.not_(nodrc_drw)
    count = metal1_iprobe.count()
    deck.info(f"metal1_iprobe has {count} polygons")
    polygons_count += count

    metal1_diffprb = get_polygons(8, 34)
    metal1_diffprb = metal1_diffprb.not_(nodrc_drw)
    count = metal1_diffprb.count()
    deck.info(f"metal1_diffprb has {count} polygons")
    polygons_count += count

    passiv_drw = get_polygons(9, 0)
    passiv_drw = passiv_drw.not_(nodrc_drw)
    count = passiv_drw.count()
    deck.info(f"passiv_drw has {count} polygons")
    polygons_count += count

    passiv_pin = get_polygons(9, 2)
    passiv_pin = passiv_pin.not_(nodrc_drw)
    count = passiv_pin.count()
    deck.info(f"passiv_pin has {count} polygons")
    polygons_count += count

    passiv_sbump = get_polygons(9, 36)
    passiv_sbump = passiv_sbump.not_(nodrc_drw)
    count = passiv_sbump.count()
    deck.info(f"passiv_sbump has {count} polygons")
    polygons_count += count

    passiv_pillar = get_polygons(9, 35)
    passiv_pillar = passiv_pillar.not_(nodrc_drw)
    count = passiv_pillar.count()
    deck.info(f"passiv_pillar has {count} polygons")
    polygons_count += count

    passiv_pdl = get_polygons(9, 40)
    passiv_pdl = passiv_pdl.not_(nodrc_drw)
    count = passiv_pdl.count()
    deck.info(f"passiv_pdl has {count} polygons")
    polygons_count += count

    metal2_drw = get_polygons(10, 0)
    metal2_drw = metal2_drw.not_(nodrc_drw)
    count = metal2_drw.count()
    deck.info(f"metal2_drw has {count} polygons")
    polygons_count += count

    metal2_filler = get_polygons(10, 22)
    metal2_filler = metal2_filler.not_(nodrc_drw)
    count = metal2_filler.count()
    deck.info(f"metal2_filler has {count} polygons")
    polygons_count += count

    metal2_slit = get_polygons(10, 24)
    metal2_slit = metal2_slit.not_(nodrc_drw)
    count = metal2_slit.count()
    deck.info(f"metal2_slit has {count} polygons")
    polygons_count += count

    # metal2 org
    metal2 = metal2_drw.join(metal2_filler).not_(metal2_slit)
    count = metal2.count()
    deck.info(f"metal2 has {count} polygons")

    metal2_pin = get_polygons(10, 2)
    metal2_pin = metal2_pin.not_(nodrc_drw)
    count = metal2_pin.count()
    deck.info(f"metal2_pin has {count} polygons")
    polygons_count += count

    metal2_mask = get_polygons(10, 20)
    metal2_mask = metal2_mask.not_(nodrc_drw)
    count = metal2_mask.count()
    deck.info(f"metal2_mask has {count} polygons")
    polygons_count += count

    metal2_nofill = get_polygons(10, 23)
    metal2_nofill = metal2_nofill.not_(nodrc_drw)
    count = metal2_nofill.count()
    deck.info(f"metal2_nofill has {count} polygons")
    polygons_count += count

    metal2_text = deck.labels(10, 25)
    metal2_text = metal2_text.not_(nodrc_drw)
    count = metal2_text.count()
    deck.info(f"metal2_text has {count} polygons")
    polygons_count += count

    metal2_OPC = get_polygons(10, 26)
    metal2_OPC = metal2_OPC.not_(nodrc_drw)
    count = metal2_OPC.count()
    deck.info(f"metal2_OPC has {count} polygons")
    polygons_count += count

    metal2_noqrc = get_polygons(10, 28)
    metal2_noqrc = metal2_noqrc.not_(nodrc_drw)
    count = metal2_noqrc.count()
    deck.info(f"metal2_noqrc has {count} polygons")
    polygons_count += count

    metal2_res = get_polygons(10, 29)
    metal2_res = metal2_res.not_(nodrc_drw)
    count = metal2_res.count()
    deck.info(f"metal2_res has {count} polygons")
    polygons_count += count

    metal2_iprobe = get_polygons(10, 33)
    metal2_iprobe = metal2_iprobe.not_(nodrc_drw)
    count = metal2_iprobe.count()
    deck.info(f"metal2_iprobe has {count} polygons")
    polygons_count += count

    metal2_diffprb = get_polygons(10, 34)
    metal2_diffprb = metal2_diffprb.not_(nodrc_drw)
    count = metal2_diffprb.count()
    deck.info(f"metal2_diffprb has {count} polygons")
    polygons_count += count

    baspoly_drw = get_polygons(13, 0)
    baspoly_drw = baspoly_drw.not_(nodrc_drw)
    count = baspoly_drw.count()
    deck.info(f"baspoly_drw has {count} polygons")
    polygons_count += count

    baspoly_pin = get_polygons(13, 2)
    baspoly_pin = baspoly_pin.not_(nodrc_drw)
    count = baspoly_pin.count()
    deck.info(f"baspoly_pin has {count} polygons")
    polygons_count += count

    psd_drw = get_polygons(14, 0)
    psd_drw = psd_drw.not_(nodrc_drw)
    count = psd_drw.count()
    deck.info(f"psd_drw has {count} polygons")
    polygons_count += count

    nldb_drw = get_polygons(15, 0)
    nldb_drw = nldb_drw.not_(nodrc_drw)
    count = nldb_drw.count()
    deck.info(f"nldb_drw has {count} polygons")
    polygons_count += count

    digibnd_drw = get_polygons(16, 0)
    digibnd_drw = digibnd_drw.not_(nodrc_drw)
    count = digibnd_drw.count()
    deck.info(f"digibnd_drw has {count} polygons")
    polygons_count += count

    via1_drw = get_polygons(19, 0)
    via1_drw = via1_drw.not_(nodrc_drw)
    count = via1_drw.count()
    deck.info(f"via1_drw has {count} polygons")
    polygons_count += count

    backmetal1_drw = get_polygons(20, 0)
    backmetal1_drw = backmetal1_drw.not_(nodrc_drw)
    count = backmetal1_drw.count()
    deck.info(f"backmetal1_drw has {count} polygons")
    polygons_count += count

    backmetal1_pin = get_polygons(20, 2)
    backmetal1_pin = backmetal1_pin.not_(nodrc_drw)
    count = backmetal1_pin.count()
    deck.info(f"backmetal1_pin has {count} polygons")
    polygons_count += count

    backmetal1_mask = get_polygons(20, 20)
    backmetal1_mask = backmetal1_mask.not_(nodrc_drw)
    count = backmetal1_mask.count()
    deck.info(f"backmetal1_mask has {count} polygons")
    polygons_count += count

    backmetal1_filler = get_polygons(20, 22)
    backmetal1_filler = backmetal1_filler.not_(nodrc_drw)
    count = backmetal1_filler.count()
    deck.info(f"backmetal1_filler has {count} polygons")
    polygons_count += count

    backmetal1_nofill = get_polygons(20, 23)
    backmetal1_nofill = backmetal1_nofill.not_(nodrc_drw)
    count = backmetal1_nofill.count()
    deck.info(f"backmetal1_nofill has {count} polygons")
    polygons_count += count

    backmetal1_slit = get_polygons(20, 24)
    backmetal1_slit = backmetal1_slit.not_(nodrc_drw)
    count = backmetal1_slit.count()
    deck.info(f"backmetal1_slit has {count} polygons")
    polygons_count += count

    backmetal1_text = deck.labels(20, 25)
    backmetal1_text = backmetal1_text.not_(nodrc_drw)
    count = backmetal1_text.count()
    deck.info(f"backmetal1_text has {count} polygons")
    polygons_count += count

    backmetal1_OPC = get_polygons(20, 26)
    backmetal1_OPC = backmetal1_OPC.not_(nodrc_drw)
    count = backmetal1_OPC.count()
    deck.info(f"backmetal1_OPC has {count} polygons")
    polygons_count += count

    backmetal1_noqrc = get_polygons(20, 28)
    backmetal1_noqrc = backmetal1_noqrc.not_(nodrc_drw)
    count = backmetal1_noqrc.count()
    deck.info(f"backmetal1_noqrc has {count} polygons")
    polygons_count += count

    backmetal1_res = get_polygons(20, 29)
    backmetal1_res = backmetal1_res.not_(nodrc_drw)
    count = backmetal1_res.count()
    deck.info(f"backmetal1_res has {count} polygons")
    polygons_count += count

    backmetal1_iprobe = get_polygons(20, 33)
    backmetal1_iprobe = backmetal1_iprobe.not_(nodrc_drw)
    count = backmetal1_iprobe.count()
    deck.info(f"backmetal1_iprobe has {count} polygons")
    polygons_count += count

    backmetal1_diffprb = get_polygons(20, 34)
    backmetal1_diffprb = backmetal1_diffprb.not_(nodrc_drw)
    count = backmetal1_diffprb.count()
    deck.info(f"backmetal1_diffprb has {count} polygons")
    polygons_count += count

    backpassiv_drw = get_polygons(23, 0)
    backpassiv_drw = backpassiv_drw.not_(nodrc_drw)
    count = backpassiv_drw.count()
    deck.info(f"backpassiv_drw has {count} polygons")
    polygons_count += count

    res_drw = get_polygons(24, 0)
    res_drw = res_drw.not_(nodrc_drw)
    count = res_drw.count()
    deck.info(f"res_drw has {count} polygons")
    polygons_count += count

    sram_drw = get_polygons(25, 0)
    sram_drw = sram_drw.not_(nodrc_drw)
    count = sram_drw.count()
    deck.info(f"sram_drw has {count} polygons")
    polygons_count += count

    trans_drw = get_polygons(26, 0)
    trans_drw = trans_drw.not_(nodrc_drw)
    count = trans_drw.count()
    deck.info(f"trans_drw has {count} polygons")
    polygons_count += count

    ind_drw = get_polygons(27, 0)
    ind_drw = ind_drw.not_(nodrc_drw)
    count = ind_drw.count()
    deck.info(f"ind_drw has {count} polygons")
    polygons_count += count

    ind_pin = get_polygons(27, 2)
    ind_pin = ind_pin.not_(nodrc_drw)
    count = ind_pin.count()
    deck.info(f"ind_pin has {count} polygons")
    polygons_count += count

    ind_text = deck.labels(27, 25)
    ind_text = ind_text.not_(nodrc_drw)
    count = ind_text.count()
    deck.info(f"ind_text has {count} polygons")
    polygons_count += count

    salblock_drw = get_polygons(28, 0)
    salblock_drw = salblock_drw.not_(nodrc_drw)
    count = salblock_drw.count()
    deck.info(f"salblock_drw has {count} polygons")
    polygons_count += count

    via2_drw = get_polygons(29, 0)
    via2_drw = via2_drw.not_(nodrc_drw)
    count = via2_drw.count()
    deck.info(f"via2_drw has {count} polygons")
    polygons_count += count

    metal3_drw = get_polygons(30, 0)
    metal3_drw = metal3_drw.not_(nodrc_drw)
    count = metal3_drw.count()
    deck.info(f"metal3_drw has {count} polygons")
    polygons_count += count

    metal3_filler = get_polygons(30, 22)
    metal3_filler = metal3_filler.not_(nodrc_drw)
    count = metal3_filler.count()
    deck.info(f"metal3_filler has {count} polygons")
    polygons_count += count

    metal3_slit = get_polygons(30, 24)
    metal3_slit = metal3_slit.not_(nodrc_drw)
    count = metal3_slit.count()
    deck.info(f"metal3_slit has {count} polygons")
    polygons_count += count

    # metal3 org
    metal3 = metal3_drw.join(metal3_filler).not_(metal3_slit)
    count = metal3.count()
    deck.info(f"metal3 has {count} polygons")

    metal3_pin = get_polygons(30, 2)
    metal3_pin = metal3_pin.not_(nodrc_drw)
    count = metal3_pin.count()
    deck.info(f"metal3_pin has {count} polygons")
    polygons_count += count

    metal3_mask = get_polygons(30, 20)
    metal3_mask = metal3_mask.not_(nodrc_drw)
    count = metal3_mask.count()
    deck.info(f"metal3_mask has {count} polygons")
    polygons_count += count

    metal3_nofill = get_polygons(30, 23)
    metal3_nofill = metal3_nofill.not_(nodrc_drw)
    count = metal3_nofill.count()
    deck.info(f"metal3_nofill has {count} polygons")
    polygons_count += count

    metal3_text = deck.labels(30, 25)
    metal3_text = metal3_text.not_(nodrc_drw)
    count = metal3_text.count()
    deck.info(f"metal3_text has {count} polygons")
    polygons_count += count

    metal3_OPC = get_polygons(30, 26)
    metal3_OPC = metal3_OPC.not_(nodrc_drw)
    count = metal3_OPC.count()
    deck.info(f"metal3_OPC has {count} polygons")
    polygons_count += count

    metal3_noqrc = get_polygons(30, 28)
    metal3_noqrc = metal3_noqrc.not_(nodrc_drw)
    count = metal3_noqrc.count()
    deck.info(f"metal3_noqrc has {count} polygons")
    polygons_count += count

    metal3_res = get_polygons(30, 29)
    metal3_res = metal3_res.not_(nodrc_drw)
    count = metal3_res.count()
    deck.info(f"metal3_res has {count} polygons")
    polygons_count += count

    metal3_iprobe = get_polygons(30, 33)
    metal3_iprobe = metal3_iprobe.not_(nodrc_drw)
    count = metal3_iprobe.count()
    deck.info(f"metal3_iprobe has {count} polygons")
    polygons_count += count

    metal3_diffprb = get_polygons(30, 34)
    metal3_diffprb = metal3_diffprb.not_(nodrc_drw)
    count = metal3_diffprb.count()
    deck.info(f"metal3_diffprb has {count} polygons")
    polygons_count += count

    nwell_drw = get_polygons(31, 0)
    nwell_drw = nwell_drw.not_(nodrc_drw)
    count = nwell_drw.count()
    deck.info(f"nwell_drw has {count} polygons")
    polygons_count += count

    nwell_pin = get_polygons(31, 2)
    nwell_pin = nwell_pin.not_(nodrc_drw)
    count = nwell_pin.count()
    deck.info(f"nwell_pin has {count} polygons")
    polygons_count += count

    nbulay_drw = get_polygons(32, 0)
    nbulay_drw = nbulay_drw.not_(nodrc_drw)
    count = nbulay_drw.count()
    deck.info(f"nbulay_drw has {count} polygons")
    polygons_count += count

    nbulay_pin = get_polygons(32, 2)
    nbulay_pin = nbulay_pin.not_(nodrc_drw)
    count = nbulay_pin.count()
    deck.info(f"nbulay_pin has {count} polygons")
    polygons_count += count

    nbulay_block = get_polygons(32, 21)
    nbulay_block = nbulay_block.not_(nodrc_drw)
    count = nbulay_block.count()
    deck.info(f"nbulay_block has {count} polygons")
    polygons_count += count

    emwind_drw = get_polygons(33, 0)
    emwind_drw = emwind_drw.not_(nodrc_drw)
    count = emwind_drw.count()
    deck.info(f"emwind_drw has {count} polygons")
    polygons_count += count

    emwind_OPC = get_polygons(33, 26)
    emwind_OPC = emwind_OPC.not_(nodrc_drw)
    count = emwind_OPC.count()
    deck.info(f"emwind_OPC has {count} polygons")
    polygons_count += count

    deepco_drw = get_polygons(35, 0)
    deepco_drw = deepco_drw.not_(nodrc_drw)
    count = deepco_drw.count()
    deck.info(f"deepco_drw has {count} polygons")
    polygons_count += count

    mim_drw = get_polygons(36, 0)
    mim_drw = mim_drw.not_(nodrc_drw)
    count = mim_drw.count()
    deck.info(f"mim_drw has {count} polygons")
    polygons_count += count

    edgeseal_drw = get_polygons(39, 0)
    edgeseal_drw = edgeseal_drw.not_(nodrc_drw)
    count = edgeseal_drw.count()
    deck.info(f"edgeseal_drw has {count} polygons")
    polygons_count += count

    substrate_drw = get_polygons(40, 0)
    substrate_drw = substrate_drw.not_(nodrc_drw)
    count = substrate_drw.count()
    deck.info(f"substrate_drw has {count} polygons")
    polygons_count += count

    substrate_text = deck.labels(40, 25)
    substrate_text = substrate_text.not_(nodrc_drw)
    count = substrate_text.count()
    deck.info(f"substrate_text has {count} polygons")
    polygons_count += count

    dfpad_drw = get_polygons(41, 0)
    dfpad_drw = dfpad_drw.not_(nodrc_drw)
    count = dfpad_drw.count()
    deck.info(f"dfpad_drw has {count} polygons")
    polygons_count += count

    dfpad_pillar = get_polygons(41, 35)
    dfpad_pillar = dfpad_pillar.not_(nodrc_drw)
    count = dfpad_pillar.count()
    deck.info(f"dfpad_pillar has {count} polygons")
    polygons_count += count

    dfpad_sbump = get_polygons(41, 36)
    dfpad_sbump = dfpad_sbump.not_(nodrc_drw)
    count = dfpad_sbump.count()
    deck.info(f"dfpad_sbump has {count} polygons")
    polygons_count += count

    thickgateox_drw = get_polygons(44, 0)
    thickgateox_drw = thickgateox_drw.not_(nodrc_drw)
    count = thickgateox_drw.count()
    deck.info(f"thickgateox_drw has {count} polygons")
    polygons_count += count

    pldb_drw = get_polygons(45, 0)
    pldb_drw = pldb_drw.not_(nodrc_drw)
    count = pldb_drw.count()
    deck.info(f"pldb_drw has {count} polygons")
    polygons_count += count

    pwell_drw = get_polygons(46, 0)
    pwell_drw = pwell_drw.not_(nodrc_drw)
    count = pwell_drw.count()
    deck.info(f"pwell_drw has {count} polygons")
    polygons_count += count

    pwell_pin = get_polygons(46, 2)
    pwell_pin = pwell_pin.not_(nodrc_drw)
    count = pwell_pin.count()
    deck.info(f"pwell_pin has {count} polygons")
    polygons_count += count

    pwell_block = get_polygons(46, 21)
    pwell_block = pwell_block.not_(nodrc_drw)
    count = pwell_block.count()
    deck.info(f"pwell_block has {count} polygons")
    polygons_count += count

    ic_drw = get_polygons(48, 0)
    ic_drw = ic_drw.not_(nodrc_drw)
    count = ic_drw.count()
    deck.info(f"ic_drw has {count} polygons")
    polygons_count += count

    via3_drw = get_polygons(49, 0)
    via3_drw = via3_drw.not_(nodrc_drw)
    count = via3_drw.count()
    deck.info(f"via3_drw has {count} polygons")
    polygons_count += count

    metal4_drw = get_polygons(50, 0)
    metal4_drw = metal4_drw.not_(nodrc_drw)
    count = metal4_drw.count()
    deck.info(f"metal4_drw has {count} polygons")
    polygons_count += count

    metal4_filler = get_polygons(50, 22)
    metal4_filler = metal4_filler.not_(nodrc_drw)
    count = metal4_filler.count()
    deck.info(f"metal4_filler has {count} polygons")
    polygons_count += count

    metal4_slit = get_polygons(50, 24)
    metal4_slit = metal4_slit.not_(nodrc_drw)
    count = metal4_slit.count()
    deck.info(f"metal4_slit has {count} polygons")
    polygons_count += count

    # metal4 org
    metal4 = metal4_drw.join(metal4_filler).not_(metal4_slit)
    count = metal4.count()
    deck.info(f"metal4 has {count} polygons")

    metal4_pin = get_polygons(50, 2)
    metal4_pin = metal4_pin.not_(nodrc_drw)
    count = metal4_pin.count()
    deck.info(f"metal4_pin has {count} polygons")
    polygons_count += count

    metal4_mask = get_polygons(50, 20)
    metal4_mask = metal4_mask.not_(nodrc_drw)
    count = metal4_mask.count()
    deck.info(f"metal4_mask has {count} polygons")
    polygons_count += count

    metal4_nofill = get_polygons(50, 23)
    metal4_nofill = metal4_nofill.not_(nodrc_drw)
    count = metal4_nofill.count()
    deck.info(f"metal4_nofill has {count} polygons")
    polygons_count += count

    metal4_text = deck.labels(50, 25)
    metal4_text = metal4_text.not_(nodrc_drw)
    count = metal4_text.count()
    deck.info(f"metal4_text has {count} polygons")
    polygons_count += count

    metal4_OPC = get_polygons(50, 26)
    metal4_OPC = metal4_OPC.not_(nodrc_drw)
    count = metal4_OPC.count()
    deck.info(f"metal4_OPC has {count} polygons")
    polygons_count += count

    metal4_noqrc = get_polygons(50, 28)
    metal4_noqrc = metal4_noqrc.not_(nodrc_drw)
    count = metal4_noqrc.count()
    deck.info(f"metal4_noqrc has {count} polygons")
    polygons_count += count

    metal4_res = get_polygons(50, 29)
    metal4_res = metal4_res.not_(nodrc_drw)
    count = metal4_res.count()
    deck.info(f"metal4_res has {count} polygons")
    polygons_count += count

    metal4_iprobe = get_polygons(50, 33)
    metal4_iprobe = metal4_iprobe.not_(nodrc_drw)
    count = metal4_iprobe.count()
    deck.info(f"metal4_iprobe has {count} polygons")
    polygons_count += count

    metal4_diffprb = get_polygons(50, 34)
    metal4_diffprb = metal4_diffprb.not_(nodrc_drw)
    count = metal4_diffprb.count()
    deck.info(f"metal4_diffprb has {count} polygons")
    polygons_count += count

    heattrans_drw = get_polygons(51, 0)
    heattrans_drw = heattrans_drw.not_(nodrc_drw)
    count = heattrans_drw.count()
    deck.info(f"heattrans_drw has {count} polygons")
    polygons_count += count

    heatres_drw = get_polygons(52, 0)
    heatres_drw = heatres_drw.not_(nodrc_drw)
    count = heatres_drw.count()
    deck.info(f"heatres_drw has {count} polygons")
    polygons_count += count

    fbe_drw = get_polygons(54, 0)
    fbe_drw = fbe_drw.not_(nodrc_drw)
    count = fbe_drw.count()
    deck.info(f"fbe_drw has {count} polygons")
    polygons_count += count

    empoly_drw = get_polygons(55, 0)
    empoly_drw = empoly_drw.not_(nodrc_drw)
    count = empoly_drw.count()
    deck.info(f"empoly_drw has {count} polygons")
    polygons_count += count

    digisub_drw = get_polygons(60, 0)
    digisub_drw = digisub_drw.not_(nodrc_drw)
    count = digisub_drw.count()
    deck.info(f"digisub_drw has {count} polygons")
    polygons_count += count

    text_drw = deck.labels(63, 0)
    text_drw = text_drw.not_(nodrc_drw)
    count = text_drw.count()
    deck.info(f"text_drw has {count} polygons")
    polygons_count += count

    via4_drw = get_polygons(66, 0)
    via4_drw = via4_drw.not_(nodrc_drw)
    count = via4_drw.count()
    deck.info(f"via4_drw has {count} polygons")
    polygons_count += count

    metal5_drw = get_polygons(67, 0)
    metal5_drw = metal5_drw.not_(nodrc_drw)
    count = metal5_drw.count()
    deck.info(f"metal5_drw has {count} polygons")
    polygons_count += count

    metal5_filler = get_polygons(67, 22)
    metal5_filler = metal5_filler.not_(nodrc_drw)
    count = metal5_filler.count()
    deck.info(f"metal5_filler has {count} polygons")
    polygons_count += count

    metal5_slit = get_polygons(67, 24)
    metal5_slit = metal5_slit.not_(nodrc_drw)
    count = metal5_slit.count()
    deck.info(f"metal5_slit has {count} polygons")
    polygons_count += count

    # metal5 org
    metal5 = metal5_drw.join(metal5_filler).not_(metal5_slit)
    count = metal5.count()
    deck.info(f"metal5 has {count} polygons")

    metal5_pin = get_polygons(67, 2)
    metal5_pin = metal5_pin.not_(nodrc_drw)
    count = metal5_pin.count()
    deck.info(f"metal5_pin has {count} polygons")
    polygons_count += count

    metal5_mask = get_polygons(67, 20)
    metal5_mask = metal5_mask.not_(nodrc_drw)
    count = metal5_mask.count()
    deck.info(f"metal5_mask has {count} polygons")
    polygons_count += count

    metal5_nofill = get_polygons(67, 23)
    metal5_nofill = metal5_nofill.not_(nodrc_drw)
    count = metal5_nofill.count()
    deck.info(f"metal5_nofill has {count} polygons")
    polygons_count += count

    metal5_text = deck.labels(67, 25)
    metal5_text = metal5_text.not_(nodrc_drw)
    count = metal5_text.count()
    deck.info(f"metal5_text has {count} polygons")
    polygons_count += count

    metal5_OPC = get_polygons(67, 26)
    metal5_OPC = metal5_OPC.not_(nodrc_drw)
    count = metal5_OPC.count()
    deck.info(f"metal5_OPC has {count} polygons")
    polygons_count += count

    metal5_noqrc = get_polygons(67, 28)
    metal5_noqrc = metal5_noqrc.not_(nodrc_drw)
    count = metal5_noqrc.count()
    deck.info(f"metal5_noqrc has {count} polygons")
    polygons_count += count

    metal5_res = get_polygons(67, 29)
    metal5_res = metal5_res.not_(nodrc_drw)
    count = metal5_res.count()
    deck.info(f"metal5_res has {count} polygons")
    polygons_count += count

    metal5_iprobe = get_polygons(67, 33)
    metal5_iprobe = metal5_iprobe.not_(nodrc_drw)
    count = metal5_iprobe.count()
    deck.info(f"metal5_iprobe has {count} polygons")
    polygons_count += count

    metal5_diffprb = get_polygons(67, 34)
    metal5_diffprb = metal5_diffprb.not_(nodrc_drw)
    count = metal5_diffprb.count()
    deck.info(f"metal5_diffprb has {count} polygons")
    polygons_count += count

    radhard_drw = get_polygons(68, 0)
    radhard_drw = radhard_drw.not_(nodrc_drw)
    count = radhard_drw.count()
    deck.info(f"radhard_drw has {count} polygons")
    polygons_count += count

    memcap_drw = get_polygons(69, 0)
    memcap_drw = memcap_drw.not_(nodrc_drw)
    count = memcap_drw.count()
    deck.info(f"memcap_drw has {count} polygons")
    polygons_count += count

    varicap_drw = get_polygons(70, 0)
    varicap_drw = varicap_drw.not_(nodrc_drw)
    count = varicap_drw.count()
    deck.info(f"varicap_drw has {count} polygons")
    polygons_count += count

    intbondvia_drw = get_polygons(72, 0)
    intbondvia_drw = intbondvia_drw.not_(nodrc_drw)
    count = intbondvia_drw.count()
    deck.info(f"intbondvia_drw has {count} polygons")
    polygons_count += count

    intbondmet_drw = get_polygons(73, 0)
    intbondmet_drw = intbondmet_drw.not_(nodrc_drw)
    count = intbondmet_drw.count()
    deck.info(f"intbondmet_drw has {count} polygons")
    polygons_count += count

    devbondvia_drw = get_polygons(74, 0)
    devbondvia_drw = devbondvia_drw.not_(nodrc_drw)
    count = devbondvia_drw.count()
    deck.info(f"devbondvia_drw has {count} polygons")
    polygons_count += count

    devbondmet_drw = get_polygons(75, 0)
    devbondmet_drw = devbondmet_drw.not_(nodrc_drw)
    count = devbondmet_drw.count()
    deck.info(f"devbondmet_drw has {count} polygons")
    polygons_count += count

    devtrench_drw = get_polygons(76, 0)
    devtrench_drw = devtrench_drw.not_(nodrc_drw)
    count = devtrench_drw.count()
    deck.info(f"devtrench_drw has {count} polygons")
    polygons_count += count

    redist_drw = get_polygons(77, 0)
    redist_drw = redist_drw.not_(nodrc_drw)
    count = redist_drw.count()
    deck.info(f"redist_drw has {count} polygons")
    polygons_count += count

    graphbot_drw = get_polygons(78, 0)
    graphbot_drw = graphbot_drw.not_(nodrc_drw)
    count = graphbot_drw.count()
    deck.info(f"graphbot_drw has {count} polygons")
    polygons_count += count

    graphtop_drw = get_polygons(79, 0)
    graphtop_drw = graphtop_drw.not_(nodrc_drw)
    count = graphtop_drw.count()
    deck.info(f"graphtop_drw has {count} polygons")
    polygons_count += count

    antvia1_drw = get_polygons(83, 0)
    antvia1_drw = antvia1_drw.not_(nodrc_drw)
    count = antvia1_drw.count()
    deck.info(f"antvia1_drw has {count} polygons")
    polygons_count += count

    antmetal2_drw = get_polygons(84, 0)
    antmetal2_drw = antmetal2_drw.not_(nodrc_drw)
    count = antmetal2_drw.count()
    deck.info(f"antmetal2_drw has {count} polygons")
    polygons_count += count

    graphcont_drw = get_polygons(85, 0)
    graphcont_drw = graphcont_drw.not_(nodrc_drw)
    count = graphcont_drw.count()
    deck.info(f"graphcont_drw has {count} polygons")
    polygons_count += count

    siwg_drw = get_polygons(86, 0)
    siwg_drw = siwg_drw.not_(nodrc_drw)
    count = siwg_drw.count()
    deck.info(f"siwg_drw has {count} polygons")
    polygons_count += count

    siwg_filler = get_polygons(86, 22)
    siwg_filler = siwg_filler.not_(nodrc_drw)
    count = siwg_filler.count()
    deck.info(f"siwg_filler has {count} polygons")
    polygons_count += count

    siwg_nofill = get_polygons(86, 23)
    siwg_nofill = siwg_nofill.not_(nodrc_drw)
    count = siwg_nofill.count()
    deck.info(f"siwg_nofill has {count} polygons")
    polygons_count += count

    sigrating_drw = get_polygons(87, 0)
    sigrating_drw = sigrating_drw.not_(nodrc_drw)
    count = sigrating_drw.count()
    deck.info(f"sigrating_drw has {count} polygons")
    polygons_count += count

    singrating_drw = get_polygons(88, 0)
    singrating_drw = singrating_drw.not_(nodrc_drw)
    count = singrating_drw.count()
    deck.info(f"singrating_drw has {count} polygons")
    polygons_count += count

    graphpas_drw = get_polygons(89, 0)
    graphpas_drw = graphpas_drw.not_(nodrc_drw)
    count = graphpas_drw.count()
    deck.info(f"graphpas_drw has {count} polygons")
    polygons_count += count

    emwind3_drw = get_polygons(90, 0)
    emwind3_drw = emwind3_drw.not_(nodrc_drw)
    count = emwind3_drw.count()
    deck.info(f"emwind3_drw has {count} polygons")
    polygons_count += count

    emwihv3_drw = get_polygons(91, 0)
    emwihv3_drw = emwihv3_drw.not_(nodrc_drw)
    count = emwihv3_drw.count()
    deck.info(f"emwihv3_drw has {count} polygons")
    polygons_count += count

    redbulay_drw = get_polygons(92, 0)
    redbulay_drw = redbulay_drw.not_(nodrc_drw)
    count = redbulay_drw.count()
    deck.info(f"redbulay_drw has {count} polygons")
    polygons_count += count

    smos_drw = get_polygons(93, 0)
    smos_drw = smos_drw.not_(nodrc_drw)
    count = smos_drw.count()
    deck.info(f"smos_drw has {count} polygons")
    polygons_count += count

    graphpad_drw = get_polygons(97, 0)
    graphpad_drw = graphpad_drw.not_(nodrc_drw)
    count = graphpad_drw.count()
    deck.info(f"graphpad_drw has {count} polygons")
    polygons_count += count

    polimide_drw = get_polygons(98, 0)
    polimide_drw = polimide_drw.not_(nodrc_drw)
    count = polimide_drw.count()
    deck.info(f"polimide_drw has {count} polygons")
    polygons_count += count

    polimide_pin = get_polygons(98, 2)
    polimide_pin = polimide_pin.not_(nodrc_drw)
    count = polimide_pin.count()
    deck.info(f"polimide_pin has {count} polygons")
    polygons_count += count

    recog_drw = get_polygons(99, 0)
    recog_drw = recog_drw.not_(nodrc_drw)
    count = recog_drw.count()
    deck.info(f"recog_drw has {count} polygons")
    polygons_count += count

    recog_pin = get_polygons(99, 2)
    recog_pin = recog_pin.not_(nodrc_drw)
    count = recog_pin.count()
    deck.info(f"recog_pin has {count} polygons")
    polygons_count += count

    recog_esd = get_polygons(99, 30)
    recog_esd = recog_esd.not_(nodrc_drw)
    count = recog_esd.count()
    deck.info(f"recog_esd has {count} polygons")
    polygons_count += count

    recog_diode = get_polygons(99, 31)
    recog_diode = recog_diode.not_(nodrc_drw)
    count = recog_diode.count()
    deck.info(f"recog_diode has {count} polygons")
    polygons_count += count

    recog_tsv = get_polygons(99, 32)
    recog_tsv = recog_tsv.not_(nodrc_drw)
    count = recog_tsv.count()
    deck.info(f"recog_tsv has {count} polygons")
    polygons_count += count

    recog_iprobe = get_polygons(99, 33)
    recog_iprobe = recog_iprobe.not_(nodrc_drw)
    count = recog_iprobe.count()
    deck.info(f"recog_iprobe has {count} polygons")
    polygons_count += count

    recog_diffprb = get_polygons(99, 34)
    recog_diffprb = recog_diffprb.not_(nodrc_drw)
    count = recog_diffprb.count()
    deck.info(f"recog_diffprb has {count} polygons")
    polygons_count += count

    recog_pillar = get_polygons(99, 35)
    recog_pillar = recog_pillar.not_(nodrc_drw)
    count = recog_pillar.count()
    deck.info(f"recog_pillar has {count} polygons")
    polygons_count += count

    recog_sbump = get_polygons(99, 36)
    recog_sbump = recog_sbump.not_(nodrc_drw)
    count = recog_sbump.count()
    deck.info(f"recog_sbump has {count} polygons")
    polygons_count += count

    recog_otp = get_polygons(99, 37)
    recog_otp = recog_otp.not_(nodrc_drw)
    count = recog_otp.count()
    deck.info(f"recog_otp has {count} polygons")
    polygons_count += count

    recog_pdiode = get_polygons(99, 38)
    recog_pdiode = recog_pdiode.not_(nodrc_drw)
    count = recog_pdiode.count()
    deck.info(f"recog_pdiode has {count} polygons")
    polygons_count += count

    recog_mom = get_polygons(99, 39)
    recog_mom = recog_mom.not_(nodrc_drw)
    count = recog_mom.count()
    deck.info(f"recog_mom has {count} polygons")
    polygons_count += count

    recog_pcm = get_polygons(99, 100)
    recog_pcm = recog_pcm.not_(nodrc_drw)
    count = recog_pcm.count()
    deck.info(f"recog_pcm has {count} polygons")
    polygons_count += count

    colopen_drw = get_polygons(101, 0)
    colopen_drw = colopen_drw.not_(nodrc_drw)
    count = colopen_drw.count()
    deck.info(f"colopen_drw has {count} polygons")
    polygons_count += count

    graphmetal1_drw = get_polygons(109, 0)
    graphmetal1_drw = graphmetal1_drw.not_(nodrc_drw)
    count = graphmetal1_drw.count()
    deck.info(f"graphmetal1_drw has {count} polygons")
    polygons_count += count

    graphmetal1_filler = get_polygons(109, 22)
    graphmetal1_filler = graphmetal1_filler.not_(nodrc_drw)
    count = graphmetal1_filler.count()
    deck.info(f"graphmetal1_filler has {count} polygons")
    polygons_count += count

    graphmetal1_nofill = get_polygons(109, 23)
    graphmetal1_nofill = graphmetal1_nofill.not_(nodrc_drw)
    count = graphmetal1_nofill.count()
    deck.info(f"graphmetal1_nofill has {count} polygons")
    polygons_count += count

    graphmetal1_slit = get_polygons(109, 24)
    graphmetal1_slit = graphmetal1_slit.not_(nodrc_drw)
    count = graphmetal1_slit.count()
    deck.info(f"graphmetal1_slit has {count} polygons")
    polygons_count += count

    graphmetal1_OPC = get_polygons(109, 26)
    graphmetal1_OPC = graphmetal1_OPC.not_(nodrc_drw)
    count = graphmetal1_OPC.count()
    deck.info(f"graphmetal1_OPC has {count} polygons")
    polygons_count += count

    graphmet1l_drw = get_polygons(110, 0)
    graphmet1l_drw = graphmet1l_drw.not_(nodrc_drw)
    count = graphmet1l_drw.count()
    deck.info(f"graphmet1l_drw has {count} polygons")
    polygons_count += count

    graphmet1l_filler = get_polygons(110, 22)
    graphmet1l_filler = graphmet1l_filler.not_(nodrc_drw)
    count = graphmet1l_filler.count()
    deck.info(f"graphmet1l_filler has {count} polygons")
    polygons_count += count

    graphmet1l_nofill = get_polygons(110, 23)
    graphmet1l_nofill = graphmet1l_nofill.not_(nodrc_drw)
    count = graphmet1l_nofill.count()
    deck.info(f"graphmet1l_nofill has {count} polygons")
    polygons_count += count

    graphmet1l_slit = get_polygons(110, 24)
    graphmet1l_slit = graphmet1l_slit.not_(nodrc_drw)
    count = graphmet1l_slit.count()
    deck.info(f"graphmet1l_slit has {count} polygons")
    polygons_count += count

    graphmet1l_OPC = get_polygons(110, 26)
    graphmet1l_OPC = graphmet1l_OPC.not_(nodrc_drw)
    count = graphmet1l_OPC.count()
    deck.info(f"graphmet1l_OPC has {count} polygons")
    polygons_count += count

    extblock_drw = get_polygons(111, 0)
    extblock_drw = extblock_drw.not_(nodrc_drw)
    count = extblock_drw.count()
    deck.info(f"extblock_drw has {count} polygons")
    polygons_count += count

    nldd_drw = get_polygons(112, 0)
    nldd_drw = nldd_drw.not_(nodrc_drw)
    count = nldd_drw.count()
    deck.info(f"nldd_drw has {count} polygons")
    polygons_count += count

    pldd_drw = get_polygons(113, 0)
    pldd_drw = pldd_drw.not_(nodrc_drw)
    count = pldd_drw.count()
    deck.info(f"pldd_drw has {count} polygons")
    polygons_count += count

    next_drw = get_polygons(114, 0)
    next_drw = next_drw.not_(nodrc_drw)
    count = next_drw.count()
    deck.info(f"next_drw has {count} polygons")
    polygons_count += count

    pext_drw = get_polygons(115, 0)
    pext_drw = pext_drw.not_(nodrc_drw)
    count = pext_drw.count()
    deck.info(f"pext_drw has {count} polygons")
    polygons_count += count

    nexthv_drw = get_polygons(116, 0)
    nexthv_drw = nexthv_drw.not_(nodrc_drw)
    count = nexthv_drw.count()
    deck.info(f"nexthv_drw has {count} polygons")
    polygons_count += count

    pexthv_drw = get_polygons(117, 0)
    pexthv_drw = pexthv_drw.not_(nodrc_drw)
    count = pexthv_drw.count()
    deck.info(f"pexthv_drw has {count} polygons")
    polygons_count += count

    graphgate_drw = get_polygons(118, 0)
    graphgate_drw = graphgate_drw.not_(nodrc_drw)
    count = graphgate_drw.count()
    deck.info(f"graphgate_drw has {count} polygons")
    polygons_count += count

    sinwg_drw = get_polygons(119, 0)
    sinwg_drw = sinwg_drw.not_(nodrc_drw)
    count = sinwg_drw.count()
    deck.info(f"sinwg_drw has {count} polygons")
    polygons_count += count

    sinwg_filler = get_polygons(119, 22)
    sinwg_filler = sinwg_filler.not_(nodrc_drw)
    count = sinwg_filler.count()
    deck.info(f"sinwg_filler has {count} polygons")
    polygons_count += count

    sinwg_nofill = get_polygons(119, 23)
    sinwg_nofill = sinwg_nofill.not_(nodrc_drw)
    count = sinwg_nofill.count()
    deck.info(f"sinwg_nofill has {count} polygons")
    polygons_count += count

    mempad_drw = get_polygons(124, 0)
    mempad_drw = mempad_drw.not_(nodrc_drw)
    count = mempad_drw.count()
    deck.info(f"mempad_drw has {count} polygons")
    polygons_count += count

    topvia1_drw = get_polygons(125, 0)
    topvia1_drw = topvia1_drw.not_(nodrc_drw)
    count = topvia1_drw.count()
    deck.info(f"topvia1_drw has {count} polygons")
    polygons_count += count

    topmetal1_drw = get_polygons(126, 0)
    topmetal1_drw = topmetal1_drw.not_(nodrc_drw)
    count = topmetal1_drw.count()
    deck.info(f"topmetal1_drw has {count} polygons")
    polygons_count += count

    topmetal1_filler = get_polygons(126, 22)
    topmetal1_filler = topmetal1_filler.not_(nodrc_drw)
    count = topmetal1_filler.count()
    deck.info(f"topmetal1_filler has {count} polygons")
    polygons_count += count

    topmetal1_slit = get_polygons(126, 24)
    topmetal1_slit = topmetal1_slit.not_(nodrc_drw)
    count = topmetal1_slit.count()
    deck.info(f"topmetal1_slit has {count} polygons")
    polygons_count += count

    # topmetal1 org
    topmetal1 = topmetal1_drw.join(topmetal1_filler).not_(topmetal1_slit)
    count = topmetal1.count()
    deck.info(f"topmetal1 has {count} polygons")

    topmetal1_pin = get_polygons(126, 2)
    topmetal1_pin = topmetal1_pin.not_(nodrc_drw)
    count = topmetal1_pin.count()
    deck.info(f"topmetal1_pin has {count} polygons")
    polygons_count += count

    topmetal1_mask = get_polygons(126, 20)
    topmetal1_mask = topmetal1_mask.not_(nodrc_drw)
    count = topmetal1_mask.count()
    deck.info(f"topmetal1_mask has {count} polygons")
    polygons_count += count

    topmetal1_nofill = get_polygons(126, 23)
    topmetal1_nofill = topmetal1_nofill.not_(nodrc_drw)
    count = topmetal1_nofill.count()
    deck.info(f"topmetal1_nofill has {count} polygons")
    polygons_count += count

    topmetal1_text = deck.labels(126, 25)
    topmetal1_text = topmetal1_text.not_(nodrc_drw)
    count = topmetal1_text.count()
    deck.info(f"topmetal1_text has {count} polygons")
    polygons_count += count

    topmetal1_noqrc = get_polygons(126, 28)
    topmetal1_noqrc = topmetal1_noqrc.not_(nodrc_drw)
    count = topmetal1_noqrc.count()
    deck.info(f"topmetal1_noqrc has {count} polygons")
    polygons_count += count

    topmetal1_res = get_polygons(126, 29)
    topmetal1_res = topmetal1_res.not_(nodrc_drw)
    count = topmetal1_res.count()
    deck.info(f"topmetal1_res has {count} polygons")
    polygons_count += count

    topmetal1_iprobe = get_polygons(126, 33)
    topmetal1_iprobe = topmetal1_iprobe.not_(nodrc_drw)
    count = topmetal1_iprobe.count()
    deck.info(f"topmetal1_iprobe has {count} polygons")
    polygons_count += count

    topmetal1_diffprb = get_polygons(126, 34)
    topmetal1_diffprb = topmetal1_diffprb.not_(nodrc_drw)
    count = topmetal1_diffprb.count()
    deck.info(f"topmetal1_diffprb has {count} polygons")
    polygons_count += count

    inldpwl_drw = get_polygons(127, 0)
    inldpwl_drw = inldpwl_drw.not_(nodrc_drw)
    count = inldpwl_drw.count()
    deck.info(f"inldpwl_drw has {count} polygons")
    polygons_count += count

    polyres_drw = get_polygons(128, 0)
    polyres_drw = polyres_drw.not_(nodrc_drw)
    count = polyres_drw.count()
    deck.info(f"polyres_drw has {count} polygons")
    polygons_count += count

    polyres_pin = get_polygons(128, 2)
    polyres_pin = polyres_pin.not_(nodrc_drw)
    count = polyres_pin.count()
    deck.info(f"polyres_pin has {count} polygons")
    polygons_count += count

    vmim_drw = get_polygons(129, 0)
    vmim_drw = vmim_drw.not_(nodrc_drw)
    count = vmim_drw.count()
    deck.info(f"vmim_drw has {count} polygons")
    polygons_count += count

    nbulaycut_drw = get_polygons(131, 0)
    nbulaycut_drw = nbulaycut_drw.not_(nodrc_drw)
    count = nbulaycut_drw.count()
    deck.info(f"nbulaycut_drw has {count} polygons")
    polygons_count += count

    antmetal1_drw = get_polygons(132, 0)
    antmetal1_drw = antmetal1_drw.not_(nodrc_drw)
    count = antmetal1_drw.count()
    deck.info(f"antmetal1_drw has {count} polygons")
    polygons_count += count

    topvia2_drw = get_polygons(133, 0)
    topvia2_drw = topvia2_drw.not_(nodrc_drw)
    count = topvia2_drw.count()
    deck.info(f"topvia2_drw has {count} polygons")
    polygons_count += count

    topmetal2_drw = get_polygons(134, 0)
    topmetal2_drw = topmetal2_drw.not_(nodrc_drw)
    count = topmetal2_drw.count()
    deck.info(f"topmetal2_drw has {count} polygons")
    polygons_count += count

    topmetal2_filler = get_polygons(134, 22)
    topmetal2_filler = topmetal2_filler.not_(nodrc_drw)
    count = topmetal2_filler.count()
    deck.info(f"topmetal2_filler has {count} polygons")
    polygons_count += count

    topmetal2_slit = get_polygons(134, 24)
    topmetal2_slit = topmetal2_slit.not_(nodrc_drw)
    count = topmetal2_slit.count()
    deck.info(f"topmetal2_slit has {count} polygons")
    polygons_count += count

    # topmetal2 org
    topmetal2 = topmetal2_drw.join(topmetal2_filler).not_(topmetal2_slit)
    count = topmetal2.count()
    deck.info(f"topmetal2 has {count} polygons")

    topmetal2_pin = get_polygons(134, 2)
    topmetal2_pin = topmetal2_pin.not_(nodrc_drw)
    count = topmetal2_pin.count()
    deck.info(f"topmetal2_pin has {count} polygons")
    polygons_count += count

    topmetal2_mask = get_polygons(134, 20)
    topmetal2_mask = topmetal2_mask.not_(nodrc_drw)
    count = topmetal2_mask.count()
    deck.info(f"topmetal2_mask has {count} polygons")
    polygons_count += count

    topmetal2_nofill = get_polygons(134, 23)
    topmetal2_nofill = topmetal2_nofill.not_(nodrc_drw)
    count = topmetal2_nofill.count()
    deck.info(f"topmetal2_nofill has {count} polygons")
    polygons_count += count

    topmetal2_text = deck.labels(134, 25)
    topmetal2_text = topmetal2_text.not_(nodrc_drw)
    count = topmetal2_text.count()
    deck.info(f"topmetal2_text has {count} polygons")
    polygons_count += count

    topmetal2_noqrc = get_polygons(134, 28)
    topmetal2_noqrc = topmetal2_noqrc.not_(nodrc_drw)
    count = topmetal2_noqrc.count()
    deck.info(f"topmetal2_noqrc has {count} polygons")
    polygons_count += count

    topmetal2_res = get_polygons(134, 29)
    topmetal2_res = topmetal2_res.not_(nodrc_drw)
    count = topmetal2_res.count()
    deck.info(f"topmetal2_res has {count} polygons")
    polygons_count += count

    topmetal2_iprobe = get_polygons(134, 33)
    topmetal2_iprobe = topmetal2_iprobe.not_(nodrc_drw)
    count = topmetal2_iprobe.count()
    deck.info(f"topmetal2_iprobe has {count} polygons")
    polygons_count += count

    topmetal2_diffprb = get_polygons(134, 34)
    topmetal2_diffprb = topmetal2_diffprb.not_(nodrc_drw)
    count = topmetal2_diffprb.count()
    deck.info(f"topmetal2_diffprb has {count} polygons")
    polygons_count += count

    snsring_drw = get_polygons(135, 0)
    snsring_drw = snsring_drw.not_(nodrc_drw)
    count = snsring_drw.count()
    deck.info(f"snsring_drw has {count} polygons")
    polygons_count += count

    sensor_drw = get_polygons(136, 0)
    sensor_drw = sensor_drw.not_(nodrc_drw)
    count = sensor_drw.count()
    deck.info(f"sensor_drw has {count} polygons")
    polygons_count += count

    snsarms_drw = get_polygons(137, 0)
    snsarms_drw = snsarms_drw.not_(nodrc_drw)
    count = snsarms_drw.count()
    deck.info(f"snsarms_drw has {count} polygons")
    polygons_count += count

    snscmosvia_drw = get_polygons(138, 0)
    snscmosvia_drw = snscmosvia_drw.not_(nodrc_drw)
    count = snscmosvia_drw.count()
    deck.info(f"snscmosvia_drw has {count} polygons")
    polygons_count += count

    colwind_drw = get_polygons(139, 0)
    colwind_drw = colwind_drw.not_(nodrc_drw)
    count = colwind_drw.count()
    deck.info(f"colwind_drw has {count} polygons")
    polygons_count += count

    flm_drw = get_polygons(142, 0)
    flm_drw = flm_drw.not_(nodrc_drw)
    count = flm_drw.count()
    deck.info(f"flm_drw has {count} polygons")
    polygons_count += count

    hafniumox_drw = get_polygons(143, 0)
    hafniumox_drw = hafniumox_drw.not_(nodrc_drw)
    count = hafniumox_drw.count()
    deck.info(f"hafniumox_drw has {count} polygons")
    polygons_count += count

    memvia_drw = get_polygons(145, 0)
    memvia_drw = memvia_drw.not_(nodrc_drw)
    count = memvia_drw.count()
    deck.info(f"memvia_drw has {count} polygons")
    polygons_count += count

    thinfilmres_drw = get_polygons(146, 0)
    thinfilmres_drw = thinfilmres_drw.not_(nodrc_drw)
    count = thinfilmres_drw.count()
    deck.info(f"thinfilmres_drw has {count} polygons")
    polygons_count += count

    rfmem_drw = get_polygons(147, 0)
    rfmem_drw = rfmem_drw.not_(nodrc_drw)
    count = rfmem_drw.count()
    deck.info(f"rfmem_drw has {count} polygons")
    polygons_count += count

    norcx_drw = get_polygons(148, 0)
    norcx_drw = norcx_drw.not_(nodrc_drw)
    count = norcx_drw.count()
    deck.info(f"norcx_drw has {count} polygons")
    polygons_count += count

    norcx_m2m3 = get_polygons(148, 41)
    norcx_m2m3 = norcx_m2m3.not_(nodrc_drw)
    count = norcx_m2m3.count()
    deck.info(f"norcx_m2m3 has {count} polygons")
    polygons_count += count

    norcx_m2m4 = get_polygons(148, 42)
    norcx_m2m4 = norcx_m2m4.not_(nodrc_drw)
    count = norcx_m2m4.count()
    deck.info(f"norcx_m2m4 has {count} polygons")
    polygons_count += count

    norcx_m2m5 = get_polygons(148, 43)
    norcx_m2m5 = norcx_m2m5.not_(nodrc_drw)
    count = norcx_m2m5.count()
    deck.info(f"norcx_m2m5 has {count} polygons")
    polygons_count += count

    norcx_m2tm1 = get_polygons(148, 44)
    norcx_m2tm1 = norcx_m2tm1.not_(nodrc_drw)
    count = norcx_m2tm1.count()
    deck.info(f"norcx_m2tm1 has {count} polygons")
    polygons_count += count

    norcx_m2tm2 = get_polygons(148, 45)
    norcx_m2tm2 = norcx_m2tm2.not_(nodrc_drw)
    count = norcx_m2tm2.count()
    deck.info(f"norcx_m2tm2 has {count} polygons")
    polygons_count += count

    norcx_m3m4 = get_polygons(148, 46)
    norcx_m3m4 = norcx_m3m4.not_(nodrc_drw)
    count = norcx_m3m4.count()
    deck.info(f"norcx_m3m4 has {count} polygons")
    polygons_count += count

    norcx_m3m5 = get_polygons(148, 47)
    norcx_m3m5 = norcx_m3m5.not_(nodrc_drw)
    count = norcx_m3m5.count()
    deck.info(f"norcx_m3m5 has {count} polygons")
    polygons_count += count

    norcx_m3tm1 = get_polygons(148, 48)
    norcx_m3tm1 = norcx_m3tm1.not_(nodrc_drw)
    count = norcx_m3tm1.count()
    deck.info(f"norcx_m3tm1 has {count} polygons")
    polygons_count += count

    norcx_m3tm2 = get_polygons(148, 49)
    norcx_m3tm2 = norcx_m3tm2.not_(nodrc_drw)
    count = norcx_m3tm2.count()
    deck.info(f"norcx_m3tm2 has {count} polygons")
    polygons_count += count

    norcx_m4m5 = get_polygons(148, 50)
    norcx_m4m5 = norcx_m4m5.not_(nodrc_drw)
    count = norcx_m4m5.count()
    deck.info(f"norcx_m4m5 has {count} polygons")
    polygons_count += count

    norcx_m4tm1 = get_polygons(148, 51)
    norcx_m4tm1 = norcx_m4tm1.not_(nodrc_drw)
    count = norcx_m4tm1.count()
    deck.info(f"norcx_m4tm1 has {count} polygons")
    polygons_count += count

    norcx_m4tm2 = get_polygons(148, 52)
    norcx_m4tm2 = norcx_m4tm2.not_(nodrc_drw)
    count = norcx_m4tm2.count()
    deck.info(f"norcx_m4tm2 has {count} polygons")
    polygons_count += count

    norcx_m5tm1 = get_polygons(148, 53)
    norcx_m5tm1 = norcx_m5tm1.not_(nodrc_drw)
    count = norcx_m5tm1.count()
    deck.info(f"norcx_m5tm1 has {count} polygons")
    polygons_count += count

    norcx_m5tm2 = get_polygons(148, 54)
    norcx_m5tm2 = norcx_m5tm2.not_(nodrc_drw)
    count = norcx_m5tm2.count()
    deck.info(f"norcx_m5tm2 has {count} polygons")
    polygons_count += count

    norcx_tm1tm2 = get_polygons(148, 55)
    norcx_tm1tm2 = norcx_tm1tm2.not_(nodrc_drw)
    count = norcx_tm1tm2.count()
    deck.info(f"norcx_tm1tm2 has {count} polygons")
    polygons_count += count

    norcx_m1sub = get_polygons(148, 123)
    norcx_m1sub = norcx_m1sub.not_(nodrc_drw)
    count = norcx_m1sub.count()
    deck.info(f"norcx_m1sub has {count} polygons")
    polygons_count += count

    norcx_m2sub = get_polygons(148, 124)
    norcx_m2sub = norcx_m2sub.not_(nodrc_drw)
    count = norcx_m2sub.count()
    deck.info(f"norcx_m2sub has {count} polygons")
    polygons_count += count

    norcx_m3sub = get_polygons(148, 125)
    norcx_m3sub = norcx_m3sub.not_(nodrc_drw)
    count = norcx_m3sub.count()
    deck.info(f"norcx_m3sub has {count} polygons")
    polygons_count += count

    norcx_m4sub = get_polygons(148, 126)
    norcx_m4sub = norcx_m4sub.not_(nodrc_drw)
    count = norcx_m4sub.count()
    deck.info(f"norcx_m4sub has {count} polygons")
    polygons_count += count

    norcx_m5sub = get_polygons(148, 127)
    norcx_m5sub = norcx_m5sub.not_(nodrc_drw)
    count = norcx_m5sub.count()
    deck.info(f"norcx_m5sub has {count} polygons")
    polygons_count += count

    norcx_tm1sub = get_polygons(148, 300)
    norcx_tm1sub = norcx_tm1sub.not_(nodrc_drw)
    count = norcx_tm1sub.count()
    deck.info(f"norcx_tm1sub has {count} polygons")
    polygons_count += count

    norcx_tm2sub = get_polygons(148, 301)
    norcx_tm2sub = norcx_tm2sub.not_(nodrc_drw)
    count = norcx_tm2sub.count()
    deck.info(f"norcx_tm2sub has {count} polygons")
    polygons_count += count

    snsbotvia_drw = get_polygons(149, 0)
    snsbotvia_drw = snsbotvia_drw.not_(nodrc_drw)
    count = snsbotvia_drw.count()
    deck.info(f"snsbotvia_drw has {count} polygons")
    polygons_count += count

    snstopvia_drw = get_polygons(151, 0)
    snstopvia_drw = snstopvia_drw.not_(nodrc_drw)
    count = snstopvia_drw.count()
    deck.info(f"snstopvia_drw has {count} polygons")
    polygons_count += count

    deepvia_drw = get_polygons(152, 0)
    deepvia_drw = deepvia_drw.not_(nodrc_drw)
    count = deepvia_drw.count()
    deck.info(f"deepvia_drw has {count} polygons")
    polygons_count += count

    fgetch_drw = get_polygons(153, 0)
    fgetch_drw = fgetch_drw.not_(nodrc_drw)
    count = fgetch_drw.count()
    deck.info(f"fgetch_drw has {count} polygons")
    polygons_count += count

    ctrgat_drw = get_polygons(154, 0)
    ctrgat_drw = ctrgat_drw.not_(nodrc_drw)
    count = ctrgat_drw.count()
    deck.info(f"ctrgat_drw has {count} polygons")
    polygons_count += count

    fgimp_drw = get_polygons(155, 0)
    fgimp_drw = fgimp_drw.not_(nodrc_drw)
    count = fgimp_drw.count()
    deck.info(f"fgimp_drw has {count} polygons")
    polygons_count += count

    emwihv_drw = get_polygons(156, 0)
    emwihv_drw = emwihv_drw.not_(nodrc_drw)
    count = emwihv_drw.count()
    deck.info(f"emwihv_drw has {count} polygons")
    polygons_count += count

    lbe_drw = get_polygons(157, 0)
    lbe_drw = lbe_drw.not_(nodrc_drw)
    count = lbe_drw.count()
    deck.info(f"lbe_drw has {count} polygons")
    polygons_count += count

    alcustop_drw = get_polygons(159, 0)
    alcustop_drw = alcustop_drw.not_(nodrc_drw)
    count = alcustop_drw.count()
    deck.info(f"alcustop_drw has {count} polygons")
    polygons_count += count

    nometfiller_drw = get_polygons(160, 0)
    nometfiller_drw = nometfiller_drw.not_(nodrc_drw)
    count = nometfiller_drw.count()
    deck.info(f"nometfiller_drw has {count} polygons")
    polygons_count += count

    prboundary_drw = get_polygons(189, 0)
    prboundary_drw = prboundary_drw.not_(nodrc_drw)
    count = prboundary_drw.count()
    deck.info(f"prboundary_drw has {count} polygons")
    polygons_count += count

    exchange0_drw = get_polygons(190, 0)
    exchange0_drw = exchange0_drw.not_(nodrc_drw)
    count = exchange0_drw.count()
    deck.info(f"exchange0_drw has {count} polygons")
    polygons_count += count

    exchange0_pin = get_polygons(190, 2)
    exchange0_pin = exchange0_pin.not_(nodrc_drw)
    count = exchange0_pin.count()
    deck.info(f"exchange0_pin has {count} polygons")
    polygons_count += count

    exchange0_text = deck.labels(190, 25)
    exchange0_text = exchange0_text.not_(nodrc_drw)
    count = exchange0_text.count()
    deck.info(f"exchange0_text has {count} polygons")
    polygons_count += count

    exchange1_drw = get_polygons(191, 0)
    exchange1_drw = exchange1_drw.not_(nodrc_drw)
    count = exchange1_drw.count()
    deck.info(f"exchange1_drw has {count} polygons")
    polygons_count += count

    exchange1_pin = get_polygons(191, 2)
    exchange1_pin = exchange1_pin.not_(nodrc_drw)
    count = exchange1_pin.count()
    deck.info(f"exchange1_pin has {count} polygons")
    polygons_count += count

    exchange1_text = deck.labels(191, 25)
    exchange1_text = exchange1_text.not_(nodrc_drw)
    count = exchange1_text.count()
    deck.info(f"exchange1_text has {count} polygons")
    polygons_count += count

    exchange2_drw = get_polygons(192, 0)
    exchange2_drw = exchange2_drw.not_(nodrc_drw)
    count = exchange2_drw.count()
    deck.info(f"exchange2_drw has {count} polygons")
    polygons_count += count

    exchange2_pin = get_polygons(192, 2)
    exchange2_pin = exchange2_pin.not_(nodrc_drw)
    count = exchange2_pin.count()
    deck.info(f"exchange2_pin has {count} polygons")
    polygons_count += count

    exchange2_text = deck.labels(192, 25)
    exchange2_text = exchange2_text.not_(nodrc_drw)
    count = exchange2_text.count()
    deck.info(f"exchange2_text has {count} polygons")
    polygons_count += count

    exchange3_drw = get_polygons(193, 0)
    exchange3_drw = exchange3_drw.not_(nodrc_drw)
    count = exchange3_drw.count()
    deck.info(f"exchange3_drw has {count} polygons")
    polygons_count += count

    exchange3_pin = get_polygons(193, 2)
    exchange3_pin = exchange3_pin.not_(nodrc_drw)
    count = exchange3_pin.count()
    deck.info(f"exchange3_pin has {count} polygons")
    polygons_count += count

    exchange3_text = deck.labels(193, 25)
    exchange3_text = exchange3_text.not_(nodrc_drw)
    count = exchange3_text.count()
    deck.info(f"exchange3_text has {count} polygons")
    polygons_count += count

    exchange4_drw = get_polygons(194, 0)
    exchange4_drw = exchange4_drw.not_(nodrc_drw)
    count = exchange4_drw.count()
    deck.info(f"exchange4_drw has {count} polygons")
    polygons_count += count

    exchange4_pin = get_polygons(194, 2)
    exchange4_pin = exchange4_pin.not_(nodrc_drw)
    count = exchange4_pin.count()
    deck.info(f"exchange4_pin has {count} polygons")
    polygons_count += count

    exchange4_text = deck.labels(194, 25)
    exchange4_text = exchange4_text.not_(nodrc_drw)
    count = exchange4_text.count()
    deck.info(f"exchange4_text has {count} polygons")
    polygons_count += count

    isonwell_drw = get_polygons(257, 0)
    isonwell_drw = isonwell_drw.not_(nodrc_drw)
    count = isonwell_drw.count()
    deck.info(f"isonwell_drw has {count} polygons")
    polygons_count += count

    deck.info(f"Total no. of polygons in the design is {polygons_count}")

    # general_derivations.lvs
    deck.info("Starting general LVS derivations")

    # === Global Layers ===
    # === CHIP ===
    CHIP = deck.extent("*")

    # === General Derivations ===
    # nwell
    nwell_iso = nwell_drw.and_(nbulay_drw)
    nwell_holes = nwell_drw.holes().not_(nwell_drw)

    # pwell
    pwell_allowed = CHIP.not_(pwell_block)
    digisub_gap = digisub_drw.not_(digisub_drw.sized(nm(-1)))
    pwell = pwell_allowed.not_(nwell_drw).not_(digisub_gap)

    # General pwell
    pwell_sub = pwell_allowed.not_(digisub_drw).not_(
        nbulay_drw.interacting(nwell_holes)
    )

    # n & p activ
    nactiv = activ.not_(psd_drw.join(nsd_block))
    pactiv = activ.and_(psd_drw)

    # res/cap exclusion
    res_mk = polyres_drw.join(res_drw)
    poly_con = gatpoly.not_(res_mk)
    metal1_con = metal1.not_(metal1_res)
    metal2_con = metal2.not_(metal2_res)
    metal3_con = metal3.not_(metal3_res)
    metal4_con = metal4.not_(metal4_res)
    metal5_con = metal5.not_(metal5_res)
    topmetal1_con = topmetal1.not_(topmetal1_res).not_(ind_drw)
    topmetal2_con = topmetal2.not_(topmetal2_res).not_(ind_drw)

    # Gate FETs
    tgate = gatpoly.and_(activ).not_(res_mk)
    ngate = nactiv.and_(tgate)
    pgate = pactiv.and_(tgate)
    ngate_lv_base = ngate.not_(thickgateox_drw)
    pgate_lv_base = pgate.not_(thickgateox_drw)
    ngate_hv_base = ngate.and_(thickgateox_drw)
    pgate_hv_base = pgate.and_(thickgateox_drw)

    # S/D FETs
    nsd_fet = (
        nactiv.not_(nwell_drw).interacting(ngate).not_(ngate).not_interacting(res_mk)
    )
    psd_fet = (
        pactiv.and_(nwell_drw).interacting(pgate).not_(pgate).not_interacting(res_mk)
    )

    # n1/p1 taps labels
    well_patt = glob_to_case_insensitive_glob("well")
    sub_patt = glob_to_case_insensitive_glob("sub!")

    ntap1_lbl = text_drw.texts(well_patt)
    ntap1_mk = nwell_drw.interacting(ntap1_lbl)

    ptap1_lbl = text_drw.texts(sub_patt)
    ptap1_mk = substrate_drw.and_(pwell).interacting(ptap1_lbl)

    # n & p taps (short connections)
    ntap = nactiv.and_(nwell_drw).not_(recog_diode).not_(gatpoly).not_(ntap1_mk)
    ptap = pactiv.and_(pwell).not_(ptap1_mk).not_(recog_diode).not_(gatpoly)
    ptap_holes = ptap.holes()
    ntap_holes = ntap.holes()

    # S/D (salicide)
    nsd_sal = nsd_fet.not_(salblock_drw)
    psd_sal = psd_fet.not_(salblock_drw)

    # n & p taps (salicide)
    ntap_sal = ntap.not_(salblock_drw)
    ptap_sal = ptap.not_(salblock_drw)

    # n/p SD abutted with n/p taps (salicide)
    nsd_ptap_abutt = nsd_sal.edges().and_(ptap_sal.edges()).extended(i=nm(1), o=nm(1))
    psd_ntap_abutt = psd_sal.edges().and_(ntap_sal.edges()).extended(i=nm(1), o=nm(1))

    # mos_derivations.lvs
    deck.info("Starting MOSFET DERIVATIONS")

    mos_exclude = (
        pwell_block.join(nsd_drw)
        .join(trans_drw)
        .join(emwind_drw)
        .join(emwihv_drw)
        .join(salblock_drw)
        .join(polyres_drw)
        .join(extblock_drw)
        .join(res_drw)
        .join(activ_mask)
        .join(recog_diode)
        .join(recog_esd)
        .join(ind_drw)
        .join(ind_pin)
        .join(ind_drw)
        .join(substrate_drw)
        .join(nsd_block)
    )

    # ==== General FETs & RF-FETs =====

    rfnmos_exc = nwell_drw.join(psd_drw).join(mos_exclude)
    rfpmos_exc = pwell.join(nwell_holes).join(mos_exclude)

    # Get case insensitive patterns for FETs
    rfnmos_patt = glob_to_case_insensitive_glob("rfnmos")
    rfnmoshv_patt = glob_to_case_insensitive_glob("rfnmosHV")

    rfpmos_patt = glob_to_case_insensitive_glob("rfpmos")
    rfpmoshv_patt = glob_to_case_insensitive_glob("rfpmosHV")

    rfnmos_mk_gen = ptap.join(ptap_holes)
    rfnmos_mk = rfnmos_mk_gen.interacting(text_drw.texts(rfnmos_patt))
    rfnmoshv_mk = rfnmos_mk_gen.interacting(text_drw.texts(rfnmoshv_patt))

    rfpmos_mk_gen = ntap.join(ntap_holes)
    rfpmos_mk = rfpmos_mk_gen.interacting(text_drw.texts(rfpmos_patt))
    rfpmoshv_mk = rfpmos_mk_gen.interacting(text_drw.texts(rfpmoshv_patt))

    # ==============
    # ---- NMOS ----
    # ==============

    deck.info("Starting NMOS DERIVATIONS")

    # for regular FETs
    nmos_exc = rfnmos_exc.join(rfnmos_mk)
    nmoshv_exc = rfnmos_exc.join(rfnmoshv_mk)

    # nmos - LV
    ngate_lv = ngate_lv_base.not_(nmos_exc)

    # nmos - HV
    ngate_hv = ngate_hv_base.not_(nmoshv_exc)

    # ==============
    # ---- PMOS ----
    # ==============

    deck.info("Starting PMOS DERIVATIONS")

    # for regular FETs
    pmos_exc = rfpmos_exc.join(rfpmos_mk)
    pmoshv_exc = rfpmos_exc.join(rfpmoshv_mk)

    # pmos - LV
    pgate_lv = pgate_lv_base.not_(pmos_exc)

    # pmos - HV
    pgate_hv = pgate_hv_base.not_(pmoshv_exc)

    # rfmos_derivations.lvs
    deck.info("Starting RF-MOSFET DERIVATIONS")

    # ===============
    # --- RF-NMOS ---
    # ===============

    deck.info("Starting RF-NMOS DERIVATIONS")

    # rfnmos - LV
    rfngate_lv = ngate_lv_base.and_(rfnmos_mk).not_(rfnmos_exc)

    # rfnmos - HV
    rfngate_hv = ngate_hv_base.and_(rfnmoshv_mk).not_(rfnmos_exc)

    # ===============
    # --- RF-PMOS ---
    # ===============

    deck.info("Starting RF-PMOS DERIVATIONS")

    # rfpmos - LV
    rfpgate_lv = pgate_lv_base.and_(rfpmos_mk).not_(rfpmos_exc)

    # rfpmos - HV
    rfpgate_hv = pgate_hv_base.and_(rfpmoshv_mk).not_(rfpmos_exc)

    # bjt_derivations.lvs
    deck.info("Starting BJT DERIVATIONS")

    # =============
    # ---- NPN ----
    # =============

    deck.info("Starting NPN-BJT DERIVATIONS")

    bjt_exclude = (
        gatpoly.join(pwell_block)
        .join(nsd_drw)
        .join(salblock_drw)
        .join(polyres_drw)
        .join(extblock_drw)
        .join(res_drw)
        .join(recog_diode)
        .join(recog_esd)
        .join(ind_drw)
        .join(ind_pin)
        .join(substrate_drw)
    )

    npn_exclude = nwell_drw.join(psd_drw).join(nbulay_drw).join(bjt_exclude)

    # ---------- General NPN ----------
    npn_mk = trans_drw.and_(pwell).and_(ptap_holes)
    npn_c_exc = (
        emwind_drw.join(emwihv_drw).join(activ_mask).join(nsd_block).join(npn_exclude)
    )
    npn_b_exc = emwind_drw.join(emwihv_drw).join(npn_exclude)
    npn_sub = npn_mk.not_(npn_exclude)
    npn_dev = activ.join(activ_mask).and_(npn_mk)

    # ---------- npn13G2 ----------
    # npn13G2 exclusion layers
    npn13G2_e_exc = activ.join(emwihv_drw).join(npn_exclude)
    npn13G2_b_exc = npn_b_exc.join(activ_mask)

    # npn13G2 nodes
    npn13G2_e_ = (
        emwind_drw.and_(activ_mask).and_(nsd_block).and_(npn_mk).not_(npn13G2_e_exc)
    )
    # npn13G2 is a fixed device (0.07um X 0.9um)
    npn13G2_e_pin = (
        npn13G2_e_.with_bbox_min(um(0.07)).with_bbox_max(um(0.9)).with_area(um(0.063))
    )
    npn13G2_b_pin = nsd_block.and_(npn_mk).not_(npn13G2_b_exc)
    npn13G2_c_pin = activ.and_(npn_mk).not_overlapping(npn_c_exc)

    npn13G2_dev = (
        npn_dev.join(nsd_block)
        .extents()
        .covering(npn13G2_e_pin)
        .covering(npn13G2_b_pin)
        .covering(npn13G2_c_pin)
    )
    npn13G2_c = npn13G2_dev.sized(nm(-1))
    npn13G2_tc = npn13G2_dev.not_(npn13G2_c).interacting(npn13G2_c_pin)
    npn13G2_b = npn13G2_dev.not_(npn13G2_c_pin)
    npn13G2_tb = npn13G2_b.not_(npn13G2_e_pin).merged()
    npn13G2_e = npn13G2_e_pin
    npn13G2_te = npn13G2_e

    # ---------- npn13G2L ----------
    # npn13G2L exclusion layers
    npn13G2l_e_exc = activ_mask.join(nsd_block).join(emwihv_drw).join(npn_exclude)
    npn13G2l_b_exc = npn_b_exc.join(activ).join(nsd_block)

    # npn13G2L nodes
    npn13G2l_e_ = emwind_drw.and_(activ).and_(npn_mk).not_(npn13G2l_e_exc)
    # npn13G2L has fixed width (0.07um), Length could vary from 1:2.5 um
    npn13G2l_e_pin = (
        npn13G2l_e_.with_bbox_min(um(0.07))
        .with_bbox_max(um(1), um(2.5))
        .with_area(um(0.07), um(0.175))
    )
    npn13G2l_b_pin = activ_mask.and_(npn_mk).not_(npn13G2l_b_exc)
    npn13G2l_c_pin = npn13G2_c_pin

    npn13G2l_dev = (
        npn_dev.covering(npn13G2l_e_pin)
        .covering(npn13G2l_b_pin)
        .covering(npn13G2l_c_pin)
    )
    npn13G2l_c = npn13G2l_dev.sized(nm(1))
    npn13G2l_tc = npn13G2l_c.not_(npn13G2l_dev).interacting(npn13G2l_c_pin)
    npn13G2l_b = npn13G2l_dev.not_(npn13G2l_c_pin)
    npn13G2l_tb = npn13G2l_b.not_(npn13G2l_e_pin).merged()
    npn13G2l_e = npn13G2l_e_pin
    npn13G2l_te = npn13G2l_e

    # # ---------- npn13G2V ----------
    # npn13G2V exclusion layers
    npn13G2v_e_exc = activ_mask.join(nsd_block).join(emwind_drw).join(npn_exclude)

    # npn13G2V nodes
    npn13G2v_e_ = emwihv_drw.and_(activ).and_(npn_mk).not_(npn13G2v_e_exc)
    # npn13G2L has fixed width (0.12um), Length could vary from 1:5 um
    npn13G2v_e_pin = (
        npn13G2v_e_.with_bbox_min(um(0.12))
        .with_bbox_max(um(1), um(5))
        .with_area(um(0.12), um(0.6))
    )
    npn13G2v_b_pin = npn13G2l_b_pin
    npn13G2v_c_pin = npn13G2l_c_pin

    npn13G2v_dev = (
        npn_dev.covering(npn13G2v_e_pin)
        .covering(npn13G2v_b_pin)
        .covering(npn13G2v_c_pin)
    )
    npn13G2v_c = npn13G2v_dev.sized(nm(1))
    npn13G2v_tc = npn13G2v_c.not_(npn13G2v_dev).interacting(npn13G2v_c_pin)
    npn13G2v_b = npn13G2v_dev.not_(npn13G2v_c_pin)
    npn13G2v_tb = npn13G2v_b.not_(npn13G2v_e_pin).merged()
    npn13G2v_e = npn13G2v_e_pin
    npn13G2v_te = npn13G2v_e

    # =============
    # ---- PNP ----
    # =============

    deck.info("Starting PNP-BJT DERIVATIONS")

    pnp_exclude = (
        trans_drw.join(emwind_drw).join(emwihv_drw).join(nsd_block).join(bjt_exclude)
    )

    pnp_mk = ptap_holes.not_(pnp_exclude)

    # pnp general nodes DERIVATIONS
    pnp_e = pactiv.and_(pnp_mk).and_(nwell_iso)
    pnp_b = nactiv.and_(pnp_mk).and_(nwell_iso)
    pnp_c = ptap.interacting(pnp_mk).not_(pnp_exclude)

    # pnp_mpa nodes DERIVATIONS
    pnp_mpa_e = pnp_e.and_(pnp_b.extents()).and_(pnp_c.extents())
    pnp_mpa_b = pnp_b.interacting(pnp_b.extents().interacting(pnp_mpa_e))
    pnp_mpa_c = pnp_c.interacting(pnp_c.extents().interacting(pnp_mpa_e))

    # diode_derivations.lvs
    deck.info("Starting DIODE DERIVATIONS")

    diode_exclude = (
        gatpoly.join(nsd_drw)
        .join(trans_drw)
        .join(emwind_drw)
        .join(emwihv_drw)
        .join(polyres_drw)
        .join(extblock_drw)
        .join(res_drw)
        .join(activ_mask)
        .join(recog_esd)
        .join(ind_drw)
        .join(ind_pin)
        .join(substrate_drw)
    )

    antenna_d_exc = pwell_block.join(salblock_drw).join(nsd_block).join(diode_exclude)

    antenna_d_mk = recog_diode.not_(antenna_d_exc)

    # ==== dantenna diode ====
    dantenna_n = activ.and_(antenna_d_mk).not_(psd_drw).not_(nwell_drw)
    dantenna_p = pwell.and_(antenna_d_mk).covering(dantenna_n)

    # ==== dpantenna diode ====
    dpantenna_p = pactiv.and_(antenna_d_mk)
    dpantenna_n = nwell_drw.covering(dpantenna_p)

    # ==== schottky_nbl1 diode ====
    schottky_mk = (
        recog_diode.and_(thickgateox_drw)
        .not_(diode_exclude)
        .and_(pwell_block)
        .and_(ptap_holes)
        .and_(nbulay_drw)
        .and_(salblock_drw)
        .and_(nsd_block)
        .and_(nwell_holes)
        .not_(psd_drw)
        .not_(pwell)
        .not_(diode_exclude)
    )

    schottcky_p_ = cont_drw.and_(activ).and_(metal1_con).and_(schottky_mk)

    # schottky_nbl1 is a fixed device (0.3um X 1.0 um)
    schottcky_p = schottcky_p_.with_bbox_min(um(0.3)).with_bbox_max(um(1.0))
    # Using box with area 1x1 to be used as a reference to (m)
    schottcky_p_1x1 = schottcky_p.middle(as_boxes).sized(um(0.499))

    schottcky_n = nsd_block.and_(activ).covering(schottcky_p)

    # define port for schottcky
    schottcky_n_port = (
        activ.interacting(nwell_iso)
        .interacting(schottcky_n)
        .not_(schottcky_n.sized(nm(-1)))
    )
    schottcky_n_con = cont_drw.and_(schottcky_n_port).not_interacting(schottcky_p)
    schottcky_sub = ptap.extents().covering(schottcky_p).covering(schottcky_n)

    # res_derivations.lvs
    deck.info("Starting RESISTOR DERIVATIONS")

    polyres_exclude = (
        activ.join(pwell_block)
        .join(nsd_block)
        .join(nbulay_drw)
        .join(thickgateox_drw)
        .join(trans_drw)
        .join(emwind_drw)
        .join(emwihv_drw)
        .join(activ_mask)
        .join(recog_diode)
        .join(recog_esd)
        .join(ind_drw)
        .join(ind_pin)
        .join(substrate_drw)
    )

    # ==============
    # ---- POLY ----
    # ==============

    ## polyres
    polyres_mk = (
        polyres_drw.and_(extblock_drw).interacting(gatpoly).not_(polyres_exclude)
    )

    ## rhigh
    rhigh_res = polyres_mk.and_(psd_drw).and_(nsd_drw).and_(salblock_drw)
    rhigh_ports = gatpoly.interacting(rhigh_res).not_(rhigh_res)

    ## rppd
    rppd_res = polyres_mk.and_(psd_drw).and_(salblock_drw).not_(nsd_block).not_(nsd_drw)
    rppd_ports = gatpoly.interacting(rppd_res).not_(rppd_res)

    ## rsil
    rsil_exc = psd_drw.join(salblock_drw).join(nsd_drw).join(nsd_block)
    rsil_res = polyres_mk.and_(res_drw).not_(rsil_exc)
    rsil_ports = gatpoly.interacting(rsil_res).not_(rsil_res)

    # ===============
    # ---- METAL ----
    # ===============

    # res_metal1
    res_metal1 = metal1.and_(metal1_res)

    # res_metal2
    res_metal2 = metal2.and_(metal2_res)

    # res_metal3
    res_metal3 = metal3.and_(metal3_res)

    # res_metal4
    res_metal4 = metal4.and_(metal4_res)

    # res_metal5
    res_metal5 = metal5.and_(metal5_res)

    # res_topmetal1
    res_topmetal1 = topmetal1.and_(topmetal1_res)

    # res_topmetal2
    res_topmetal2 = topmetal2.and_(topmetal2_res)

    # cap_derivations.lvs
    deck.info("Starting CAP DERIVATIONS")

    rfmimcap_exc = ind_drw.join(ind_pin)

    # === MIMCAP ===
    mimcap_exclude = pwell_block.join(rfmimcap_exc)

    mim_top = mim_drw.overlapping(topmetal1_con).and_(metal5_con)
    mim_btm = metal5_con.and_(mim_drw).sized(um(0.6))
    mim_via = vmim_drw.join(topvia1_drw).and_(mim_drw)
    topvia1_n_cap = topvia1_drw.not_(mim_via)

    # === cap_cmim ===
    cmim_top = mim_top.not_(mimcap_exclude)
    cmim_btm = mim_btm.covering(cmim_top)
    cmim_dev = mim_drw.covering(cmim_top).and_(cmim_btm)

    # === rfcmim ===
    rfmim_area = pwell_block.interacting(mim_drw)
    rfmim_top = mim_top.and_(rfmim_area).not_(rfmimcap_exc)
    rfmim_btm = mim_btm.and_(rfmim_area).covering(rfmim_top)
    rfmim_dev = mim_drw.covering(rfmim_top).and_(rfmim_btm)
    rfmim_sub = ptap.extents().interacting(rfmim_area)
    rfmeas_mk = metal5_con.overlapping(rfmim_btm).and_(rfmim_area)

    # === svaricap ===
    cap_exc = (
        nsd_drw.join(trans_drw)
        .join(emwind_drw)
        .join(emwihv_drw)
        .join(salblock_drw)
        .join(polyres_drw)
        .join(extblock_drw)
        .join(res_drw)
        .join(activ_mask)
        .join(recog_diode)
        .join(recog_esd)
        .join(ind_drw)
        .join(ind_pin)
        .join(substrate_drw)
    )

    varicap_exc = pwell.join(pwell_block).join(nwell_holes).join(cap_exc)

    varicap_core = ngate_hv_base.and_(nwell_iso).not_(varicap_exc)
    varicap_diff_port = (
        nactiv.interacting(varicap_core)
        .not_(varicap_core)
        .and_(nwell_iso)
        .not_(varicap_exc)
        .sized(nm(-1))
    )
    varicap_poly_port = gatpoly.interacting(varicap_core)
    varicap_ports = varicap_poly_port.join(varicap_diff_port)
    varicap_sub = ptap.and_(thickgateox_drw)
    varicap_dev_mk = thickgateox_drw.covering(varicap_core).interacting(varicap_ports)

    # esd_derivations.lvs
    deck.info("Starting ESD DERIVATIONS")

    # General
    esd_exclude = (
        nsd_block.join(nsd_drw)
        .join(trans_drw)
        .join(emwind_drw)
        .join(emwihv_drw)
        .join(polyres_drw)
        .join(extblock_drw)
        .join(res_drw)
        .join(substrate_drw)
        .join(ind_drw)
        .join(ind_pin)
    )

    esd_exc_d = gatpoly.join(thickgateox_drw).join(salblock_drw).join(esd_exclude)

    idiodevdd_exc = esd_exc_d.join(nwell_holes)
    diodevdd_exc = idiodevdd_exc.join(nbulay_drw).join(pwell_block)

    idiodevss_exc = esd_exc_d.join(nwell_drw.not_interacting(nwell_holes)).join(
        pwell_block
    )
    diodevss_exc = idiodevss_exc.join(nbulay_drw)

    nw_diode = nwell_drw.not_interacting(pwell_block)
    nw_idiode = nwell_iso.interacting(pwell_block)

    # ======================
    # ----- diode-ESD -----
    # ======================

    # diodevdd_2kv
    diodevdd_2kv_e = pactiv.and_(nw_diode).and_(recog_esd).not_(diodevdd_exc)
    diodevdd_2kv_e_1x1 = diodevdd_2kv_e.middle().sized(um(0.499))
    diodevdd_2kv_b_ = nactiv.and_(nw_diode).and_(recog_esd).not_(diodevdd_exc)
    diodevdd_2kv_b = diodevdd_2kv_b_.interacting(
        diodevdd_2kv_b_.extents().interacting(diodevdd_2kv_e, 1, 1)
    )
    diodevdd_2kv_tb = cont_drw.and_(diodevdd_2kv_b).not_interacting(diodevdd_2kv_e)
    diodevdd_2kv_c_ = pactiv.and_(pwell).and_(recog_esd).not_(diodevdd_exc)
    diodevdd_2kv_c = diodevdd_2kv_c_.interacting(
        diodevdd_2kv_c_.extents().interacting(diodevdd_2kv_b, 1, 1)
    )

    # diodevdd_4kv
    diodevdd_4kv_b = diodevdd_2kv_b_.interacting(
        diodevdd_2kv_b_.extents().interacting(diodevdd_2kv_e, 2, 2)
    )
    diodevdd_4kv_c = diodevdd_2kv_c_.interacting(
        diodevdd_2kv_c_.extents().interacting(diodevdd_4kv_b, 1, 1)
    )
    diodevdd_4kv_e = diodevdd_4kv_b.extents().sized(um(-0.15))
    diodevdd_4kv_e_1x1 = diodevdd_4kv_e.middle().sized(um(0.499))
    diodevdd_4kv_te = cont_drw.and_(diodevdd_2kv_e).not_interacting(diodevdd_4kv_b)
    diodevdd_4kv_tb = cont_drw.and_(diodevdd_4kv_b).not_interacting(diodevdd_2kv_e)

    # diodevss_2kv
    diodevss_2kv_e = nactiv.and_(pwell).and_(recog_esd).not_(diodevss_exc)
    diodevss_2kv_e_1x1 = diodevss_2kv_e.middle().sized(um(0.499))
    diodevss_2kv_b_ = pactiv.and_(pwell).and_(recog_esd).not_(diodevss_exc)
    diodevss_2kv_b = diodevss_2kv_b_.interacting(
        diodevss_2kv_b_.extents().interacting(diodevss_2kv_e, 1, 1)
    )
    diodevss_2kv_tb = cont_drw.and_(diodevss_2kv_b).not_interacting(diodevss_2kv_e)
    diodevss_2kv_c_ = nactiv.and_(nw_diode).and_(recog_esd).not_(diodevss_exc)
    diodevss_2kv_c = diodevss_2kv_c_.interacting(
        diodevss_2kv_c_.extents().interacting(diodevss_2kv_b, 1, 1)
    )

    # diodevss_4kv
    diodevss_4kv_b = diodevss_2kv_b_.interacting(
        diodevss_2kv_b_.extents().interacting(diodevss_2kv_e, 2, 2)
    )
    diodevss_4kv_c = diodevss_2kv_c_.interacting(
        diodevss_2kv_c_.extents().interacting(diodevss_4kv_b, 1, 1)
    )
    diodevss_4kv_e = diodevss_4kv_b.extents().sized(um(-0.15))
    diodevss_4kv_e_1x1 = diodevss_4kv_e.middle().sized(um(0.499))
    diodevss_4kv_te = cont_drw.and_(diodevss_2kv_e).not_interacting(diodevss_4kv_b)
    diodevss_4kv_tb = cont_drw.and_(diodevss_4kv_b).not_interacting(diodevss_2kv_e)

    # =======================
    # ----- idiode-ESD -----
    # =======================

    # idiodevdd_2kv
    idiodevdd_2kv_e = pactiv.and_(nw_idiode).and_(recog_esd).not_(idiodevdd_exc)
    idiodevdd_2kv_e_1x1 = idiodevdd_2kv_e.middle().sized(um(0.499))
    idiodevdd_2kv_b_ = nactiv.and_(nw_idiode).and_(recog_esd).not_(idiodevdd_exc)
    idiodevdd_2kv_b = idiodevdd_2kv_b_.interacting(
        idiodevdd_2kv_b_.extents().interacting(idiodevdd_2kv_e, 1, 1)
    )
    idiodevdd_2kv_tb = cont_drw.and_(idiodevdd_2kv_b).not_interacting(idiodevdd_2kv_e)
    idiodevdd_2kv_c_ = pactiv.and_(pwell).and_(recog_esd).not_(idiodevdd_exc)
    idiodevdd_2kv_c = idiodevdd_2kv_c_.interacting(
        idiodevdd_2kv_c_.extents().interacting(idiodevdd_2kv_b, 1, 1)
    )

    # idiodevdd_4kv
    idiodevdd_4kv_b = idiodevdd_2kv_b_.interacting(
        idiodevdd_2kv_b_.extents().interacting(idiodevdd_2kv_e, 2, 2)
    )
    idiodevdd_4kv_c = idiodevdd_2kv_c_.interacting(
        idiodevdd_2kv_c_.extents().interacting(idiodevdd_4kv_b, 1, 1)
    )
    idiodevdd_4kv_e = idiodevdd_4kv_b.extents().sized(um(-0.15))
    idiodevdd_4kv_e_1x1 = idiodevdd_4kv_e.middle().sized(um(0.499))
    idiodevdd_4kv_te = cont_drw.and_(idiodevdd_2kv_e).not_interacting(idiodevdd_4kv_b)
    idiodevdd_4kv_tb = cont_drw.and_(idiodevdd_4kv_b).not_interacting(idiodevdd_2kv_e)

    # idiodevss_2kv
    idiodevss_2kv_e = (
        nactiv.and_(pwell).and_(nbulay_drw).and_(recog_esd).not_(idiodevss_exc)
    )
    idiodevss_2kv_e_1x1 = idiodevss_2kv_e.middle().sized(um(0.499))
    idiodevss_2kv_b_ = (
        pactiv.and_(pwell).and_(nbulay_drw).and_(recog_esd).not_(idiodevss_exc)
    )
    idiodevss_2kv_b = idiodevss_2kv_b_.interacting(
        idiodevss_2kv_b_.extents().interacting(idiodevss_2kv_e, 1, 1)
    )
    idiodevss_2kv_tb = cont_drw.and_(idiodevss_2kv_b).not_interacting(idiodevss_2kv_e)
    idiodevss_2kv_c_ = nactiv.and_(nwell_iso).and_(recog_esd).not_(idiodevss_exc)
    idiodevss_2kv_c = idiodevss_2kv_c_.interacting(
        idiodevss_2kv_c_.extents().interacting(idiodevss_2kv_b, 1, 1)
    )

    # idiodevss_4kv
    idiodevss_4kv_b = idiodevss_2kv_b_.interacting(
        idiodevss_2kv_b_.extents().interacting(idiodevss_2kv_e, 2, 2)
    )
    idiodevss_4kv_c = idiodevss_2kv_c_.interacting(
        idiodevss_2kv_c_.extents().interacting(idiodevss_4kv_b, 1, 1)
    )
    idiodevss_4kv_e = idiodevss_4kv_b.extents().sized(um(-0.15))
    idiodevss_4kv_e_1x1 = idiodevss_4kv_e.middle().sized(um(0.499))
    idiodevss_4kv_te = cont_drw.and_(idiodevss_2kv_e).not_interacting(idiodevss_4kv_b)
    idiodevss_4kv_tb = cont_drw.and_(idiodevss_4kv_b).not_interacting(idiodevss_2kv_e)

    # ======================
    # ----- MOSCL-ESD -----
    # ======================

    nmoscl_exc = esd_exclude.join(pwell_block)

    # nmoscl_2
    nmoscl_2_patt = glob_to_case_insensitive_glob("nmoscl_2")

    gate_moscl = ngate_hv_base.and_(salblock_drw).and_(nbulay_drw)
    nmoscl_2_n_ = recog_esd.interacting(text_drw.texts(nmoscl_2_patt))
    nmoscl_2_n = nmoscl_2_n_.interacting(gate_moscl, 12)
    nmoscl_2_n_port = nwell_drw.and_(nmoscl_2_n)
    nmoscl_2_p_ = ptap.and_(nbulay_drw).inside(nmoscl_2_n_)
    # Using box with area 1x1 to be used as a reference to (m)
    nmoscl_2_p = nmoscl_2_p_.middle(as_boxes).sized(um(0.499))

    # nmoscl_4
    nmoscl_4_patt = glob_to_case_insensitive_glob("nmoscl_4")

    gate_moscl = ngate_hv_base.and_(salblock_drw).and_(nbulay_drw)
    nmoscl_4_n_ = recog_esd.interacting(text_drw.texts(nmoscl_4_patt))
    nmoscl_4_n = nmoscl_4_n_.interacting(gate_moscl, 24)
    nmoscl_4_n_port = nwell_drw.and_(nmoscl_4_n)
    nmoscl_4_p_ = ptap.and_(nbulay_drw).inside(nmoscl_4_n_)
    # Using box with area 1x1 to be used as a reference to (m)
    nmoscl_4_p = nmoscl_4_p_.middle(as_boxes).sized(um(0.499))

    # ind_derivations.lvs
    deck.info("Starting Inductor DERIVATIONS")

    ind_exc = (
        gatpoly.join(nsd_drw)
        .join(nbulay_drw)
        .join(thickgateox_drw)
        .join(emwind_drw)
        .join(emwihv_drw)
        .join(salblock_drw)
        .join(polyres_drw)
        .join(mim_drw)
        .join(extblock_drw)
        .join(res_drw)
        .join(activ_mask)
        .join(recog_diode)
        .join(recog_esd)
        .join(substrate_drw)
    )

    # General
    la_patt = glob_to_case_insensitive_glob("LA")
    lb_patt = glob_to_case_insensitive_glob("LB")
    lc_patt = glob_to_case_insensitive_glob("LC")
    ind2_patt = glob_to_case_insensitive_glob("inductor2*")
    ind3_patt = glob_to_case_insensitive_glob("inductor3*")

    ind_edges = ind_drw.edges()
    ind_core_ = topmetal2.join(topmetal1).and_(ind_drw).merged().not_(ind_exc)
    ind_ports_ = ind_pin.and_(ind_core_).interacting(ind_edges)
    ind_port_la = ind_ports_.interacting(ind_text.texts(la_patt))
    ind_la_tm1 = ind_port_la.and_(topmetal1)
    ind_port_lb = ind_ports_.interacting(ind_text.texts(lb_patt))
    ind_lb_tm1 = ind_port_lb.and_(topmetal1)
    ind_port_lc = ind_ports_.interacting(ind_text.texts(lc_patt))
    ind_lc_tm2 = ind_port_lc.and_(topmetal2)

    # inductor2
    ind2_ports = ind_port_la.join(ind_port_lb)
    ind2_core = ind_core_.interacting(ind_port_la, 1).interacting(ind_port_lb, 1)
    ind2_mk_ = ind_drw.interacting(text_drw.texts(ind2_patt))
    ind2_mk = (
        ind2_mk_.interacting(ind2_core)
        .interacting(ind2_ports)
        .not_interacting(ind_port_lc)
    )
    ind2_sub1 = pwell.and_(ind_drw).interacting(ind2_core)
    ind2_sub2 = pwell_block.and_(ind_drw).interacting(ind2_core).sized(nm(1))
    ind2_well = nwell_drw.and_(ind_drw).interacting(ind2_core).sized(nm(-1))
    ind2_sub = ind2_sub1.join(ind2_sub2).join(ind2_well)
    # inductor3
    ind3_ports = ind_la_tm1.join(ind_lb_tm1).join(ind_lc_tm2)
    ind3_core = (
        ind_core_.interacting(ind_lb_tm1, 1)
        .interacting(ind_lb_tm1, 1)
        .interacting(ind_lc_tm2, 1)
    )
    ind3_mk_ = ind_drw.interacting(text_drw.texts(ind3_patt))
    ind3_mk = ind3_mk_.interacting(ind3_core).interacting(ind3_ports)
    ind3_sub1 = pwell.and_(ind_drw).interacting(ind3_core)
    ind3_sub2 = pwell_block.and_(ind_drw).interacting(ind3_core).sized(nm(1))
    ind3_well = nwell_drw.and_(ind_drw).interacting(ind3_core).sized(nm(-1))
    ind3_sub = ind3_sub1.join(ind3_sub2).join(ind3_well)

    # tap_derivations.lvs
    deck.info("Starting Taps DERIVATIONS")

    taps_exclude = (
        gatpoly.join(nsd_drw)
        .join(trans_drw)
        .join(emwind_drw)
        .join(emwihv_drw)
        .join(salblock_drw)
        .join(polyres_drw)
        .join(extblock_drw)
        .join(res_drw)
        .join(activ_mask)
        .join(recog_diode)
        .join(recog_esd)
        .join(ind_drw)
        .join(ind_pin)
    )

    # === ntap1 ===
    ntap1_exc = pwell.join(psd_drw).join(taps_exclude)

    ntap1_tie = nactiv.and_(ntap1_mk).extents().not_(ntap1_exc)
    ntap1_well = ntap1_mk.covering(ntap1_tie)

    # === ptap1 ===
    ptap1_exc = nwell_drw.join(taps_exclude)

    ptap1_tie = pactiv.and_(ptap1_mk).extents().not_(ptap1_exc)
    ptap1_sub = pwell.covering(ptap1_tie)

    # devices_connections.lvs
    deck.info("Starting GF180 LVS connectivity setup")

    # ================================
    # ----- GENERAL CONNECTIONS -----
    # ================================

    # ================================
    # ----- MOSFET CONNECTIONS ------
    # ================================

    # ================================
    # ---- RF-MOSFET CONNECTIONS ----
    # ================================

    # ================================
    # ------ BJT CONNECTIONS --------
    # ================================

    # ================================
    # ----- DIODE CONNECTIONS -------
    # ================================

    # ================================
    # ------- RES CONNECTIONS -------
    # ================================

    # ==================================
    # -------- CAP CONNECTIONS --------
    # ==================================

    # ================================
    # ------- ESD CONNECTIONS -------
    # ================================

    # =================================
    # ----- Inductor CONNECTIONS -----
    # =================================

    # ================================
    # ------- Taps CONNECTIONS ------
    # ================================

    # general_connections.lvs
    deck.info("Starting GF180 LVS connectivity setup (Inter-layer)")

    # Inter-layer
    deck.connect(pwell_sub, pwell)
    deck.connect(pwell, ptap)
    deck.connect(nwell_drw, ntap)
    deck.connect(ntap, cont_drw)
    deck.connect(ptap, cont_drw)
    deck.connect(poly_con, cont_drw)
    deck.connect(nsd_fet, cont_drw)
    deck.connect(psd_fet, cont_drw)
    deck.connect(cont_drw, metal1_con)
    deck.connect(metal1_con, via1_drw)
    deck.connect(via1_drw, metal2_con)
    deck.connect(metal2_con, via2_drw)
    deck.connect(via2_drw, metal3_con)
    deck.connect(metal3_con, via3_drw)
    deck.connect(via3_drw, metal4_con)
    deck.connect(metal4_con, via4_drw)
    deck.connect(via4_drw, metal5_con)
    deck.connect(metal5_con, topvia1_n_cap)
    deck.connect(topvia1_n_cap, topmetal1_con)
    deck.connect(topmetal1_con, topvia2_drw)
    deck.connect(topvia2_drw, topmetal2_con)

    # salicide connection
    deck.connect(nsd_fet, nsd_ptap_abutt)
    deck.connect(nsd_ptap_abutt, ptap)
    deck.connect(psd_fet, psd_ntap_abutt)
    deck.connect(psd_ntap_abutt, ntap)

    # Attaching labels
    deck.connect(metal1_con, metal1_text)
    deck.connect(metal2_con, metal2_text)
    deck.connect(metal3_con, metal3_text)
    deck.connect(metal4_con, metal4_text)
    deck.connect(metal5_con, metal5_text)
    deck.connect(topmetal1_con, topmetal1_text)
    deck.connect(topmetal2_con, topmetal2_text)

    deck.info("Starting SG13G2 LVS connectivity setup (Global)")

    # mos_connections.lvs
    deck.info("Starting LVS MOSFET CONNECTIONS")

    # rfmos_connections.lvs
    deck.info("Starting LVS RF-MOSFET CONNECTIONS")

    # bjt_connections.lvs
    deck.info("Starting LVS BJT CONNECTIONS")

    # =============
    # ---- NPN ----
    # =============

    # General
    deck.connect(npn_sub, pwell)

    # npn13G2 nodes connections
    deck.connect(npn13G2_te, npn13G2_e_pin)
    deck.connect(npn13G2_tc, npn13G2_c_pin)
    deck.connect(npn13G2_tb, npn13G2_b_pin)
    deck.connect(npn13G2_e_pin, cont_drw)
    deck.connect(npn13G2_c_pin, cont_drw)
    deck.connect(npn13G2_b_pin, cont_drw)
    deck.connect(npn_sub, pwell)
    deck.connect(npn13G2_e_pin, emwind_drw)
    deck.connect(emwind_drw, metal1_con)

    # npn13G2L nodes connections
    deck.connect(npn13G2l_te, npn13G2l_e_pin)
    deck.connect(npn13G2l_tc, npn13G2l_c_pin)
    deck.connect(npn13G2l_tb, npn13G2l_b_pin)
    deck.connect(npn13G2l_e_pin, cont_drw)
    deck.connect(npn13G2l_c_pin, cont_drw)
    deck.connect(npn13G2l_b_pin, cont_drw)
    deck.connect(npn_sub, pwell)

    # npn13G2V nodes connections
    deck.connect(npn13G2v_te, npn13G2v_e_pin)
    deck.connect(npn13G2v_tc, npn13G2v_c_pin)
    deck.connect(npn13G2v_tb, npn13G2v_b_pin)
    deck.connect(npn13G2v_e_pin, cont_drw)
    deck.connect(npn13G2v_c_pin, cont_drw)
    deck.connect(npn13G2v_b_pin, cont_drw)
    deck.connect(npn_sub, pwell)

    # =============
    # ---- PNP ----
    # =============

    # pnp_mpa nodes connections
    deck.connect(pnp_mpa_e, cont_drw)
    deck.connect(pnp_mpa_b, cont_drw)
    deck.connect(pnp_mpa_c, cont_drw)

    # diode_connections.lvs
    deck.info("Starting LVS DIODE CONNECTIONS")

    # dantenna diode
    deck.connect(dantenna_n, cont_drw)
    deck.connect(dantenna_p, pwell)

    # dantenna diode
    deck.connect(dpantenna_n, nwell_drw)
    deck.connect(dpantenna_p, cont_drw)

    # dantenna diode
    deck.connect(schottcky_p_1x1, schottcky_p)
    deck.connect(schottcky_p, metal1_con)
    deck.connect(schottcky_n, schottcky_n_port)
    deck.connect(schottcky_n_port, schottcky_n_con)
    deck.connect(schottcky_n_con, metal1_con)

    # res_connections.lvs
    deck.info("Starting RESISTOR CONNECTIONS")

    # === rsil ===
    deck.connect(rsil_ports, cont_drw)

    # === rppd ===
    deck.connect(rppd_ports, cont_drw)

    # === rhigh ===
    deck.connect(rhigh_ports, cont_drw)

    # === Metal Res ===
    # Added in general connections

    # cap_connections.lvs
    deck.info("Starting LVS CAP CONNECTIONS")

    # === cap_mim ===
    deck.connect(cmim_btm, metal5_con)
    deck.connect(cmim_top, mim_via)
    deck.connect(mim_via, topmetal1_con)

    # === rfcmim ===
    deck.connect(rfmim_btm, metal5_con)
    deck.connect(rfmim_top, mim_via)
    deck.connect(rfmim_sub, ptap)

    # === svarivap ===
    deck.connect(varicap_ports, cont_drw)
    deck.connect(varicap_ports, text_drw)
    deck.connect(varicap_sub, ptap)

    # esd_connections.lvs
    deck.info("Starting ESD CONNECTIONS")

    # ======================
    # ----- diode-ESD -----
    # ======================

    # diodevdd_2kv
    deck.connect(diodevdd_2kv_e_1x1, diodevdd_2kv_e)
    deck.connect(diodevdd_2kv_e, cont_drw)
    deck.connect(diodevdd_2kv_b, diodevdd_2kv_tb)
    deck.connect(diodevdd_2kv_tb, cont_drw)
    deck.connect(diodevdd_2kv_c, cont_drw)

    # diodevdd_4kv
    deck.connect(diodevdd_4kv_e_1x1, diodevdd_4kv_e)
    deck.connect(diodevdd_4kv_e, diodevdd_4kv_te)
    deck.connect(diodevdd_4kv_te, cont_drw)
    deck.connect(diodevdd_4kv_b, diodevdd_4kv_tb)
    deck.connect(diodevdd_4kv_tb, cont_drw)
    deck.connect(diodevdd_4kv_c, cont_drw)

    # diodevss_2kv
    deck.connect(diodevss_2kv_e_1x1, diodevss_2kv_e)
    deck.connect(diodevss_2kv_e, cont_drw)
    deck.connect(diodevss_2kv_b, diodevss_2kv_tb)
    deck.connect(diodevss_2kv_tb, cont_drw)
    deck.connect(diodevss_2kv_c, cont_drw)

    # diodevss_4kv
    deck.connect(diodevss_4kv_e_1x1, diodevss_4kv_e)
    deck.connect(diodevss_4kv_e, diodevss_4kv_te)
    deck.connect(diodevss_4kv_te, cont_drw)
    deck.connect(diodevss_4kv_b, diodevss_4kv_tb)
    deck.connect(diodevss_4kv_tb, cont_drw)
    deck.connect(diodevss_4kv_c, cont_drw)

    # =======================
    # ----- idiode-ESD -----
    # =======================

    # idiodevdd_2kv
    deck.connect(idiodevdd_2kv_e_1x1, idiodevdd_2kv_e)
    deck.connect(idiodevdd_2kv_e, cont_drw)
    deck.connect(idiodevdd_2kv_b, idiodevdd_2kv_tb)
    deck.connect(idiodevdd_2kv_tb, cont_drw)
    deck.connect(idiodevdd_2kv_c, cont_drw)

    # idiodevdd_4kv
    deck.connect(idiodevdd_4kv_e_1x1, idiodevdd_4kv_e)
    deck.connect(idiodevdd_4kv_e, idiodevdd_4kv_te)
    deck.connect(idiodevdd_4kv_te, cont_drw)
    deck.connect(idiodevdd_4kv_b, idiodevdd_4kv_tb)
    deck.connect(idiodevdd_4kv_tb, cont_drw)
    deck.connect(idiodevdd_4kv_c, cont_drw)

    # idiodevss_2kv
    deck.connect(idiodevss_2kv_e_1x1, idiodevss_2kv_e)
    deck.connect(idiodevss_2kv_e, cont_drw)
    deck.connect(idiodevss_2kv_b, idiodevss_2kv_tb)
    deck.connect(idiodevss_2kv_tb, cont_drw)
    deck.connect(idiodevss_2kv_c, cont_drw)

    # idiodevss_4kv
    deck.connect(idiodevss_4kv_e_1x1, idiodevss_4kv_e)
    deck.connect(idiodevss_4kv_e, idiodevss_4kv_te)
    deck.connect(idiodevss_4kv_te, cont_drw)
    deck.connect(idiodevss_4kv_b, idiodevss_4kv_tb)
    deck.connect(idiodevss_4kv_tb, cont_drw)
    deck.connect(idiodevss_4kv_c, cont_drw)

    # ======================
    # ----- MOSCL-ESD -----
    # ======================

    # nmoscl_2
    deck.connect(nmoscl_2_n, nmoscl_2_n_port)
    deck.connect(nmoscl_2_n_port, cont_drw)
    deck.connect(nmoscl_2_p, nmoscl_2_p_)
    deck.connect(nmoscl_2_p_, ptap)

    # nmoscl_4
    deck.connect(nmoscl_4_n, nmoscl_4_n_port)
    deck.connect(nmoscl_4_n_port, cont_drw)
    deck.connect(nmoscl_4_p, nmoscl_4_p_)
    deck.connect(nmoscl_4_p_, ptap)

    # ind_connections.lvs
    deck.info("Starting Inductor CONNECTIONS")

    # ind2
    deck.connect(ind2_ports, ind_pin)
    deck.connect(ind_pin, ind_text)
    deck.connect(ind_pin, topmetal2_con)
    deck.connect(ind2_sub, pwell)
    deck.connect(ind2_sub, nwell_drw)

    # ind3
    deck.connect(ind3_ports, ind_pin)
    deck.connect(ind_pin, topmetal1_con)
    deck.connect(ind3_sub, pwell)
    deck.connect(ind3_sub, nwell_drw)

    # tap_connections.lvs
    deck.info("Starting LVS Taps CONNECTIONS")

    # ntap1
    deck.connect(ntap1_tie, cont_drw)
    deck.connect(ntap1_well, nwell_drw)

    # ptap1
    deck.connect(ptap1_tie, cont_drw)
    deck.connect(ptap1_sub, pwell)

    # mos_extraction.lvs
    deck.info("Starting MOSFET EXTRACTION")

    # ==============
    # ---- NMOS ----
    # ==============

    deck.info("Starting NMOS EXTRACTION")

    # nmos - LV
    deck.info("Extraction of NMOS-LV transistor")
    deck.extract_devices(
        klayout_lvs.mos4("sg13_lv_nmos"),
        {
            "SD": nsd_fet,
            "G": ngate_lv,
            "tS": nsd_fet,
            "tD": nsd_fet,
            "tG": poly_con,
            "W": pwell,
        },
    )

    # nmos - HV
    deck.info("Extraction of NMOS-HV transistor")
    deck.extract_devices(
        klayout_lvs.mos4("sg13_hv_nmos"),
        {
            "SD": nsd_fet,
            "G": ngate_hv,
            "tS": nsd_fet,
            "tD": nsd_fet,
            "tG": poly_con,
            "W": pwell,
        },
    )

    # ==============
    # ---- PMOS ----
    # ==============

    deck.info("Starting PMOS EXTRACTION")

    # pmos - LV
    deck.info("Extraction of PMOS-LV transistor")
    deck.extract_devices(
        klayout_lvs.mos4("sg13_lv_pmos"),
        {
            "SD": psd_fet,
            "G": pgate_lv,
            "tS": psd_fet,
            "tD": psd_fet,
            "tG": poly_con,
            "W": nwell_drw,
        },
    )

    # pmos - HV
    deck.info("Extraction of PMOS-HV transistor")
    deck.extract_devices(
        klayout_lvs.mos4("sg13_hv_pmos"),
        {
            "SD": psd_fet,
            "G": pgate_hv,
            "tS": psd_fet,
            "tD": psd_fet,
            "tG": poly_con,
            "W": nwell_drw,
        },
    )

    # rfmos_extraction.lvs
    deck.info("Starting RF-MOSFET EXTRACTION")

    # ===============
    # --- RF-NMOS ---
    # ===============

    # rfnmos - LV
    deck.info("Extraction of RF-NMOS-LV transistor")
    deck.extract_devices(
        klayout_lvs.mos4("rfnmos"),
        {
            "SD": nsd_fet,
            "G": rfngate_lv,
            "W": pwell,
            "tS": nsd_fet,
            "tD": nsd_fet,
            "tG": poly_con,
            "tW": ptap,
        },
    )

    # rfnmos - HV
    deck.info("Extraction of RF-NMOS-HV transistor")
    deck.extract_devices(
        klayout_lvs.mos4("rfnmoshv"),
        {
            "SD": nsd_fet,
            "G": rfngate_hv,
            "W": pwell,
            "tS": nsd_fet,
            "tD": nsd_fet,
            "tG": poly_con,
            "tW": ptap,
        },
    )

    # ===============
    # --- RF-PMOS ---
    # ===============

    # rfpmos - LV
    deck.info("Extraction of RF-PMOS-LV transistor")
    deck.extract_devices(
        klayout_lvs.mos4("rfpmos"),
        {
            "SD": psd_fet,
            "G": rfpgate_lv,
            "tS": psd_fet,
            "tD": psd_fet,
            "tG": poly_con,
            "W": nwell_drw,
            "tW": ntap,
        },
    )

    # rfpmos - HV
    deck.info("Extraction of RF-PMOS-HV transistor")
    deck.extract_devices(
        klayout_lvs.mos4("rfpmoshv"),
        {
            "SD": psd_fet,
            "G": rfpgate_hv,
            "tS": psd_fet,
            "tD": psd_fet,
            "tG": poly_con,
            "W": nwell_drw,
            "tW": ntap,
        },
    )

    # bjt_extraction.lvs
    deck.info("Starting BJT EXTRACTION")

    # =============
    # ---- NPN ----
    # =============

    deck.info("Starting NPN-BJT EXTRACTION")

    deck.info("Extraction of npn13G2 BJT transistor")
    deck.extract_devices(
        klayout_lvs.bjt4("npn13G2", CustomBJT4),
        {
            "C": npn13G2_c,
            "B": npn13G2_b,
            "E": npn13G2_e,
            "S": npn_sub,
            "tC": npn13G2_tc,
            "tB": npn13G2_tb,
            "tE": npn13G2_te,
            "tS": npn_sub,
        },
    )

    deck.info("Extraction of npn13G2L BJT transistor")
    deck.extract_devices(
        klayout_lvs.bjt4("npn13G2l", CustomBJT4),
        {
            "C": npn13G2l_c,
            "B": npn13G2l_b,
            "E": npn13G2l_e,
            "S": npn_sub,
            "tC": npn13G2l_tc,
            "tB": npn13G2l_tb,
            "tE": npn13G2l_te,
            "tS": npn_sub,
        },
    )

    deck.info("Extraction of npn13G2V BJT transistor")
    deck.extract_devices(
        klayout_lvs.bjt4("npn13G2v", CustomBJT4),
        {
            "C": npn13G2v_c,
            "B": npn13G2v_b,
            "E": npn13G2v_e,
            "S": npn_sub,
            "tC": npn13G2v_tc,
            "tB": npn13G2v_tb,
            "tE": npn13G2v_te,
            "tS": npn_sub,
        },
    )

    # =============
    # ---- PNP ----
    # =============

    deck.info("Starting PNP-BJT EXTRACTION")

    # pnp_mpa BJT
    deck.info("Extracting pnpMPA BJT")
    deck.extract_devices(
        klayout_lvs.bjt3("pnpMPA", CustomBJT3),
        {
            "C": pnp_mpa_c.extents(),
            "B": pnp_mpa_b.extents(),
            "E": pnp_mpa_e,
            "tC": pnp_mpa_c,
            "tB": pnp_mpa_b,
            "tE": pnp_mpa_e,
        },
    )

    # diode_extraction.lvs
    deck.info("Starting DIODE EXTRACTION")

    # dantenna diode
    deck.info("Extracting dantenna diode")
    deck.extract_devices(
        klayout_lvs.diode("dantenna", EnDiode), {"N": dantenna_n, "P": dantenna_p}
    )

    # dpantenna diode
    deck.info("Extracting dpantenna diode")
    deck.extract_devices(
        klayout_lvs.diode("dpantenna", EnDiode), {"N": dpantenna_n, "P": dpantenna_p}
    )

    # schottky_nbl1 diode
    deck.info("Extracting schottky_nbl1 diode")
    deck.extract_devices(
        klayout_lvs.bjt3("schottky_nbl1", Esd3Term),
        {
            "C": schottcky_sub,
            "B": schottcky_n_port.extents(),
            "E": schottcky_p_1x1,
            "tC": ptap,
            "tB": schottcky_n_port,
            "tE": schottcky_p_1x1,
        },
    )

    # res_extraction.lvs
    deck.info("Starting RESISTOR EXTRACTION")

    # ==============
    # ---- POLY ----
    # ==============

    # rsil
    deck.info("Extracting rsil resistor")
    deck.extract_devices(
        GeneralNTerminalExtractor("rsil", 2),
        {
            "core": rsil_res,
            "ports": rsil_ports,
            "meas_mk": polyres_drw,
            "dev_mk": polyres_drw.interacting(rsil_res),
            "sub_mk": pwell.join(nwell_drw),
        },
    )
    # rppd
    deck.info("Extracting rppd resistor")
    deck.extract_devices(
        GeneralNTerminalExtractor("rppd", 2),
        {
            "core": rppd_res,
            "ports": rppd_ports,
            "meas_mk": polyres_drw,
            "dev_mk": polyres_drw.interacting(rppd_res),
            "sub_mk": pwell.join(nwell_drw),
        },
    )

    # rhigh
    deck.info("Extracting rhigh resistor")
    deck.extract_devices(
        GeneralNTerminalExtractor("rhigh", 2),
        {
            "core": rhigh_res,
            "ports": rhigh_ports,
            "meas_mk": polyres_drw,
            "dev_mk": polyres_drw.interacting(rhigh_res),
            "sub_mk": pwell.join(nwell_drw),
        },
    )

    # ===============
    # ---- METAL ----
    # ===============

    # RM1
    deck.info("Extracting res_metal1 resistor")
    deck.extract_devices(
        klayout_lvs.resistor("res_metal1", 1.0, RES2),
        {"R": res_metal1, "C": metal1_con},
    )

    # RM2
    deck.info("Extracting res_metal2 resistor")
    deck.extract_devices(
        klayout_lvs.resistor("res_metal2", 1.0, RES2),
        {"R": res_metal2, "C": metal2_con},
    )

    # RM3
    deck.info("Extracting res_metal3 resistor")
    deck.extract_devices(
        klayout_lvs.resistor("res_metal3", 1.0, RES2),
        {"R": res_metal3, "C": metal3_con},
    )

    # RM4
    deck.info("Extracting res_metal4 resistor")
    deck.extract_devices(
        klayout_lvs.resistor("res_metal4", 1.0, RES2),
        {"R": res_metal4, "C": metal4_con},
    )

    # RM5
    deck.info("Extracting res_metal5 resistor")
    deck.extract_devices(
        klayout_lvs.resistor("res_metal5", 1.0, RES2),
        {"R": res_metal5, "C": metal5_con},
    )

    # RTM1
    deck.info("Extracting res_topmetal1 resistor")
    deck.extract_devices(
        klayout_lvs.resistor("res_topmetal1", 1.0, RES2),
        {"R": res_topmetal1, "C": topmetal1_con},
    )

    # RTM2
    deck.info("Extracting res_topmetal2 resistor")
    deck.extract_devices(
        klayout_lvs.resistor("res_topmetal2", 1.0, RES2),
        {"R": res_topmetal2, "C": topmetal2_con},
    )

    # cap_extraction.lvs
    deck.info("Starting CAP EXTRACTION")

    # === cap_cmim ===
    deck.info("Extracting cap_cmim device")
    deck.extract_devices(
        MIMCAPExtractor("cap_cmim"),
        {
            "core": cmim_top,
            "top_mim": cmim_top,
            "btm_mim": cmim_btm,
            "meas_mk": cmim_dev,
            "dev_mk": cmim_dev,
        },
    )

    # === rfcmim ===
    deck.info("Extracting rfcmim device")
    deck.extract_devices(
        MIMCAPExtractor("rfcmim"),
        {
            "core": rfmim_top,
            "top_mim": rfmim_top,
            "btm_mim": rfmim_btm,
            "dev_mk": rfmim_area.covering(rfmim_dev),
            "meas_mk": rfmeas_mk,
            "sub_mk": rfmim_sub,
        },
    )

    # === svaricap ===
    deck.info("Extracting sg13_hv_svaricap varactor")
    deck.extract_devices(
        GeneralNTerminalExtractor("sg13_hv_svaricap", 3),
        {
            "core": varicap_core,
            "ports": varicap_ports,
            "meas_mk": activ,
            "dev_mk": varicap_dev_mk,
            "sub_mk": varicap_sub,
        },
    )

    # esd_extraction.lvs
    deck.info("Starting ESD EXTRACTION")

    # ======================
    # ----- diode-ESD -----
    # ======================

    # diodevdd_2kv
    deck.info("Extracting diodevdd_2kv ESD device")
    deck.extract_devices(
        klayout_lvs.bjt3("diodevdd_2kv", Esd3Term),
        {
            "C": diodevdd_2kv_c.extents(),
            "B": diodevdd_2kv_b.extents(),
            "E": diodevdd_2kv_e_1x1,
            "tC": diodevdd_2kv_c,
            "tB": diodevdd_2kv_b,
            "tE": diodevdd_2kv_e_1x1,
        },
    )

    # diodevdd_4kv
    deck.info("Extracting diodevdd_4kv ESD device")
    deck.extract_devices(
        klayout_lvs.bjt3("diodevdd_4kv", Esd3Term),
        {
            "C": diodevdd_4kv_c.extents(),
            "B": diodevdd_4kv_b.extents(),
            "E": diodevdd_4kv_e_1x1,
            "tC": diodevdd_4kv_c,
            "tB": diodevdd_4kv_b,
            "tE": diodevdd_4kv_e_1x1,
        },
    )

    # diodevss_2kv
    deck.info("Extracting diodevss_2kv ESD device")
    deck.extract_devices(
        klayout_lvs.bjt3("diodevss_2kv", Esd3Term),
        {
            "C": diodevss_2kv_c.extents(),
            "B": diodevss_2kv_b.extents(),
            "E": diodevss_2kv_e_1x1,
            "tC": diodevss_2kv_c,
            "tB": diodevss_2kv_b,
            "tE": diodevss_2kv_e_1x1,
        },
    )

    # diodevss_4kv
    deck.info("Extracting diodevss_4kv ESD device")
    deck.extract_devices(
        klayout_lvs.bjt3("diodevss_4kv", Esd3Term),
        {
            "C": diodevss_4kv_c.extents(),
            "B": diodevss_4kv_b.extents(),
            "E": diodevss_4kv_e_1x1,
            "tC": diodevss_4kv_c,
            "tB": diodevss_4kv_b,
            "tE": diodevss_4kv_e_1x1,
        },
    )

    # =======================
    # ----- idiode-ESD -----
    # =======================

    # idiodevdd_2kv
    deck.info("Extracting idiodevdd_2kv ESD device")
    deck.extract_devices(
        klayout_lvs.bjt3("idiodevdd_2kv", Esd3Term),
        {
            "C": idiodevdd_2kv_c.extents(),
            "B": idiodevdd_2kv_b.extents(),
            "E": idiodevdd_2kv_e_1x1,
            "tC": idiodevdd_2kv_c,
            "tB": idiodevdd_2kv_b,
            "tE": idiodevdd_2kv_e_1x1,
        },
    )

    # idiodevdd_4kv
    deck.info("Extracting idiodevdd_4kv ESD device")
    deck.extract_devices(
        klayout_lvs.bjt3("idiodevdd_4kv", Esd3Term),
        {
            "C": idiodevdd_4kv_c.extents(),
            "B": idiodevdd_4kv_b.extents(),
            "E": idiodevdd_4kv_e_1x1,
            "tC": idiodevdd_4kv_c,
            "tB": idiodevdd_4kv_b,
            "tE": idiodevdd_4kv_e_1x1,
        },
    )

    # idiodevss_2kv
    deck.info("Extracting idiodevss_2kv ESD device")
    deck.extract_devices(
        klayout_lvs.bjt3("idiodevss_2kv", Esd3Term),
        {
            "C": idiodevss_2kv_c.extents(),
            "B": idiodevss_2kv_b.extents(),
            "E": idiodevss_2kv_e_1x1,
            "tC": idiodevss_2kv_c,
            "tB": idiodevss_2kv_b,
            "tE": idiodevss_2kv_e_1x1,
        },
    )

    # idiodevss_4kv
    deck.info("Extracting idiodevss_4kv ESD device")
    deck.extract_devices(
        klayout_lvs.bjt3("idiodevss_4kv", Esd3Term),
        {
            "C": idiodevss_4kv_c.extents(),
            "B": idiodevss_4kv_b.extents(),
            "E": idiodevss_4kv_e_1x1,
            "tC": idiodevss_4kv_c,
            "tB": idiodevss_4kv_b,
            "tE": idiodevss_4kv_e_1x1,
        },
    )

    # ======================
    # ----- MOSCL-ESD -----
    # ======================

    # nmoscl_2
    deck.info("Extracting nmoscl_2 ESD device")
    deck.extract_devices(
        klayout_lvs.diode("nmoscl_2", Esd2Term), {"N": nmoscl_2_n, "P": nmoscl_2_p}
    )

    # nmoscl_4
    deck.info("Extracting nmoscl_4 ESD device")
    deck.extract_devices(
        klayout_lvs.diode("nmoscl_4", Esd2Term), {"N": nmoscl_4_n, "P": nmoscl_4_p}
    )

    # ind_extraction.lvs
    deck.info("Starting Inductor EXTRACTION")

    # ind2
    deck.info("Extracting Inductor2 device")
    deck.extract_devices(
        GeneralNTerminalExtractor("inductor", 2),
        {
            "core": ind2_core,
            "ports": ind2_ports,
            "meas_mk": topmetal2.and_(ind2_core),
            "dev_mk": ind2_mk,
            "sub_mk": ind2_sub,
        },
    )

    # ind3
    deck.info("Extracting Inductor3 device")
    deck.extract_devices(
        GeneralNTerminalExtractor("inductor3", 3),
        {
            "core": ind3_core,
            "ports": ind3_ports,
            "meas_mk": topmetal2.and_(ind3_core),
            "dev_mk": ind3_mk,
            "sub_mk": ind3_sub,
        },
    )

    # tap_extraction.lvs
    deck.info("Starting Taps EXTRACTION")

    # ntap1
    deck.info("Extracting ntap1 device")
    deck.extract_devices(
        klayout_lvs.diode("ntap1", CustomTap), {"N": ntap1_tie, "P": ntap1_well}
    )

    # ptap1
    deck.info("Extracting ptap1 device")
    deck.extract_devices(
        klayout_lvs.diode("ptap1", CustomTap), {"N": ptap1_tie, "P": ptap1_sub}
    )

    # ==================================================
    # ------------ COMPARISON PREPARATIONS ------------
    # ==================================================

    deck.info("Starting SG13G2 LVS Options Preparations")

    # === Aligns the extracted netlist vs. the schematic ===
    deck.info("Starting SG13G2 LVS Alignment")
    deck.align()

    netlist = deck.netlist()
    schematic = deck.schematic

    # === NETLIST OPTIONS ===
    deck.info("Starting SG13G2 LVS Simplification")
    # SIMPLIFY
    if SIMPLIFY:
        netlist.simplify()
        schematic.simplify()

    # TOP_LVL_PINS
    if TOP_LVL_PINS:
        netlist.make_top_level_pins()
        schematic.make_top_level_pins()

    # COMBINE_DEVICES
    if COMBINE_DEVICES:
        netlist.combine_devices()
        schematic.combine_devices()

    # PURGE
    if PURGE:
        netlist.purge()
        schematic.purge()

    # PURGE_NETS
    if PURGE_NETS:
        netlist.purge_nets()
        schematic.purge_nets()

    # === IGNORE EXTREME VALUES ===
    deck.max_res(1e9)
    deck.min_caps(1e-18)

    # === COMPARISON ===
    deck.info("Starting SG13G2 LVS Comparison")
    match = deck.compare()

    # ================================================
    # ------------- COMPARISON RESULTS ---------------
    # ================================================

    if not match:
        deck.info("ERROR : Netlists don't match")
    else:
        deck.info("INFO : Congratulations! Netlists match.")
    return match
