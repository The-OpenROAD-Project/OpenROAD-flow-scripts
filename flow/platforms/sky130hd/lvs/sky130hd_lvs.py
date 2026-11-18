"""SKY130 LVS deck, run by flow/util/klayout_lvs.py on the klayout module.

Extraction for SKY130, translated line by line from KLayout's LVS
language.
"""

from klayout_lvs import mos4

THREADS = 4

NMOS_CLASSES = ["nfet_01v8", "nfet_01v8_lvt", "nfet_g5v0d10v5", "nfet_01v8_nvt"]
PMOS_CLASSES = ["pfet_01v8", "pfet_01v8_hvt", "pfet_g5v0d10v5"]


def merge_parallel_series_stacks(circuit, device_class_names):
    """Join the internal nets of parallel/series transistor stacks.

    Real GDS-extracted layout often ties 3+ transistor fingers to a single
    shared internal diffusion node (interdigitated/folded layout), whereas
    the idealized schematic CDL always has exactly 2 terminals per
    internal fold node. This builds a signature for every qualifying
    terminal on a net (any count), then requires the entire sorted
    multiset of a net's terminal signatures to match another net's before
    joining them, which refuses to conflate two nets that only partially
    overlap in connectivity (two distinct internal series junctions in a
    3-stage stack).

    Signature keys are net names. Every unnamed net first gets a real,
    persistent name (synth_<n>): the binding hands back a new wrapper
    object on each lookup, so neither object identity nor equality of the
    wrappers identifies the same net reached two ways, and two distinct
    anonymous nets must never share a key.
    """
    synth_counter = 0
    for n in circuit.each_net():
        if not n.name:
            synth_counter += 1
            n.name = "synth_%d" % synth_counter

    def net_key(net):
        if net is None:
            return "unconnected"
        return net.name

    names = [n.lower() for n in device_class_names]
    chains = []
    for net in circuit.each_net():
        if any(True for _ in net.each_pin()) or any(
            True for _ in net.each_subcircuit_pin()
        ):
            continue
        has_gate_terminal = False
        for t in net.each_terminal():
            dc = t.device().device_class()
            try:
                if t.terminal_id() == dc.terminal_id("G"):
                    has_gate_terminal = True
            except RuntimeError:
                pass
        if has_gate_terminal:
            continue
        term_sigs = []
        for t in net.each_terminal():
            d = t.device()
            dc = d.device_class()
            if dc.name.lower() not in names:
                continue
            tid_s = dc.terminal_id("S")
            tid_g = dc.terminal_id("G")
            tid_d = dc.terminal_id("D")
            tid_b = dc.terminal_id("B")
            role = t.terminal_id()
            if role not in (tid_s, tid_d):
                continue
            opp = tid_d if role == tid_s else tid_s
            term_sigs.append(
                (
                    net_key(d.net_for_terminal(opp)),
                    net_key(d.net_for_terminal(tid_g)),
                    net_key(d.net_for_terminal(tid_b)),
                    dc.name.lower(),
                )
            )
        if len(term_sigs) < 2:
            continue
        chains.append((tuple(sorted(term_sigs)), net))

    groups = {}
    for sig, net in chains:
        groups.setdefault(sig, []).append(net)
    joined = set()
    for nets_in_group in groups.values():
        uniq_nets = []
        for n in nets_in_group:
            if n.name not in joined and n.name not in [u.name for u in uniq_nets]:
                uniq_nets.append(n)
        if len(uniq_nets) < 2:
            continue
        keep = uniq_nets[0]
        joined.update(n.name for n in uniq_nets)
        for other in uniq_nets[1:]:
            circuit.join_nets(keep, other)


def converge_merge(circuit, nmos_classes, pmos_classes, max_iters=10):
    """Merge parallel/series stacks until the device count stops
    shrinking: a single pass can leave multi-finger devices partially
    folded, e.g. sky130 cells where a "wide" transistor is laid out as
    several minimum-width fingers in parallel."""
    prev_count = -1
    for _ in range(max_iters):
        merge_parallel_series_stacks(circuit, nmos_classes)
        merge_parallel_series_stacks(circuit, pmos_classes)
        circuit.combine_devices()
        count = sum(1 for _ in circuit.each_device())
        if count == prev_count:
            return
        prev_count = count
    print(
        "WARNING: converge_merge did not stabilize for %s after %d iterations"
        % (circuit.name, max_iters)
    )


def find_net_by_name_component(circuit, component):
    """The net whose comma-separated name has the component.

    KLayout's extraction can merge the ground net with tied-off signal
    pins (constant-0 outputs) and name it "VSS,data_addr_o[0],...", which
    an exact net_by_name("VSS") does not find.
    """
    for n in circuit.each_net():
        if n.name and component in n.name.split(","):
            return n
    return None


def lvs(deck):
    # layers definitions
    ########################
    BOUND = deck.polygons(235, 4)
    DNWELL = deck.polygons(64, 18)
    PWRES = deck.polygons(64, 13)
    NWELL = deck.polygons(64, 20)
    NWELLTXT = deck.input(64, 5)
    NWELLPIN = deck.polygons(64, 16)
    SUBTXT = deck.input(122, 5)
    SUBPIN = deck.input(64, 59)
    DIFF = deck.polygons(65, 20)
    TAP = deck.polygons(65, 44)
    PSDM = deck.polygons(94, 20)
    NSDM = deck.polygons(93, 44)
    LVTN = deck.polygons(125, 44)
    HVTR = deck.polygons(18, 20)
    HVTP = deck.polygons(78, 44)
    SONOS = deck.polygons(80, 20)
    COREID = deck.polygons(81, 2)
    STDCELL = deck.polygons(81, 4)
    NPNID = deck.polygons(82, 20)
    PNPID = deck.polygons(82, 44)
    RPM = deck.polygons(86, 20)
    URPM = deck.polygons(79, 20)
    LDNTM = deck.polygons(11, 44)
    HVNTM = deck.polygons(125, 20)
    POLY = deck.polygons(66, 20)
    POLYTXT = deck.input(66, 5)
    POLYPIN = deck.polygons(66, 16)
    HVI = deck.polygons(75, 20)
    LICON = deck.polygons(66, 44)
    NPC = deck.polygons(95, 20)
    DIFFRES = deck.polygons(65, 13)
    POLYRES = deck.polygons(66, 13)
    POLYSHO = deck.polygons(66, 15)
    DIODE = deck.polygons(81, 23)
    LI = deck.polygons(67, 20)
    LITXT = deck.input(67, 5)
    LIPIN = deck.polygons(67, 16)
    LIRES = deck.polygons(67, 13)
    MCON = deck.polygons(67, 44)
    MET1 = deck.polygons(68, 20)
    MET1TXT = deck.input(68, 5)
    MET1PIN = deck.polygons(68, 16)
    MET1RES = deck.polygons(68, 13)
    VIA1 = deck.polygons(68, 44)
    MET2 = deck.polygons(69, 20)
    MET2TXT = deck.input(69, 5)
    MET2PIN = deck.polygons(69, 16)
    MET2RES = deck.polygons(69, 13)
    VIA2 = deck.polygons(69, 44)
    MET3 = deck.polygons(70, 20)
    MET3TXT = deck.input(70, 5)
    MET3PIN = deck.polygons(70, 16)
    MET3RES = deck.polygons(70, 13)
    VIA3 = deck.polygons(70, 44)
    MET4 = deck.polygons(71, 20)
    MET4TXT = deck.input(71, 5)
    MET4PIN = deck.polygons(71, 16)
    MET4RES = deck.polygons(71, 13)
    VIA4 = deck.polygons(71, 44)
    MET5 = deck.polygons(72, 20)
    MET5TXT = deck.input(72, 5)
    MET5PIN = deck.polygons(72, 16)
    MET5RES = deck.polygons(72, 13)
    RDL = deck.polygons(74, 20)
    RDLTXT = deck.input(74, 5)
    RDLPIN = deck.polygons(74, 16)
    GLASS = deck.polygons(76, 20)
    CAPM = deck.polygons(89, 44)
    CAPM2 = deck.polygons(97, 44)
    LOWTAPD = deck.polygons(81, 14)
    FILLOBSM1 = deck.polygons(62, 24)
    FILLOBSM2 = deck.polygons(105, 52)
    FILLOBSM3 = deck.polygons(107, 24)
    FILLOBSM4 = deck.polygons(112, 4)
    NCM = deck.polygons(92, 44)

    # Bulk layer for terminal provisioning
    SUB = deck.polygons(236, 0)
    # SUB = deck.polygon_layer()

    # Computed layers
    PDIFF = DIFF & NWELL & PSDM
    NTAP = TAP & NWELL & NSDM
    PGATE = PDIFF & POLY
    PSD = PDIFF - PGATE
    STD_PGATE = PGATE - HVTP - NCM - HVI
    HVT_PGATE = PGATE & HVTP - NCM - HVI
    HV5_PGATE = PGATE - HVTP - NCM & HVI

    NDIFF = DIFF - NWELL & NSDM
    PTAP = TAP - NWELL & PSDM
    NGATE = NDIFF & POLY
    NSD = NDIFF - NGATE
    STD_NGATE = NGATE - NCM - LVTN - HVI
    LVT_NGATE = NGATE - NCM & LVTN - HVI
    HV5_NGATE = NGATE - NCM - LVTN & HVI
    HV5NA_NGATE = NGATE - NCM & LVTN & HVI

    # drawing to physical
    deck.device_scaling(1000000)

    # PMOS transistor device extraction
    deck.extract_devices(
        mos4("pfet_01v8"),
        {"SD": PSD, "G": STD_PGATE, "tS": PSD, "tD": PSD, "tG": POLY, "W": NWELL},
    )
    deck.extract_devices(
        mos4("pfet_01v8_hvt"),
        {"SD": PSD, "G": HVT_PGATE, "tS": PSD, "tD": PSD, "tG": POLY, "W": NWELL},
    )
    deck.extract_devices(
        mos4("pfet_g5v0d10v5"),
        {"SD": PSD, "G": HV5_PGATE, "tS": PSD, "tD": PSD, "tG": POLY, "W": NWELL},
    )

    # NMOS transistor device extraction
    deck.extract_devices(
        mos4("nfet_01v8"),
        {"SD": NSD, "G": STD_NGATE, "tS": NSD, "tD": NSD, "tG": POLY, "W": SUB},
    )
    deck.extract_devices(
        mos4("nfet_01v8_lvt"),
        {"SD": NSD, "G": LVT_NGATE, "tS": NSD, "tD": NSD, "tG": POLY, "W": SUB},
    )
    deck.extract_devices(
        mos4("nfet_g5v0d10v5"),
        {"SD": NSD, "G": HV5_NGATE, "tS": NSD, "tD": NSD, "tG": POLY, "W": SUB},
    )
    deck.extract_devices(
        mos4("nfet_01v8_nvt"),
        {"SD": NSD, "G": HV5NA_NGATE, "tS": NSD, "tD": NSD, "tG": POLY, "W": SUB},
    )

    # Define connectivity for netlist extraction

    # Inter-layer
    deck.connect(SUB, PTAP)
    deck.connect(NWELL, NTAP)
    deck.connect(LICON, PTAP)
    deck.connect(LICON, NTAP)
    deck.connect(PSD, LICON)
    deck.connect(NSD, LICON)
    deck.connect(POLY, LICON)
    deck.connect(LICON, LI)
    deck.connect(LI, MCON)
    deck.connect(MCON, MET1)
    deck.connect(MET1, VIA1)
    deck.connect(VIA1, MET2)
    deck.connect(MET2, VIA2)
    deck.connect(VIA2, MET3)
    deck.connect(MET3, VIA3)
    deck.connect(VIA3, MET4)
    deck.connect(MET4, VIA4)
    deck.connect(VIA4, MET5)
    # Attaching labels
    deck.connect(SUB, SUBTXT)
    deck.connect(SUB, SUBPIN)
    deck.connect(NWELL, NWELLTXT)
    deck.connect(POLY, POLYTXT)
    deck.connect(LI, LITXT)
    deck.connect(MET1, MET1TXT)
    deck.connect(MET2, MET2TXT)
    deck.connect(MET3, MET3TXT)
    deck.connect(MET4, MET4TXT)
    deck.connect(MET5, MET5TXT)

    # Global
    deck.connect_global(SUB, "VNB")

    # Merge 0-ohm tie resistors in the schematic into direct net shorts,
    # so their structure matches the physical layout (which has no discrete
    # device for these ties, just a metal/contact short).
    schematic = deck.schematic
    for c in schematic.each_circuit():
        if c.name != "SKY130_FD_SC_HD__CONB_1":
            continue
        to_remove = []
        for d in c.each_device():
            dc = d.device_class()
            if dc.name == "RES" and d.parameter("R") == 0.0:
                na = d.net_for_terminal(dc.terminal_id("A"))
                nb = d.net_for_terminal(dc.terminal_id("B"))
                if na and nb and na.name != nb.name:
                    c.join_nets(na, nb)
                to_remove.append(d)
        for d in to_remove:
            c.remove_device(d)

    deck.same_circuits("sky130_fd_sc_hd__conb_1", "SKY130_FD_SC_HD__CONB_1")

    # Required to match transistors properly
    for c in schematic.each_circuit():
        converge_merge(c, NMOS_CLASSES, PMOS_CLASSES)

    # Actually performs the extraction
    netlist = deck.netlist()

    # Keep diode in both netlist and schematic, so it matches
    c1 = netlist.circuit_by_name("sky130_fd_sc_hd__conb_1")
    if c1:
        c1.dont_purge = True
    c2 = schematic.circuit_by_name("SKY130_FD_SC_HD__CONB_1")
    if c2:
        c2.dont_purge = True

    deck.split_gates("nfet_01v8")
    deck.split_gates("nfet_01v8_lvt")
    deck.split_gates("nfet_g5v0d10v5")
    deck.split_gates("nfet_01v8_nvt")
    deck.split_gates("pfet_01v8")
    deck.split_gates("pfet_01v8_hvt")
    deck.split_gates("pfet_g5v0d10v5")

    # The same multi-finger folding applies to the layout-extracted
    # netlist. Empirically this must run after split_gates, not before:
    # running it earlier (against the raw, still-undecomposed extracted
    # device representation) produced more fragmented results, not fewer.
    for c in netlist.each_circuit():
        converge_merge(c, NMOS_CLASSES, PMOS_CLASSES)

    # Ties VNB and VSS in the top cell.
    for c in netlist.each_circuit():
        if c.name != deck.top_cell:
            continue
        n_vnb = find_net_by_name_component(c, "VNB")
        n_vss = find_net_by_name_component(c, "VSS")
        if n_vnb and n_vss and n_vnb.name != n_vss.name:
            c.join_nets(n_vnb, n_vss)

    # Flatten cells which are present in one netlist only
    deck.align()

    # SIMPLIFICATION of the netlist
    netlist.simplify()
    schematic.simplify()

    # Tolerances for the devices extracted parameters
    for device in ("pfet_01v8", "pfet_01v8_hvt", "nfet_01v8", "nfet_01v8_lvt"):
        for parameter in ("W", "L"):
            deck.tolerance(device, parameter, absolute=0.001, relative=0.001)

    deck.equivalent_pins("*AND2_1", "A", "B")
    deck.equivalent_pins("*AND2_2", "A", "B")
    deck.equivalent_pins("*AND2_4", "A", "B")
    deck.equivalent_pins("*AND3_1", "A", "B", "C")
    deck.equivalent_pins("*AND3_2", "A", "B", "C")
    deck.equivalent_pins("*AND3_4", "A", "B", "C")
    deck.equivalent_pins("*AND4_1", "A", "B", "C", "D")
    deck.equivalent_pins("*AND4_2", "A", "B", "C", "D")
    deck.equivalent_pins("*AND4_4", "A", "B", "C", "D")
    deck.equivalent_pins("*A21OI_1", "A1", "A2")
    deck.equivalent_pins("*A21OI_2", "A1", "A2")
    deck.equivalent_pins("*A21OI_4", "A1", "A2")
    deck.equivalent_pins("*A211OI_1", "A1", "A2")
    deck.equivalent_pins("*A211OI_1", "B1", "C1")
    deck.equivalent_pins("*A211OI_2", "A1", "A2")
    deck.equivalent_pins("*A211OI_2", "B1", "C1")
    deck.equivalent_pins("*A211OI_4", "A1", "A2")
    deck.equivalent_pins("*A211OI_4", "B1", "C1")
    deck.equivalent_pins("*A221OI_1", "A1", "A2")
    deck.equivalent_pins("*A221OI_1", "B1", "B2")
    deck.equivalent_pins("*A22OI_1", "A1", "A2")
    deck.equivalent_pins("*A22OI_1", "B1", "B2")
    deck.equivalent_pins("*NAND2_1", "A", "B")
    deck.equivalent_pins("*NAND2_2", "A", "B")
    deck.equivalent_pins("*NAND2_4", "A", "B")
    deck.equivalent_pins("*NAND3_1", "A", "B", "C")
    deck.equivalent_pins("*NAND3_2", "A", "B", "C")
    deck.equivalent_pins("*NAND3_4", "A", "B", "C")
    deck.equivalent_pins("*NAND4_X1", "A", "B", "C", "D")
    deck.equivalent_pins("*NAND4_2", "A", "B", "C", "D")
    deck.equivalent_pins("*NAND4_4", "A", "B", "C", "D")
    deck.equivalent_pins("*OR2_1", "A", "B")
    deck.equivalent_pins("*OR2_2", "A", "B")
    deck.equivalent_pins("*OR2_4", "A", "B")
    deck.equivalent_pins("*OR3_1", "A", "B", "C")
    deck.equivalent_pins("*OR3_2", "A", "B", "C")
    deck.equivalent_pins("*OR3_4", "A", "B", "C")
    deck.equivalent_pins("*OR4_1", "A", "B", "C", "D")
    deck.equivalent_pins("*OR4_2", "A", "B", "C", "D")
    deck.equivalent_pins("*OR4_4", "A", "B", "C", "D")
    deck.equivalent_pins("*NOR2_1", "A", "B")
    deck.equivalent_pins("*NOR2_2", "A", "B")
    deck.equivalent_pins("*NOR2_4", "A", "B")
    deck.equivalent_pins("*NOR3_1", "A", "B", "C")
    deck.equivalent_pins("*NOR3_2", "A", "B", "C")
    deck.equivalent_pins("*NOR3_4", "A", "B", "C")
    deck.equivalent_pins("*NOR4_1", "A", "B", "C", "D")
    deck.equivalent_pins("*NOR4_2", "A", "B", "C", "D")
    deck.equivalent_pins("*NOR4_4", "A", "B", "C", "D")
    deck.equivalent_pins("*XOR2_1", "A", "B")
    deck.equivalent_pins("*XOR2_2", "A", "B")
    deck.equivalent_pins("*XNOR2_1", "A", "B")
    deck.equivalent_pins("*XNOR2_2", "A", "B")

    return deck.compare()
