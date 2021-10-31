#!/usr/bin/env python3

'''
This scripts automatically tuning the input parameters. The user should
install python Ray and Tune package and corresponding searching algorithms.
Ray and Tune installation instruction can be found in below URL.
https://docs.ray.io/en/master/installation.html

User can decide the input parameter space by modifying 'autotuner.json'.
'''

import argparse
import os
import json
import hashlib
import multiprocessing
import math
import time

import ray
from ray import tune
from ray.tune import Stopper
from ray.tune.suggest import ConcurrencyLimiter
from ray.tune.schedulers import AsyncHyperBandScheduler
from ray.tune.suggest.hyperopt import HyperOptSearch


class TimeStopper(Stopper):
    '''
    Experiment stop conditions.
    '''

    def __init__(self):
        self._start = time.time()
        self._deadline = 63966

    def __call__(self, trial_id, result):
        return False

    def stop_all(self):
        return time.time() - self._start > self._deadline


class Autotuner(tune.Trainable):
    '''
    Atutotuner base class for experiments.
    '''

    def setup(self, config):
        if args.server is not None:
            self.run_dir = os.path.abspath(os.getcwd() + '/../../../../')
        else:
            self.run_dir = os.path.abspath(os.getcwd() + '/../')
        self.parameters = parse_config(config)
        self.flow_variant = get_flow_variant(self.parameters)
        self.step_ = 0

    def step(self):
        '''
        Run step experiment and compute its score.
        '''
        metrics_file = run_openroad(self.run_dir,
                                    self.flow_variant,
                                    self.parameters)
        metrics = read_metrics(metrics_file)
        error = 'ERR' in metrics
        not_found = 'N/A' in metrics
        self.step_ += 1
        if error or not_found:
            score = (99999999999) * (self.step_ / 100)**(-1)
        else:
            score = self.evaluate(metrics)
        # Feed the score back back to Tune.
        # return must match 'metric' used in tune.run()
        return {"minimum": score}

    def evaluate(self, metrics):
        '''
        User-defined evaluation function.
        It can change in any form to minimize the score (return value).
        '''
        worst_slack, wirelength, num_drc = metrics
        alpha = -(wirelength / 100)
        beta = 1
        gamma = (wirelength / 10)
        term_1 = alpha * worst_slack + beta * wirelength
        term_2 = (self.step_ / 100)**(-1)
        term_3 = gamma * num_drc
        return term_1 * term_2 + term_3


def read_metrics(file_name):
    '''
    Collects metrics to evaluate the user-defined objective function.
    '''
    with open(file_name) as file:
        data = json.load(file)
    for key, value in data.items():
        if key == 'detailedroute':
            num_drc = value.get('route__drc_errors__count')
            wirelength = value.get('route__wirelength')
        if key == 'finish':
            worst_slack = value.get('timing__setup__ws')
    return worst_slack, wirelength, num_drc


def read_config(file_name):
    '''
    Please consider inclusive, exclusive
    Most type uses [min, max)
    But, Quantization makes the upper bound inclusive.
    e.g., qrandint and qlograndint uses [min, max]
    step value is used for quantized type (e.g., quniform). Otherwise, write 0.
    When min==max, it means the constant value
    '''

    config = {}
    with open(file_name) as file:
        data = json.load(file)

    config_data = data['param']
    space = data['space']

    for key, value in config_data.items():
        config_type = value.get('type')
        config_minmax = value.get('minmax')
        config_step = value.get('step')
        config_min = config_minmax[0]
        config_max = config_minmax[1]
        # This means the param is constant.
        if config_min == config_max:
            config[key] = config_min
            continue
        if config_type == 'int' and config_step == 1:
            config[key] = tune.randint(config_min, config_max)
        elif config_type == 'int' and config_step != 1:
            config[key] = tune.qrandint(
                config_min, config_max, config_step)
        elif config_type == 'float' and config_step != 0:
            config[key] = tune.quniform(
                config_min, config_max, config_step)
        elif config_type == 'float' and config_step == 0:
            config[key] = tune.uniform(config_min, config_max)

    return config, space


def parse_config(config):
    '''
    Parse config received from tune into make variables.
    '''
    options = ''
    for key, value in config.items():
        options += f' {key}={value}'
    return options


def get_flow_variant(parameters):
    '''
    Create a hash based on the parameters. This way we don't need to re-run
    experiments with the same configuration.
    '''
    variant_hash = hashlib.md5(parameters.encode('utf-8')).hexdigest()
    with open(os.path.join(os.getcwd() + '/variant_hash.txt'), 'w') as file:
        file.write(variant_hash)
    return f'{args.experiment}/variant-{variant_hash}'


def run_openroad(run_dir, flow_variant, parameters):
    '''
    Run OpenROAD-flow-scripts with a given set of parameters.
    '''

    if args.server is not None:
        install_path = f'{run_dir}/orfs/tools/install'
        export_command = f'export PATH={install_path}/OpenROAD/bin'
        export_command += f':{install_path}/yosys/bin'
        export_command += f':{install_path}/LSOracle/bin:$PATH'
        print('[INFO TUN-0003] Export command:', export_command)
        export_command += ' && '
    else:
        export_command = ''
        print('[INFO TUN-0004] Export command not set for local run.')

    make_command = export_command
    make_command += f'make -C {run_dir}/orfs/flow DESIGN_CONFIG=designs/'
    make_command += f'{args.platform}/{args.design}/config.mk'
    make_command += f' FLOW_VARIANT={flow_variant}'
    make_command += f' {parameters} > /dev/null'
    print(f'[INFO TUN-0005] Run current FLOW_VARIANT: {make_command}')
    os.system(make_command)

    metrics_file = os.path.join(os.getcwd(), 'metrics.json')
    metrics_command = export_command
    metrics_command += f'{run_dir}/orfs/flow/util/genMetrics.py -x'
    metrics_command += f' -v {flow_variant}'
    metrics_command += f' -d {args.design}'
    metrics_command += f' -p {args.platform}'
    metrics_command += f' -o {metrics_file}'
    print(f'[INFO TUN-0006] Generate metrics file: {metrics_command}')
    os.system(metrics_command)

    return metrics_file


@ray.remote
def nfs_setup(path):
    '''
    Clone ORFS repo and compile binaries inside a NFS shared folder.
    '''
    git_command = f'echo "Remote folder: {path}"'
    git_command += f' && mkdir -p {path}'
    # if args.force_clone:
    #     git_command += f' && rm -rf {path}/orfs'
    if not os.path.isdir(f'{path}/orfs/.git'):
        url = 'https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts'
        git_options = '--recursive --single-branch --branch master --depth 1'
        git_command += f' && git clone {git_options} {url} {path}/orfs'
    git_command += f' && cd {path}/orfs'
    # if args.clean:
    #     git_command += ' && git clean -xdf'
    #     git_command += ' && git submodule foreach --recursive git clean -xdf'
    if not os.path.isfile(f'{path}/orfs/tools/install/OpenROAD/bin/openroad'):
        build_command = 'bash -ic "./build_openroad.sh --local --threads 16"'
        git_command += f' && {build_command}'
    print(f'[INFO TUN-0000] Git command: {git_command}')
    os.system(git_command)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--design',
        '-d',
        type=str,
        required=False,
        default='gcd',
        help='Name of the design for Autotuning.')
    parser.add_argument(
        '--platform',
        '-p',
        type=str,
        required=False,
        default='sky130hd',
        help='Name of the platform for Autotuning.')
    parser.add_argument(
        '--experiment',
        '-e',
        type=str,
        required=False,
        default='test-hyperopt',
        help='Experiment name. This parameter is used to prefix the'
        ' FLOW_VARIANT and to set the Ray log destination'
        ' (i.e., {platform}/{design}/{experiment}).')
    parser.add_argument(
        '--jobs',
        '-j',
        type=int,
        required=False,
        default=math.floor(multiprocessing.cpu_count() / 2),
        help='Max number of concurrent jobs.')
    parser.add_argument(
        '--samples',
        '-s',
        type=int,
        required=False,
        default=10,
        help='Number of samples for search algorithm.')
    parser.add_argument(
        '--server',
        type=str,
        default=None,
        required=False,
        help='The address of Ray server to connect.')
    parser.add_argument(
        '--port',
        type=int,
        default=10001,
        required=False,
        help='The port of Ray server to connect.')
    parser.add_argument(
        '--config',
        '-c',
        type=str,
        default='util/autotuner.json',
        required=False,
        help='Configuration file that sets which knobs to use for Autotuning.')
    parser.add_argument(
        '--resume',
        '-r',
        action='store_true',
        help='Resume previous run.')
    args = parser.parse_args()

    # Connect to remote Ray server if any, otherwise will run locally
    if args.server is not None:
        ray.init(f'ray://{args.server}:{args.port}')
        # use a nfs mount to run experiment
        with open(args.config) as config_file:
            RUN = hashlib.md5(config_file.read().encode('utf-8')).hexdigest()
            local_dir = f'/shared-data/autotuner-{RUN}'
        results = [nfs_setup.remote(local_dir)]
        # Use ray.get() to wait for nfs_setup().
        print(f'[INFO TUN-0001] {ray.get(results)}')
    else:
        # on local run, use traditional logs folder
        local_dir = 'logs'

    best_param_file = f'designs/{args.platform}/{args.design}/autotuner.json'
    if os.path.isfile(best_param_file):
        with open(best_param_file) as f:
            best_params = json.load(f)
    else:
        best_params = []
    search_algo = HyperOptSearch(points_to_evaluate=best_params)
    search_algo = ConcurrencyLimiter(search_algo, max_concurrent=args.jobs)

    scheduler = AsyncHyperBandScheduler()

    config_dict, _ = read_config(args.config)

    analysis = tune.run(
        Autotuner,
        metric='minimum',
        mode='min',
        search_alg=search_algo,
        name=f'{args.platform}/{args.design}/{args.experiment}',
        scheduler=scheduler,
        num_samples=args.samples,
        config=config_dict,
        stop=TimeStopper(),
        fail_fast=True,
        local_dir=local_dir,
        resume=args.resume,
        resources_per_trial={"cpu": 4},
        queue_trials=True,
        verbose=1
    )
    print(f'[INFO TUN-0002] Best parameters found: {analysis.best_config}')
