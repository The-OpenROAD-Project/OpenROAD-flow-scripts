'''
This scripts handles sweeping and tuning of OpenROAD-flow-scripts parameters.
Dependencies are documented in pip format at distributed-requirements.txt

For both sweep and tune modes:
    python3 distributed.py -h

Note: the order of the parameters matter. Arguments --design, --platform and
--config are always required and should preceed the <mode>.

AutoTuner:
    python3 distributed.py tune -h
    python3 distributed.py --design gcd --platform sky130hd \
                           --config ../designs/sky130hd/gcd/autotuner.json \
                           tune
    Example:

Parameter sweeping:
    python3 distributed.py sweep -h
    Example:
    python3 distributed.py --design gcd --platform sky130hd \
                           --config distributed-sweep-example.json \
                           sweep
'''

import argparse
import hashlib
import json
import os
from os.path import abspath
import re
import sys
from datetime import datetime
from multiprocessing import cpu_count
from subprocess import run
import numpy as np

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
FASTROUTE_TCL = 'fastroute.tcl'
CONSTRAINTS_SDC = 'constraint.sdc'


class AutoTunerBase(tune.Trainable):
    '''
    AutoTuner base class for experiments.
    '''

    def setup(self, config):
        '''
        Setup current experiment step.
        '''
        # We create the following directory structure:
        #      1/     2/         3/       4/                5/   6/
        # <repo>/<logs>/<platform>/<design>/<experiment>-DATE/<id>/<cwd>
        repo_dir = os.getcwd() + '/../' * 6
        self.repo_dir = abspath(repo_dir)
        self.parameters = parse_config(config, path=os.getcwd())
        self.step_ = 0

    def step(self):
        '''
        Run step experiment and compute its score.
        '''
        metrics_file = openroad(self.repo_dir, self.parameters)
        self.step_ += 1
        score = self.evaluate(self.read_metrics(metrics_file))
        # Feed the score back to Tune.
        # return must match 'metric' used in tune.run()
        return {"minimum": score}

    def evaluate(self, metrics):
        '''
        User-defined evaluation function.
        It can change in any form to minimize the score (return value).
        Default evaluation function optimizes effective clock period.
        '''
        error = 'ERR' in metrics.values()
        not_found = 'N/A' in metrics.values()
        if error or not_found:
            return (99999999999) * (self.step_ / 100)**(-1)
        gamma = (metrics['clk_period'] - metrics['worst_slack']) / 10
        score = metrics['clk_period'] - metrics['worst_slack']
        score = (self.step_ / 100)**(-1) + gamma * metrics['num_drc']
        return score

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
        for stage, value in data.items():
            if stage == 'constraints' and len(value['clocks__details']) > 0:
                clk_period = float(value['clocks__details'][0].split()[1])
            if stage == 'floorplan' \
                    and 'design__instance__utilization' in value:
                core_util = value['design__instance__utilization']
            if stage == 'detailedroute' and 'route__drc_errors' in value:
                num_drc = value['route__drc_errors']
            if stage == 'detailedroute' and 'route__wirelength' in value:
                wirelength = value['route__wirelength']
            if stage == 'finish' and 'timing__setup__ws' in value:
                worst_slack = value['timing__setup__ws']
            if stage == 'finish' and 'power__total' in value:
                total_power = value['power__total']
            if stage == 'finish' and 'design__instance__utilization' in value:
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


class PPAImprov(AutoTunerBase):
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
        with open(abspath(path), 'r') as file:
            ret = file.read()
        return ret

    def read_sweep(this):
        return [*this['minmax'], this['step']]

    def read_tune(this):
        min_, max_ = this['minmax']
        if min_ == max_:
            # Returning a choice of a single element allow pbt algorithm to
            # work. pbt does not accept single values as tunable.
            return tune.choice([min_])
        if this['type'] == 'int':
            if min_ == 0 and args.algorithm == 'nevergrad':
                print('[WARNING TUN-0011] NevergradSearch may not work '
                      'with lowerbound value 0.')
            if this['step'] == 1:
                return tune.randint(min_, max_)
            return tune.qrandint(min_, max_, this['step'])
        if this['type'] == 'float':
            if this['step'] == 0:
                return tune.uniform(min_, max_)
            return tune.quniform(min_, max_, this['step'])
        return None

    def read_tune_ax(name, this):
        dict_ = dict(name=name)
        min_, max_ = this['minmax']
        if min_ == max_:
            dict_["type"] = "fixed"
            dict_["value"] = min_
        elif this['type'] == 'int':
            if this['step'] == 1:
                dict_["type"] = "range"
                dict_["bounds"] = [min_, max_]
                dict_["value_type"] = "int"
            else:
                dict_["type"] = "choice"
                dict_["values"] = tune.randint(min_, max_, this['step'])
                dict_["value_type"] = "int"
        elif this['type'] == 'float':
            if this['step'] == 1:
                dict_["type"] = "choice"
                dict_["values"] = tune.quniform(min_, max_, this['step'])
                dict_["value_type"] = "float"
            else:
                dict_["type"] = "range"
                dict_["bounds"] = [min_, max_]
                dict_["value_type"] = "float"
        return dict_

    with open(file_name) as file:
        data = json.load(file)
    sdc_file = ''
    fr_file = ''
    if args.mode == 'tune' and args.algorithm == 'ax':
        config = list()
    else:
        config = dict()
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
        if not isinstance(value, dict):
            config[key] = value
        elif args.mode == 'sweep':
            config[key] = read_sweep(value)
        elif args.mode == 'tune' and args.algorithm != 'ax':
            config[key] = read_tune(value)
        elif args.mode == 'tune' and args.algorithm == 'ax':
            config.append(read_tune_ax(key, value))
    # Copy back to global variables
    return config, sdc_file, fr_file


def parse_config(config, path=os.getcwd()):
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
    if bool(sdc):
        write_sdc(sdc, path)
        options += f' SDC_FILE={path}/{CONSTRAINTS_SDC}'
    if bool(fast_route):
        write_fast_route(fast_route, path)
        options += f' FASTROUTE_TCL={path}/{FASTROUTE_TCL}'
    return options


def write_sdc(variables, path):
    '''
    Create a SDC file with parameters for current tuning iteration.
    '''
    # TODO: handle case where the reference file does not exist
    new_file = SDC_ORIGINAL
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
    file_name = path + f'/{CONSTRAINTS_SDC}'
    with open(file_name, 'w') as file:
        file.write(new_file)
    return file_name


def write_fast_route(variables, path):
    '''
    Create a FastRoute Tcl file with parameters for current tuning iteration.
    '''
    # TODO: handle case where the reference file does not exist
    layer_cmd = 'set_global_routing_layer_adjustment'
    new_file = FR_ORIGINAL
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
    file_name = path + f'/{FASTROUTE_TCL}'
    with open(file_name, 'w') as file:
        file.write(new_file)
    return file_name


def get_flow_variant(param):
    '''
    Create a hash based on the parameters. This way we don't need to re-run
    experiments with the same configuration.
    '''
    variant_hash = hashlib.md5(f"{param}".encode('utf-8')).hexdigest()
    if args.mode == 'tune':
        with open(os.path.join(os.getcwd(), 'variant_hash.txt'), 'w') as file:
            file.write(variant_hash)
    return f'{args.experiment}/variant-{variant_hash}'


def run_command(cmd, stderr_file=None, stdout_file=None, fail_fast=False):
    '''
    Wrapper for subprocess.run
    Allows to run shell command, control print and exceptions.
    '''
    process = run(cmd, capture_output=True, text=True, check=False, shell=True)
    if stderr_file is not None and process.stderr != '':
        with open(stderr_file, 'a') as file:
            file.write(f'\n\n{cmd}\n{process.stderr}')
    if stdout_file is not None and process.stdout != '':
        with open(stdout_file, 'a') as file:
            file.write(f'\n\n{cmd}\n{process.stdout}')
    if args.verbose >= 1:
        print(process.stderr)
    if args.verbose >= 2:
        print(process.stdout)

    if fail_fast and process.returncode != 0:
        raise RuntimeError


@ray.remote
def openroad_distributed(repo_dir, config, path):
    ''' Simple wrapper to run openroad distributed with Ray. '''
    config = parse_config(config)
    openroad(repo_dir, config, path=path)


def openroad(base_dir, parameters, path=''):
    '''
    Run OpenROAD-flow-scripts with a given set of parameters.
    '''
    # Make sure path ends in a slash, i.e., is a folder
    flow_variant = get_flow_variant(parameters)
    if path != '':
        log_path = f'{path}/{flow_variant}/'
        report_path = log_path.replace('logs', 'reports')
        os.system(f'mkdir -p {log_path}')
        os.system(f'mkdir -p {report_path}')
    else:
        log_path = report_path = os.getcwd() + '/'

    export_command = f'export PATH={INSTALL_PATH}/OpenROAD/bin'
    export_command += f':{INSTALL_PATH}/yosys/bin'
    export_command += f':{INSTALL_PATH}/LSOracle/bin:$PATH'
    export_command += ' && '

    make_command = export_command
    make_command += f'make -C {base_dir}/flow DESIGN_CONFIG=designs/'
    make_command += f'{args.platform}/{args.design}/config.mk'
    make_command += f' FLOW_VARIANT={flow_variant} {parameters}'
    make_command += f' NPROC={args.openroad_threads}'
    run_command(make_command,
                stderr_file=f'{log_path}error-make-finish.log',
                stdout_file=f'{log_path}make-finish-stdout.log')

    metrics_file = os.path.join(report_path, 'metrics.json')
    metrics_command = export_command
    metrics_command += f'{base_dir}/flow/util/genMetrics.py -x'
    metrics_command += f' -v {flow_variant}'
    metrics_command += f' -d {args.design}'
    metrics_command += f' -p {args.platform}'
    metrics_command += f' -o {metrics_file}'
    run_command(metrics_command,
                stderr_file=f'{log_path}error-metrics.log',
                stdout_file=f'{log_path}metrics-stdout.log')

    return metrics_file


def clone(path):
    '''
    Clone base repo in the remote machine. Only used for Kubernetes at GCP.
    '''
    if args.git_clone:
        os.system(f'rm -rf {path}')
    if not os.path.isdir(f'{path}/.git'):
        git_command = 'git clone --depth 1 --recursive --single-branch'
        git_command += f' {args.git_clone_args}'
        git_command += f' --branch {args.git_orfs_branch}'
        git_command += f' {args.git_url} {path}'
        os.system(git_command)


def build(base, install):
    '''
    Build OpenROAD, Yosys and other dependencies.
    '''
    build_command = f'cd "{base}"'
    if args.git_clean:
        build_command += ' && git clean -xdf tools'
        build_command += ' && git submodule foreach --recursive git clean -xdf'
    if args.git_clean \
            or not os.path.isfile(f'{install}/OpenROAD/bin/openroad') \
            or not os.path.isfile(f'{install}/yosys/bin/yosys') \
            or not os.path.isfile(f'{install}/LSOracle/bin/lsoracle'):
        build_command += ' && bash -ic "./build_openroad.sh'
        # Some GCP machines have 200+ cores. Let's be reasonable...
        build_command += f' --local --nice --threads {min(32, cpu_count())}'
        if args.git_latest:
            build_command += ' --latest'
        build_command += f' {args.build_args}"'
    os.system(build_command)


@ray.remote
def setup_repo(base):
    '''
    Clone ORFS repository and compile binaries.
    '''
    print(f'[INFO TUN-0000] Remote folder: {base}')
    install = f'{base}/tools/install'
    if args.server is not None:
        clone(base)
    build(base, install)
    return install


def parse_arguments():
    '''
    Parse arguments from command line.
    '''
    parser = argparse.ArgumentParser()

    subparsers = parser.add_subparsers(help='mode of execution',
                                       dest='mode',
                                       required=True)
    tune_parser = subparsers.add_parser("tune")
    sweep_parser = subparsers.add_parser("sweep")

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
        '--experiment',
        type=str,
        metavar='<str>',
        default='test',
        help='Experiment name. This parameter is used to prefix the'
        ' FLOW_VARIANT and to set the Ray log destination.')
    tune_parser.add_argument(
        '--resume',
        action='store_true',
        help='Resume previous run.')

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
    tune_parser.add_argument(
        '--algorithm',
        type=str,
        choices=['hyperopt',
                 'ax',
                 'nevergrad',
                 'optuna',
                 'pbt',
                 'random'],
        default='hyperopt',
        help='Search algorithm to use for Autotuning.')
    tune_parser.add_argument(
        '--eval',
        type=str,
        choices=['default', 'ppa-improv'],
        default='default',
        help='Evaluate function to use with search algorithm.')
    tune_parser.add_argument(
        '--samples',
        type=int,
        metavar='<int>',
        default=10,
        help='Number of samples for tuning.')
    tune_parser.add_argument(
        '--iterations',
        type=int,
        metavar='<int>',
        default=1,
        help='Number of iterations for tuning.')
    tune_parser.add_argument(
        '--reference',
        type=str,
        metavar='<path>',
        default=None,
        help='Reference file for use with PPAImprov.')
    tune_parser.add_argument(
        '--perturbation',
        type=int,
        metavar='<int>',
        default=25,
        help='Perturbation interval for PopulationBasedTraining.')
    tune_parser.add_argument(
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
        default=int(np.floor(cpu_count() / 2)),
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
    if arguments.mode == 'tune':
        arguments.algorithm = arguments.algorithm.lower()
        # Validation of arguments
        if arguments.eval == 'ppa-improv' and arguments.reference is None:
            print('[ERROR TUN-0006] The argument "--eval ppa-improv"'
                  ' requries that "--reference <FILE>" is also given.')
            sys.exit(7)

    arguments.experiment += f'-{arguments.mode}-{DATE}'

    return arguments


def set_algorithm(experiment_name, config):
    '''
    Configure search algorithm.
    '''
    if args.algorithm == 'hyperopt':
        algorithm = HyperOptSearch(points_to_evaluate=best_params)
    elif args.algorithm == 'ax':
        ax_client = AxClient(enforce_sequential_optimization=False)
        ax_client.create_experiment(
            name=experiment_name,
            parameters=config,
            objective_name="minimum",
            minimize=True
        )
        algorithm = AxSearch(ax_client=ax_client,
                             points_to_evaluate=best_params,
                             max_concurrent=args.jobs)
    elif args.algorithm == 'nevergrad':
        algorithm = NevergradSearch(
            points_to_evaluate=best_params,
            optimizer=ng.optimizers.registry["PortfolioDiscreteOnePlusOne"]
        )
    elif args.algorithm == 'optuna':
        algorithm = OptunaSearch(points_to_evaluate=best_params,
                                 seed=args.seed)
    elif args.algorithm == 'pbt':
        algorithm = PopulationBasedTraining(
            time_attr="training_iteration",
            perturbation_interval=args.perturbation,
            hyperparam_mutations=config,
            synch=False
        )
    elif args.algorithm == 'random':
        algorithm = BasicVariantGenerator(max_concurrent=args.jobs)
    if args.algorithm not in ['random', 'pbt']:
        algorithm = ConcurrencyLimiter(algorithm, max_concurrent=args.jobs)
    return algorithm


def set_best_params(platform, design):
    '''
    Get current known best parameters if it exists.
    '''
    params = []
    best_param_file = f'designs/{platform}/{design}/{AUTOTUNER_BEST}'
    if os.path.isfile(best_param_file):
        with open(best_param_file) as file:
            params = json.load(file)
    return params


def set_training_class(function):
    '''
    Set training class.
    '''
    if function == 'default':
        return AutoTunerBase
    if function == 'ppa-improv':
        return PPAImprov
    return None


@ray.remote
def save_best(best_config):
    '''
    Save best configuration of parameters found.
    '''
    new_best_path = f'{LOCAL_DIR}/{args.experiment}/{AUTOTUNER_BEST}'
    with open(new_best_path, 'w') as new_best_file:
        json.dump(best_config, new_best_file, indent=4)
    print(f'[INFO TUN-0003] Best parameters written to {new_best_path}')


def sweep():
    ''' Run sweep of parameters '''
    workers = list()
    if args.server is not None:
        # For remote sweep we create the following directory structure:
        #      1/     2/         3/       4/
        # <repo>/<logs>/<platform>/<design>/
        repo_dir = abspath(LOCAL_DIR + '/../' * 4)
    else:
        repo_dir = abspath('../')
    print(f'[INFO TUN-0012] Log dir {LOCAL_DIR}.')
    for name, content in config_dict.items():
        if not isinstance(content, list):
            continue
        print(f'[INFO TUN-0007] Scheduling runs for parameter {name}.')
        for i in np.arange(*content):
            config_dict[name] = i
            workers.append(openroad_distributed.remote(repo_dir, config_dict,
                                                       LOCAL_DIR))
        print(f'[INFO TUN-0008] Finish scheduling for parameter {name}.')
    print('[INFO TUN-0009] Waiting for results.')
    _ = ray.get(workers)
    print('[INFO TUN-0010] Sweep complete.')


if __name__ == '__main__':
    args = parse_arguments()

    # Read config and original files before handling where to run in case we
    # need to upload the files.
    config_dict, SDC_ORIGINAL, FR_ORIGINAL = read_config(abspath(args.config))

    # Connect to remote Ray server if any, otherwise will run locally
    if args.server is not None:
        # At GCP we have a NFS folder that is present for all worker nodes.
        # This allows to build required binaries once. We clone, build and
        # store intermediate files at LOCAL_DIR.
        with open(args.config) as config_file:
            LOCAL_DIR = '/shared-data/autotuner'
            LOCAL_DIR += f'-orfs-{args.git_orfs_branch}'
            if args.git_or_branch != '':
                LOCAL_DIR += f'-or-{args.git_or_branch}'
            if args.git_latest:
                LOCAL_DIR += '-or-latest'
        # Connect to ray server before first remote execution.
        ray.init(f'ray://{args.server}:{args.port}')
        # Remote functions return a task id and are non-blocking. Since we
        # need the setup repo to be do to contune we call ray.get() to wait
        # for its completion.
        INSTALL_PATH = ray.get(setup_repo.remote(LOCAL_DIR))
        LOCAL_DIR += f'/flow/logs/{args.platform}/{args.design}'
        print('[INFO TUN-0001] NFS setup completed.')
    else:
        # For local runs, use the same folder as other ORFS utilities.
        os.chdir(os.path.dirname(abspath(__file__)) + '/../')
        LOCAL_DIR = f'logs/{args.platform}/{args.design}'
        INSTALL_PATH = abspath('../tools/install')

    if args.mode == 'tune':

        best_params = set_best_params(args.platform, args.design)
        search_algo = set_algorithm(args.experiment, config_dict)
        TrainClass = set_training_class(args.eval)
        # PPAImprov requires a reference file to compute training scores.
        if args.eval == 'ppa-improv':
            reference = PPAImprov.read_metrics(args.reference)

        tune_args = dict(
            name=f'{args.experiment}',
            metric='minimum',
            mode='min',
            num_samples=args.samples,
            fail_fast=True,
            local_dir=LOCAL_DIR,
            resume=args.resume,
            stop={"training_iteration": args.iterations},
        )
        if args.algorithm == 'pbt':
            tune_args['scheduler'] = search_algo
        else:
            tune_args['search_alg'] = search_algo
            tune_args['scheduler'] = AsyncHyperBandScheduler()
        if args.algorithm != 'ax':
            tune_args['config'] = config_dict
        analysis = tune.run(TrainClass, **tune_args)

        task_id = save_best.remote(analysis.best_config)
        _ = ray.get(task_id)
        print(f'[INFO TUN-0002] Best parameters found: {analysis.best_config}')
    elif args.mode == 'sweep':
        sweep()
