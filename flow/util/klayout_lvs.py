"""LVS decks in Python on the PyPI klayout module.

KLayout's LVS language is its DRC language plus a netlist comparer
(src/lvs/lvs/built-in-macros/_lvs_netter.rb). This module adds to
klayout_drc.Deck what ORFS's LVS decks use: device extraction, the
schematic, the comparer's configuration and the comparison, with the
calls the LVS language makes, in its order: what is configured before
the netlist is extracted runs right after the extraction, what is
configured for the comparer runs when it is made.
"""

import argparse
import os
import sys

import klayout_drc
from klayout_drc import db


class LvsDeck(klayout_drc.Deck):
    def __init__(self, in_gds, report_file, cdl_file, top_cell, threads=1):
        super().__init__(in_gds, report_file, "LVS", mode="deep", threads=threads)
        self.top_cell = top_cell
        self.cdl_file = cdl_file
        self.scaling = 1.0
        self.post_extract = []
        self.comparer_config = []
        self.read_schematic(db.NetlistSpiceReader())

    def read_schematic(self, reader):
        """Reads the CDL with a reader, as the LVS language's
        schematic(file, reader)."""
        self.info("Reading netlist: %s .." % self.cdl_file)
        self.schematic = db.Netlist()
        self.schematic.read(self.cdl_file, reader)

    def _l2n_register(self, data):
        if self.l2n is None:
            self.l2n = db.LayoutVsSchematic(self.dss)
            self.l2n.name = "LVS"
            self.l2n.device_scaling = self.scaling
            self.l2n_layers = {}
        super()._l2n_register(data)

    def device_scaling(self, factor):
        self.scaling = factor
        if self.l2n is not None:
            self.l2n.device_scaling = factor

    def extract_devices(self, extractor, layers):
        """layers: terminal or layer name to Layer, as the LVS language's
        hash; registered in the order of the sorted names, as it does."""
        selection = {}
        for name in sorted(layers):
            self._l2n_register(layers[name].data)
            selection[name] = layers[name].data
        self.l2n.extract_devices(extractor, selection)
        return extractor.device_class()

    def connect_global(self, layer, name):
        self._l2n_register(layer.data)
        self.l2n.connect(layer.data)
        self.l2n.connect_global(layer.data, name)

    def _l2n_data(self):
        if not self.l2n.is_extracted():
            super()._l2n_data()
            for f in self.post_extract:
                f(self.l2n)
        return self.l2n

    def netlist(self):
        return self._l2n_data().netlist()

    def _extracted(self):
        return self.l2n is not None and self.l2n.is_extracted()

    def _now_or_after_extraction(self, f):
        if self._extracted():
            f(self.l2n)
        else:
            self.post_extract.append(f)

    def split_gates(self, device_name, circuit_pattern="*"):
        def f(l2n):
            dc = l2n.netlist().device_class_by_name(device_name)
            if dc is None:
                raise ValueError("'%s' is not a valid device name" % device_name)
            for c in l2n.netlist().circuits_by_name(circuit_pattern):
                dc.join_split_gates(c)

        self._now_or_after_extraction(f)

    def tolerance(self, device_class_name, parameter_name, absolute=0.0, relative=0.0):
        def f(l2n):
            dc = l2n.netlist().device_class_by_name(device_class_name)
            if dc is not None and dc.has_parameter(parameter_name):
                ep = db.EqualDeviceParameters(
                    dc.parameter_id(parameter_name), float(absolute), float(relative)
                )
                if dc.equal_parameters is None:
                    dc.equal_parameters = ep
                else:
                    dc.equal_parameters += ep

        self._now_or_after_extraction(f)

    def same_circuits(self, a, b):
        def f(comparer):
            circuit_a = a and self.netlist().circuit_by_name(a)
            circuit_b = b and self.schematic.circuit_by_name(b)
            if circuit_a and circuit_b:
                comparer.same_circuits(circuit_a, circuit_b)

        self.comparer_config.append(f)

    def equivalent_pins(self, circuit, *pins):
        def f(comparer):
            circuit_b = self.schematic.circuit_by_name(circuit)
            if circuit_b is None:
                return
            by_index = list(circuit_b.each_pin())
            ids = []
            for p in pins:
                if isinstance(p, str):
                    pin = circuit_b.pin_by_name(p)
                else:
                    pin = by_index[int(p)]
                if pin is None:
                    raise ValueError(
                        "Not a valid pin in circuit '%s' in 'equivalent_pins': %s"
                        % (circuit, p)
                    )
                ids.append(pin.id())
            comparer.equivalent_pins(circuit_b, ids)

        self.comparer_config.append(f)

    def max_res(self, value):
        v = float(value)

        def f(comparer):
            comparer.max_resistance = v

        self.comparer_config.append(f)

    def min_caps(self, value):
        v = float(value)

        def f(comparer):
            comparer.min_capacitance = v

        self.comparer_config.append(f)

    def _comparer(self):
        comparer = db.NetlistComparer()
        for f in self.comparer_config:
            f(comparer)
        return comparer

    def align(self):
        nl_a, nl_b = self.netlist(), self.schematic
        comparer = self._comparer()
        unmatched_a = comparer.unmatched_circuits_a(nl_a, nl_b)
        top = self.l2n.internal_top_cell().name
        if any(c.name == top for c in unmatched_a):
            raise ValueError(
                "Can't find a schematic counterpart for the top cell %s" % top
            )
        for c in unmatched_a:
            self.info("Flatten layout cell (no schematic): %s" % c.name)
        nl_a.flatten_circuits(unmatched_a)
        unmatched_b = comparer.unmatched_circuits_b(nl_a, nl_b)
        for c in unmatched_b:
            self.info("Flatten schematic circuit (no layout): %s" % c.name)
        nl_b.flatten_circuits(unmatched_b)

    def compare(self):
        self.netlist()
        self.l2n.reference = self.schematic
        return self.l2n.compare(self._comparer())

    def write(self):
        if self.l2n is not None and self.l2n.xref() is not None:
            self.info("Writing LVS database: %s .." % self.report_file)
            self.l2n.write(self.report_file, True)


# Device classes and factories handed to the extractors; the klayout
# objects hold them by pointer, so Python keeps them alive.
_keep = []


class _DeviceClassFactory(db.DeviceClassFactory if db else object):
    """A device class factory for a class, as the DRC language's
    CustomDeviceClassFactory."""

    def __init__(self, cls):
        super().__init__()
        self.cls = cls

    def create_class(self):
        dc = self.cls()
        _keep.append(dc)
        return dc


def _factory(cls):
    if cls is None:
        return None
    f = _DeviceClassFactory(cls)
    _keep.append(f)
    return f


def mos4(name, cls=None):
    return db.DeviceExtractorMOS4Transistor(name, False, _factory(cls))


def bjt3(name, cls=None):
    return db.DeviceExtractorBJT3Transistor(name, _factory(cls))


def bjt4(name, cls=None):
    return db.DeviceExtractorBJT4Transistor(name, _factory(cls))


def diode(name, cls=None):
    return db.DeviceExtractorDiode(name, _factory(cls))


def resistor(name, sheet_rho, cls=None):
    return db.DeviceExtractorResistor(name, sheet_rho, _factory(cls))


def parse_args(argv):
    parser = argparse.ArgumentParser(
        description="Run a Python LVS deck on a GDS/OAS file against a CDL"
        " netlist and write a KLayout LVS database (.lvsdb)."
    )
    parser.add_argument("--deck", required=True, help="the deck, a .py file")
    parser.add_argument("--in-gds", required=True)
    parser.add_argument("--cdl-file", required=True)
    parser.add_argument("--top-cell", required=True)
    parser.add_argument("--report-file", required=True)
    return parser.parse_args(argv)


def main(argv):
    args = parse_args(argv)
    klayout_drc.require_db()
    module = klayout_drc.load_deck(args.deck)
    deck = LvsDeck(
        args.in_gds,
        args.report_file,
        args.cdl_file,
        args.top_cell,
        threads=module.THREADS,
    )
    match = module.lvs(deck)
    deck.write()
    if match:
        print("INFO : Congratulations! Netlists match.")
    else:
        print("ERROR : Netlists don't match")
    return 0


if __name__ == "__main__":
    # The deck imports these modules by name; run those, not __main__,
    # so the objects it passes are the ones checked here.
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import klayout_lvs

    sys.exit(klayout_lvs.main(sys.argv[1:]))
