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
import sys
from datetime import datetime

import ray
from ray import tune
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

BUILD_CPUS = 16
CPUS = 12
DATE = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
ORFS_URL = 'https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts'


class AutotunerBase(tune.Trainable):
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
        error = 'ERR' in metrics.values()
        not_found = 'N/A' in metrics.values()
        if error or not_found:
            return (99999999999) * (self.step_ / 100)**(-1)
        alpha = -(metrics['wirelength'] / 100)
        beta = 1
        gamma = (metrics['wirelength'] / 10)
        term_1 = alpha * metrics['worst_slack'] + beta * metrics['wirelength']
        term_2 = (self.step_ / 100)**(-1)
        term_3 = gamma * metrics['num_drc']
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
        ret = {
            'worst_slack': worst_slack,
            'wirelength': wirelength,
            'num_drc': num_drc
        }
        return ret


class AxPPA(AutotunerBase):
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
        worst_slack = 'ERR'
        wirelength = 'ERR'
        num_drc = 'ERR'
        total_power = 'ERR'
        core_util = 'ERR'
        final_util = 'ERR'
        for key, value in data.items():
            if key == 'constraints' and len(value.get('clocks__details')) > 0:
                clk_period = float(value.get('clocks__details')[0].split()[1])
            if key == 'floorplan':
                core_util = value.get('design__instance__design__util')
            if key == 'detailedroute':
                num_drc = value.get('route__drc_errors__count')
                wirelength = value.get('route__wirelength')
            if key == 'finish':
                worst_slack = value.get('timing__setup__ws')
                total_power = value.get('power__total')
                final_util = value.get('design__instance__utilization')
        ret = {
            "clk_period": clk_period,
            "worst_slack": worst_slack,
            "wirelength": wirelength,
            "num_drc": num_drc,
            "total_power": total_power,
            "core_util": core_util,
            "final_util": final_util
        }
        return ret


class EffClkPeriod(AxPPA):
    '''
    EffClkPeriod
    '''

    def evaluate(self, metrics):
        error = 'ERR' in metrics.values()
        not_found = 'N/A' in metrics.values()
        if error or not_found:
            return (99999999999) * (self.step_ / 100)**(-1)
        gamma = (metrics['clk_period'] - metrics['worst_slack']) / 10
        score = metrics['clk_period'] - metrics['worst_slack']
        score = (self.step_ / 100)**(-1) + gamma * metrics['num_drc']
        return score


class PPA(AxPPA):
    '''
    PPA
    '''

    def evaluate(self, metrics):
        error = 'ERR' in metrics.values()
        not_found = 'N/A' in metrics.values()
        if error or not_found:
            return (99999999999) * (self.step_ / 100)**(-1)
        # eff_clk_period -100~100 -> multiply 100
        # area (100/metrics['final_util']), 0~100 -> multiply 1
        # metrics['total_power'] 0~ about 0.1 -> muliply 1
        if metrics['worst_slack'] > 0:
            eff_clk_period = metrics['clk_period']
        else:
            eff_clk_period = (metrics['clk_period'] - metrics['worst_slack'])
        ppa = 100 / metrics['final_util'] + (metrics['total_power'] * 10)
        ppa += 100
        ppa *= eff_clk_period
        gamma = ppa / 10
        score = ppa * (self.step_ / 100)**(-1) + (gamma * metrics['num_drc'])
        return score


class PPAImprov(AxPPA):
    '''
    PPAImprov
    '''

    @classmethod
    def get_ppa(cls, metrics):
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
        area = percent(100 - reference['final_util'],
                       100 - metrics['final_util'])

        # lower values of ppa are better.
        ppa_upper_bound = (coeff_perform + coeff_power + coeff_area) * 100
        ppa = performance * coeff_perform
        ppa += power * coeff_power
        ppa += area * coeff_area
        return ppa_upper_bound - ppa

    def evaluate(self, metrics):
        error = 'ERR' in metrics.values() or 'ERR' in reference.values()
        not_found = 'N/A' in metrics.values() or 'N/A' in reference.values()
        if error or not_found:
            return (99999999999) * (self.step_ / 100)**(-1)
        ppa = self.get_ppa(metrics)
        gamma = ppa / 10
        score = ppa * (self.step_ / 100)**(-1) + (gamma * metrics['num_drc'])
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
    with open(file_name) as file:
        data = json.load(file)
    config = {}
    for key, value in data['param'].items():
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
    return config, data['space']


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
        export_command += ' && '
    else:
        export_command = ''

    make_command = export_command
    make_command += f'make -C {run_dir}/orfs/flow DESIGN_CONFIG=designs/'
    make_command += f'{args.platform}/{args.design}/config.mk'
    make_command += f' FLOW_VARIANT={flow_variant} {parameters}'
    make_command += f' NPROC={CPUS}'
    make_command += ' > make-finish-stdout.log 2> make-finish-stderr.log'
    os.system(make_command)

    metrics_file = os.path.join(os.getcwd(), 'metrics.json')
    metrics_command = export_command
    metrics_command += f'{run_dir}/orfs/flow/util/genMetrics.py -x'
    metrics_command += f' -v {flow_variant}'
    metrics_command += f' -d {args.design}'
    metrics_command += f' -p {args.platform}'
    metrics_command += f' -o {metrics_file}'
    metrics_command += ' > metrics-stdout.log 2> metrics-stderr.log'
    os.system(metrics_command)

    return metrics_file


@ray.remote
def nfs_setup(path):
    '''
    Clone ORFS repo and compile binaries inside a NFS shared folder.
    '''
    git_command = f'echo "Remote folder: {path}"'
    git_command += f' && mkdir -p {path}'
    if args.git_clone:
        git_command += f' && rm -rf {path}/orfs'
    if not os.path.isdir(f'{path}/orfs/.git'):
        git_command += ' && git clone --depth 1 --recursive --single-branch'
        git_command += f' {args.git_clone_args}'
        if args.git_orfs_branch != '':
            git_command += f' --branch {args.git_orfs_branch}'
        git_command += f' {args.git_url} {path}/orfs'
    git_command += f' && cd {path}/orfs'
    if args.git_clean:
        git_command += ' && git clean -xdf tools'
        git_command += ' && git submodule foreach --recursive git clean -xdf'
    if not os.path.isfile(f'{path}/orfs/tools/install/OpenROAD/bin/openroad'):
        build_command = './build_openroad.sh --local --threads {BUILD_CPUS}'
        if args.git_latest:
            build_command += ' --latest'
        build_command += f' {args.build_args}'
        git_command += f' && bash -ic "{build_command}"'
    print(f'[INFO TUN-0000] Git command: {git_command}')
    os.system(git_command)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    # Setup
    parser.add_argument(
        '--git-clean',
        action='store_true',
        help='Clean binaries and build files.'
             ' WARNING: may lose previous data.'
             ' Use carfully.')
    parser.add_argument(
        '--git-clone',
        action='store_true',
        help='Force new git clone.'
             ' WARNING: may lose previous data.'
             ' Use carfully.')
    parser.add_argument(
        '--git-clone-args',
        type=str,
        required=False,
        default='',
        help='Additional git clone arugments.')
    parser.add_argument(
        '--git-latest',
        action='store_true',
        help='Use latest version of OpenROAD app.')
    parser.add_argument(
        '--git-or-branch',
        type=str,
        required=False,
        default='',
        help='OpenROAD app branch to use.')
    parser.add_argument(
        '--git-orfs-branch',
        type=str,
        required=False,
        default='master',
        help='OpenROAD-flow-scripts branch to use.')
    parser.add_argument(
        '--git-url',
        type=str,
        required=False,
        default=ORFS_URL,
        help='OpenROAD-flow-scripts repo URL to use.')
    parser.add_argument(
        '--build-args',
        type=str,
        required=False,
        default='',
        help='Additional arguments givent to ./build_openroad.sh.')

    # DUT
    parser.add_argument(
        '--design',
        type=str,
        required=False,
        default='gcd',
        help='Name of the design for Autotuning.')
    parser.add_argument(
        '--platform',
        type=str,
        required=False,
        default='sky130hd',
        help='Name of the platform for Autotuning.')

    # Experiment Setup
    parser.add_argument(
        '--experiment',
        type=str,
        required=False,
        default='test-hyperopt',
        help='Experiment name. This parameter is used to prefix the'
        ' FLOW_VARIANT and to set the Ray log destination.')
    parser.add_argument(
        '--config',
        type=str,
        default='util/autotuner.json',
        required=False,
        help='Configuration file that sets which knobs to use for Autotuning.')
    parser.add_argument(
        '--resume',
        action='store_true',
        help='Resume previous run.')

    # ML
    parser.add_argument(
        '--algorithm',
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
        '--samples',
        type=int,
        required=False,
        default=10,
        help='Number of samples for tunning.')
    parser.add_argument(
        '--reference',
        type=str,
        default=None,
        required=False,
        help='Reference file for use with PPAImprov.')
    parser.add_argument(
        '--perturbation',
        type=int,
        default=25,
        required=False,
        help='Perturbation interval for PopulationBasedTraining.')
    parser.add_argument(
        '--seed',
        type=int,
        default=42,
        required=False,
        help='Random seed.')

    # Workload
    parser.add_argument(
        '--jobs',
        type=int,
        required=False,
        default=math.floor(multiprocessing.cpu_count() / 2),
        help='Max number of concurrent jobs.')
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
        _ = ray.get(results)
        print('[INFO TUN-0001] Done waiting.')
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
        # TODO need to fix config_dict format
        ax.create_experiment(
            name=f'{args.platform}/{args.design}/{args.experiment}',
            parameters=config_dict,
            objective_name="minimum",
            minimize=True
        )
        search_algo = AxSearch(ax_client=ax,
                               points_to_evaluate=best_params,
                               max_concurrent=args.jobs)
    elif args.algorithm == 'nevergrad':
        # TODO need to fix Lower bound issue
        search_algo = NevergradSearch(
            points_to_evaluate=best_params,
            optimizer=ng.optimizers.registry["PortfolioDiscreteOnePlusOne"])
    elif args.algorithm == 'optuna':
        search_algo = OptunaSearch(points_to_evaluate=best_params,
                                   seed=args.seed)
    elif args.algorithm == 'pbt':
        # TODO need to fix config_dict format
        search_algo = PopulationBasedTraining(
            time_attr="training_iteration",
            perturbation_interval=args.perturbation,
            hyperparam_mutations=config_dict,
            synch=False
        )
    elif args.algorithm == 'random':
        search_algo = BasicVariantGenerator(max_concurrent=args.jobs)
    else:
        print(f'[ERROR TUN-0007] Invalid search algorithm: {args.algorithm}')
        sys.exit(1)

    if args.eval == 'default':
        TrainClass = AutotunerBase
    elif args.eval == 'eff-clk-period':
        TrainClass = EffClkPeriod
    elif args.eval == 'ppa':
        TrainClass = PPA
    elif args.eval == 'ppa-improv':
        TrainClass = PPAImprov
        if args.reference is None:
            print('''
                  [ERROR TUN-0009] --eval ppa-improv requries --reference flag
                  ''')
            sys.exit(1)
        reference = PPAImprov.read_metrics(args.reference)
    elif args.eval == 'ax-ppa':
        TrainClass = AxPPA
    else:
        print(f'[ERROR TUN-0008] Invalid evaluate function: {args.eval}')
        sys.exit(1)

    if args.algorithm != 'random':
        search_algo = ConcurrencyLimiter(search_algo, max_concurrent=args.jobs)

    analysis = tune.run(
        TrainClass,
        metric='minimum',
        mode='min',
        search_alg=search_algo,
        name=f'{args.platform}/{args.design}/{args.experiment}-{DATE}',
        scheduler=AsyncHyperBandScheduler(),
        num_samples=args.samples,
        config=config_dict,
        fail_fast=True,
        local_dir=local_dir,
        resume=args.resume,
        queue_trials=True
    )
    print(f'[INFO TUN-0002] Best parameters found: {analysis.best_config}')
    ray.shutdown()
