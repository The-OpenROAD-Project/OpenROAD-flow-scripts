#!/usr/bin/env python3

# This scripts automatically tuning the input parameters. The user should install python Ray and Tune package and corresponding searching algorithms.
# Ray and Tune installation instruction can be found in below URL.
# https://docs.ray.io/en/master/installation.html

# User can change objective evaluation function by modifying 'evaluation_fn'.
# User can decide the input parameter space by modifying 'config.json'.
# run log files will be stored in util/autotuner/runs and util/autotuner/results
# -------------------------------------------------------------------------------
import numpy as np
import time
import json
import os
import re
import subprocess
import random

from ray import tune
from ray.tune.suggest import ConcurrencyLimiter
from ray.tune.schedulers import PopulationBasedTraining

# Global Variables
autotunerPath = "util/autotuner"

# User-defined evaluation function
# It can change in any form to minimize the score (return value)


# Collects metrics to evalute the user-defined objective function.
def read_metrics(metricsPath):
    with open(metricsPath) as f:
        data = json.load(f)
    clkPeriod = 9999999
    for key, value in data.items():
        if key == 'constraints' and len(value.get('clocks__details')) > 0:
            clkPeriod = float(value.get('clocks__details')[0].split()[1])
        if key == 'floorplan':
            coreUtil = value.get('design__instance__design__util')
        if key == 'detailedroute':
            ndrc = value.get('route__drc_errors__count')
            wl = value.get('route__wirelength')
        if key == 'finish':
            ws = value.get('timing__setup__ws')
            totalPower = value.get('power__total')
            finalUtil = value.get('design__instance__utilization')

    return clkPeriod, ws, wl, ndrc, totalPower, coreUtil, finalUtil


def evaluation_fn(step, ws, wl, ndrc):
    # alpha, beta, gamma are user-defined constant values
    alpha = -(wl / 100)
    beta = 1
    gamma = (wl / 10)

    return ((alpha * ws + beta * wl) * (step / 100)**(-1) + gamma * ndrc)


def evaluation_fn_effClkPeriod(step, clk, ws, ndrc):
    # alpha, beta, gamma are user-defined constant values
    gamma = (clk - ws) / 10
    effClkPeriod = (clk - ws) * (step / 100)**(-1) + gamma * ndrc

    return effClkPeriod


def evaluation_fn_ppa(step, clk, ws, ndrc, power, util):
    # alpha, beta, gamma are user-defined constant values
    # effClkPeriod -100~100 -> multiply 100
    # area (100/util), 0~100 -> multiply 1
    # power 0~ about 0.1 -> muliply 1
    if ws > 0:
        effClkPeriod = clk
    else:
        effClkPeriod = (clk - ws)
    #ppa = effClkPeriod + (100/util*100) + (power*1000000)
    ppa = effClkPeriod * 100 + (100 / util) + (power * 10)
    gamma = ppa / 10
    score = ppa * (step / 100)**(-1) + (gamma * ndrc)

    return score


def evaluation_fn_ppa_improv(step, clk, ws, ndrc, power, util):

    clkRef, wsRef, wlRef, ndrcRef, powerRef, utilRef, finalUtilRef = read_metrics(
        pathRef)
    if ws > 0:
        effClkPeriod = clk
    else:
        effClkPeriod = (clk - ws)
    if wsRef > 0:
        effClkPeriodRef = clkRef
    else:
        effClkPeriodRef = (clkRef - wsRef)
    # Coefficient shoule be 0 to 100
    coeffPerform, coeffPower, coeffArea = 10000, 100, 100
    improvPerform = 100 * (effClkPeriodRef - effClkPeriod) / effClkPeriodRef
    improvPower = 100 * (powerRef - power) / powerRef
    #improvArea = 100 * ((1/utilRef) - (1/util)) / (1/utilRef)
    improvArea = 100 * ((100 - utilRef) - (100 - util)) / (100 - utilRef)

    # ppa: less is better.
    ppaUpperBound = (100 * (coeffPerform + coeffPower + coeffArea))
    ppa = ppaUpperBound - (coeffPerform * improvPerform +
                           coeffPower * improvPower + coeffArea * improvArea)
    gamma = ppa / 10
    score = ppa * (step / 100)**(-1) + (gamma * ndrc)

    return score


def parse_massive(config):
    with open('%s/util/genMassive.py' % cwd) as inFile:
        lines = inFile.readlines()

    if "CLK_PERIOD" in config:
        clkPeriod = config["CLK_PERIOD"]
    if "CORE_UTIL" in config:
        coreUtil = config["CORE_UTIL"]
    if "ASPECT_RATIO" in config:
        aspectRatio = config["ASPECT_RATIO"]
    if "CORE_DIE_MARGIN" in config:
        coreDieMargin = config["CORE_DIE_MARGIN"]
    if "GP_PAD" in config:
        gpPad = config["GP_PAD"]
    if "DP_PAD" in config:
        dpPad = config["DP_PAD"]
    if "LAYER_ADJUST" in config:
        layerAdjust = config["LAYER_ADJUST"]
    if "PLACE_DENSITY_LB_ADDON" in config:
        placeDensity = config["PLACE_DENSITY_LB_ADDON"]
    if "FLATTEN" in config:
        flatten = config["FLATTEN"]
    if "PINS_DISTANCE" in config:
        pinsDist = config["PINS_DISTANCE"]
    if "CTS_CLUSTER_SIZE" in config:
        ctsClusterSize = config["CTS_CLUSTER_SIZE"]
    if "CTS_CLUSTER_DIAMETER" in config:
        ctsClusterDia = config["CTS_CLUSTER_DIAMETER"]
    if "GR_OVERFLOW" in config:
        grOverflow = config["GR_OVERFLOW"]

    fileName = ''
    fileName = fileName + 'CP_%s' % clkPeriod
    fileName = fileName + '-FLATTEN_%s' % flatten
    fileName = fileName + '-UTIL_%s' % coreUtil
    fileName = fileName + '-AR_%s' % aspectRatio
    fileName = fileName + '-GAP_%s' % coreDieMargin
    fileName = fileName + '-PINS_DISTANCE_%s' % pinsDist
    fileName = fileName + '-GP_PAD_%s' % gpPad
    fileName = fileName + '-DP_PAD_%s' % dpPad
    fileName = fileName + '-PD_LB_ADD_%s' % placeDensity
    fileName = fileName + '-CTS_CLUSTER_SIZE_%s' % ctsClusterSize
    fileName = fileName + '-CTS_CLUSTER_DIAMETER_%s' % ctsClusterDia
    fileName = fileName + '-LAYER_ADJUST_%s' % layerAdjust
    fileName = fileName + '-GR_OVERFLOW_%s' % grOverflow

    if not os.path.isdir('%s/%s/runs' % (cwd, autotunerPath)):
        os.mkdir('%s/%s/runs' % (cwd, autotunerPath))

    fo = open('%s/%s/runs/auto-%s.py' % (cwd, autotunerPath, fileName), 'w')

    for line in lines:
        if line.startswith('ShellName') and line.split()[1] == '=':
            line = 'ShellName = "runs-%s"\n' % fileName
        if line.startswith('PLATFORM_DESIGN') and line.split()[1] == '=':
            line = 'PLATFORM_DESIGN = [ \'%s-%s\' ]\n' % (
                args.platform, args.design)
        if line.startswith('CLK_PERIOD') and line.split()[1] == '=':
            line = 'CLK_PERIOD = [ %s ]\n' % clkPeriod
        if line.startswith('CORE_UTIL') and line.split()[1] == '=':
            line = 'CORE_UTIL = [ %s ]\n' % coreUtil
        if line.startswith('ASPECT_RATIO') and line.split()[1] == '=':
            line = 'ASPECT_RATIO = [ %s ]\n' % aspectRatio
        if line.startswith('CORE_DIE_MARGIN') and line.split()[1] == '=':
            line = 'CORE_DIE_MARGIN = [ %s ]\n' % coreDieMargin
        if line.startswith('GP_PAD') and line.split()[1] == '=':
            line = 'GP_PAD = [ %s ]\n' % gpPad
        if line.startswith('DP_PAD') and line.split()[1] == '=':
            line = 'DP_PAD = [ %s ]\n' % dpPad
        if line.startswith('LAYER_ADJUST ') and line.split()[1] == '=':
            line = 'LAYER_ADJUST = [ %s ]\n' % layerAdjust
        if line.startswith('PLACE_DENSITY_LB_ADDON') and line.split()[
                1] == '=':
            line = 'PLACE_DENSITY_LB_ADDON = [ %s ]\n' % placeDensity
        if line.startswith('FLATTEN') and line.split()[1] == '=':
            line = 'FLATTEN = [ %s ]\n' % flatten
        if line.startswith('PINS_DISTANCE') and line.split()[1] == '=':
            line = 'PINS_DISTANCE = [ %s ]\n' % pinsDist
        if line.startswith('CTS_CLUSTER_SIZE') and line.split()[1] == '=':
            line = 'CTS_CLUSTER_SIZE = [ %s ]\n' % ctsClusterSize
        if line.startswith('CTS_CLUSTER_DIAMETER') and line.split()[1] == '=':
            line = 'CTS_CLUSTER_DIAMETER = [ %s ]\n' % ctsClusterDia
        if line.startswith('GR_OVERFLOW') and line.split()[1] == '=':
            line = 'GR_OVERFLOW = [ %s ]\n' % grOverflow
        fo.write(line)
    fo.close()

    return fileName


def easy_objective(config, checkpoint_dir=None):
    runDir = os.getcwd()
    # Hyperparameters
    #clkPeriod = config["CLK_PERIOD"]
    #coreUtil = config["CORE_UTIL"]
    aspectRatio = config["ASPECT_RATIO"]
    coreDieMargin = config["CORE_DIE_MARGIN"]
    gpPad, dpPad, layerAdjust = config["GP_PAD"], config["DP_PAD"], config["LAYER_ADJUST"]
    placeDensity = config["PLACE_DENSITY_LB_ADDON"]
    flatten = config["FLATTEN"]
    pinsDist = config["PINS_DISTANCE"]
    ctsClusterSize = config["CTS_CLUSTER_SIZE"]
    ctsClusterDia = config["CTS_CLUSTER_DIAMETER"]
    grOverflow = config["GR_OVERFLOW"]

    minimum = 0.0
    start = 0

    if checkpoint_dir:
        with open(os.path.join(checkpoint_dir, "checkpoint")) as f:
            state = json.loads(f.read())
            start = state["step"] + 1

    # parse trial config hyperparameters to genMassive.py script
    # Newly generated genMassive.py scripts are located in
    # ./util/autotuner/runs/autotuner-{variantName}.py
    variantName = parse_massive(config)

    # run each runMassive.sh file ( generated from genMassive.py)
    os.chdir('%s' % cwd)

    print('run generated python to make run shell')
    os.system('python %s/%s/runs/auto-%s.py run' %
              (cwd, autotunerPath, variantName))
    print('run generated run shell')
    os.system('source %s/runs-%s.sh' % (cwd, variantName))

    # run genMetrics.py to make metrics.json
    os.system(
        'python %s/util/genMetrics.py -x -f %s -d %s -p %s -v %s -o %s/metrics.json' %
        (cwd, cwd, args.design, args.platform, variantName, runDir))

    # read generated metrics.json and parse Success / Fail, WNS, Wirelength
    # and #DRC

    clkPeriod, ws, wl, ndrc, totalPower, coreUtil, finalUtil = read_metrics(
        '%s/metrics.json' %
        runDir)

    os.chdir('%s' % runDir)
    for step in range(1, 101):
        # if ws == 'ERR' or ws == 'N/A' or ndrc == 'ERR' or ndrc == 'N/A' or wl
        # == 'ERR' or wl == 'N/A':
        if ws == 'ERR' or ws == 'N/A' or ndrc == 'ERR' or ndrc == 'N/A' or wl == 'ERR' or wl == 'N/A':
            intermediate_score = (10000000) * (step / 100)**(-1)
        else:
            # Iterative training function
            # can be any arbitrary training procedure
            #intermediate_score = evaluation_fn(step, ws, wl, ndrc)
            #intermediate_score = evaluation_fn_effClkPeriod(step, clkPeriod, ws, ndrc)
            intermediate_score = evaluation_fn_ppa_improv(
                step, clkPeriod, ws, ndrc, totalPower, coreUtil)

        # Obtain a checkpoint directory
        with tune.checkpoint_dir(step=step) as checkpoint_dir:
            path = os.path.join(checkpoint_dir, "checkpoint")
            with open(path, "w") as f:
                f.write(json.dumps({"step": step}))

        # Feed the score back back to Tune.
        tune.report(minimum=intermediate_score)


def read_config():
    # Please consider inclusive, exclusive
    # Most type uses [min, max)
    # But, Quantization makes the upper bound inclusive.
    # e.g., qrandint and qlograndint uses [min, max]
    # step value is used for quantized type (e.g., quniform). Otherwise, write 0.
    # When min==max, it means the constant value

    config_dict = {}
    # with open('./%s/config_fmax.json' % autotunerPath) as f:
    with open('./%s/config_fmax_%s-%s.json' % (autotunerPath, args.platform, args.design)) as f:
        data = json.load(f)
    for key, value in data.items():
        config_type = value.get("type")
        config_minmax = value.get("minmax")
        config_step = value.get("step")

        config_min = config_minmax[0]
        config_max = config_minmax[1]

        # This means the param is constant.
        if config_min == config_max:
            config_dict[key] = [config_min]
            continue

        print(key, config_min, config_max, config_type)
        if config_type == 'int' and config_step == 1:
            config_dict[key] = tune.randint(config_min, config_max)
        elif config_type == 'int' and config_step != 1:
            config_dict[key] = tune.qrandint(
                config_min, config_max, config_step)
        elif config_type == 'float' and config_step != 0:
            config_dict[key] = tune.quniform(
                config_min, config_max, config_step)
        elif config_type == 'float' and config_step == 0:
            config_dict[key] = tune.uniform(config_min, config_max)
    return config_dict


if __name__ == "__main__":
    import argparse
    cwd = os.getcwd()

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--design",
        '-d',
        type=str,
        required=True,
        help="Design Name for Autotuning")
    parser.add_argument(
        "--platform",
        '-p',
        type=str,
        required=True,
        help="Platform Name for Autotuning")
    parser.add_argument(
        "--exp-name",
        '-e',
        type=str,
        required=False,
        default="test-hyperopt",
        help="Result Folder Name: {platform}-{design}-{exp-name}")
    parser.add_argument(
        "--num_jobs",
        "-j",
        type=int,
        required=True,
        help="Number of Concurrent Jobs")
    parser.add_argument(
        "--num_trials",
        "-n",
        type=int,
        required=True,
        help="Number of Trials")
    parser.add_argument(
        "--ref",
        "-r",
        type=str,
        required=False,
        help="Reference known-best metrics json to perform improvement-oriented optimization")
    parser.add_argument(
        "--smoke-test", action="store_true", help="Finish quickly for testing")
    parser.add_argument(
        "--server-address",
        type=str,
        default=None,
        required=False,
        help="The address of server to connect to if using "
        "Ray Client.")
    args, _ = parser.parse_known_args()

    pathRef = os.path.abspath(args.ref)

    # Optional
    current_best_params_LUT = {'sky130hd-aes': [{
        'CLK_PERIOD': 3.7439,
        'CORE_UTIL': 20,
        'ASPECT_RATIO': 1.0,
        'CORE_DIE_MARGIN': 2,
        'GP_PAD': 4,
        'DP_PAD': 2,
        'LAYER_ADJUST': 0.5,
        'PLACE_DENSITY_LB_ADDON': 0.04,
        'FLATTEN': 1,
        'PINS_DISTANCE': 2,
        'CTS_CLUSTER_SIZE': 30,
        'CTS_CLUSTER_DIAMETER': 100,
        'GR_OVERFLOW': 1,
    }], 'sky130hd-ibex': [{
        'CLK_PERIOD': 15.1550,
        'CORE_UTIL': 20,
        'ASPECT_RATIO': 1.5,
        'CORE_DIE_MARGIN': 2,
        'GP_PAD': 4,
        'DP_PAD': 2,
        'LAYER_ADJUST': 0.5,
        'PLACE_DENSITY_LB_ADDON': 0.04,
        'FLATTEN': 1,
        'PINS_DISTANCE': 2,
        'CTS_CLUSTER_SIZE': 30,
        'CTS_CLUSTER_DIAMETER': 100,
        'GR_OVERFLOW': 1,
    }], 'sky130hd-jpeg': [{
        'CLK_PERIOD': 12.0870,
        'CORE_UTIL': 20,
        'ASPECT_RATIO': 1.0,
        'CORE_DIE_MARGIN': 2,
        'GP_PAD': 4,
        'DP_PAD': 2,
        'LAYER_ADJUST': 0.5,
        'PLACE_DENSITY_LB_ADDON': 0.1,
        'FLATTEN': 1,
        'PINS_DISTANCE': 2,
        'CTS_CLUSTER_SIZE': 30,
        'CTS_CLUSTER_DIAMETER': 100,
        'GR_OVERFLOW': 1,
    }], 'sky130hd-gcd': [{
        'CLK_PERIOD': 4.3647,
        'CORE_UTIL': 5,
        'ASPECT_RATIO': 1.0,
        'CORE_DIE_MARGIN': 2,
        'GP_PAD': 4,
        'DP_PAD': 2,
        'LAYER_ADJUST': 0.5,
        'PLACE_DENSITY_LB_ADDON': 0.04,
        'FLATTEN': 1,
        'PINS_DISTANCE': 2,
        'CTS_CLUSTER_SIZE': 30,
        'CTS_CLUSTER_DIAMETER': 100,
        'GR_OVERFLOW': 1,
    }], 'asap7-aes': [{
        'CLK_PERIOD': 600,
        'CORE_UTIL': 30,
        'ASPECT_RATIO': 1.0,
        'CORE_DIE_MARGIN': 2,
        'GP_PAD': 2,
        'DP_PAD': 1,
        'LAYER_ADJUST': 0.5,
        'PLACE_DENSITY_LB_ADDON': 0.04,
        'FLATTEN': 1,
        'PINS_DISTANCE': 2,
        'CTS_CLUSTER_SIZE': 30,
        'CTS_CLUSTER_DIAMETER': 100,
        'GR_OVERFLOW': 1,
    }], 'asap7-ibex': [{
        'CLK_PERIOD': 6000,
        'CORE_UTIL': 25,
        'ASPECT_RATIO': 1.0,
        'CORE_DIE_MARGIN': 2,
        'GP_PAD': 2,
        'DP_PAD': 1,
        'LAYER_ADJUST': 0.5,
        'PLACE_DENSITY_LB_ADDON': 0.04,
        'FLATTEN': 1,
        'PINS_DISTANCE': 2,
        'CTS_CLUSTER_SIZE': 30,
        'CTS_CLUSTER_DIAMETER': 100,
        'GR_OVERFLOW': 1,
    }], 'asap7-jpeg': [{
        'CLK_PERIOD': 2200,
        'CORE_UTIL': 30,
        'ASPECT_RATIO': 1.0,
        'CORE_DIE_MARGIN': 2,
        'GP_PAD': 2,
        'DP_PAD': 1,
        'LAYER_ADJUST': 0.5,
        'PLACE_DENSITY_LB_ADDON': 0.04,
        'FLATTEN': 1,
        'PINS_DISTANCE': 2,
        'CTS_CLUSTER_SIZE': 30,
        'CTS_CLUSTER_DIAMETER': 100,
        'GR_OVERFLOW': 1,
    }], 'asap7-gcd': [{
        'CLK_PERIOD': 2000,
        'CORE_UTIL': 5,
        'ASPECT_RATIO': 1.0,
        'CORE_DIE_MARGIN': 2,
        'GP_PAD': 2,
        'DP_PAD': 1,
        'LAYER_ADJUST': 0.5,
        'PLACE_DENSITY_LB_ADDON': 0.04,
        'FLATTEN': 1,
        'PINS_DISTANCE': 2,
        'CTS_CLUSTER_SIZE': 30,
        'CTS_CLUSTER_DIAMETER': 100,
        'GR_OVERFLOW': 1,
    }]}
    designKey = '%s-%s' % (args.platform, args.design)
    current_best_params = current_best_params_LUT[designKey]

    if args.server_address:
        import ray

        ray.util.connect(args.server_address)

    num_samples = 10 if args.smoke_test else args.num_trials
    #num_samples = num_samples//25
    num_samples = num_samples

    resultsDir = "%s/%s/results" % (cwd, autotunerPath)

    if not os.path.isdir(resultsDir):
        os.mkdir(resultsDir)

    config_dict = read_config()
    print(config_dict)

    # User-defined concurrent #runs
    #algo = ConcurrencyLimiter(algo, max_concurrent=args.num_jobs)

    algo = PopulationBasedTraining(
        time_attr="training_iteration",
        perturbation_interval=25,
        hyperparam_mutations=config_dict,
        synch=False
    )

    analysis = tune.run(
        easy_objective,
        metric="minimum",
        mode="min",
        name="%s-%s-%s" % (args.platform, args.design, args.exp_name),
        scheduler=algo,
        num_samples=num_samples,
        stop={
            "training_iteration": 100,
        },
        fail_fast=True,
        resources_per_trial={"cpu": 4},
        local_dir="%s" % (resultsDir)
    )
    print("Best config found: ", analysis.best_config)
