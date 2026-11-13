################################################################################
# Rules updated from https://github.com/klayoutmatthias/FreePDK45_for_KLayout
# Reused under GNU GPLv3: https://www.gnu.org/licenses/
#
# This DRC file for FreePDK45 was developed from the FreePDK45 DRC docs:
#   https://www.eda.ncsu.edu/wiki/FreePDK45:RuleDevel
#   https://www.eda.ncsu.edu/wiki/FreePDK45:Contents
"""FreePDK45 DRC deck, run by flow/util/klayout_drc.py on the klayout module.

Translated line by line from KLayout's DRC language.
"""

from klayout_drc import angle_limit, euclidian, nm, projection, um

DESCRIPTION = "FreePDK45 DRC runset"
MODE = "deep"
THREADS = 4

FEOL = True  # Front-end-of-line checks
BEOL = True  # Back-end-of-line checks
OFFGRID = True  # Manufacturing grid checks
ANTENNA = True  # Antenna checks


# splits a layer classes with increasing min dimensions
def classify_by_width(deck, layer, *dimensions):
    result = []
    for d in dimensions:
        layer = layer.sized(-0.5 * (d - deck.dbu)).sized(0.5 * (d - deck.dbu))
        result.append(layer)
    return result


def drc(deck):
    ####################
    # Layer definitions
    ####################
    active = deck.polygons(1, 0)
    pwell = deck.polygons(2, 0)
    nwell = deck.polygons(3, 0)
    nplus = deck.polygons(4, 0)
    pplus = deck.polygons(5, 0)
    vtg = deck.polygons(6, 0)
    vth = deck.polygons(7, 0)
    thkox = deck.polygons(8, 0)
    poly = deck.polygons(9, 0)
    cont = deck.polygons(10, 0)
    metal1 = deck.polygons(11, 0)
    via1 = deck.polygons(12, 0)
    metal2 = deck.polygons(13, 0)
    via2 = deck.polygons(14, 0)
    metal3 = deck.polygons(15, 0)
    via3 = deck.polygons(16, 0)
    metal4 = deck.polygons(17, 0)
    via4 = deck.polygons(18, 0)
    metal5 = deck.polygons(19, 0)
    via5 = deck.polygons(20, 0)
    metal6 = deck.polygons(21, 0)
    via6 = deck.polygons(22, 0)
    metal7 = deck.polygons(23, 0)
    via7 = deck.polygons(24, 0)
    metal8 = deck.polygons(25, 0)
    via8 = deck.polygons(26, 0)
    metal9 = deck.polygons(27, 0)
    via9 = deck.polygons(28, 0)
    metal10 = deck.polygons(29, 0)

    ####################
    # Helper functions
    ####################

    # splits a layer classes with increasing min dimensions

    ####################
    # Rules
    ####################
    # TODO(rovinski) Via enclosure rules (METALx.3, METALx.4) do not appear to correctly identify violations

    # FEOL checks
    if FEOL:
        deck.info("FEOL checks")

        # Well
        well = nwell.or_(pwell)
        nwell.and_(pwell).output("WELL.1", "WELL.1 : nwell/pwell must not overlap")
        # the rule "WELL.2 : Minimum spacing of well at different potential : 225nm" was not coded : see : https://www.klayout.de/forum/discussion/comment/6021
        nwell.space(nm(135), euclidian).output(
            "WELL.3", "WELL.3 : Minimum spacing of nwell at same potential : 135nm"
        )
        pwell.space(nm(135), euclidian).output(
            "WELL.3", "WELL.3 : Minimum spacing of pwell at same potential : 135nm"
        )
        well.separation(well, nm(200), euclidian).output(
            "WELL.4", "WELL.4 : Minimum width of nwell/pwell : 200nm"
        )
        vtg.not_(well).output(
            "VT.1", "VT.1 : Vtg adjust layers must coincide with well"
        )
        vth.not_(well).output(
            "VT.1", "VT.1 : Vth adjust layers must coincide with well"
        )

        # Poly
        gate = poly & active
        poly.width(nm(50), euclidian).output(
            "POLY.1", "POLY.1 : Minimum width of poly : 50nm"
        )

        # TODO(rovinski) This section errors out for some reason
        ##if poly.separation(active, 140.nm, projection).polygons?
        #  poly.separation(active, 140.nm, projection).polygons.without_area(0).output("POLY.2", "POLY.2 : Minimum spacing of poly AND active: 140nm")
        ##end
        # poly.enclosing(gate, 55.nm, projection).polygons.without_area(0).output("POLY.3", "POLY.3 : Minimum poly extension beyond active : 55nm")

        active.enclosing(gate, nm(70), projection).polygons().without_area(0).output(
            "POLY.4", "POLY.4 : Minimum enclosure of active around gate : 70nm"
        )
        poly.not_(active).separation(
            active, nm(50), projection
        ).polygons().without_area(0).output(
            "POLY.5", "POLY.5 : Minimum spacing of field poly to active: 50nm"
        )
        poly.space(nm(75), euclidian).output(
            "POLY.6", "POLY.6 : Minimum spacing of field poly: 75nm"
        )

        # Active
        active.width(nm(90), euclidian).output(
            "ACTIVE.1", "ACTIVE.1 : Minimum width of active : 90nm"
        )
        active.space(nm(80), euclidian).output(
            "ACTIVE.2", "ACTIVE.2 : Minimum spacing of active : 80nm"
        )
        well.enclosing(active, nm(55), euclidian).output(
            "ACTIVE.3",
            "ACTIVE.3 : Minimum enclosure/spacing of nwell/pwell to active: 55nm",
        )
        active.not_(well).output(
            "ACTIVE.4", "ACTIVE.4 : active must be inside nwell or pwell"
        )

        # Implant
        implant = nplus.or_(pplus)
        implant.separation(gate, nm(70), projection).polygons().without_area(0).output(
            "IMPLANT.1",
            "IMPLANT.1 : Minimum spacing of nimplant/ pimplant to channel : 70nm",
        )
        implant.separation(cont, nm(25), projection).polygons().without_area(0).output(
            "IMPLANT.2",
            "IMPLANT.1 : Minimum spacing of nimplant/ pimplant to contact : 25nm",
        )
        implant.width(nm(45), euclidian).output(
            "IMPLANT.3", "IMPLANT.3 : Minimum width of nimplant/ pimplant  : 45nm"
        )
        implant.space(nm(45), euclidian).output(
            "IMPLANT.4", "IMPLANT.4 : Minimum spacing of nimplant/ pimplant  : 45nm"
        )
        nplus.and_(pplus).output(
            "IMPLANT.5", "IMPLANT.5 : Nimplant and pimplant must not overlap"
        )

        # Contact
        cont.width(nm(65)).output(
            "CONTACT.1", "CONTACT.1 : Minimum/Maximum width of contact : 65nm"
        )
        cont.space(nm(75), euclidian).output(
            "CONTACT.2", "CONTACT.2 : Minimum spacing of contact : 75nm"
        )
        cont.not_(active.or_(poly.or_(metal1))).output(
            "CONTACT.3", "CONTACT.3 : contact must be inside active or poly or metal1"
        )
        active.enclosing(cont, nm(5), euclidian).output(
            "CONTACT.4", "CONTACT.4 : Minimum enclosure of active around contact : 5nm"
        )
        poly.enclosing(cont, nm(5), euclidian).output(
            "CONTACT.5", "CONTACT.5 : Minimum enclosure of poly around contact : 5nm"
        )
        cont.separation(poly, nm(35), euclidian).output(
            "CONTACT.6", "CONTACT.6 : Minimum spacing of contact and poly : 35nm"
        )

    # BEOL checks
    if BEOL:
        deck.info("BEOL checks")

        # Metal1
        metal1.width(nm(65), euclidian).output(
            "METAL1.1", "METAL1.1 : Minimum width of metal1 : 65nm"
        )
        metal1.space(nm(65), euclidian).output(
            "METAL1.2", "METAL1.2 : Minimum spacing of metal1 : 65nm"
        )
        cont_edges_with_less_enclosure = metal1.enclosing(
            cont, nm(35), projection
        ).second_edges()
        error_corners = cont_edges_with_less_enclosure.width(
            angle_limit(100.0), 1 * deck.dbu
        )
        cont.interacting(error_corners.polygons(1 * deck.dbu)).output(
            "METAL1.3",
            "METAL1.3 : Minimum enclosure around contact on two opposite sides : 35nm",
        )
        via1_edges_with_less_enclosure = metal1.enclosing(
            via1, nm(35), projection
        ).second_edges()
        error_corners = via1_edges_with_less_enclosure.width(
            angle_limit(100.0), 1 * deck.dbu
        )
        via1.interacting(error_corners.polygons(1 * deck.dbu)).output(
            "METAL1.4",
            "METAL1.4 : Minimum enclosure around via1 on two opposite sides : 35nm",
        )
        metal1_gt90, metal1_gt270, metal1_gt500, metal1_gt900, metal1_gt1500 = (
            classify_by_width(deck, metal1, nm(90), nm(270), nm(500), nm(900), nm(1500))
        )
        metal1_gt90.edges().with_length(nm(300), None).space(nm(90), euclidian).output(
            "METAL1.5",
            "METAL1.5 : Minimum spacing of metal1 wider than 90 nm and longer than 300 nm : 90nm",
        )
        metal1_gt270.edges().with_length(nm(900), None).space(
            nm(270), euclidian
        ).output(
            "METAL1.6",
            "METAL1.6 : Minimum spacing of metal1 wider than 270 nm and longer than 900 nm : 270nm",
        )
        metal1_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL1.7",
            "METAL1.7 : Minimum spacing of metal1 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal1_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL1.8",
            "METAL1.8 : Minimum spacing of metal1 wider than 900 nm and longer than 2.7 um : 900nm",
        )
        metal1_gt1500.edges().with_length(um(4), None).space(
            nm(1500), euclidian
        ).output(
            "METAL1.9",
            "METAL1.9 : Minimum spacing of metal1 wider than 1500 nm and longer than 4.0 um : 1500nm",
        )

        # via1
        via1.width(nm(65), euclidian).output(
            "VIA1.1", "VIA1.1 : Minimum/Maximum width of via1 : 65nm"
        )
        via1.space(nm(75), euclidian).output(
            "VIA1.2", "VIA1.2 : Minimum spacing of via1 : 75nm"
        )
        via1.not_(metal1).output("VIA1.3", "VIA1.3 : via1 must be inside metal1")
        via1.not_(metal2).output("VIA1.4", "VIA1.4 : via1 must be inside metal2")

        # metal2
        metal2.width(nm(70), euclidian).output(
            "METAL2.1", "METAL2.1 : Minimum width of  intermediate metal2 : 70nm"
        )
        metal2.space(nm(70), euclidian).output(
            "METAL2.2", "METAL2.2 : Minimum spacing of  intermediate metal2 : 70nm"
        )
        via1_edges_with_less_enclosure = metal2.enclosing(
            via1, nm(35), projection
        ).second_edges()
        error_corners = via1_edges_with_less_enclosure.width(
            angle_limit(100.0), 1 * deck.dbu
        )
        via1.interacting(error_corners.polygons(1 * deck.dbu)).output(
            "METAL2.3",
            "METAL2.3 : Minimum enclosure around via1 on two opposite sides : 35nm",
        )
        via2_edges_with_less_enclosure = metal2.enclosing(
            via2, nm(35), projection
        ).second_edges()
        error_corners = via2_edges_with_less_enclosure.width(
            angle_limit(100.0), 1 * deck.dbu
        )
        via2.interacting(error_corners.polygons(1 * deck.dbu)).output(
            "METAL2.4",
            "METAL2.4 : Minimum enclosure around via2 on two opposite sides : 35nm",
        )
        metal2_gt90, metal2_gt270, metal2_gt500, metal2_gt900, metal2_gt1500 = (
            classify_by_width(deck, metal2, nm(90), nm(270), nm(500), nm(900), nm(1500))
        )
        metal2_gt90.edges().with_length(nm(300), None).space(nm(90), euclidian).output(
            "METAL2.5",
            "METAL2.5 : Minimum spacing of  intermediate metal2 wider than 90 nm and longer than 300 nm : 90nm",
        )
        metal2_gt270.edges().with_length(nm(900), None).space(
            nm(270), euclidian
        ).output(
            "METAL2.6",
            "METAL2.6 : Minimum spacing of  intermediate metal2 wider than 270 nm and longer than 900 nm : 270nm",
        )
        metal2_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL2.7",
            "METAL2.7 : Minimum spacing of  intermediate metal2 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal2_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL2.8",
            "METAL2.8 : Minimum spacing of  intermediate metal2 wider than 900 nm and longer than 2.7 um : 900nm",
        )
        metal2_gt1500.edges().with_length(um(4), None).space(
            nm(1500), euclidian
        ).output(
            "METAL2.9",
            "METAL2.9 : Minimum spacing of  intermediate metal2 wider than 1500 nm and longer than 4.0 um : 1500nm",
        )

        # via2
        via2.width(nm(70), euclidian).output(
            "VIA2.1", "VIA2.1 : Minimum/Maximum width of via2 : 70nm"
        )
        via2.space(nm(85), euclidian).output(
            "VIA2.2", "VIA2.2 : Minimum spacing of via2 : 85nm"
        )
        via2.not_(metal2).output("VIA2.3", "VIA2.3 : via2 must be inside metal2")
        via2.not_(metal3).output("VIA2.4", "VIA2.4 : via2 must be inside metal3")

        # metal3
        metal3.width(nm(70), euclidian).output(
            "METAL3.1", "METAL3.1 : Minimum width of  intermediate metal3 : 70nm"
        )
        metal3.space(nm(70), euclidian).output(
            "METAL3.2", "METAL3.2 : Minimum spacing of  intermediate metal3 : 70nm"
        )
        via2_edges_with_less_enclosure = metal3.enclosing(
            via2, nm(35), projection
        ).second_edges()
        error_corners = via2_edges_with_less_enclosure.width(
            angle_limit(100.0), 1 * deck.dbu
        )
        via2.interacting(error_corners.polygons(1 * deck.dbu)).output(
            "METAL3.3",
            "METAL3.3 : Minimum enclosure around via2 on two opposite sides : 35nm",
        )
        via3_edges_with_less_enclosure = metal3.enclosing(
            via3, nm(35), projection
        ).second_edges()
        error_corners = via3_edges_with_less_enclosure.width(
            angle_limit(100.0), 1 * deck.dbu
        )
        via3.interacting(error_corners.polygons(1 * deck.dbu)).output(
            "METAL3.4",
            "METAL3.4 : Minimum enclosure around via3 on two opposite sides : 35nm",
        )
        metal3_gt90, metal3_gt270, metal3_gt500, metal3_gt900, metal3_gt1500 = (
            classify_by_width(deck, metal3, nm(90), nm(270), nm(500), nm(900), nm(1500))
        )
        metal3_gt90.edges().with_length(nm(300), None).space(nm(90), euclidian).output(
            "METAL3.5",
            "METAL3.5 : Minimum spacing of  intermediate metal3 wider than 90 nm and longer than 300 nm : 90nm",
        )
        metal3_gt270.edges().with_length(nm(900), None).space(
            nm(270), euclidian
        ).output(
            "METAL3.6",
            "METAL3.6 : Minimum spacing of  intermediate metal3 wider than 270 nm and longer than 900 nm : 270nm",
        )
        metal3_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL3.7",
            "METAL3.7 : Minimum spacing of  intermediate metal3 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal3_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL3.8",
            "METAL3.8 : Minimum spacing of  intermediate metal3 wider than 900 nm and longer than 2.7 um : 900nm",
        )
        metal3_gt1500.edges().with_length(um(4), None).space(
            nm(1500), euclidian
        ).output(
            "METAL3.9",
            "METAL3.9 : Minimum spacing of  intermediate metal3 wider than 1500 nm and longer than 4.0 um : 1500nm",
        )

        # via3
        via3.width(nm(70), euclidian).output(
            "VIA3.1", "VIA3.1 : Minimum/Maximum width of via3 : 70nm"
        )
        via3.space(nm(85), euclidian).output(
            "VIA3.2", "VIA3.2 : Minimum spacing of via3 : 85nm"
        )
        via3.not_(metal3).output("VIA3.3", "VIA3.3 : via3 must be inside metal3")
        via3.not_(metal4).output("VIA3.4", "VIA3.4 : via3 must be inside metal4")

        # metal4
        metal4.width(nm(140), euclidian).output(
            "METAL4.1", "METAL4.1 : Minimum width of  semi-global metal4 : 140nm"
        )
        metal4.space(nm(140), euclidian).output(
            "METAL4.2", "METAL4.2 : Minimum spacing of  semi-global metal4 : 140nm"
        )
        metal4_gt270, metal4_gt500, metal4_gt900 = classify_by_width(
            deck, metal4, nm(270), nm(500), nm(900)
        )
        metal4_gt270.edges().with_length(nm(900), None).space(
            nm(270), euclidian
        ).output(
            "METAL4.6",
            "METAL4.6 : Minimum spacing of semi-global metal4 wider than 270 nm and longer than 900 nm : 270nm",
        )
        metal4_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL4.7",
            "METAL4.7 : Minimum spacing of semi-global metal4 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal4_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL4.8",
            "METAL4.8 : Minimum spacing of semi-global meta4l wider than 900 nm and longer than 2.7 um : 900nm",
        )

        # via4
        via4.width(nm(140), euclidian).output(
            "VIA4.1", "VIA4.1 : Minimum width of via4 : 140nm"
        )
        via4.space(nm(160), euclidian).output(
            "VIA4.2", "VIA4.2 : Minimum spacing of via4 : 160nm"
        )
        via4.not_(metal4).output("VIA4.3", "VIA4.3 : via4 must be inside metal4")
        via4.not_(metal5).output("VIA4.4", "VIA4.4 : via4 must be inside metal5")

        # metal5
        metal5.width(nm(140), euclidian).output(
            "METAL5.1", "METAL5.1 : Minimum width of semi-global metal5 : 140nm"
        )
        metal5.space(nm(140), euclidian).output(
            "METAL5.2", "METAL5.2 : Minimum spacing of semi-global metal5 : 140nm"
        )
        metal5_gt270, metal5_gt500, metal5_gt900 = classify_by_width(
            deck, metal5, nm(270), nm(500), nm(900)
        )
        metal5_gt270.edges().with_length(nm(900), None).space(
            nm(270), euclidian
        ).output(
            "METAL5.6",
            "METAL5.6 : Minimum spacing of semi-global metal5 wider than 270 nm and longer than 900 nm : 270nm",
        )
        metal5_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL5.7",
            "METAL5.7 : Minimum spacing of semi-global metal5 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal5_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL5.8",
            "METAL5.8 : Minimum spacing of semi-global meta5l wider than 900 nm and longer than 2.7 um : 900nm",
        )

        # via5
        via5.width(nm(140), euclidian).output(
            "VIA5.1", "VIA5.1 : Minimum/Maximum width of via5 : 140nm"
        )
        via5.space(nm(160), euclidian).output(
            "VIA5.2", "VIA5.2 : Minimum spacing of via5 : 160nm"
        )
        via5.not_(metal5).output("VIA5.3", "VIA5.3 : via5 must be inside metal5")
        via5.not_(metal6).output("VIA5.4", "VIA5.4 : via5 must be inside metal6")

        # metal6
        metal6.width(nm(140), euclidian).output(
            "METAL6.1", "METAL6.1 : Minimum width of semi-global metal6 : 140nm"
        )
        metal6.space(nm(140), euclidian).output(
            "METAL6.2", "METAL6.2 : Minimum spacing of semi-global metal6 : 140nm"
        )
        metal6_gt270, metal6_gt500, metal6_gt900 = classify_by_width(
            deck, metal6, nm(270), nm(500), nm(900)
        )
        metal6_gt270.edges().with_length(nm(900), None).space(
            nm(270), euclidian
        ).output(
            "METAL6.6",
            "METAL6.6 : Minimum spacing of semi-global metal6 wider than 270 nm and longer than 900 nm : 270nm",
        )
        metal6_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL6.7",
            "METAL6.7 : Minimum spacing of semi-global metal6 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal6_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL6.8",
            "METAL6.8 : Minimum spacing of semi-global metal6 wider than 900 nm and longer than 2.7 um : 900nm",
        )

        # via6
        via6.width(nm(140), euclidian).output(
            "VIA6.1", "VIA6.1 : Minimum/Maximum width of via6 : 140nm"
        )
        via6.space(nm(160), euclidian).output(
            "VIA6.2", "VIA6.2 : Minimum spacing of via6 : 160nm"
        )
        via6.not_(metal6).output("VIA6.3", "VIA6.3 : via6 must be inside metal6")
        via6.not_(metal7).output("VIA6.4", "VIA6.4 : via6 must be inside metal7")

        # metal7
        metal7.width(nm(400), euclidian).output(
            "METAL7.1", "METAL7.1 : Minimum width of thin global metal7 : 400nm"
        )
        metal7.space(nm(400), euclidian).output(
            "METAL7.2", "METAL7.2 : Minimum spacing of thin global metal7 : 400nm"
        )
        metal7_gt500, metal7_gt900, metal7_gt1500 = classify_by_width(
            deck, metal7, nm(500), nm(900), nm(1500)
        )
        metal7_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL7.7",
            "METAL7.7 : Minimum spacing of thin global metal7 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal7_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL7.8",
            "METAL7.8 : Minimum spacing of thin global metal7 wider than 900 nm and longer than 2.7 um : 900nm",
        )
        metal7_gt1500.edges().with_length(um(4), None).space(
            nm(1500), euclidian
        ).output(
            "METAL7.9",
            "METAL7.9 : Minimum spacing of thin global meta7l wider than 1500 nm and longer than 4.0 um : 1500nm",
        )

        # via7
        via7.width(nm(400), euclidian).output(
            "VIA6.1", "VIA6.1 : Minimum/Maximum width of via7 : 400nm"
        )
        via7.space(nm(440), euclidian).output(
            "VIA6.2", "VIA6.2 : Minimum spacing of via7 : 440nm"
        )
        via7.not_(metal7).output("VIA7.3", "VIA7.3 : via7 must be inside metal7")
        via7.not_(metal8).output("VIA7.4", "VIA7.4 : via7 must be inside metal8")

        # metal8
        metal8.width(nm(400), euclidian).output(
            "METAL8.1", "METAL8.1 : Minimum width of thin global metal8 : 400nm"
        )
        metal8.space(nm(400), euclidian).output(
            "METAL8.2", "METAL8.2 : Minimum spacing of thin global metal8 : 400nm"
        )
        metal8_gt500, metal8_gt900, metal8_gt1500 = classify_by_width(
            deck, metal8, nm(500), nm(900), nm(1500)
        )
        metal8_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL8.7",
            "METAL8.7 : Minimum spacing of thin global metal8 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal8_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL8.8",
            "METAL8.8 : Minimum spacing of thin global metal8 wider than 900 nm and longer than 2.7 um : 900nm",
        )
        metal8_gt1500.edges().with_length(um(4), None).space(
            nm(1500), euclidian
        ).output(
            "METAL8.9",
            "METAL8.9 : Minimum spacing of thin global metal8 wider than 1500 nm and longer than 4.0 um : 1500nm",
        )

        # via8
        via8.width(nm(400), euclidian).output(
            "VIA8.1", "VIA8.1 : Minimum/Maximum width of via8 : 400nm"
        )
        via8.space(nm(440), euclidian).output(
            "VIA8.2", "VIA8.2 : Minimum spacing of via8 : 440nm"
        )
        via8.not_(metal8).output("VIA8.3", "VIA8.3 : via8 must be inside metal8")
        via8.not_(metal9).output("VIA8.4", "VIA8.4 : via8 must be inside metal9")

        # metal9
        metal9.width(nm(800), euclidian).output(
            "METAL9.1", "METAL9.1 : Minimum width of global metal9 : 800nm"
        )
        metal9.space(nm(800), euclidian).output(
            "METAL9.2", "METAL9.2 : Minimum spacing of global metal9 : 800nm"
        )
        metal9_gt500, metal9_gt900, metal9_gt1500 = classify_by_width(
            deck, metal9, nm(500), nm(900), nm(1500)
        )
        metal9_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL9.7",
            "METAL9.7 : Minimum spacing of global metal9 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal9_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL9.8",
            "METAL9.8 : Minimum spacing of global metal9 wider than 900 nm and longer than 2.7 um : 900nm",
        )
        metal9_gt1500.edges().with_length(um(4), None).space(
            nm(1500), euclidian
        ).output(
            "METAL9.9",
            "METAL9.9 : Minimum spacing of global metal9 wider than 1500 nm and longer than 4.0 um : 1500nm",
        )

        # via9
        via9.width(nm(800), euclidian).output(
            "VIA9.1", "VIA9.1 : Minimum/Maximum width of via9 : 800nm"
        )
        via9.space(nm(880), euclidian).output(
            "VIA9.2", "VIA9.2 : Minimum spacing of via9 : 880nm"
        )
        via9.not_(metal9).output("VIA9.3", "VIA9.3 : via9 must be inside metal9")
        via9.not_(metal10).output("VIA9.4", "VIA9.4 : via9 must be inside metal10")

        # metal10
        metal10.width(nm(800), euclidian).output(
            "METAL10.1", "METAL10.1 : Minimum width of global metal10 : 800nm"
        )
        metal10.space(nm(800), euclidian).output(
            "METAL10.2", "METAL10.2 : Minimum spacing of global metal10 : 800nm"
        )
        metal10_gt500, metal10_gt900, metal10_gt1500 = classify_by_width(
            deck, metal10, nm(500), nm(900), nm(1500)
        )
        metal10_gt500.edges().with_length(um(1.8), None).space(
            nm(500), euclidian
        ).output(
            "METAL10.7",
            "METAL10.7 : Minimum spacing of global metal10 wider than 500 nm and longer than 1.8 um : 500nm",
        )
        metal10_gt900.edges().with_length(um(2.7), None).space(
            nm(900), euclidian
        ).output(
            "METAL10.8",
            "METAL10.8 : Minimum spacing of global metal10 wider than 900 nm and longer than 2.7 um : 900nm",
        )
        metal10_gt1500.edges().with_length(um(4), None).space(
            nm(1500), euclidian
        ).output(
            "METAL10.9",
            "METAL10.9 : Minimum spacing of global metal10 wider than 1500 nm and longer than 4.0 um : 1500nm",
        )

    # Manufacturing grid check
    # https://www.eda.ncsu.edu/wiki/FreePDK45:Manufacturing_Grid

    if OFFGRID:
        deck.info("Off-grid checks")

        # grid = nm(2.5)

        # A Ruby idiom to get the value of a variable whose name is in "dwg" (as symbol)
        # TODO(rovinski) local_variable_get is not compatible with older Ruby versions
        # all_drawing.each do |dwg|
        #  layer = binding.local_variable_get(dwg)
        #  r_grid = layer.ongrid(grid).polygons(10.nm)
        #  r_grid.output("GRID: vertexes on layer #{dwg} not on grid of #{'%.12g' % grid}")
        # end

    # Antenna checks

    if ANTENNA:
        deck.info("ANTENNA checks")

        # Create layer connections
        deck.connect(gate, poly)
        deck.connect(poly, cont)
        deck.connect(cont, metal1)
        deck.connect(metal1, via1)
        deck.connect(via1, metal2)
        deck.connect(metal2, via2)
        deck.connect(via2, metal3)
        deck.connect(metal3, via3)
        deck.connect(via3, metal4)
        deck.connect(metal4, via4)
        deck.connect(via4, metal5)
        deck.connect(metal5, via5)
        deck.connect(via5, metal6)
        deck.connect(metal6, via6)
        deck.connect(via6, metal7)
        deck.connect(metal7, via7)
        deck.connect(via7, metal8)
        deck.connect(metal8, via8)
        deck.connect(via8, metal9)
        deck.connect(metal9, via9)
        deck.connect(via9, metal10)

        # Create and connect diodes
        diode = nplus & active - nwell
        deck.connect(diode, cont)

        deck.antenna_check(gate, metal1, 300.0, diode).output(
            "METAL1_ANTENNA",
            "METAL1_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )
        deck.antenna_check(gate, metal2, 300.0, diode).output(
            "METAL2_ANTENNA",
            "METAL2_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )
        deck.antenna_check(gate, metal3, 300.0, diode).output(
            "METAL3_ANTENNA",
            "METAL3_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )
        deck.antenna_check(gate, metal4, 300.0, diode).output(
            "METAL4_ANTENNA",
            "METAL4_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )
        deck.antenna_check(gate, metal5, 300.0, diode).output(
            "METAL5_ANTENNA",
            "METAL5_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )
        deck.antenna_check(gate, metal6, 300.0, diode).output(
            "METAL6_ANTENNA",
            "METAL6_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )
        deck.antenna_check(gate, metal7, 300.0, diode).output(
            "METAL7_ANTENNA",
            "METAL7_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )
        deck.antenna_check(gate, metal8, 300.0, diode).output(
            "METAL8_ANTENNA",
            "METAL8_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )
        deck.antenna_check(gate, metal9, 300.0, diode).output(
            "METAL9_ANTENNA",
            "METAL9_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )
        deck.antenna_check(gate, metal10, 300.0, diode).output(
            "METAL10_ANTENNA",
            "METAL10_ANTENNA : Ratio of Maximum Allowed (Field poly area or Metal Layer Area) to transistor gate area : 300:1",
        )

        # Remove connections
        deck.clear_connections()
