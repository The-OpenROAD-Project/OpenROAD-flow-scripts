#!/usr/bin/env python3

# This scripts automatically tuning the input parameters. The user should install python Ray and Tune package and corresponding searching algorithms.
# Ray and Tune installation instruction can be found in below URL.
# https://docs.ray.io/en/master/installation.html

# User can change objective evaluation function by modifying 'evaluation_fn'.
# User can decide the input parameter space by modifying 'config.json'.
# run log files will be stored in util/autotuner/runs and util/autotuner/results
# -------------------------------------------------------------------------------

import time
import json
import os
import re
import subprocess

from ray import tune
from ray.tune.suggest import ConcurrencyLimiter
from ray.tune.schedulers import AsyncHyperBandScheduler
from ray.tune.suggest.hyperopt import HyperOptSearch

# Global Variables
autotunerPath = "util/autotuner"

# User-defined evaluation function
# It can change in any form to minimize the score (return value)


def evaluation_fn(step, ws, wl, ndrc):
    # alpha, beta, gamma are user-defined constant values
    alpha = -(wl / 100)
    beta = 1
    gamma = (wl / 10)

    return ((alpha * ws + beta * wl) * (step / 100)**(-1) + gamma * ndrc)


def evaluation_fn_fmax(step, clk, ws, ndrc):
    # alpha, beta, gamma are user-defined constant values
    fmax = (clk - ws) * (step / 100)**(-1)

    return fmax


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
    if "PLACE_DENSITY" in config:
        placeDensity = config["PLACE_DENSITY"]
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
    fileName = fileName + '-PD_%s' % placeDensity
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
        if line.startswith('PLACE_DENSITY') and line.split()[
                1] == '=' and not line.startswith('PLACE_DENSITY_LB_ADDON'):
            line = 'PLACE_DENSITY = [ %s ]\n' % placeDensity
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


# Collects metrics to evalute the user-defined objective function.
def read_metrics(path):
    with open('%s/metrics.json' % path) as f:
        data = json.load(f)
    for key, value in data.items():
        if key == 'detailedroute':
            ndrc = value.get('route__drc_errors__count')
            wl = value.get('route__wirelength')
        if key == 'finish':
            ws = value.get('timing__setup__ws')

    return ws, wl, ndrc


def easy_objective(config):
    runDir = os.getcwd()
    # Hyperparameters
    clkPeriod = config["CLK_PERIOD"]
    coreUtil = config["CORE_UTIL"]
    aspectRatio = config["ASPECT_RATIO"]
    coreDieMargin = config["CORE_DIE_MARGIN"]
    gpPad, dpPad, layerAdjust = config["GP_PAD"], config["DP_PAD"], config["LAYER_ADJUST"]
    placeDensity = config["PLACE_DENSITY"]
    flatten = config["FLATTEN"]
    pinsDist = config["PINS_DISTANCE"]
    ctsClusterSize = config["CTS_CLUSTER_SIZE"]
    ctsClusterDia = config["CTS_CLUSTER_DIAMETER"]
    grOverflow = config["GR_OVERFLOW"]

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

    ws, wl, ndrc = read_metrics(runDir)

    os.chdir('%s' % runDir)
    for step in range(1, 101):
        # if ws == 'ERR' or ws == 'N/A' or ndrc == 'ERR' or ndrc == 'N/A' or wl
        # == 'ERR' or wl == 'N/A':
        if ndrc != 0:
            intermediate_score = (99999999999) * (step / 100)**(-1)
        else:
            # Iterative training function
            # can be any arbitrary training procedure
            #intermediate_score = evaluation_fn(step, ws, wl, ndrc)
            intermediate_score = evaluation_fn_fmax(step, clkPeriod, ws, ndrc)

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
    with open('./%s/config_fmax.json' % autotunerPath) as f:
        data = json.load(f)
    for key, value in data.items():
        config_type = value.get("type")
        config_minmax = value.get("minmax")
        config_step = value.get("step")

        config_min = config_minmax[0]
        config_max = config_minmax[1]

        # This means the param is constant.
        if config_min == config_max:
            config_dict[key] = config_min
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
        "--smoke-test", action="store_true", help="Finish quickly for testing")
    parser.add_argument(
        "--server-address",
        type=str,
        default=None,
        required=False,
        help="The address of server to connect to if using "
        "Ray Client.")
    args, _ = parser.parse_known_args()

    # Optional
    current_best_params = [{
        'CLK_PERIOD': 4.3647,
        'CORE_UTIL': 20,
        'ASPECT_RATIO': 1.0,
        'CORE_DIE_MARGIN': 10,
        'GP_PAD': 4,
        'DP_PAD': 2,
        'LAYER_ADJUST': 0.5,
        'PLACE_DENSITY': 0.6,
        'FLATTEN': 1,
        'PINS_DISTANCE': 2,
        'CTS_CLUSTER_SIZE': 30,
        'CTS_CLUSTER_DIAMETER': 100,
        'GR_OVERFLOW': 1,
    }]

    if args.server_address:
        import ray

        ray.util.connect(args.server_address)

    num_samples = 10 if args.smoke_test else args.num_trials

    resultsDir = "%s/%s/results" % (cwd, autotunerPath)

    if not os.path.isdir(resultsDir):
        os.mkdir(resultsDir)

    config_dict = read_config()
    print(config_dict)

    # Optional: Pass the parameter space yourself
    # space = {
    #     # for continuous dimensions: (continuous, search_range, precision)
    #     "height": (ValueType.CONTINUOUS, [-10, 10], 1e-2),
    #     # for discrete dimensions: (discrete, search_range, has_order)
    #     "width": (ValueType.DISCRETE, [0, 10], True)
    #     # for grid dimensions: (grid, grid_list)
    #     "layers": (ValueType.GRID, [4, 8, 16])
    # }

    algo = HyperOptSearch(points_to_evaluate=current_best_params)
    #algo = HyperOptSearch()

    # User-defined concurrent #runs
    algo = ConcurrencyLimiter(algo, max_concurrent=args.num_jobs)

    scheduler = AsyncHyperBandScheduler()

    analysis = tune.run(
        easy_objective,
        metric="minimum",
        mode="min",
        search_alg=algo,
        name="%s-%s-%s" % (args.platform, args.design, args.exp_name),
        scheduler=scheduler,
        num_samples=num_samples,
        config=config_dict,
        local_dir="%s" % (resultsDir)
    )
    print("Best config found: ", analysis.best_config)
