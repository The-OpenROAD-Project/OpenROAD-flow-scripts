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
import sys

import ray
from ray import tune
from ray.tune import Stopper
from ray.tune.schedulers import AsyncHyperBandScheduler
from ray.tune.schedulers import PopulationBasedTraining
from ray.tune.suggest import ConcurrencyLimiter
from ray.tune.suggest.ax import AxSearch
from ray.tune.suggest.basic_variant import BasicVariantGenerator
from ray.tune.suggest.hyperopt import HyperOptSearch
from ray.tune.suggest.nevergrad import NevergradSearch
from ray.tune.suggest.optuna import OptunaSearch

import nevergrad as ng
from ax.service.ax_client import AxClient


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
        '''
        Setup current experiment step.
        '''
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
        self.step_ += 1
        score = self.evaluate(self.read_metrics(metrics_file))
        # Feed the score back back to Tune.
        # return must match 'metric' used in tune.run()
        return {"minimum": score}

    def evaluate(self, metrics):
        '''
        User-defined evaluation function.
        It can change in any form to minimize the score (return value).
        '''
        error = 'ERR' in metrics
        not_found = 'N/A' in metrics
        if error or not_found:
            return (99999999999) * (self.step_ / 100)**(-1)
        worst_slack, wirelength, num_drc = metrics
        alpha = -(wirelength / 100)
        beta = 1
        gamma = (wirelength / 10)
        term_1 = alpha * worst_slack + beta * wirelength
        term_2 = (self.step_ / 100)**(-1)
        term_3 = gamma * num_drc
        return term_1 * term_2 + term_3

    @classmethod
    def read_metrics(cls, file_name):
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


class AxPPA(Autotuner):
    '''
    AxPPA
    '''
    @classmethod
    def read_metrics(cls, file_name):
        '''
        Collects metrics to evaluate the user-defined objective function.
        '''
        with open(file_name) as file:
            data = json.load(file)
        clk_period = 9999999
        for key, value in data.items():
            if key == 'constraints' and len(value.get('clocks__details')) > 0:
                clk_period = float(value.get('clocks__details')[0].split()[1])
            if key == 'floorplan':
                core_util = value.get('design__instance__design__util')
            if key == 'detailedroute':
                ndrc = value.get('route__drc_errors__count')
                wirelength = value.get('route__wirelength')
            if key == 'finish':
                worst_slack = value.get('timing__setup__ws')
                total_power = value.get('power__total')
                final_util = value.get('design__instance__utilization')
        ret = {
            "clk_period": clk_period,
            "worst_slack": worst_slack,
            "wirelength": wirelength,
            "ndrc": ndrc,
            "total_power": total_power,
            "core_uti": core_util,
            "final_util": final_util
        }
        return ret


class EffClkPeriod(AxPPA):
    '''
    EffClkPeriod
    '''

    def evaluate(self, metrics):
        gamma = (metrics['clk_period'] - metrics['worst_slack']) / 10
        eff_clk_period = (metrics['clk_period'] - metrics['worst_slack']) * \
            (self.step_ / 100)**(-1) + gamma * metrics['ndrc']
        return eff_clk_period


class PPA(AxPPA):
    '''
    PPA
    '''

    def evaluate(self, metrics):
        # eff_clk_period -100~100 -> multiply 100
        # area (100/metrics['utilization']), 0~100 -> multiply 1
        # metrics['total_power'] 0~ about 0.1 -> muliply 1
        if metrics['worst_slack'] > 0:
            eff_clk_period = metrics['clk_period']
        else:
            eff_clk_period = (metrics['clk_period'] - metrics['worst_slack'])
        ppa = eff_clk_period * 100 + \
            (100 / metrics['utilization']) + (metrics['total_power'] * 10)
        gamma = ppa / 10
        score = ppa * (self.step_ / 100)**(-1) + (gamma * metrics['ndrc'])
        return score


class PPAImprov(AxPPA):
    '''
    PPAImprov
    '''

    @classmethod
    def get_ppa(cls, metrics, reference):
        '''
        Compute PPA term for evaluate.
        '''
        coeff_perform, coeff_power, coeff_area = 10000, 100, 100

        eff_clk_period = metrics['clk_period']
        if metrics['worst_slack'] < 0:
            eff_clk_period -= metrics['worst_slack']

        eff_clk_period_ref = reference['clk_period']
        if reference['worst_slack'] < 0:
            eff_clk_period_ref -= reference['worst_slack']

        def percent(x_1, x_2):
            return (x_1 - x_2) / x_1 * 100

        performance = percent(eff_clk_period_ref, eff_clk_period)
        power = percent(reference['total_power'],
                        metrics['total_power'])
        area = percent(100 - reference['utilization'],
                       100 - metrics['utilization'])

        # lower values of ppa are better.
        ppa_upper_bound = (coeff_perform + coeff_power + coeff_area) * 100
        ppa = performance * coeff_perform
        ppa += power * coeff_power
        ppa += area * coeff_area
        return ppa_upper_bound - ppa

    def evaluate(self, metrics):
        # TODO
        reference = {}
        ppa = self.get_ppa(metrics, reference)
        gamma = ppa / 10
        score = ppa * (self.step_ / 100)**(-1) + (gamma * metrics['ndrc'])
        return score


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
        '--seed',
        type=int,
        default=123,
        required=False,
        help='Random seed.')
    parser.add_argument(
        '--perturbation',
        type=int,
        default=25,
        required=False,
        help='Perturbation interval for PopulationBasedTraining.')
    parser.add_argument(
        '--algorithm',
        '-a',
        type=str,
        default='hyperopt',
        required=False,
        help='Search algorithm to use for Autotuning.')
    parser.add_argument(
        '--eval',
        type=str,
        default='default',
        required=False,
        help='Evaluate function to use with search algorithm.')
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
    args.algorithm = args.algorithm.lower()

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

    config_dict, _ = read_config(args.config)

    if args.algorithm == 'hyperopt':
        search_algo = HyperOptSearch(points_to_evaluate=best_params)
    elif args.algorithm == 'axppa':
        ax = AxClient(enforce_sequential_optimization=False)
        ax.create_experiment(
            name="%s-%s-%s" % (args.platform, args.design, args.exp_name),
            parameters=config_dict,
            objective_name="minimum",
            minimize=True,
        )
        search_algo = AxSearch(
            ax_client=ax,
            points_to_evaluate=best_params,
            max_concurrent=args.num_jobs)
    elif args.algorithm == 'nevergrad':
        search_algo = NevergradSearch(
            points_to_evaluate=best_params,
            optimizer=ng.optimizers.registry["PortfolioDiscreteOnePlusOne"])
    elif args.algorithm == 'optuna':
        search_algo = OptunaSearch(points_to_evaluate=best_params,
                                   seed=args.seed)
    elif args.algorithm == 'pbt':
        search_algo = PopulationBasedTraining(
            time_attr="training_iteration",
            perturbation_interval=args.perturbation,
            hyperparam_mutations=config_dict,
            synch=False
        )
    elif args.algorithm == 'random':
        search_algo = BasicVariantGenerator(max_concurrent=args.num_jobs)
    else:
        print(f'[ERROR TUN-0007] Invalid search algorithm: {args.algorithm}')
        sys.exit(1)

    if args.eval == 'default':
        TrainClass = Autotuner
    elif args.eval == 'eff-clk-period':
        TrainClass = EffClkPeriod
    elif args.eval == 'ppa':
        TrainClass = PPA
    elif args.eval == 'ppa-improv':
        TrainClass = PPAImprov
    elif args.eval == 'ax-ppa':
        TrainClass = AxPPA
    else:
        print(f'[ERROR TUN-0008] Invalid evaluate function: {args.eval}')
        sys.exit(1)

    analysis = tune.run(
        TrainClass,
        metric='minimum',
        mode='min',
        search_alg=ConcurrencyLimiter(search_algo, max_concurrent=args.jobs),
        name=f'{args.platform}/{args.design}/{args.experiment}',
        scheduler=AsyncHyperBandScheduler(),
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
