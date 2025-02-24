#!/usr/bin/env python3

# This scripts attempts to generate massive design of experiment runscripts.
# and save it into a "runMassive.sh" and "doe.log".
# -------------------------------------------------------------------------------

import os
import sys
import os.path
import re
import itertools
import glob


PUBLIC = ["nangate45", "sky130hd", "sky130hs", "asap7"]

# The number of generated config files into
# designs/{platform}/{design}/chunks/chuck{number} directory.
NumFilesPerChunk = 50000

# Orignal SDC file name
OriginalSDC = "constraint.sdc"

##################################
#  define input parameters
##################################

# for generated .sh file name
ShellName = "runMassive"
# for metrics collect script (with '.sh') file name
MetricsShellName = "%s_metrics_collect.sh" % (ShellName)


##################
# Design
##################

# Define platform-design. User should remove ',' for the last item in the
# list. (string)
PLATFORM_DESIGN = ["sky130hd-gcd"]


# Target Clock Period (float)
CLK_PERIOD = []

# SDC uncertainty and IO delay.
# TODO: Currently, it only support when 'set uncertainty' and 'set io_delay'
# are defined in the constraint.sdc file.
UNCERTAINTY = []
IO_DELAY = []


##################
# Synthesis
##################

# Clock period for Yosys (for synthesis)
# The unit should follow each design (ns, ps) (float)
ABC_CLOCK_PERIOD = []
# Hierarchical Synthsis. 0 = hierarchical, 1 = flatten, empty = flatten
# (default) (int)
FLATTEN = []


##################
# Floorplan
##################


# Utilization. e.g, 45 -> 45% of core util. (int)
# CORE_UTIL = [20, 40, 55]
CORE_UTIL = []

# Aspect ratio. It REQUIRES 'CORE_UTIL' values (float)
ASPECT_RATIO = []
# Core-to-die gap distance (um). It REQUIRES 'CORE_UTIL' values (int)
CORE_DIE_MARGIN = []

# Pin Distance
# PINS_DISTANCE = [2]
PINS_DISTANCE = []

##################
# Placement
##################

# Global Placement Padding for std cells (int)
GP_PAD = []
# Detailed Placement Padding for std cells (int)
DP_PAD = []

# Global Placement target bin density (select only one option) (.2 float)
# option 1) PLACE_DENSITY uses the values in the list as it is.
# option 2) PLACE_DENSITY_LB_ADDON adds the values in the list to the lower boundary of the PLACE_DENSITY
# For eaxmple, PLACE_DENSITY_LB_ADDON = [0, 0.02, 0.04] means PLACE_DENSITY = [LB, LB+0.02, LB+0.04]
# LB of the place density == (total instance area + padding) / total die area
PLACE_DENSITY = []
PLACE_DENSITY_LB_ADDON = []


##################
# CTS
##################

# CTS clustering size and diameter (um) (int)
CTS_CLUSTER_SIZE = []
CTS_CLUSTER_DIAMETER = []

##################
# Global Routing
##################

# Set global routing layer capacity adjustment
# e.g.) 0.2 -> 20% usage for global routing

# Set for all layers.
# Each layer's layer adjustment will be overwritten with below per-layer
# values. (float)
LAYER_ADJUST = []

LAYER_ADJUST_M1 = []
LAYER_ADJUST_M2 = []
LAYER_ADJUST_M3 = []
LAYER_ADJUST_M4 = []
LAYER_ADJUST_M5 = []
LAYER_ADJUST_M6 = []
LAYER_ADJUST_M7 = []
LAYER_ADJUST_M8 = []
LAYER_ADJUST_M9 = []

# Set global routing random seed. (int)
GR_SEED = []

# Set allow global routing overflow. 0 = no, 1 = yes, empty = no (default) (int)
# TODO: currently it does not work. Let this as 0 as it is.
GR_OVERFLOW = [0]

##################
# Detailed Routing
##################

# Set global routing random seed. (int)
DR_SEED = []

SweepingAttributes = {
    "PLATFORM_DESIGN": PLATFORM_DESIGN,
    "CP": CLK_PERIOD,
    "ABC_CP": ABC_CLOCK_PERIOD,
    "FLATTEN": FLATTEN,
    "UNCERTAINTY": UNCERTAINTY,
    "IO_DELAY": IO_DELAY,
    "UTIL": CORE_UTIL,
    "AR": ASPECT_RATIO,
    "GAP": CORE_DIE_MARGIN,
    "PINS_DISTANCE": PINS_DISTANCE,
    "GP_PAD": GP_PAD,
    "DP_PAD": DP_PAD,
    "PD": PLACE_DENSITY,
    "PD_LB_ADD": PLACE_DENSITY_LB_ADDON,
    "CTS_CLUSTER_SIZE": CTS_CLUSTER_SIZE,
    "CTS_CLUSTER_DIAMETER": CTS_CLUSTER_DIAMETER,
    "LAYER_ADJUST": LAYER_ADJUST,
    "M1": LAYER_ADJUST_M1,
    "M2": LAYER_ADJUST_M2,
    "M3": LAYER_ADJUST_M3,
    "M4": LAYER_ADJUST_M4,
    "M5": LAYER_ADJUST_M5,
    "M6": LAYER_ADJUST_M6,
    "M7": LAYER_ADJUST_M7,
    "M8": LAYER_ADJUST_M8,
    "M9": LAYER_ADJUST_M9,
    "GR_SEED": GR_SEED,
    "GR_OVERFLOW": GR_OVERFLOW,
    "DR_SEED": DR_SEED,
}


def assignEmptyAttrs(dicts):
    knobs = {}
    for k, v in dicts.items():
        if len(v) == 0:
            knobs.setdefault(k, ["empty"])
        else:
            knobs.setdefault(k, v)
    return knobs


def writeDoeLog(dicts, ProductDicts):
    fo = open("./doe.log", "w")
    numRuns = 1
    for k, v in dicts.items():
        if len(v) > 0:
            print("%s has %s number of values" % (k, len(v)))
            fo.write("%s has %s number of values\n" % (k, len(v)))
            numRuns = numRuns * len(v)
    fo.write("\nTotal Number of Runs = %s\n\n" % numRuns)
    print("\nTotal Number of Runs = %s\n\n" % numRuns)

    knobValuesList = []
    knobNamesList = []
    for CurAttrs in ProductAttrs:
        knobValues = []
        knobNames = []
        for k, v in CurAttrs.items():
            if v == "empty":
                continue
            else:
                knobNames.append(str(k))
                knobValues.append(str(v))
        knobValuesList.append(knobValues)
        knobNamesList.append(knobNames)
    fo.write(str(knobNamesList[0]) + "\n")
    for knobSet in knobValuesList:
        fo.write(str(knobSet) + "\n")

    fo.close()


def productDict(dicts):
    return (dict(zip(dicts, x)) for x in itertools.product(*dicts.values()))


def adjustFastRoute(filedata, adjSet, GrOverflow):
    if adjSet[0] != "empty":
        filedata = re.sub(
            "(set_global_routing_layer_adjustment .* )[0-9\\.]+",
            "\\g<1>{:.2f}".format(float(adjSet[0])),
            filedata,
        )
    sep_la_cmds = ""
    for i, sep_la in enumerate(adjSet):
        if i == 0 or sep_la == "empty":
            continue
        # TODO: Currently, only supports for SKY130HD and SKY130HS.
        # TODO: user should manually change the layer name to match techLEF.
        layer_name = "met%s" % i
        sep_la_cmds += (
            "set_global_routing_layer_adjustment "
            + layer_name
            + " {:.2f}\n".format(float(sep_la))
        )
    filedata = re.sub(
        "set_global_routing_layer_adjustment.*\n", "\\g<0>" + sep_la_cmds, filedata
    )
    if int(GrOverflow) == 1:
        filedata = re.sub(
            "(global_route.*(\n\\s+.*)*)",
            "\\g<1> \\\n             -allow_overflow",
            filedata,
        )

    return filedata


# def setPlaceDensity(DESIGN, Util, GpPad):
#  if DESIGN == "ibex":
#      LB = (Util/100) + (GpPad * (0.4*(Util/100)-0.01))+0.01
#  elif DESIGN == "aes":
#      LB = (Util/100) + (GpPad * (0.5*(Util/100)-0.005))+0.02
#  else:
#      LB = (Util/100) + (GpPad * (0.4*(Util/100)-0.01))+0.01
#  return LB


def writeConfigs(CurAttrs, CurChunkNum):
    CurPlatform, CurDesign = CurAttrs.get("PLATFORM_DESIGN").split("-")
    CurClkPeriod = CurAttrs.get("CP")
    CurAbcClkPeriod = CurAttrs.get("ABC_CP")
    CurFlatten = CurAttrs.get("FLATTEN")
    CurUncertainty = CurAttrs.get("UNCERTAINTY")
    CurIoDelay = CurAttrs.get("IO_DELAY")
    CurCoreUtil = CurAttrs.get("UTIL")
    CurAspectRatio = CurAttrs.get("AR")
    CurCoreDieMargin = CurAttrs.get("GAP")
    CurPinsDistance = CurAttrs.get("PINS_DISTANCE")
    CurGpPad = CurAttrs.get("GP_PAD")
    CurDpPad = CurAttrs.get("DP_PAD")
    CurPlaceDensity = CurAttrs.get("PD")
    CurPlaceDensityLbAddon = CurAttrs.get("PD_LB_ADD")
    CurCtsClusterSize = CurAttrs.get("CTS_CLUSTER_SIZE")
    CurCtsClusterDiameter = CurAttrs.get("CTS_CLUSTER_DIAMETER")
    CurLayerAdjust = CurAttrs.get("LAYER_ADJUST")
    CurLayerAdjustM1 = CurAttrs.get("M1")
    CurLayerAdjustM2 = CurAttrs.get("M2")
    CurLayerAdjustM3 = CurAttrs.get("M3")
    CurLayerAdjustM4 = CurAttrs.get("M4")
    CurLayerAdjustM5 = CurAttrs.get("M5")
    CurLayerAdjustM6 = CurAttrs.get("M6")
    CurLayerAdjustM7 = CurAttrs.get("M7")
    CurLayerAdjustM8 = CurAttrs.get("M8")
    CurLayerAdjustM9 = CurAttrs.get("M9")
    CurGrSeed = CurAttrs.get("GR_SEED")
    CurGrOverflow = CurAttrs.get("GR_OVERFLOW")
    CurDrSeed = CurAttrs.get("DR_SEED")

    if not os.path.isdir("./designs/%s/%s/chunks" % (CurPlatform, CurDesign)):
        os.mkdir("./designs/%s/%s/chunks" % (CurPlatform, CurDesign))
    CurDesignDir = "./designs/%s/%s" % (CurPlatform, CurDesign)
    CurChunkDir = "./designs/%s/%s/chunks/chunk%s" % (
        CurPlatform,
        CurDesign,
        CurChunkNum,
    )

    if not os.path.isdir(CurChunkDir):
        os.mkdir(CurChunkDir)

    if MakeArg == "clean":
        fileList = glob.glob("%s/*-DoE-*" % (CurChunkDir))
        if fileList is not None:
            for file in fileList:
                os.remove(file)
        return

    # print(CurPlatform, CurDesign)
    # print(CurClkPeriod, CurAbcClkPeriod, CurFlatten, CurCoreUtil)
    # print(CurAspectRatio, CurCoreDieMargin, CurGpPad, CurDpPad)
    # print(CurCtsClusterSize, CurCtsClusterDiameter, CurLayerAdjust)
    # print(CurLayerAdjustM1, CurLayerAdjustM2, CurLayerAdjustM3)
    # print(CurLayerAdjustM4, CurLayerAdjustM5, CurLayerAdjustM6)
    # print(CurLayerAdjustM7, CurLayerAdjustM8, CurLayerAdjustM9)
    # print(CurGrOverflow)

    # print(CurAttrs.items())
    variantName = ""
    for k, v in CurAttrs.items():
        if v != "empty" and k != "PLATFORM_DESIGN":
            variantName = variantName + "-" + str(k) + "_" + str(v)
    variantName = variantName[1:]
    # fileName = 'config-%s-%s-'%(CurPlatform, CurDesign)+variantName + '.mk'
    fileName = "config-DoE-" + variantName + ".mk"

    fo = open("%s/%s" % (CurChunkDir, fileName), "w")

    fo.write("include $(realpath $(dir $(DESIGN_CONFIG))../../)/config.mk\n")
    fo.write("\n")
    fo.write("FLOW_VARIANT = %s\n" % (variantName))
    fo.write("\n")

    if CurClkPeriod != "empty" or CurUncertainty != "empty" or CurIoDelay != "empty":
        fOrigSdc = open("%s/%s" % (CurDesignDir, OriginalSDC), "r")
        filedata = fOrigSdc.read()
        fOrigSdc.close()
        if CurClkPeriod != "empty":
            filedata = re.sub(
                "-period [0-9\\.]+", "-period " + str(CurClkPeriod), filedata
            )
            # filedata = re.sub("-waveform [{}\s0-9\.]+$}", "\n", filedata)
            filedata = re.sub("-waveform [{}\\s0-9\\.]+[\\s|\n]", "", filedata)
        if CurUncertainty != "empty":
            filedata = re.sub(
                "set uncertainty [0-9\\.]+",
                "set uncertainty " + str(CurUncertainty),
                filedata,
            )
        if CurIoDelay != "empty":
            filedata = re.sub(
                "set io_delay [0-9\\.]+", "set io_delay " + str(CurIoDelay), filedata
            )

        # fOutSdc = open('./designs/%s/%s/constraint-%s-%s-'%(CurPlatform,CurDesign,CurPlatform,CurDesign)+variantName+'.sdc','w')
        fOutSdc = open("%s/constraint-DoE-" % (CurChunkDir) + variantName + ".sdc", "w")
        fOutSdc.write(filedata)
        fOutSdc.close()
        fo.write(
            "export SDC_FILE = $(dir $(DESIGN_CONFIG))/constraint-DoE-%s.sdc\n"
            % variantName
        )

    if CurAbcClkPeriod != "empty":
        fo.write("export ABC_CLOCK_PERIOD_IN_PS = %s\n" % CurAbcClkPeriod)
    if CurFlatten != "empty":
        if CurFlatten == 0:
            fo.write("export SYNTH_ARGS = \n")

    if CurCoreUtil != "empty":
        fo.write("export CORE_UTILIZATION = %s\n" % CurCoreUtil)
    if CurPlaceDensity != "empty":
        fo.write("export PLACE_DENSITY = %.2f\n" % CurPlaceDensity)
    if CurPlaceDensityLbAddon != "empty":
        fo.write("export PLACE_DENSITY_LB_ADDON = %.2f\n" % CurPlaceDensityLbAddon)
    if CurAspectRatio != "empty":
        fo.write("export CORE_ASPECT_RATIO = %s\n" % CurAspectRatio)
    if CurCoreDieMargin != "empty":
        fo.write("export CORE_MARGIN = %s\n" % CurCoreDieMargin)
    if CurPinsDistance != "empty":
        fo.write("export PLACE_PINS_ARGS = -min_distance %s\n" % CurPinsDistance)
    if CurGpPad != "empty":
        fo.write("export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = %s\n" % CurGpPad)
    if CurDpPad != "empty":
        fo.write("export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = %s\n" % CurDpPad)

    if CurCtsClusterSize != "empty":
        fo.write("export CTS_CLUSTER_SIZE = %s\n" % CurCtsClusterSize)
    if CurCtsClusterDiameter != "empty":
        fo.write("export CTS_CLUSTER_DIAMETER = %s\n" % CurCtsClusterDiameter)
    if CurDrSeed != "empty":
        fo.write("export OR_K = 1.0\n")
        fo.write("export OR_SEED = %s\n" % CurDrSeed)
    if (
        CurLayerAdjust != "empty"
        or CurLayerAdjustM1 != "empty"
        or CurLayerAdjustM2 != "empty"
        or CurLayerAdjustM3 != "empty"
        or CurLayerAdjustM4 != "empty"
        or CurLayerAdjustM5 != "empty"
        or CurLayerAdjustM6 != "empty"
        or CurLayerAdjustM7 != "empty"
        or CurLayerAdjustM8 != "empty"
        or CurLayerAdjustM9 != "empty"
        or CurGrSeed != "empty"
    ):
        fo.write(
            "export FASTROUTE_TCL = $(dir $(DESIGN_CONFIG))/fastroute-DoE-%s.tcl"
            % variantName
        )

        if CurPlatform in PUBLIC:
            PLATFORM_DIR = "./platforms/%s" % CurPlatform
        else:
            PLATFORM_DIR = "../../%s" % CurPlatform

        fFrIn = open("%s/fastroute.tcl" % PLATFORM_DIR, "r")
        filedata = fFrIn.read()
        fFrIn.close()

        CurLayerAdjustSet = [
            CurLayerAdjust,
            CurLayerAdjustM1,
            CurLayerAdjustM2,
            CurLayerAdjustM3,
            CurLayerAdjustM4,
            CurLayerAdjustM5,
            CurLayerAdjustM6,
            CurLayerAdjustM7,
            CurLayerAdjustM8,
            CurLayerAdjustM9,
        ]
        filedata = adjustFastRoute(filedata, CurLayerAdjustSet, CurGrOverflow)
        FrName = "fastroute-DoE-" + variantName + ".tcl"
        fOutFr = open("%s/%s" % (CurChunkDir, FrName), "w")
        fOutFr.write(filedata)
        if CurGrSeed != "empty":
            fOutFr.write("set_global_routing_random -seed %s" % CurGrSeed)
        fOutFr.close()

    fo.close()

    frun = open("./%s.sh" % ShellName, "a")
    RunName = "DESIGN_CONFIG=%s/%s make\n" % (CurChunkDir, fileName)
    frun.write(RunName)
    frun.close()

    with open("./metrics/%s" % MetricsShellName, "a") as fcollect:
        CollectName = (
            "python util/genMetrics.py -x -p %s -d %s -v %s -o metrics/metrics_%s/%s.json\n"
            % (CurPlatform, CurDesign, variantName, ShellName, variantName)
        )
        fcollect.write(CollectName)


MakeArg = sys.argv[1]


if not os.path.isdir("./metrics"):
    os.mkdir("./metrics")
if not os.path.isdir("./metrics/metrics_%s" % ShellName):
    os.mkdir("./metrics/metrics_%s" % ShellName)

knobs = assignEmptyAttrs(SweepingAttributes)
ProductAttrs = list(productDict(knobs))
writeDoeLog(SweepingAttributes, ProductAttrs)
if os.path.isfile("./%s.sh" % ShellName):
    os.remove("./%s.sh" % ShellName)
if os.path.isfile("./metrics/%s" % MetricsShellName):
    os.remove("./metrics/%s" % MetricsShellName)
CurChunkNum = 0
for i, CurAttrs in enumerate(ProductAttrs, 1):
    if i % NumFilesPerChunk == 0:
        writeConfigs(CurAttrs, CurChunkNum)
        CurChunkNum = CurChunkNum + 1
    else:
        writeConfigs(CurAttrs, CurChunkNum)


# with open('file.txt') as data:
#    line = data.readlines()
#
# for line in lines:

# with open('file.txt') as data:
#    for line in file_data:
