##########################################################################################
# BSD 2-Clause License
#
# Copyright (c) 2021, laurentc2
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
"""ASAP7 DRC deck, run by flow/util/klayout_drc.py on the klayout module.

DRC for ASAP7 according to asap7_drm_201207a.pdf, found on
https://github.com/The-OpenROAD-Project/asap7/blob/master/asap7PDK_r1p7/docs/asap7_drm_201207a.pdf

Based on work by @laurentc2 found on
https://github.com/laurentc2/ASAP7_for_KLayout, translated line by line
from KLayout's DRC language.
"""

import klayout.db as db

from klayout_drc import (
    Layer,
    euclidian,
    mm,
    nm,
    one_side_allowed,
    projection,
    two_connected_sides_allowed,
    two_opposite_sides_allowed,
    um,
    width,
)

DESCRIPTION = "ASAP7 DRC runset"
MODE = "deep"
THREADS = 8

# manufacturing grid/angle checks
OFFGRID = False


def with_holes(layer, lo, hi):
    """Polygons with lo to hi holes, both inclusive, hi None for no limit."""
    new_data = db.Region()
    for p in layer.data.each():
        if p.holes() >= (lo or 0) and (hi is None or p.holes() <= hi):
            new_data.insert(p)
    return Layer(layer.deck, new_data)


def drc(deck):
    # layers definitions
    nwell = deck.input(1, 0)
    fin = deck.input(2, 0)
    gate = deck.input(7, 0)
    gcut = deck.input(10, 0)
    active = deck.input(11, 0)
    sdt = deck.input(88, 0)
    nselect = deck.input(12, 0)
    pselect = deck.input(13, 0)
    slvt = deck.input(97, 0)
    lvt = deck.input(98, 0)
    sramdrc = deck.input(99, 0)
    sramvt = deck.input(110, 0)
    dummy = deck.input(8, 0)
    lig = deck.input(16, 0)
    lisd = deck.input(17, 0)
    v0 = deck.input(18, 0)
    m1 = deck.input(19, 0)
    v1 = deck.input(21, 0)
    m2 = deck.input(20, 0)
    v2 = deck.input(25, 0)
    m3 = deck.input(30, 0)
    v3 = deck.input(35, 0)
    m4 = deck.input(40, 0)
    v4 = deck.input(45, 0)
    m5 = deck.input(50, 0)
    v5 = deck.input(55, 0)
    m6 = deck.input(60, 0)
    v6 = deck.input(65, 0)
    m7 = deck.input(70, 0)
    v7 = deck.input(75, 0)
    m8 = deck.input(80, 0)
    v8 = deck.input(85, 0)
    m9 = deck.input(90, 0)
    v9 = deck.input(95, 0)
    pad = deck.input(96, 0)

    # DRC section
    ########################
    deck.info("DRC section")

    #  construction layers :
    gatenogcut = gate - gcut
    activesram, activenosram = active.andnot(sramdrc)
    ligsram, lignosram = lig.andnot(sramdrc)

    ###   WELL
    nwell.width(nm(108), projection).with_angle(90).output(
        "WELL.W.1", "WELL.W.1 : Min. horizontal width of WELL : 108nm"
    )
    nwell.width(nm(54), projection).with_angle(0).output(
        "WELL.W.2", "WELL.W.2 : Min. vertical width of WELL : 54nm"
    )
    nwell.space(nm(108), projection).with_angle(0).output(
        "WELL.S.1", "WELL.S.1 : Min. vertical spacing between WELL : 108nm"
    )
    nwell.space(nm(54), projection).with_angle(90).output(
        "WELL.S.2", "WELL.S.2 : Min. horizontal spacing between WELL : 54nm"
    )
    nwell.with_area((0, 0.005832)).output(
        "WELL.A.1A", "WELL.A.1A : Min. area of WELL : 5832nm2"
    )
    nwell.holes().with_area((0, 0.005832)).output(
        "WELL.A.1B", "WELL.A.1B : Min. enclosed area of WELL : 5832nm2"
    )
    nwell.enclosing(gatenogcut, nm(7), projection).with_angle(90).output(
        "WELL.GATE.EX.1",
        "WELL.GATE.EX.1 : Min. horizontal extension of WELL past GATE (not cut by GCUT layer): 7nm",
    )
    nwell.not_(sramdrc).enclosing(gatenogcut, nm(7), projection).with_angle(0).output(
        "WELL.GATE.EX.2",
        "WELL.GATE.EX.2 : Min. vertical extension of WELL past GATE (not cut by GCUT layer): 7nm",
    )

    ###   FIN
    fin.edges().with_angle(90).without_length(nm(7)).output(
        "FIN.W.1a", "FIN.W.1 : Exact vertical width of FIN : 7nm"
    )
    fin.without_bbox_height(nm(7)).output(
        "FIN.W.1", "FIN.W.1 : Exact vertical width of FIN : 7nm"
    )
    # fin.drc(if_all(angle == 90, length != 7.nm)).output("FIN.W.1c", "FIN.W.1 : Exact vertical width of FIN : 7nm")
    fin.drc(width(projection) < nm(108)).with_angle(90).output(
        "FIN.W.2", "FIN.W.2 : Min. horizontal width of WELL : 108nm"
    )
    fin.space(nm(35), projection).polygons().not_(fin).without_bbox_height(
        nm(20)
    ).sized(0, nm(3.5)).output("FIN.S.1", "FIN.S.1 : Exact vertical FIN pitch : 27nm")
    fin.corners((0, 90)).sized(nm(1)).output(
        "FIN.AUX.1", "FIN.AUX.1 : FIN may not bend"
    )

    ###   GATE
    gate.drc(width(projection) != nm(20)).with_angle(90).output(
        "GATE.W.1", "GATE.W.1 : Exact horizontal width of GATE : 20nm"
    )
    gate.width(nm(40), projection).with_angle(0).output(
        "GATE.W.2", "GATE.W.2 : Min. vertical width of GATE : 40nm"
    )
    gate.space(nm(100), projection).polygons().not_(fin).without_bbox_width(
        nm(34)
    ).sized(0, nm(10)).output(
        "GATE.S.1", "GATE.S.1 : Exact horizontal GATE pitch : 54nm"
    )
    gate.space(nm(34), projection).with_angle(90).output(
        "GATE.S.3", "GATE.S.3 : Min. horizontal spacing between GATE : 34nm"
    )
    gatenogcut.not_(sramdrc).sized(nm(55), 0).not_interacting(gate).output(
        "GATE.S.2",
        "GATE.S.2 : Every GATE (not cut by GCUT and not interacting with the layer SRAMDRC) must have at least one other GATE within 54 nm of its surrounding along the horizontal axis : 54nm",
    )
    gate.corners((0, 90)).sized(nm(1)).output(
        "GATE.AUX.1", "GATE.AUX.1 : GATE may not bend"
    )
    with_holes(gate.sized(1 * deck.dbu, mm(1)).and_(gate), 2, None).output(
        "GATE.AUX.2",
        "GATE.AUX.2 : GATE may not be discontinuous along the vertical axis",
    )
    active.edges().with_angle(90).and_(gate).output(
        "GATE.AUX.3",
        "GATE.AUX.3 : ACTIVE layer vertical edge may not lie inside, or coincide with, the GATE layer",
    )
    gate.enclosing(gate.and_(active), nm(4), projection).polygons().without_area(
        0
    ).output(
        "GATE.ACTIVE.EX.1",
        "GATE.ACTIVE.EX.1 : Min. vertical extension of GATE (not cut by GCUT) past ACTIVE : 4nm",
    )
    active.interacting(gate).enclosing(
        gate.and_(active), nm(25), projection
    ).polygons().without_area(0).output(
        "GATE.ACTIVE.EX.2",
        "GATE.ACTIVE.EX.2 : Min. horizontal extension of ACTIVE interacting with GATE (not cut by GCUT layer) past GATE (not cut by GCUT layer) : 20nm",
    )
    gatenogcut.separation(active, nm(9), projection).polygons().without_area(
        0
    ).not_interacting(gate & active).output(
        "GATE.ACTIVE.S.4",
        "GATE.ACTIVE.S.4 : Min. horizontal spacing between ACTIVE and GATE (not cut by GCUT and not interacting with ACTIVE) : 9nm",
    )

    ### ACTIVE
    active.enclosing(fin, nm(10), projection).polygons().without_area(0).output(
        "ACTIVE.FIN.EX.1",
        "ACTIVE.FIN.EX.1 : Min. vertical extension of ACTIVE past FIN : 10nm",
    )
    active.width(nm(27), projection).with_angle(0).output(
        "ACTIVE.W.1", "ACTIVE.W.1 : Min. vertical width of ACTIVE : 27nm"
    )
    active.without_bbox_height(nm(27)).and_(
        active.without_bbox_height(2 * nm(27))
    ).and_(active.without_bbox_height(3 * nm(27))).and_(
        active.without_bbox_height(4 * nm(27))
    ).and_(
        active.without_bbox_height(5 * nm(27))
    ).and_(
        active.without_bbox_height(6 * nm(27))
    ).and_(
        active.without_bbox_height(7 * nm(27))
    ).and_(
        active.without_bbox_height(8 * nm(27))
    ).and_(
        active.without_bbox_height(9 * nm(27))
    ).and_(
        active.without_bbox_height(10 * nm(27))
    ).and_(
        active.without_bbox_height(11 * nm(27))
    ).and_(
        active.without_bbox_height(12 * nm(27))
    ).output(
        "ACTIVE.W.2",
        "ACTIVE.W.2 : ACTIVE layer vertical width increment is an integer multiple of : 27nm",
    )
    active.width(nm(16), projection).with_angle(90).output(
        "ACTIVE.W.3", "ACTIVE.W.3 : Min. horizontal width of ACTIVE : 16nm"
    )
    active.space(nm(27), projection).with_angle(0).output(
        "ACTIVE.S.1", "ACTIVE.S.1 : Min. vertical spacing between ACTIVE : 27nm"
    )
    active.interacting(gate).space(nm(92), projection).edges().with_angle(
        90
    ).extended_out(nm(30)).not_(lisd).output(
        "ACTIVE.S.2A",
        "ACTIVE.S.2A : Min. horizontal spacing between ACTIVE layers forming source/drain regions (of different transistors) : 92nm",
    )
    active.space(nm(38), projection).with_angle(90).output(
        "ACTIVE.S.2B", "ACTIVE.S.2B : Min. horizontal spacing between ACTIVE : 38nm"
    )
    activenosram.separation(nwell, nm(27), projection).output(
        "ACTIVE.WELL.S.4", "ACTIVE.WELL.S.4 : Min. spacing of ACTIVE to WELL : 27nm"
    )
    activesram.separation(nwell, nm(13.5), projection).output(
        "SRAM.ACTIVE.WELL.S.5",
        "SRAM.ACTIVE.WELL.S.5 : Min. spacing of ACTIVE in SRAM to WELL : 13.5nm",
    )
    nwell.enclosing(activenosram, nm(27), projection).polygons().without_area(0).output(
        "ACTIVE.WELL.EN.1", "ACTIVE.WELL.EN.1 : Min. enclosure of ACTIVE by WELL : 27nm"
    )
    nwell.enclosing(activesram, nm(13.5), projection).polygons().without_area(0).output(
        "SRAM.ACTIVE.WELL.EN.2",
        "SRAM.ACTIVE.WELL.EN.2 : Min. enclosure of ACTIVE in SRAM by WELL : 13.5nm",
    )
    activenosram.with_area((0, 0.000864)).output(
        "ACTIVE.A.1A", "ACTIVE.A.1A : Min. area of ACTIVE : 864nm2"
    )
    activenosram.holes().with_area((0, 0.000864)).output(
        "ACTIVE.A.1B", "ACTIVE.A.1B : Min. enclosed area of ACTIVE : 864nm2"
    )
    activesram.with_area((0, 0.000432)).output(
        "SRAM.ACTIVE.A.1A", "SRAM.ACTIVE.A.1A : Min. area of ACTIVE in SRAM : 432nm2"
    )
    activesram.holes().with_area((0, 0.000432)).output(
        "SRAM.ACTIVE.A.1B",
        "SRAM.ACTIVE.A.1B : Min. enclosed area of ACTIVE in SRAM : 432nm2",
    )
    active.not_(nselect + pselect).output(
        "ACTIVE.AUX.1",
        "ACTIVE.AUX.1 : ACTIVE must always be enclosed by NSELECT or PSELECT",
    )
    active.edges().and_((nselect + pselect).edges()).output(
        "ACTIVE.AUX.1_edges",
        "ACTIVE.AUX.1 : ACTIVE must always be enclosed by NSELECT or PSELECT, such that no ACTIVE layer edge(s) coincide with NSELECT or PSELECT layer edge(s)",
    )
    sramdrc.edges().and_(active).output(
        "SRAM.ACTIVE.AUX.2",
        "SRAM.ACTIVE.AUX.2 : ACTIVE not belonging to an SRAM cell may not touch the SRAMDRC layer",
    )
    active.notch(mm(1), projection).with_angle(0).output(
        "ACTIVE.AUX.3",
        "ACTIVE.AUX.3 : notch in ACTIVE along vertical axis is not allowed",
    )
    (active.interacting(gate) & nselect).sized(um(30)).not_interacting(
        active & pselect - nwell
    ).sized(-um(30)).output(
        "ACTIVE.LUP.1",
        "ACTIVE.LUP.1 : Maximum distance, to prevent latch-up, between ACTIVE forming a MOS device and ACTIVE forming a bulk/substrate contact within the same WELL/substrate : 30um",
    )
    (active.interacting(gate) & pselect).sized(um(30)).not_interacting(
        active & nselect & nwell
    ).sized(-um(30)).output(
        "ACTIVE.LUP.1",
        "ACTIVE.LUP.1 : Maximum distance, to prevent latch-up, between ACTIVE forming a MOS device and ACTIVE forming a bulk/substrate contact within the same WELL/substrate : 30um",
    )

    ###   GCUT
    gcut.width(nm(17), projection).with_angle(0).output(
        "GCUT.W.1", "GCUT.W.1 : Min. vertical width of GCUT : 17nm"
    )
    gcut.separation(active, nm(4), projection).output(
        "GCUT.ACTIVE.S.1",
        "GCUT.ACTIVE.S.1 : Min. vertical spacing between GCUT and channel : 4nm",
    )
    gcut.enclosing(gate.and_(gcut), nm(17), projection).with_angle(
        90
    ).polygons().without_area(0).output(
        "GCUT.GATE.EX.1",
        "GCUT.GATE.EX.1 : Min. horizontal extension of GCUT past GATE : 17nm",
    )
    gcut.separation(gate, nm(17), projection).output(
        "GCUT.GATE.S.2", "GCUT.GATE.S.2 : Minimum spacing of GCUT to GATE : 17nm"
    )
    gcut.space(nm(35), projection).with_angle(0).output(
        "GCUT.S.3", "GCUT.S.3 : Min. vertical spacing between GCUT : 35nm"
    )
    gcut.not_interacting(gate).output(
        "GCUT.AUX.1", "GCUT.AUX.1 : GCUT layer may not exist without the layer GATE"
    )
    gcut.edges().with_angle(90).and_(gate).output(
        "GCUT.AUX.2",
        "GCUT.AUX.2 : GCUT layer vertical edge may not lie inside, or coincide with, the GATE layer",
    )
    gcut.edges().and_(active).output(
        "GCUT.AUX.3", "GCUT.AUX.3 : GCUT may not interact with channel"
    )

    ###   NSELECT/PSELECT  LVT/SLVT/SRAMVT
    nselect.width(nm(108), projection).with_angle(90).output(
        "NSELECT.W.1", "NSELECT.W.1 : Min. horizontal width of NSELECT : 108nm"
    )
    nselect.width(nm(54), projection).with_angle(0).output(
        "NSELECT.W.2", "NSELECT.W.2 : Min. vertical width of NSELECT : 54nm"
    )
    nselect.enclosing(activenosram, nm(46), projection).with_angle(90).output(
        "NSELECT.ACTIVE.EN.1",
        "NSELECT.ACTIVE.EN.1 : Min. horizontal enclosure of ACTIVE by NSELECT : 46nm",
    )
    nselect.enclosing(activenosram, nm(27), projection).with_angle(0).output(
        "NSELECT.ACTIVE.EN.2",
        "NSELECT.ACTIVE.EN.2 : Min. vertical enclosure of ACTIVE by NSELECT : 27nm",
    )
    nselect.enclosing(activesram, nm(13.5), projection).output(
        "SRAM.NSELECT.ACTIVE.EN.3-4",
        "SRAM.NSELECT.ACTIVE.EN.3-4 : Min. enclosure of ACTIVE in SRAM by NSELECT : 13.5nm",
    )
    nselect.enclosing(gatenogcut, nm(7), projection).with_angle(
        90
    ).polygons().without_area(0).output(
        "NSELECT.GATE.EX.1-2",
        "NSELECT.GATE.EX.1-2 : Min. horizontal extension of NSELECT past GATE : 7nm",
    )
    pselect.width(nm(108), projection).with_angle(90).output(
        "PSELECT.W.1", "PSELECT.W.1 : Min. horizontal width of PSELECT : 108nm"
    )
    pselect.width(nm(54), projection).with_angle(0).output(
        "PSELECT.W.2", "PSELECT.W.2 : Min. vertical width of PSELECT : 54nm"
    )
    pselect.enclosing(activenosram, nm(46), projection).with_angle(90).output(
        "PSELECT.ACTIVE.EN.1",
        "PSELECT.ACTIVE.EN.1 : Min. horizontal enclosure of ACTIVE by PSELECT : 46nm",
    )
    pselect.enclosing(activenosram, nm(27), projection).with_angle(0).output(
        "PSELECT.ACTIVE.EN.2",
        "PSELECT.ACTIVE.EN.2 : Min. vertical enclosure of ACTIVE by PSELECT : 27nm",
    )
    pselect.enclosing(activesram, nm(13.5), projection).output(
        "SRAM.PSELECT.ACTIVE.EN.3-4",
        "SRAM.PSELECT.ACTIVE.EN.3-4 : Min. enclosure of ACTIVE in SRAM by PSELECT : 13.5nm",
    )
    pselect.enclosing(gatenogcut, nm(7), projection).with_angle(
        90
    ).polygons().without_area(0).output(
        "PSELECT.GATE.EX.1-2",
        "PSELECT.GATE.EX.1-2 : Min. horizontal extension of PSELECT past GATE : 7nm",
    )
    (nselect & pselect).output(
        "NSELECT.PSELECT.AUX.1",
        "NSELECT.PSELECT.AUX.1 : NSELECT and PSELECT may not overlap",
    )
    ((lvt & slvt) + (lvt & sramvt) + (slvt & sramvt)).output(
        "VT.AUX.2", "VT.AUX.2 : VT layers (LVT, SLVT, and SRAMVT) may not overlap"
    )

    ###   SDT
    sdt.width(nm(24), projection).with_angle(90).output(
        "SDT.W.1", "SDT.W.1 : Min. horizontal width of SDT : 24nm"
    )
    sdt.not_(sramdrc).width(nm(27), projection).with_angle(0).output(
        "SDT.W.2", "SDT.W.2 : Min. vertical width of SDT : 27nm"
    )
    sdt.without_bbox_height(nm(27)).and_(sdt.without_bbox_height(2 * nm(27))).and_(
        sdt.without_bbox_height(3 * nm(27))
    ).and_(sdt.without_bbox_height(4 * nm(27))).and_(
        sdt.without_bbox_height(5 * nm(27))
    ).and_(
        sdt.without_bbox_height(6 * nm(27))
    ).and_(
        sdt.without_bbox_height(7 * nm(27))
    ).and_(
        sdt.without_bbox_height(8 * nm(27))
    ).and_(
        sdt.without_bbox_height(9 * nm(27))
    ).and_(
        sdt.without_bbox_height(10 * nm(27))
    ).and_(
        sdt.without_bbox_height(11 * nm(27))
    ).and_(
        sdt.without_bbox_height(12 * nm(27))
    ).output(
        "SDT.W.3",
        "SDT.W.3 : SDT vertical height increment is an integer multiple of : 27nm",
    )
    sdt.and_(sramdrc).width(nm(17), projection).with_angle(0).output(
        "SRAM.SDT.W.4", "SRAM.SDT.W.4 : Min. vertical width of SDT in SRAM : 17nm"
    )
    sdt.space(nm(30), projection).with_angle(90).output(
        "SDT.S.1", "SDT.S.1 : Min. vertical spacing between SDT : 30nm"
    )
    sdt.separation(gate, nm(5), projection).output(
        "SDT.GATE.S.2",
        "SDT.GATE.S.2 : Min. horizontal spacing between SDT and GATE : 5nm",
    )

    ###   LISD
    lisd.width(nm(24)).output("LISD.W.1", "LISD.W.1 : Min. width of LISD : 24nm")
    lisd.space(nm(18)).polygons().not_interacting(
        lisd.edges().with_length((0, nm(36)))
    ).output(
        "LISD.S.1",
        "LISD.S.1 : Min. spacing between two LISD' edges, when both edges are > 36 nm : 18nm",
    )
    lisd.space(nm(25)).polygons().not_interacting(
        lisd.edges().with_length((nm(36), mm(100)))
    ).output(
        "LISD.S.2",
        "LISD.S.2 : Min. spacing between two LISD' edges, when one edge is > 36 nm : 25nm",
    )
    lisd.space(nm(27), euclidian).polygons().not_interacting(
        lisd.edges().with_length((nm(36), mm(100)))
    ).output(
        "LISD.S.3-4",
        "LISD.S.3-4 : Min. spacing between two LISD' edges, when both edge are =< 36 nm : 27nm",
    )
    lisd.with_area((0, 0.000648)).output(
        "LISD.A.1", "LISD.A.1 : Min. area of LISD : 648nm2"
    )
    lisd.and_(sramdrc).with_area(0).output(
        "SRAM.LISD.AUX.1",
        "SRAM.LISD.AUX.1 : LISD, which are either completely outside the SRAMDRC or which do not intersect the SRAMDRC, may not touch the SRAMDRC",
    )

    ###   LIG
    lig.width(nm(16)).output("LIG.W.1", "LIG.W.1 : Min. width of LIG : 16nm")
    lig.space(nm(18)).polygons().not_interacting(
        lig.edges().with_length((0, nm(36)))
    ).output(
        "LIG.S.1",
        "LIG.S.1 : Min. spacing between two LIG' edges, when both edges are > 36 nm : 18nm",
    )
    lig.space(nm(25)).polygons().not_interacting(
        lig.edges().with_length((nm(36), mm(100)))
    ).output(
        "LISD.S.2",
        "LIG.S.2 : Min. spacing between two LIG' edges, when one edge is > 36 nm : 25nm",
    )
    lig.space(nm(27)).polygons().not_interacting(
        lig.edges().with_length((0, nm(24)))
    ).not_interacting(lig.edges().with_length((nm(36), mm(100)))).output(
        "LIG.S.3",
        "LIG.S.3 : Min. spacing between two LIG' edges, when both edges are >=24nm and =< 36 nm : 27nm",
    )
    lig.space(nm(31), euclidian).polygons().not_interacting(
        lisd.edges().with_length((nm(24), mm(100)))
    ).output(
        "LIG.S.4-5",
        "LISD.S.4-5 : Min. spacing between two LIG' edges, when both edge are =< 24 nm : 31nm",
    )
    lig.separation(lisd, nm(14), projection).output(
        "LIG.LISD.S.6"
        "LIG.LISD.S.6 : Min. spacing between LIG and LISD not on the same net : 14nm"
    )
    lig.separation(lisd, nm(15), euclidian).output(
        "LIG.LISD.S.7"
        "LIG.LISD.S.7 : Min. corner-to-corner spacing between LISD and LIG not on the same net : 15nm"
    )
    lig.separation(sdt, nm(14), projection).output(
        "LIG.SDT.S.8"
        "LIG.SDT.S.8 : Min. spacing between LIG and SDT not on the same net : 14nm"
    )
    lig.separation(gatenogcut, nm(14), projection).with_angle(0).output(
        "LIG.LISD.S.9A"
        "LIG.LISD.S.9A : Min. vertical spacing between LIG and GATE (not cut using GCUT) : 14nm"
    )
    lig.separation(gatenogcut, nm(17), projection).with_angle(90).output(
        "LIG.LISD.S.9B"
        "LIG.LISD.S.9B : Min. horizontal spacing between LIG and GATE (not cut using GCUT) : 17nm"
    )
    lig.separation(gatenogcut & active, nm(5), euclidian).output(
        "LIG.GATE.S.10"
        "LIG.GATE.S.10 : Min. spacing between LIG and GATE (not cut using GCUT) forming a channel : 5nm"
    )
    lig.separation(gcut, nm(5), euclidian).with_angle(0).output(
        "LIG.GCUT.S.11"
        "LIG.GCUT.S.11 : Min. vertical spacing between LIG and GCUT : 5nm"
    )
    lig.with_area((0, 0.000324)).output(
        "LIG.A.1", "LIG.A.1 : Min. area of LIG : 324nm2"
    )
    (lig + lisd).with_area((0, 0.000128)).output(
        "LIG.LISD.A.2",
        "LIG.LISD.A.2 : Min. area of overlap between LIG and LISD : 128nm2",
    )
    (lignosram + gatenogcut).with_area((0, 0.000320)).output(
        "LIG.GATE.A.3",
        "LIG.GATE.A.3 : Min. area of overlap between LIG and and GATE (not cut using GCUT) : 320nm2",
    )
    (ligsram + gatenogcut).with_area((0, 0.000240)).output(
        "LIG.GATE.A.4",
        "LIG.GATE.A.4 : Min. area of overlap between LIG in SRAM and and GATE (not cut using GCUT) : 240nm2",
    )
    lignosram.edges().with_angle(90).and_(gate).output(
        "LIG.GATE.AUX.1",
        "LIG.GATE.AUX.1 : LIG vertical edge may not lie inside, or coincide with, the GATE layer",
    )
    ligsram.with_area(0).output(
        "SRAM.LIG.AUX.2",
        "SRAM.LIG.AUX.2 : LIG, which are either completely outside the SRAMDRC or which do not intersect the SRAMDRC, may not touch the SRAMDRC",
    )
    lignosram.enclosing(gatenogcut, nm(1), projection).polygons().without_area(
        0
    ).output(
        "LIG.GATE.EX.1",
        "LIG.GATE.EX.1 : Min. extension of LIG past GATE (not cut using GCUT) : 1nm",
    )
    (lig + lisd).width(nm(8)).output(
        "LIG.LISD.OV.1",
        "LIG.LISD.OV.1 : Min. overlap between LIG and LISD connected together : 8nm",
    )
    (ligsram + gatenogcut).width(nm(15)).output(
        "SRAM.LIG.GATE.OV.2",
        "SRAM.LIG.GATE.OV.2 : Min. overlap between LIG in SRAM and GATE (not cut using GCUT) : 15nm",
    )

    ###   V0
    # rule V0.W.1 not checked for the instance along the length of M1
    v0.width(nm(18)).output("V0.W.1", "V0.W.1 : Min. width of V0 : 18nm")
    v0.space(nm(18), projection).output(
        "V0.S.1",
        "V0.S.1 : Min. spacing between V0 instances [on the same M1 track or on parallel M1 tracks, if they are fully or partially aligned with each other : 18nm",
    )
    v0spaceortho = v0.space(nm(27), projection).polygons()
    v0.space(nm(27), euclidian).polygons().not_interacting(v0spaceortho).output(
        "V0.S.1",
        "V0.S.1 : Min. spacing between V0 instances on parallel M1 tracks, if they are not aligned with each other : 27nm",
    )
    m1ovlp5v0 = (
        (m1 & v0.sized(nm(5)) - v0)
        .sized(-nm(2.5) + 1 * deck.dbu)
        .sized(nm(2.5) - 1 * deck.dbu)
    )
    v0.edges().and_(m1ovlp5v0).space(nm(23), euclidian).polygons().not_(
        v0spaceortho
    ).output(
        "V0.S.2",
        "V0.S.2 : Min. corner-to-corner spacing between two V0 instances—both with a 5 nm M1 end-cap : 23nm",
    )
    v0.edges().not_interacting(m1ovlp5v0).space(nm(30), euclidian).output(
        "V0.S.3",
        "V0.S.3 : Min. corner-to-corner spacing between two V0 instances—both without a 5 nm M1 end-cap : 30nm",
    )
    v0.edges().and_(m1ovlp5v0).separation(
        v0.edges().not_interacting(m1ovlp5v0), nm(27), euclidian
    ).output(
        "V0.S.4",
        "V0.S.4 : Min. corner-to-corner spacing between two V0 instances—one with and another without, a 5 nm M1 end-cap : 27nm",
    )
    v0.not_interacting(m1ovlp5v0.sized(2 * deck.dbu)).output(
        "V0.M1.EN.1", "V0.M1.EN.1 : enclosure of V0 by M1 on one side : 5nm"
    )
    v0spaceortho.forget()
    m1ovlp5v0.forget()
    (
        lisd.enclosing(
            v0.not_interacting(lig), nm(3), projection, two_connected_sides_allowed
        ).edges()
        - lisd.enclosing(
            v0.not_interacting(lig), nm(3), projection, one_side_allowed
        ).edges()
    ).output(
        "V0.LISD.EN.2",
        "V0.LISD.EN.2 : Min. enclosure of V0 (interacting with LISD, but not with LIG) by LISD on at least two opposite sides is 3 nm and such a V0 must lie completely inside LISD : 3nm",
    )
    lisd.enclosing(v0.interacting(lig), nm(3), projection, one_side_allowed).output(
        "V0.LISD.EN.3",
        "V0.LISD.EN.3 : Min. enclosure of V0 (sharing some, but not all its area with LISD) by LISD (interacting with LIG) on at least two opposite sides is 3 nm and such a V0 does not need to lie completely inside LISD : 3nm",
    )
    (
        v0.enclosing(lig, nm(1), projection, two_connected_sides_allowed).edges()
        - v0.enclosing(lig, nm(1), projection, one_side_allowed).edges()
    ).not_(lig).output(
        "V0.LIG.EN.4",
        "V0.LIG.EN.4 : Min. enclosure of LIG by V0 (interacting with LIG and not inside LISD) on two opposite sides is 1 nm : 1nm",
    )
    (v0 & lig).with_area((0, 0.000288)).output(
        "V0.LIG.A.1",
        "V0.LIG.A.1 : Min. area of overlap between V0 (interacting with LIG and not inside LISD) and LIG : 288nm2",
    )
    ((v0 - m1) + (v0 - lig.sized(nm(1)) - lisd)).output(
        "V0.AUX.1-2" "V0.AUX.1-2 : V0 must always interact with M1 and [LISD|LIG]"
    )
    v0.not_interacting(
        m1.enclosing(v0, 1 * deck.dbu, projection, two_opposite_sides_allowed).edges()
    ).output(
        "V0.M1.AUX.3",
        "V0.M1.AUX.3 : V0 must exactly be the same width as M1 along the direction perpendicular to the M1 length",
    )

    ###   M1
    m1.width(nm(18)).output("M1.W.1", "M1.W.1 : Min. width of M1 : 18nm")
    m1.space(nm(18)).polygons().not_interacting(
        m1.edges().with_length((0, nm(36)))
    ).output(
        "M1.S.1",
        "M1.S.1 : Min. spacing between two M1' edges, when both edges are > 36 nm : 18nm",
    )
    m1.space(nm(25)).polygons().not_interacting(
        m1.edges().with_length((nm(36), mm(100)))
    ).output(
        "  ",
        "M1.S.2 : Min. spacing between two M1' edges, when one edge is > 36 nm : 25nm",
    )
    m1.space(nm(27)).polygons().not_interacting(
        m1.edges().with_length((0, nm(24)))
    ).not_interacting(m1.edges().with_length((nm(36), mm(100)))).output(
        "M1.S.3",
        "M1.S.3 : Min. spacing between two M1' edges, when both edges are >=24nm and =< 36 nm : 27nm",
    )
    m1.space(nm(31)).polygons().not_interacting(
        m1.edges().with_length((nm(24), mm(100)))
    ).output(
        "M1.S.4-5",
        "M1.S.4-5 : Min. spacing between two M1' edges, when both edge are =< 24 nm : 31nm",
    )
    m1long = (
        m1.space(nm(20), projection)
        .polygons()
        .interacting(m1.edges().with_length((nm(36), mm(100))))
    )
    m1.space(nm(20), euclidian).polygons().not_interacting(m1long).output(
        "M1.S.6", "M1.S.6 : Min. corner-to-corner spacing between two M1 : 20nm"
    )
    m1long.forget()
    m1.with_area((0, 0.000504)).output("M1.A.1", "M1.A.1 : Min. area of M1 : 504nm2")

    ###   M2
    m2.width(nm(18)).output("M2.W.1", "M2.W.1 : Min. width of M2 : 18nm")
    m2.space(nm(18)).polygons().not_interacting(
        m2.edges().with_length((0, nm(36)))
    ).output(
        "M2.S.1",
        "M2.S.1 : Min. spacing between two M2' edges, when both edges are > 36 nm : 18nm",
    )
    m2.space(nm(25)).polygons().not_interacting(
        m2.edges().with_length((nm(36), mm(100)))
    ).output(
        "M2.S.2",
        "M2.S.2 : Min. spacing between two M2' edges, when one edge is > 36 nm : 25nm",
    )
    m2.space(nm(27)).polygons().not_interacting(
        m2.edges().with_length((0, nm(24)))
    ).not_interacting(m2.edges().with_length((nm(36), mm(100)))).output(
        "M2.S.3",
        "M2.S.3 : Min. spacing between two M2' edges, when both edges are >=24nm and =< 36 nm : 27nm",
    )
    m2.space(nm(31)).polygons().not_interacting(
        m2.edges().with_length((nm(24), mm(100)))
    ).output(
        "M2.S.4-5",
        "M2.S.4-5 : Min. spacing between two M2' edges, when both edge are =< 24 nm : 31nm",
    )
    m2long = (
        m2.space(nm(20), projection)
        .polygons()
        .interacting(m2.edges().with_length((nm(36), mm(100))))
    )
    m2.space(nm(20), euclidian).polygons().not_interacting(m2long).output(
        "M2.S.6", "M2.S.6 : Min. corner-to-corner spacing between two M2 : 20nm"
    )
    m2long.forget()
    m2.with_area((0, 0.000504)).output("M2.A.1", "M2.A.1 : Min. area of M2 : 504nm2")

    ###   M3
    m3.width(nm(18)).output("M3.W.1", "M3.W.1 : Min. width of M3 : 18nm")
    m3.space(nm(18)).polygons().not_interacting(
        m3.edges().with_length((0, nm(36)))
    ).output(
        "M3.S.1",
        "M3.S.1 : Min. spacing between two M3' edges, when both edges are > 36 nm : 18nm",
    )
    m3.space(nm(25)).polygons().not_interacting(
        m3.edges().with_length((nm(36), mm(100)))
    ).output(
        "M3.S.2",
        "M3.S.2 : Min. spacing between two M3' edges, when one edge is > 36 nm : 25nm",
    )
    m3.space(nm(27)).polygons().not_interacting(
        m3.edges().with_length((0, nm(24)))
    ).not_interacting(m3.edges().with_length((nm(36), mm(100)))).output(
        "M3.S.3",
        "M3.S.3 : Min. spacing between two M3' edges, when both edges are >=24nm and =< 36 nm : 27nm",
    )
    m3.space(nm(31)).polygons().not_interacting(
        m3.edges().with_length((nm(24), mm(100)))
    ).output(
        "M3.S.4-5",
        "M3.S.4-5 : Min. spacing between two M3' edges, when both edge are =< 24 nm : 31nm",
    )
    m3long = (
        m3.space(nm(20), projection)
        .polygons()
        .interacting(m3.edges().with_length((nm(36), mm(100))))
    )
    m3.space(nm(20), euclidian).polygons().not_interacting(m3long).output(
        "M3.S.6", "M3.S.6 : Min. corner-to-corner spacing between two M3 : 20nm"
    )
    m3long.forget()
    m3.with_area((0, 0.000504)).output("M3.A.1", "M3.A.1 : Min. area of M3 : 504nm2")

    ###   V1
    # rule V1.W.1 not checked for the instance along the length of M2
    v1.width(nm(18)).output("V1.W.1", "V1.W.1 : Min. width of V1 : 18nm")
    v1.space(nm(18), projection).output(
        "V1.S.1",
        "V1.S.1 : Min. spacing between V1 instances [on the same M2 track or on parallel M2 tracks, if they are fully or partially aligned with each other : 18nm",
    )
    v1spaceortho = v1.space(nm(27), projection).polygons()
    v1.space(nm(27), projection).polygons().not_interacting(v1spaceortho).output(
        "V1.S.1",
        "V1.S.1 : Min. spacing between V1 instances on parallel M2 tracks, if they are not aligned with each other : 27nm",
    )
    m2ovlp5v1 = (
        (m2 & v1.sized(nm(5) + 2 * deck.dbu) - v1).sized(-nm(2.5)).sized(nm(2.5))
    )
    v1.edges().and_(m2ovlp5v1).space(nm(23), euclidian).polygons().not_(
        v1spaceortho
    ).output(
        "V1.S.2",
        "V1.S.2 : Min. corner-to-corner spacing between two V1 instances—both with a 5 nm M2 end-cap : 23nm",
    )
    v1.edges().not_interacting(m2ovlp5v1).space(nm(30), euclidian).output(
        "V1.S.3",
        "V1.S.3 : Min. corner-to-corner spacing between two V1 instances—both without a 5 nm M2 end-cap : 30nm",
    )
    v1.edges().and_(m2ovlp5v1).separation(
        v1.edges().not_interacting(m2ovlp5v1), nm(27), euclidian
    ).output(
        "V1.S.4",
        "V1.S.4 : Min. corner-to-corner spacing between two V1 instances—one with and another without, a 5 nm M2 end-cap : 27nm",
    )
    v1spaceortho.forget()
    m1ovlp5v1 = (
        (m1 & v1.sized(nm(5)) - v1)
        .sized(-nm(2.5) + 1 * deck.dbu)
        .sized(nm(2.5) - 1 * deck.dbu)
    )
    v1.interacting(
        m1.enclosing(v1, nm(2), projection, two_connected_sides_allowed).edges()
        - m1.enclosing(v1, nm(2), projection, one_side_allowed).edges()
    ).output(
        "V1.M1.EN.1",
        "V1.M1.EN.1 : Min. enclosure of V1 by M1 on at least two opposite sides  : 5nm & 2nm",
    )
    v1.interacting(
        m1.enclosing(v1, nm(5), projection, two_connected_sides_allowed).edges()
        - m1.enclosing(v1, nm(5), projection, one_side_allowed).edges()
    ).not_interacting(m1ovlp5v1.sized(1 * deck.dbu)).output(
        "V1.M1.EN.1",
        "V1.M1.EN.1 : Min. enclosure of V1 by M1 on at least two opposite sides  : 5nm & 2nm",
    )
    v1.not_interacting(m2ovlp5v1.sized(2 * deck.dbu)).output(
        "V1.M2.EN.2", "V1.M2.EN.2 : enclosure of V1 by M2 on one side : 5nm"
    )
    m1ovlp5v1.forget()
    m2ovlp5v1.forget()
    ((v1 - m2) + (v1 - m1)).output("V1.AUX.1" "V1.AUX.1 : V1 must be inside M1 and M2")
    v1.not_interacting(
        m2.enclosing(v1, 1 * deck.dbu, projection, two_opposite_sides_allowed).edges()
    ).output(
        "V1.M2.AUX.2",
        "V1.M2.AUX.2 : V1 must exactly be the same width as M2 along the direction perpendicular to the M2 length",
    )

    ###   V2
    # rule V2.W.1 not checked for the instance along the length of M3
    v2.width(nm(18)).output("V2.W.1", "V2.W.1 : Min. width of V2 : 18nm")
    v2.space(nm(18), projection).output(
        "V2.S.1",
        "V2.S.1 : Min. spacing between V2 instances [on the same M3 track or on parallel M3 tracks, if they are fully or partially aligned with each other : 18nm",
    )
    v2spaceortho = v2.space(nm(27), projection).polygons()
    v2.space(nm(27), projection).polygons().not_interacting(v2spaceortho).output(
        "V2.S.1",
        "V2.S.1 : Min. spacing between V2 instances on parallel M3 tracks, if they are not aligned with each other : 27nm",
    )
    m3ovlp5v2 = (
        (m3 & v2.sized(nm(5)) - v2).sized(-nm(2.5) + 1 * deck.dbu).sized(nm(2.5))
    )
    v2.edges().and_(m3ovlp5v2).space(nm(23), euclidian).polygons().not_(
        v2spaceortho
    ).output(
        "V2.S.2",
        "V2.S.2 : Min. corner-to-corner spacing between two V2 instances—both with a 5 nm M3 end-cap : 23nm",
    )
    v2.edges().not_interacting(m3ovlp5v2).space(nm(30), euclidian).output(
        "V2.S.3",
        "V2.S.3 : Min. corner-to-corner spacing between two V2 instances—both without a 5 nm M3 end-cap : 30nm",
    )
    v2.edges().and_(m3ovlp5v2).separation(
        v2.edges().not_interacting(m3ovlp5v2), nm(27), euclidian
    ).output(
        "V2.S.4",
        "V2.S.4 : Min. corner-to-corner spacing between two V2 instances—one with and another without, a 5 nm M3 end-cap : 27nm",
    )
    v2.interacting(
        m2.enclosing(v2, nm(5), projection, two_connected_sides_allowed).edges()
        - m2.enclosing(v2, nm(5), projection, one_side_allowed).edges()
    ).output(
        "V2.M2.EN.1",
        "V2.M2.EN.1 : Min. enclosure of V2 by M2 on at least two opposite sides  : 5nm",
    )
    v2.not_interacting(m3ovlp5v2.sized(2 * deck.dbu)).output(
        "V2.M3.EN.2", "V2.M3.EN.2 : enclosure of V2 by M3 on one side : 5nm"
    )
    m3ovlp5v2.forget()
    ((v2 - m3) + (v2 - m2)).output("V2.AUX.1" "V2.AUX.1 : V2 must be inside M2 and M3")
    v2.not_interacting(
        m3.enclosing(v2, 1 * deck.dbu, projection, two_opposite_sides_allowed).edges()
    ).output(
        "V2.M3.AUX.2",
        "V2.M3.AUX.2 : V2 must exactly be the same width as M3 along the direction perpendicular to the M3 length",
    )

    ###   V3
    # rule V3.W.1 not checked for the instance along the length of M4
    v3.width(nm(18)).output("V3.W.1", "V3.W.1 : Min. width of V3 : 18nm")
    v3.space(nm(18), projection).output(
        "V3.S.1",
        "V3.S.1 : Min. spacing between V3 instances [on the same M4 track or on parallel M4 tracks, if they are fully or partially aligned with each other : 18nm",
    )
    v3spaceortho = v3.space(nm(27), projection).polygons()
    v3.space(nm(27), projection).polygons().not_interacting(v3spaceortho).output(
        "V3.S.1",
        "V3.S.1 : Min. spacing between V3 instances on parallel M4 tracks, if they are not aligned with each other : 27nm",
    )
    m4ovlp5v3 = (
        (m4 & v3.sized(nm(5)) - v3).sized(-nm(2.5) + 1 * deck.dbu).sized(nm(2.5))
    )
    v3.edges().and_(m4ovlp5v3).space(nm(23), euclidian).polygons().not_(
        v3spaceortho
    ).output(
        "V3.S.2",
        "V3.S.2 : Min. corner-to-corner spacing between two V3 instances—both with a 5 nm M4 end-cap : 23nm",
    )
    v3.edges().not_interacting(m4ovlp5v3).space(nm(30), euclidian).output(
        "V3.S.3",
        "V3.S.3 : Min. corner-to-corner spacing between two V3 instances—both without a 5 nm M4 end-cap : 30nm",
    )
    v3.edges().and_(m4ovlp5v3).separation(
        v3.edges().not_interacting(m4ovlp5v3), nm(27), euclidian
    ).output(
        "V3.S.4",
        "V3.S.4 : Min. corner-to-corner spacing between two V3 instances—one with and another without, a 5 nm M4 end-cap : 27nm",
    )
    m4ovlp5v3.forget()
    v3.interacting(
        m3.enclosing(v3, nm(5), projection, two_connected_sides_allowed).edges()
        - m3.enclosing(v3, nm(5), projection, one_side_allowed).edges()
    ).output(
        "V3.M3.EN.1",
        "V3.M3.EN.1 : Min. enclosure of V3 by M3 on at least two opposite sides  : 5nm",
    )
    v3.interacting(
        m4.enclosing(v3, nm(11), projection, two_connected_sides_allowed).edges()
        - m4.enclosing(v3, nm(11), projection, one_side_allowed).edges()
    ).output(
        "V3.M4.EN.2",
        "V3.M4.EN.2 : Min. enclosure of V3 by M4 on at least two opposite sides  : 11nm",
    )
    ((v3 - m4) + (v3 - m3)).output("V3.AUX.1" "V3.AUX.1 : V3 must be inside M3 and M4")
    v3.not_interacting(
        m4.enclosing(v3, 1 * deck.dbu, projection, two_opposite_sides_allowed)
        .edges()
        .with_angle(0)
    ).output(
        "V3.M4.AUX.2",
        "V3.M4.AUX.2 : V3 must exactly be the same width as M4 along the direction perpendicular to the M4 length",
    )

    ###   M4
    m4.width(nm(24), projection).with_angle(0).output(
        "M4.W.1", "M4.W.1 : Min. vertical width of M4 : 24nm"
    )
    m4.sized(0, -nm(240)).sized(0, nm(240)).output(
        "M4.W.2", "M4.W.2 : Max. vertical width of M4 : 480nm"
    )
    m4vedg = m4.width(nm(481), projection).edges().with_angle(90)
    (
        m4vedg.with_length(nm(48))
        + m4vedg.with_length(nm(96))
        + m4vedg.with_length(nm(144))
        + m4vedg.with_length(nm(192))
        + m4vedg.with_length(nm(240))
        + m4vedg.with_length(nm(288))
        + m4vedg.with_length(nm(336))
        + m4vedg.with_length(nm(384))
        + m4vedg.with_length(nm(432))
        + m4vedg.with_length(nm(480))
    ).output(
        "M4.W.3",
        "M4.W.3 : M4 vertical width may not be an even integer multiple of its minimum width",
    )
    # rule M4.W.4  not coded
    m4.width(nm(44), projection).edges().with_angle(90).output(
        "M4.W.5", "M4.W.5 : Min. horizontal width of M4 : 44nm"
    )
    m4.space(nm(24), projection).edges().with_angle(0).output(
        "M4.S.1", "M4.S.1 : Min. vertical spacing between M4 : 24nm"
    )
    m4s2 = m4.space(nm(40), projection).edges().with_angle(90)
    m4s2.output("M4.S.2", "M4.S.2 : Min. horizontal spacing between M4 : 40nm")
    m4.sized(0, nm(48)).space(nm(40), projection).edges().with_angle(90).not_(
        m4s2
    ).and_(m4).output(
        "M4.S.3",
        "M4.S.3 : Min. horizontal tip-to-tip spacing between two M4 on adjacent tracks : 40nm",
    )
    m4.sized(0, nm(48)).notch(nm(40), projection).edges().with_angle(90).not_(
        m4s2
    ).and_(m4).output(
        "M4.S.4",
        "M4.S.4 : Min. horizontal tip-to-tip spacing between two M4 on adjacent tracks : 40nm",
    )
    m4.space(nm(25), projection).edges().with_angle(0).with_length((0, nm(44))).output(
        "M4.S.5",
        "M4.S.5 : Min. parallel run length of two M4 on adjacent tracks : 44nm",
    )
    # rule M4.AUX.1 coded in ONGRID section
    # rule M4.AUX.2 not coded
    m4.corners((0, 90)).sized(nm(1)).output("M4.AUX.3", "M4.AUX.3 : M4 may not bend")
    # rule M4.AUX.4 not coded because the routing track is not defined

    ###   M5
    m5.width(nm(24), projection).with_angle(90).output(
        "M5.W.1", "M5.W.1 : Min. horizontal width of M5 : 24nm"
    )
    m5.sized(-nm(240), 0).sized(nm(240), 0).output(
        "M5.W.2", "M5.W.2 : Max. horizontal width of M5 : 480nm"
    )
    m5vedg = m5.width(nm(481), projection).edges().with_angle(0)
    (
        m5vedg.with_length(nm(48))
        + m5vedg.with_length(nm(96))
        + m5vedg.with_length(nm(144))
        + m5vedg.with_length(nm(192))
        + m5vedg.with_length(nm(240))
        + m5vedg.with_length(nm(288))
        + m5vedg.with_length(nm(336))
        + m5vedg.with_length(nm(384))
        + m5vedg.with_length(nm(432))
        + m5vedg.with_length(nm(480))
    ).output(
        "M5.W.3",
        "M5.W.3 : M5 horizontal width may not be an even integer multiple of its minimum width",
    )
    # rule M5.W.4  not coded
    m5.width(nm(44), projection).edges().with_angle(0).output(
        "M5.W.5", "M5.W.5 : Min. vertical width of M5 : 44nm"
    )
    m5.space(nm(24), projection).edges().with_angle(90).output(
        "M5.S.1", "M5.S.1 : Min. horizontal spacing between M5 : 24nm"
    )
    m5s2 = m5.space(nm(40), projection).edges().with_angle(0)
    m5s2.output("M5.S.2", "M5.S.2 : Min. vertical spacing between M5 : 40nm")
    m5.sized(0, nm(48)).space(nm(40), projection).edges().with_angle(0).not_(m5s2).and_(
        m5
    ).output(
        "M5.S.3",
        "M5.S.3 : Min. vertical tip-to-tip spacing between two M5 on adjacent tracks : 40nm",
    )
    m5.sized(0, nm(48)).notch(nm(40), projection).edges().with_angle(0).not_(m5s2).and_(
        m5
    ).output(
        "M5.S.4",
        "M5.S.4 : Min. vertical tip-to-tip spacing between two M5 on adjacent tracks : 40nm",
    )
    m5.space(nm(25), projection).edges().with_angle(90).with_length((0, nm(44))).output(
        "M5.S.5",
        "M5.S.5 : Min. parallel run length of two M5 on adjacent tracks : 44nm",
    )
    # rule M5.AUX.1 coded in ONGRID section
    # rule M5.AUX.2 not coded
    m5.corners((0, 90)).sized(nm(1)).output("M5.AUX.3", "M5.AUX.3 : M5 may not bend")
    # rule M5.AUX.4 not coded because the routing track is not defined

    ###   V4
    # rule V4.W.1 not checked for the instance along the length of M5
    v4.width(nm(24)).output("V4.W.1", "V4.W.1 : Min. width of V4 : 24nm")
    v4.space(nm(33), euclidian).output(
        "V4.S.1-2-3", "V4.S.1-2-3 : Min. spacing between V4 : 33nm"
    )
    v4.interacting(
        m4.enclosing(v4, nm(11), projection, two_connected_sides_allowed).edges()
        - m4.enclosing(v4, nm(11), projection, one_side_allowed).edges()
    ).output(
        "V4.M4.EN.1",
        "V4.M4.EN.1 : Min. enclosure of V4 by M4 on at least two opposite sides  : 11nm",
    )
    ((v4 - m4) + (v4 - m5)).output("V4.AUX.1" "V4.AUX.1 : V4 must be inside M4 and M5")
    v4.not_interacting(
        m5.enclosing(v4, 1 * deck.dbu, projection, two_opposite_sides_allowed)
        .edges()
        .with_angle(90)
    ).output(
        "V4.M5.AUX.2",
        "V4.M5.AUX.2 : V4 must exactly be the same width as M5 along the direction perpendicular to the M5 length",
    )

    ###   V5
    # rule V5.W.1 not checked for the instance along the length of M6
    v5.width(nm(24)).output("V5.W.1", "V5.W.1 : Min. width of V5 : 24nm")
    v5.space(nm(33), euclidian).output(
        "V5.S.1-2-3", "V5.S.1-2-3 : Min. spacing between V5 : 33nm"
    )
    v5.interacting(
        m5.enclosing(v5, nm(11), projection, two_connected_sides_allowed).edges()
        - m5.enclosing(v5, nm(11), projection, one_side_allowed).edges()
    ).output(
        "V5.M5.EN.1",
        "V5.M5.EN.1 : Min. enclosure of V5 by M5 on at least two opposite sides  : 11nm",
    )
    ((v5 - m5) + (v5 - m6)).output("V5.AUX.1" "V5.AUX.1 : V5 must be inside M5 and M6")
    v5.not_interacting(
        m6.enclosing(v5, 1 * deck.dbu, projection, two_opposite_sides_allowed)
        .edges()
        .with_angle(0)
    ).output(
        "V5.M6.AUX.2",
        "V5.M6.AUX.2 : V5 must exactly be the same width as M6 along the direction perpendicular to the M6 length",
    )

    ###   M6
    m6.width(nm(32), projection).with_angle(0).output(
        "M6.W.1", "M6.W.1 : Min. vertical width of M6 : 32nm"
    )
    m6.sized(0, -nm(320)).sized(0, nm(320)).output(
        "M6.W.2", "M6.W.2 : Max. vertical width of M6 : 640nm"
    )
    m6vedg = m6.width(nm(641), projection).edges().with_angle(90)
    (
        m6vedg.with_length(nm(64))
        + m6vedg.with_length(nm(128))
        + m6vedg.with_length(nm(192))
        + m6vedg.with_length(nm(256))
        + m6vedg.with_length(nm(320))
        + m6vedg.with_length(nm(384))
        + m6vedg.with_length(nm(448))
        + m6vedg.with_length(nm(512))
        + m6vedg.with_length(nm(576))
        + m6vedg.with_length(nm(640))
    ).output(
        "M6.W.3",
        "M6.W.3 : M6 vertical width may not be an even integer multiple of its minimum width",
    )
    # rule M6.W.4  not coded
    m6.width(nm(44), projection).edges().with_angle(90).output(
        "M6.W.5", "M6.W.5 : Min. horizontal width of M6 : 44nm"
    )
    m6.space(nm(32), projection).edges().with_angle(0).output(
        "M6.S.1", "M6.S.1 : Min. vertical spacing between M6 : 32nm"
    )
    m6s2 = m6.space(nm(40), projection).edges().with_angle(90)
    m6s2.output("M6.S.2", "M6.S.2 : Min. horizontal spacing between M6 : 40nm")
    m6.sized(0, nm(48)).space(nm(40), projection).edges().with_angle(90).not_(
        m6s2
    ).and_(m6).output(
        "M6.S.3",
        "M6.S.3 : Min. horizontal tip-to-tip spacing between two M6 on adjacent tracks : 40nm",
    )
    m6.sized(0, nm(48)).notch(nm(40), projection).edges().with_angle(90).not_(
        m6s2
    ).and_(m6).output(
        "M6.S.4",
        "M6.S.4 : Min. horizontal tip-to-tip spacing between two M6 on adjacent tracks : 40nm",
    )
    m6.space(nm(25), projection).edges().with_angle(0).with_length((0, nm(44))).output(
        "M6.S.5",
        "M6.S.5 : Min. parallel run length of two M6 on adjacent tracks : 44nm",
    )
    # rule M6.AUX.1 coded in ONGRID section
    # rule M6.AUX.2 not coded
    m6.corners((0, 90)).sized(nm(1)).output("M6.AUX.3", "M6.AUX.3 : M6 may not bend")
    # rule M6.AUX.4 not coded because the routing track is not defined

    ###   M7
    m7.width(nm(32), projection).with_angle(90).output(
        "M7.W.1", "M7.W.1 : Min. horizontal width of M7 : 32nm"
    )
    m7.sized(-nm(320), 0).sized(nm(320), 0).output(
        "M7.W.2", "M7.W.2 : Max. horizontal width of M7 : 640nm"
    )
    m7vedg = m7.width(nm(641), projection).edges().with_angle(0)
    (
        m7vedg.with_length(nm(64))
        + m7vedg.with_length(nm(128))
        + m7vedg.with_length(nm(192))
        + m7vedg.with_length(nm(256))
        + m7vedg.with_length(nm(320))
        + m7vedg.with_length(nm(384))
        + m7vedg.with_length(nm(448))
        + m7vedg.with_length(nm(512))
        + m7vedg.with_length(nm(576))
        + m7vedg.with_length(nm(640))
    ).output(
        "M7.W.3",
        "M7.W.3 : M7 horizontal width may not be an even integer multiple of its minimum width",
    )
    # rule M7.W.4  not coded
    m7.width(nm(44), projection).edges().with_angle(0).output(
        "M7.W.5", "M7.W.5 : Min. vertical width of M7 : 44nm"
    )
    m7.space(nm(32), projection).edges().with_angle(90).output(
        "M7.S.1", "M7.S.1 : Min. horizontal spacing between M7 : 32nm"
    )
    m7s2 = m7.space(nm(40), projection).edges().with_angle(0)
    m7s2.output("M7.S.2", "M7.S.2 : Min. vertical spacing between M7 : 40nm")
    m7.sized(0, nm(48)).space(nm(40), projection).edges().with_angle(0).not_(m7s2).and_(
        m7
    ).output(
        "M7.S.3",
        "M7.S.3 : Min. vertical tip-to-tip spacing between two M7 on adjacent tracks : 40nm",
    )
    m7.sized(0, nm(48)).notch(nm(40), projection).edges().with_angle(0).not_(m7s2).and_(
        m7
    ).output(
        "M7.S.4",
        "M7.S.4 : Min. vertical tip-to-tip spacing between two M7 on adjacent tracks : 40nm",
    )
    m7.space(nm(25), projection).edges().with_angle(90).with_length((0, nm(44))).output(
        "M7.S.5",
        "M7.S.5 : Min. parallel run length of two M7 on adjacent tracks : 44nm",
    )
    # rule M7.AUX.1 coded in ONGRID section
    # rule M7.AUX.2 not coded
    m7.corners((0, 90)).sized(nm(1)).output("M7.AUX.3", "M7.AUX.3 : M7 may not bend")
    # rule M7.AUX.4 not coded because the routing track is not defined

    ###   V6
    # rule V6.W.1 not checked for the instance along the length of M7
    v6.width(nm(32)).output("V6.W.1", "V6.W.1 : Min. width of V6 : 32nm")
    v6.space(nm(45), euclidian).output(
        "V6.S.1-2-3", "V6.S.1-2-3 : Min. spacing between V6 : 45nm"
    )
    v6.interacting(
        m6.enclosing(v6, nm(11), projection, two_connected_sides_allowed).edges()
        - m6.enclosing(v6, nm(11), projection, one_side_allowed).edges()
    ).output(
        "V6.M6.EN.1",
        "V6.M6.EN.1 : Min. enclosure of V6 by M6 on at least two opposite sides  : 11nm",
    )
    ((v6 - m6) + (v6 - m7)).output("V6.AUX.1" "V6.AUX.1 : V6 must be inside M6 and M7")
    v6.not_interacting(
        m7.enclosing(v6, 1 * deck.dbu, projection, two_opposite_sides_allowed)
        .edges()
        .with_angle(90)
    ).output(
        "V6.M7.AUX.2",
        "V6.M7.AUX.2 : V6 must exactly be the same width as M7 along the direction perpendicular to the M7 length",
    )

    ###   V7
    # rule V7.W.1 not checked for the instance along the length of M8
    v7.width(nm(32)).output("V7.W.1", "V7.W.1 : Min. width of V7 : 32nm")
    v7.space(nm(45), euclidian).output(
        "V7.S.1-2-3", "V7.S.1-2-3 : Min. spacing between V7 : 45nm"
    )
    v7.interacting(
        m7.enclosing(v7, nm(11), projection, two_connected_sides_allowed).edges()
        - m7.enclosing(v7, nm(11), projection, one_side_allowed).edges()
    ).output(
        "V7.M7.EN.1",
        "V7.M7.EN.1 : Min. enclosure of V7 by M7 on at least two opposite sides  : 11nm",
    )
    ((v7 - m7) + (v7 - m8)).output("V7.AUX.1" "V7.AUX.1 : V7 must be inside M7 and M8")
    v7.not_interacting(
        m8.enclosing(v7, 1 * deck.dbu, projection, two_opposite_sides_allowed)
        .edges()
        .with_angle(0)
    ).output(
        "V7.M8.AUX.2",
        "V7.M8.AUX.2 : V7 must exactly be the same width as M8 along the direction perpendicular to the M8 length",
    )

    ###   M8
    m8.width(nm(40)).output("M8.W.1", "M8.W.1 : Min. width of M8 : 40nm")
    m8.width(nm(60), projection).edges().with_length((0, nm(400))).output(
        "M8.W.2",
        "M8.W.2 : Min. width of M8, when its length >= 400 nm and < 1200 nm : 60nm",
    )
    m8.width(nm(80), projection).edges().with_length((nm(400), nm(1200))).output(
        "M8.W.3",
        "M8.W.3 : Min. width of M8, when its length >= 1200 nm and < 1800 nm : 80nm",
    )
    m8.width(nm(120), projection).edges().with_length((nm(1200), nm(1800))).output(
        "M8.W.4", "M8.W.3 : Min. width of M8, when its length >=1800 nm : 120nm"
    )
    m8.sized(-um(1)).sized(-um(1)).output(
        "M8.W.5", "M8.W.5 : Max. width of M8 : 2000nm"
    )
    m8.space(nm(40), projection).edges().with_length((nm(80), mm(100))).output(
        "M8.S.1",
        "M8.S.1 : Min. spacing between two M8' edges, when both edges are >= 80 nm : 40nm",
    )
    m8.space(nm(43), projection).polygons().not_interacting(
        m8.edges().with_length((nm(80), mm(100)))
    ).output(
        "M8.S.2",
        "M8.S.2 : Min. spacing between two M8' edges, when one of the edges is < 80 nm and the other is >= 80 nm : 43nm",
    )
    m8.space(nm(46), projection).edges().with_length((0, nm(80))).output(
        "M8.S.3",
        "M8.S.3 : Min. spacing between two M8' edges, when both edges are < 80 nm : 46nm",
    )
    m8.space(nm(60), projection).polygons().interacting(
        m8.edges().with_length((nm(60), nm(80)))
    ).output(
        "M8.S.4",
        "M8.S.4 : Min. spacing between two M8' edges, when one of the edges is >= 60 nm and < 80 nm : 60nm",
    )
    m8.space(nm(80), projection).polygons().interacting(
        m8.edges().with_length((nm(80), nm(120)))
    ).output(
        "M8.S.5",
        "M8.S.5 : Min. spacing between two M8' edges, when one of the edges is >= 80 nm and < 120 nm : 80nm",
    )
    m8.space(nm(120), projection).polygons().interacting(
        m8.edges().with_length((nm(120), nm(500)))
    ).output(
        "M8.S.6",
        "M8.S.6 : Min. spacing between two M8' edges, when one of the edges is >= 120 nm and < 500 nm : 120nm",
    )
    m8.space(nm(500), projection).polygons().interacting(
        m8.edges().with_length((nm(500), nm(1000)))
    ).output(
        "M8.S.7",
        "M8.S.7 : Min. spacing between two M8' edges, when one of the edges is >= 500 nm and < 1000 nm : 500nm",
    )
    m8.space(nm(1000), projection).polygons().interacting(
        m8.edges().with_length((nm(1000), mm(100)))
    ).output(
        "M8.S.8",
        "M8.S.8 : Min. spacing between two M8' edges, when one of the edges is >= 1000 nm : 1000nm",
    )
    m8.with_area((0, 0.007520)).output("M8.A.1", "M8.A.1 : Min. area of M8 : 7520nm2")
    m8.edges().without_length((nm(40), mm(100))).output(
        "M8.L.1", "M8.L.1 : Minimum feature length of M8 : 40nm"
    )

    ###   M9
    m9.width(nm(40)).output("M9.W.1", "M9.W.1 : Min. width of M9 : 40nm")
    m9.width(nm(60), projection).edges().with_length((0, nm(400))).output(
        "M9.W.2",
        "M9.W.2 : Min. width of M9, when its length >= 400 nm and < 1200 nm : 60nm",
    )
    m9.width(nm(80), projection).edges().with_length((nm(400), nm(1200))).output(
        "M9.W.3",
        "M9.W.3 : Min. width of M9, when its length >= 1200 nm and < 1800 nm : 80nm",
    )
    m9.width(nm(120), projection).edges().with_length((nm(1200), nm(1800))).output(
        "M9.W.4", "M9.W.3 : Min. width of M9, when its length >=1800 nm : 120nm"
    )
    m9.sized(-um(1)).sized(-um(1)).output(
        "M9.W.5", "M9.W.5 : Max. width of M9 : 2000nm"
    )
    m9.space(nm(40), projection).edges().with_length((nm(80), mm(100))).output(
        "M9.S.1",
        "M9.S.1 : Min. spacing between two M9' edges, when both edges are >= 80 nm : 40nm",
    )
    m9.space(nm(43), projection).polygons().not_interacting(
        m9.edges().with_length((nm(80), mm(100)))
    ).output(
        "M9.S.2",
        "M9.S.2 : Min. spacing between two M9' edges, when one of the edges is < 80 nm and the other is >= 80 nm : 43nm",
    )
    m9.space(nm(46), projection).edges().with_length((0, nm(80))).output(
        "M9.S.3",
        "M9.S.3 : Min. spacing between two M9' edges, when both edges are < 80 nm : 46nm",
    )
    m9.space(nm(60), projection).polygons().interacting(
        m9.edges().with_length((nm(60), nm(80)))
    ).output(
        "M9.S.4",
        "M9.S.4 : Min. spacing between two M9' edges, when one of the edges is >= 60 nm and < 80 nm : 60nm",
    )
    m9.space(nm(80), projection).polygons().interacting(
        m9.edges().with_length((nm(80), nm(120)))
    ).output(
        "M9.S.5",
        "M9.S.5 : Min. spacing between two M9' edges, when one of the edges is >= 80 nm and < 120 nm : 80nm",
    )
    m9.space(nm(120), projection).polygons().interacting(
        m9.edges().with_length((nm(120), nm(500)))
    ).output(
        "M9.S.6",
        "M9.S.6 : Min. spacing between two M9' edges, when one of the edges is >= 120 nm and < 500 nm : 120nm",
    )
    m9.space(nm(500), projection).polygons().interacting(
        m9.edges().with_length((nm(500), nm(1000)))
    ).output(
        "M9.S.7",
        "M9.S.7 : Min. spacing between two M9' edges, when one of the edges is >= 500 nm and < 1000 nm : 500nm",
    )
    m9.space(nm(1000), projection).polygons().interacting(
        m9.edges().with_length((nm(1000), mm(100)))
    ).output(
        "M9.S.8",
        "M9.S.8 : Min. spacing between two M9' edges, when one of the edges is >= 1000 nm : 1000nm",
    )
    m9.with_area((0, 0.007520)).output("M9.A.1", "M9.A.1 : Min. area of M9 : 7520nm2")
    m9.edges().without_length((nm(40), mm(100))).output(
        "M9.L.1", "M9.L.1 : Minimum feature length of M9 : 40nm"
    )

    ###   V8
    (
        (v8.edges().without_length(nm(40)) & v8.edges().without_length(nm(120)))
        + v8.with_area(0.0144).edges()
    ).output("V8.W.1", "V8.W.1 : Exact width of a V8 instance")
    v8.space(nm(57)).output("V8.S.1-2", "V8.S.1-2 : Min. spacing between V8 : 57.nm")
    v8.interacting(
        m8.enclosing(v8, nm(20), projection, two_connected_sides_allowed).edges()
        - m8.enclosing(v8, nm(20), projection, one_side_allowed).edges()
    ).output(
        "V8.M8.EN.1",
        "V8.M8.EN.1 : Min. enclosure of V8 by M8 on at least two opposite sides  : 20nm",
    )
    v8.interacting(
        m9.enclosing(v8, nm(20), projection, two_connected_sides_allowed).edges()
        - m9.enclosing(v8, nm(20), projection, one_side_allowed).edges()
    ).output(
        "V8.M9.EN.2",
        "V8.M9.EN.2 : Min. enclosure of V8 by M9 on at least two opposite sides  : 20nm",
    )
    ((v8 - m8) + (v8 - m9)).output("V8.AUX.1" "V8.AUX.1 : V8 must be inside M8 and M9")

    ###   V9
    (
        (v9.edges().without_length(nm(40)) & v9.edges().without_length(nm(120)))
        + v9.with_area(0.0144).edges()
    ).output("V9.W.1", "V9.W.1 : Exact width of a V9 instance")
    v9.space(nm(57)).output("V9.S.1-2", "V9.S.1-2 : Min. spacing between V9 : 57.nm")
    v9.interacting(
        m9.enclosing(v9, nm(20), projection, two_connected_sides_allowed).edges()
        - m9.enclosing(v9, nm(20), projection, one_side_allowed).edges()
    ).output(
        "V9.M9.EN.1",
        "V9.M9.EN.1 : Min. enclosure of V9 by M9 on at least two opposite sides  : 20nm",
    )
    v9.interacting(
        pad.enclosing(v9, nm(20), projection, two_connected_sides_allowed).edges()
        - pad.enclosing(v9, nm(20), projection, one_side_allowed).edges()
    ).output(
        "V9.PAD.EN.2",
        "V9.PAD.EN.2 : Min. enclosure of V9 by PAD on at least two opposite sides  : 20nm",
    )
    ((v9 - m9) + (v9 - pad)).output(
        "V9.AUX.1" "V9.AUX.1 : V9 must be inside M9 and PAD"
    )

    #   ONGRID  defined in the paper :
    #   "ASAP7 : A 7-nm finFET predictive process design kit"
    ##########################################################
    if OFFGRID:
        deck.info("GRID section")

        # special grids for M4.to M7
        m4.ongrid(nm(24), 0).output(
            "M4.AUX.1", "M4.AUX.1 : M4 horizontal edges must be at a grid of : 24nm"
        )
        m5.ongrid(0, nm(24)).output(
            "M5.AUX.1", "M5.AUX.1 : M5 vertical edges must be at a grid of : 24nm"
        )
        m6.ongrid(nm(32), 0).output(
            "M4.AUX.1", "M4.AUX.1 : M4 horizontal edges must be at a grid of : 32nm"
        )
        m7.ongrid(0, nm(32)).output(
            "M5.AUX.1", "M5.AUX.1 : M5 vertical edges must be at a grid of : 32nm"
        )

        grid = nm(1)
        all_drawing = dict(
            nwell=nwell,
            fin=fin,
            gate=gate,
            gcut=gcut,
            active=active,
            sdt=sdt,
            nselect=nselect,
            pselect=pselect,
            slvt=slvt,
            lvt=lvt,
            sramdrc=sramdrc,
            sramvt=sramvt,
            dummy=dummy,
            lig=lig,
            lisd=lisd,
            v0=v0,
            m1=m1,
            v1=v1,
            m2=m2,
            v2=v2,
            m3=m3,
            v3=v3,
            m4=m4,
            v4=v4,
            m5=m5,
            v5=v5,
            m6=m6,
            v6=v6,
            m7=m7,
            v7=v7,
            m8=m8,
            v8=v8,
            m9=m9,
            v9=v9,
        )
        for dwg, layer in all_drawing.items():
            layer.ongrid(grid).polygons(nm(2)).output(
                "GRID: vertexes on layer %s not on grid of %.12g" % (dwg, grid)
            )
            nonortho_edges = (
                layer.edges()
                - layer.edges().with_angle(0)
                - layer.edges().with_angle(90)
            )
            nonortho_edges.output(
                "%s.GEOMETRY.NONORTHOGONAL" % dwg,
                "GEOMETRY.NONORTHOGONAL on layer %s" % dwg,
            )
