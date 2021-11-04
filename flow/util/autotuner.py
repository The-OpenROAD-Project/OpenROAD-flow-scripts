#!/usr/bin/env python3

'''
This scripts automatically tuning the input parameters. The user should
install python Ray and Tune package and corresponding searching algorithms.
Ray and Tune installation instruction can be found in below URL.
https://docs.ray.io/en/master/installation.html

User can decide the input parameter space by modifying 'autotuner.json'.
'''

import argparse
import hashlib
import json
from math import floor
import os
import re
import sys
from datetime import datetime
from multiprocessing import cpu_count
from subprocess import run

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

DATE = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
ORFS_URL = 'https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts'
AUTOTUNER_BEST = 'autotuner-best.json'
VALID_ALGORITHMS = ['hyperopt',
                    'axppa',
                    'nevergrad',
                    'optuna',
                    'pbt',
                    'random']
VALID_EVAL_FN = ['default', 'eff-clk-period', 'ppa', 'ppa-improv', 'ax-ppa']


def run_command(cmd, check=True):
    '''
    Wrapper for subprocess.run
    Allows to run shell command, control print and exceptions.
    '''
    process = run(cmd, capture_output=True, text=True, check=check, shell=True)
    if args.verbose >= 1:
        print(process.stderr)
    if args.verbose >= 2:
        print(process.stdout)
    return process


class AutotunerBase(tune.Trainable):
    '''
    Autotuner base class for experiments.
    '''

    def setup(self, config):
        '''
        Setup current experiment step.
        '''
        repo_dir = os.getcwd() + '/../../../../'
        if args.server is not None:
            repo_dir += 'orfs'
        else:
            repo_dir += '/../../'
        self.repo_dir = os.path.abspath(repo_dir)
        self.parameters, sdc, fast_route = parse_config(config)
        if bool(sdc):
            sdc_file_path = write_sdc(os.getcwd(), sdc)
            self.parameters += f' SDC_FILE={sdc_file_path}'
        if bool(fast_route):
            fast_route_file_path = write_fast_route(os.getcwd(), fast_route)
            self.parameters += f' FASTROUTE_TCL={fast_route_file_path}'
        self.flow_variant = get_flow_variant(self.parameters)
        self.step_ = 0

    def step(self):
        '''
        Run step experiment and compute its score.
        '''
        metrics_file = run_openroad(self.repo_dir,
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
                num_drc = value['route__drc_errors__count']
                wirelength = value['route__wirelength']
            if key == 'finish':
                worst_slack = value['timing__setup__ws']
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
            if key == 'constraints' and len(value['clocks__details']) > 0:
                clk_period = float(value['clocks__details'][0].split()[1])
            if key == 'floorplan':
                core_util = value['design__instance__design__util']
            if key == 'detailedroute':
                num_drc = value['route__drc_errors__count']
                wirelength = value['route__wirelength']
            if key == 'finish':
                worst_slack = value['timing__setup__ws']
                total_power = value['power__total']
                final_util = value['design__instance__utilization']
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

        # Lower values of PPA are better.
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
    def read(path):
        with open(os.path.abspath(path), 'r') as file:
            ret = file.read()
        return ret
    with open(file_name) as file:
        data = json.load(file)
    sdc_file = ''
    fr_file = ''
    config = {}
    for key, value in data.items():
        if key == '_SDC_FILE_PATH' and value != '':
            if sdc_file != '':
                print('[WARNING TUN-0004] Overwriting SDC base file.')
            sdc_file = read(f'{os.path.dirname(file_name)}/{value}')
            continue
        if key == '_FR_FILE_PATH' and value != '':
            if fr_file != '':
                print('[WARNING TUN-0005] Overwriting FastRoute base file.')
            fr_file = read(f'{os.path.dirname(file_name)}/{value}')
            continue
        min_, max_ = value['minmax']
        if min_ == max_:
            config[key] = min_
        elif value['type'] == 'int':
            if value['step'] == 1:
                config[key] = tune.randint(min_, max_)
            else:
                config[key] = tune.qrandint(min_, max_, value['step'])
        elif value['type'] == 'float':
            if value['step'] == 0:
                config[key] = tune.uniform(min_, max_)
            else:
                config[key] = tune.quniform(min_, max_, value['step'])
    # Copy back to global variables
    return config, sdc_file, fr_file


def parse_config(config):
    '''
    Parse configuration received from tune into make variables.
    '''
    options = ''
    sdc = {}
    fast_route = {}
    for key, value in config.items():
        # Keys that begin with underscore need special handling.
        if key.startswith('_'):
            # Variables to be injected into fastroute.tcl
            if key.startswith('_FR_'):
                fast_route[key.replace('_FR_', '', 1)] = value
            # Variables to be injected into constraints.sdc
            elif key.startswith('_SDC_'):
                sdc[key.replace('_SDC_', '', 1)] = value
            # Special substitution cases
            elif key == "_PINS_DISTANCE":
                options += f' PLACE_PINS_ARGS="-min_distance {value}"'
            elif key == "_SYNTH_FLATTEN" and value == 1:
                options += ' SYNTH_ARGS=""'
        # Default case is VAR=VALUE
        else:
            options += f' {key}={value}'
    return options, sdc, fast_route


def write_sdc(path, variables):
    '''
    Create a SDC file with parameters for current tuning iteration.
    '''
    # TODO: handle case where the reference file does not exist
    new_file = SDC_FILE
    for key, value in variables.items():
        if key == 'CLK_PERIOD':
            new_file = re.sub(r'-period [0-9\.]+ (.*)',
                              f'-period {value} \\1',
                              new_file)
            new_file = re.sub(r'-waveform [{}\s0-9\.]+[\s|\n]',
                              '',
                              new_file)
        elif key == 'UNCERTAINTY':
            if new_file.find('set uncertainty') != -1:
                new_file = re.sub(r'set uncertainty .*\n(.*)',
                                  f'set uncertainty {value}\n\\1',
                                  new_file)
            else:
                new_file += f'\nset uncertainty {value}\n'
        elif key == "IO_DELAY":
            if new_file.find('set io_delay') != -1:
                new_file = re.sub(r'set io_delay .*\n(.*)',
                                  f'set io_delay {value}\n\\1',
                                  new_file)
            else:
                new_file += f'\nset io_delay {value}\n'
    file_name = path + '/constraints.sdc'
    with open(file_name, 'w') as file:
        file.write(new_file)
    return file_name


def write_fast_route(path, variables):
    '''
    Create a FastRoute Tcl file with parameters for current tuning iteration.
    '''
    # TODO: handle case where the reference file does not exist
    layer_cmd = 'set_global_routing_layer_adjustment'
    new_file = FR_FILE
    for key, value in variables.items():
        if key.startswith('LAYER_ADJUST'):
            layer = key.lstrip('LAYER_ADJUST')
            # If there is no suffix (i.e., layer name) apply adjust to all
            # layers.
            if layer == '':
                new_file += '\nset_global_routing_layer_adjustment'
                new_file += ' $::env(MIN_ROUTING_LAYER)'
                new_file += '-$::env(MAX_ROUTING_LAYER)'
                new_file += f' {value}'
            elif re.search(f'{layer_cmd}.*{layer}', new_file):
                new_file = re.sub(f'({layer_cmd}.*{layer}).*\n(.*)',
                                  f'\\1 {value}\n\\2',
                                  new_file)
            else:
                new_file += f'\n{layer_cmd} {layer} {value}\n'
        elif key == 'GR_SEED':
            new_file += f'\nset_global_routing_random -seed {value}\n'
    file_name = path + '/fastroute.tcl'
    with open(file_name, 'w') as file:
        file.write(new_file)
    return file_name


def get_flow_variant(parameters):
    '''
    Create a hash based on the parameters. This way we don't need to re-run
    experiments with the same configuration.
    '''
    variant_hash = hashlib.md5(parameters.encode('utf-8')).hexdigest()
    with open(os.path.join(os.getcwd() + '/variant_hash.txt'), 'w') as file:
        file.write(variant_hash)
    return f'{args.experiment}/variant-{variant_hash}'


def run_openroad(repo_dir, flow_variant, parameters):
    '''
    Run OpenROAD-flow-scripts with a given set of parameters.
    '''

    export_command = f'export PATH={INSTALL_PATH}/OpenROAD/bin'
    export_command += f':{INSTALL_PATH}/yosys/bin'
    export_command += f':{INSTALL_PATH}/LSOracle/bin:$PATH'
    export_command += ' && '

    make_command = export_command
    make_command += f'make -C {repo_dir}/flow DESIGN_CONFIG=designs/'
    make_command += f'{args.platform}/{args.design}/config.mk'
    make_command += f' FLOW_VARIANT={flow_variant} {parameters}'
    make_command += f' NPROC={args.openroad_threads}'
    # check=False -> does not raise expetion so that Ray does not stop.
    process = run_command(make_command, check=False)
    with open('error-make-finish.log', 'w+') as file:
        file.write(f'\n{process.stderr}')
    with open('make-finish-stdout.log', 'w+') as file:
        file.write(f'\n{process.stdout}')

    metrics_file = os.path.join(os.getcwd(), 'metrics.json')
    metrics_command = export_command
    metrics_command += f'{repo_dir}/flow/util/genMetrics.py -x'
    metrics_command += f' -v {flow_variant}'
    metrics_command += f' -d {args.design}'
    metrics_command += f' -p {args.platform}'
    metrics_command += f' -o {metrics_file}'
    # check=False -> does not raise expetion so that Ray does not stop.
    process = run_command(metrics_command, check=False)
    with open('error-metrics.log', 'w+') as file:
        file.write(f'\n{process.stderr}')
    with open('metrics-stdout.log', 'w+') as file:
        file.write(f'\n{process.stdout}')

    return metrics_file


def clone(path):
    '''
    Clone base repo in the remote machine. Only used for Kubernetes at GCP.
    '''
    if args.git_clone:
        run_command(f'rm -rf {path}/orfs')
    if not os.path.isdir(f'{path}/orfs/.git'):
        git_command = 'git clone --depth 1 --recursive --single-branch'
        git_command += f' {args.git_clone_args}'
        if args.git_orfs_branch != '':
            git_command += f' --branch {args.git_orfs_branch}'
        git_command += f' {args.git_url} {path}/orfs'
        run_command(git_command)


def build(base, install):
    '''
    Build OpenROAD, Yosys and other dependencies.
    '''
    build_command = f'cd {base}/orfs'
    if args.git_clean:
        build_command += ' && git clean -xdf tools'
        build_command += ' && git submodule foreach --recursive git clean -xdf'
    if args.git_clean \
            or not os.path.isfile(f'{install}/OpenROAD/bin/openroad') \
            or not os.path.isfile(f'{install}/yosys/bin/yosys') \
            or not os.path.isfile(f'{install}/LSOracle/bin/lsoracle'):
        build_command += ' && ./build_openroad.sh'
        # Some GCP machines have 200+ cores. Let's be reasonable...
        # build_command += f' --local --nice --threads {min(cpu_count(), 60)}'
        build_command += f' --local --nice --threads {cpu_count()})'
        if args.git_latest:
            build_command += ' --latest'
        build_command += f' {args.build_args}'
    run_command(build_command)


@ray.remote
def run_setup(base):
    '''
    Clone ORFS repository and compile binaries.
    '''
    print(f'[INFO TUN-0000] Remote folder: {base}')
    if not os.path.isdir(base):
        run_command(f'mkdir -p {base}')
    install = f'{base}/orfs/tools/install'
    if args.server is not None:
        clone(base)
    build(base, install)
    return install


def parse_arguments():
    '''
    Parse arguments from command line.
    '''
    parser = argparse.ArgumentParser()

    # DUT
    parser.add_argument(
        '--design',
        type=str,
        metavar='<gcd,jpeg,ibex,aes,...>',
        required=True,
        help='Name of the design for Autotuning.')
    parser.add_argument(
        '--platform',
        type=str,
        metavar='<sky130hd,sky130hs,asap7,...>',
        required=True,
        help='Name of the platform for Autotuning.')

    # Experiment Setup
    parser.add_argument(
        '--config',
        type=str,
        metavar='<path>',
        required=True,
        help='Configuration file that sets which knobs to use for Autotuning.')
    parser.add_argument(
        '--resume',
        action='store_true',
        help='Resume previous run.')
    parser.add_argument(
        '--experiment',
        type=str,
        metavar='<str>',
        default='test-hyperopt',
        help='Experiment name. This parameter is used to prefix the'
        ' FLOW_VARIANT and to set the Ray log destination.')

    # Setup
    parser.add_argument(
        '--git-clean',
        action='store_true',
        help='Clean binaries and build files.'
             ' WARNING: may lose previous data.'
             ' Use carefully.')
    parser.add_argument(
        '--git-clone',
        action='store_true',
        help='Force new git clone.'
             ' WARNING: may lose previous data.'
             ' Use carefully.')
    parser.add_argument(
        '--git-clone-args',
        type=str,
        metavar='<str>',
        default='',
        help='Additional git clone arguments.')
    parser.add_argument(
        '--git-latest',
        action='store_true',
        help='Use latest version of OpenROAD app.')
    parser.add_argument(
        '--git-or-branch',
        type=str,
        metavar='<str>',
        default='',
        help='OpenROAD app branch to use.')
    parser.add_argument(
        '--git-orfs-branch',
        type=str,
        metavar='<str>',
        default='master',
        help='OpenROAD-flow-scripts branch to use.')
    parser.add_argument(
        '--git-url',
        type=str,
        metavar='<url>',
        default=ORFS_URL,
        help='OpenROAD-flow-scripts repo URL to use.')
    parser.add_argument(
        '--build-args',
        type=str,
        metavar='<str>',
        default='',
        help='Additional arguments given to ./build_openroad.sh.')

    # ML
    parser.add_argument(
        '--algorithm',
        type=str,
        metavar=f'<{", ".join(VALID_ALGORITHMS)}>',
        default='hyperopt',
        help='Search algorithm to use for Autotuning.')
    parser.add_argument(
        '--eval',
        type=str,
        metavar=f'<{", ".join(VALID_EVAL_FN)}>',
        default='default',
        help='Evaluate function to use with search algorithm.')
    parser.add_argument(
        '--samples',
        type=int,
        metavar='<int>',
        default=10,
        help='Number of samples for tuning.')
    parser.add_argument(
        '--iterations',
        type=int,
        metavar='<int>',
        default=1,
        help='Number of iterations for tuning.')
    parser.add_argument(
        '--reference',
        type=str,
        metavar='<path>',
        default=None,
        help='Reference file for use with PPAImprov.')
    parser.add_argument(
        '--perturbation',
        type=int,
        metavar='<int>',
        default=25,
        help='Perturbation interval for PopulationBasedTraining.')
    parser.add_argument(
        '--seed',
        type=int,
        metavar='<int>',
        default=42,
        help='Random seed.')

    # Workload
    parser.add_argument(
        '--jobs',
        type=int,
        metavar='<int>',
        default=floor(cpu_count() / 2),
        help='Max number of concurrent jobs.')
    parser.add_argument(
        '--openroad-threads',
        type=int,
        metavar='<int>',
        default=16,
        help='Max number of threads openroad can use.')
    parser.add_argument(
        '--server',
        type=str,
        metavar='<ip|servername>',
        default=None,
        help='The address of Ray server to connect.')
    parser.add_argument(
        '--port',
        type=int,
        metavar='<int>',
        default=10001,
        help='The port of Ray server to connect.')

    parser.add_argument(
        '-v', '--verbose',
        action='count',
        default=0,
        help='Verbosity level.\n\t0: only print Ray status\n\t1: also print'
        ' training stderr\n\t2: also print training stdout.')

    arguments = parser.parse_args()
    arguments.algorithm = arguments.algorithm.lower()
    return arguments


def set_algorithm(name):
    '''
    Configure search algorithm.
    '''
    if args.algorithm not in VALID_ALGORITHMS:
        print(f'[ERROR TUN-0006] Invalid search algorithm: {args.algorithm}.'
              f' Choose one of {VALID_ALGORITHMS}.')
        sys.exit(1)
    if args.algorithm == 'hyperopt':
        algorithm = HyperOptSearch(points_to_evaluate=best_params)
    elif args.algorithm == 'axppa':
        ax_client = AxClient(enforce_sequential_optimization=False)
        # TODO need to fix config_dict format
        ax_client.create_experiment(
            name=name,
            parameters=config_dict,
            objective_name="minimum",
            minimize=True
        )
        algorithm = AxSearch(ax_client=ax_client,
                             points_to_evaluate=best_params,
                             max_concurrent=args.jobs)
    elif args.algorithm == 'nevergrad':
        # TODO need to fix Lower bound issue
        algorithm = NevergradSearch(
            points_to_evaluate=best_params,
            optimizer=ng.optimizers.registry["PortfolioDiscreteOnePlusOne"]
        )
    elif args.algorithm == 'optuna':
        algorithm = OptunaSearch(points_to_evaluate=best_params,
                                 seed=args.seed)
    elif args.algorithm == 'pbt':
        # TODO need to fix config_dict format
        algorithm = PopulationBasedTraining(
            time_attr="training_iteration",
            perturbation_interval=args.perturbation,
            hyperparam_mutations=config_dict,
            synch=False
        )
    elif args.algorithm == 'random':
        algorithm = BasicVariantGenerator(max_concurrent=args.jobs)
    if args.algorithm != 'random':
        algorithm = ConcurrencyLimiter(algorithm, max_concurrent=args.jobs)
    return algorithm


def set_best_params(platform, design):
    '''
    Get current known best parameters if it exists.
    '''
    params = []
    best_param_file = f'designs/{platform}/{design}'
    best_param_file += '/{AUTOTUNER_BEST}'
    if os.path.isfile(best_param_file):
        with open(best_param_file) as file:
            params = json.load(file)
    return params


def set_training_class(function):
    '''
    Set training class.
    '''
    if function not in VALID_EVAL_FN:
        print(f'[ERROR TUN-0008] Invalid evaluate function: {function}.'
              f' Choose one of {VALID_EVAL_FN}.')
        sys.exit(1)
    if function == 'default':
        return AutotunerBase
    if function == 'eff-clk-period':
        return EffClkPeriod
    if function == 'ppa':
        return PPA
    if function == 'ppa-improv':
        if args.reference is None:
            print('[ERROR TUN-0007] The argument "--eval ppa-improv"'
                  ' requries that "--reference <FILE>" is also given.')
            sys.exit(1)
        return PPAImprov
    if function == 'ax-ppa':
        return AxPPA


if __name__ == '__main__':
    args = parse_arguments()
    experiment_name = f'{args.platform}/{args.design}/{args.experiment}'
    config_dict, SDC_FILE, FR_FILE = read_config(os.path.abspath(args.config))
    best_params = set_best_params(args.platform, args.design)
    search_algo = set_algorithm(experiment_name)
    TrainClass = set_training_class(args.eval)
    # PPAImprov requires a reference metrics file to compute training scores.
    if args.eval == 'ppa-improv':
        reference = PPAImprov.read_metrics(args.reference)

    # Connect to remote Ray server if any, otherwise will run locally
    if args.server is not None:
        # At GCP we have a NFS folder that is present for all worker nodes.
        # This allows to build required binaries once. We clone, build and
        # store intermediate files at LOCAL_DIR. The RUN variable helps to id
        # different runs and also continue experiments that crash.
        with open(args.config) as config_file:
            LOCAL_DIR = '/shared-data/autotuner'
            LOCAL_DIR += f'-orfs:{args.git_orfs_branch}'
            if args.git_or_branch != '':
                LOCAL_DIR += f'-or:{args.git_or_branch}'
            if args.git_latest != '':
                LOCAL_DIR += '-or:latest'
            RUN = hashlib.md5(config_file.read().encode('utf-8')).hexdigest()
            LOCAL_DIR += f'/{RUN}'
        # Connect to ray server before first remote execution.
        ray.init(f'ray://{args.server}:{args.port}')
        # Remote functions return a task id and are non-blocking, thus we call
        # ray.get() to wait for its completion and get the function return
        # value.
        INSTALL_PATH = ray.get(run_setup.remote(LOCAL_DIR))
        print('[INFO TUN-0001] Done waiting.')
    else:
        # For local runs, use the same folder as other ORFS utilities.
        os.chdir(os.path.dirname(os.path.abspath(__file__)) + '/../')
        LOCAL_DIR = 'logs'
        INSTALL_PATH = '../tools/install'

    analysis = tune.run(
        TrainClass,
        metric='minimum',
        mode='min',
        search_alg=search_algo,
        name=f'{experiment_name}-{DATE}',
        scheduler=AsyncHyperBandScheduler(),
        num_samples=args.samples,
        config=config_dict,
        fail_fast=True,
        local_dir=LOCAL_DIR,
        resume=args.resume,
        stop={"training_iteration": args.iterations},
        queue_trials=True
    )
    ray.shutdown()
    print(f'[INFO TUN-0002] Best parameters found: {analysis.best_config}')
    new_best_path = f'{LOCAL_DIR}/{experiment_name}-{DATE}/{AUTOTUNER_BEST}'
    with open(new_best_path, 'w') as new_best_file:
        json.dump(analysis.best_config, new_best_file, indent=4)
    print(f'[INFO TUN-0003] Best parameters written to {new_best_path}')
