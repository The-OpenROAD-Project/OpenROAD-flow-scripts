# Instructions for AutoTuner with Ray

_AutoTuner_ is a "no-human-in-loop" parameter tuning framework for commercial and academic RTL-to-GDS flows.
AutoTuner provides a generic interface where users can define parameter configuration as JSON objects.
This enables AutoTuner to easily support various tools and flows. AutoTuner also utilizes [METRICS2.1](https://github.com/ieee-ceda-datc/datc-rdf-Metrics4ML) to capture PPA
of individual search trials. With the abundant features of METRICS2.1, users can explore various reward functions that steer the flow autotuning to different PPA goals.

AutoTuner provides three main functionalities as follows.
* [Ray] Automatic hyperparameter tuning framework for OpenROAD-flow-script (ORFS)
* [Ray] Parametric sweeping experiments for ORFS
* [Vizier] Multi-objective optimization of ORFS parameters


AutoTuner contains top-level Python script for ORFS, each of which implements a different search algorithm. Current supported search algorithms are as follows.
* Ray (Single-objective optimization)
  * Random/Grid Search
  * Population Based Training ([PBT](https://www.deepmind.com/blog/population-based-training-of-neural-networks))
  * Tree Parzen Estimator ([HyperOpt](https://hyperopt.github.io/hyperopt))
  * Bayesian + Multi-Armed Bandit ([AxSearch](https://ax.dev/docs/bayesopt.html))
  * Tree Parzen Estimator + Covariance Matrix Adaptation Evolution Strategy ([Optuna](https://optuna.readthedocs.io/en/stable/reference/samplers/generated/optuna.samplers.TPESampler.html))
  * Evolutionary Algorithm ([Nevergrad](https://github.com/facebookresearch/nevergrad))
* Vizier (Multi-objective optimization)
  * Random/Grid/Shuffled Search
  * Quasi Random Search ([quasi-random](https://developers.google.com/machine-learning/guides/deep-learning-tuning-playbook/quasi-random-search))
  * Gaussian Process Bandit ([GP-Bandit](https://acsweb.ucsd.edu/~shshekha/GPBandits.html))
  * Non-dominated Sorting Genetic Algorithm II ([NSGA-II](https://ieeexplore.ieee.org/document/996017))

For Ray algorithms, optimized function can be adjusted with user-defined coefficient values (`coeff_perform`, `coeff_power`, `coeff_area`) for three objectives to set the direction of tuning. They are defined in the [distributed.py sricpt](../../tools/AutoTuner/src/autotuner/distributed.py) in `get_ppa` method of `PPAImprov` class. Efforts to optimize each of the objectives are proportional to the specified coefficients.

Using Vizier algorithms, used can choose which metrics should be optimized with `--use-metrics` argument.


## Setting up AutoTuner

We have provided two convenience scripts, `./installer.sh` and `./setup.sh`
that works in Python3.8 for installation and configuration of AutoTuner,
as shown below:

```shell
# Install prerequisites for both Ray Tune and Vizier
./tools/AutoTuner/installer.sh
# Or install prerequisites for `ray` or `vizier`
./tools/AutoTuner/installer.sh vizier

# Start virtual environment
./tools/AutoTuner/setup.sh
```

## Input JSON structure

Sample JSON [file](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/blob/master/flow/designs/sky130hd/aes/autotuner.json) for Sky130HD `aes` design:  

Alternatively, here is a minimal example to get started:

```json
{
    "_SDC_FILE_PATH": "constraint.sdc",
    "_SDC_CLK_PERIOD": {
        "type": "float",
        "minmax": [
            1.0,
            3.7439
        ],
        "step": 0,
        "scale": "log"
    },
    "CORE_MARGIN": {
        "type": "int",
        "minmax": [
            2,
            2
        ],
        "step": 0
    },
}
```

* `"_SDC_FILE_PATH"`, `"_SDC_CLK_PERIOD"`, `"CORE_MARGIN"`: Parameter names for sweeping/tuning.
* `"type"`: Parameter type ("float" or "int") for sweeping/tuning
* `"minmax"`: Min-to-max range for sweeping/tuning. The unit follows the default value of each technology std cell library.
* `"step"`: Parameter step within the minmax range. Step 0 for type "float" means continuous step for sweeping/tuning. Step 0 for type "int" means the constant parameter.
* `"scale"`: Vizier-specific parameter setting [scaling type](https://oss-vizier.readthedocs.io/en/latest/guides/user/search_spaces.html#scaling), allowed values: `linear`, `log` and `rlog`.

## Tunable / sweepable parameters

Tables of parameters that can be swept/tuned in technology platforms supported by ORFS.
Any variable that can be set from the command line can be used for tune or sweep.

For SDC you can use:

* `_SDC_FILE_PATH`
  - Path relative to the current JSON file to the SDC file.
* `_SDC_CLK_PERIOD`
  - Design clock period. This will create a copy of `_SDC_FILE_PATH` and modify the clock period.
* `_SDC_UNCERTAINTY`
  - Clock uncertainty. This will create a copy of `_SDC_FILE_PATH` and modify the clock uncertainty.
* `_SDC_IO_DELAY`
  - I/O delay. This will create a copy of `_SDC_FILE_PATH` and modify the I/O delay.


For Global Routing parameters that are set on `fastroute.tcl` you can use:

* `_FR_FILE_PATH`
  - Path relative to the current JSON file to the `fastroute.tcl` file.
* `_FR_LAYER_ADJUST`
  - Layer adjustment. This will create a copy of `_FR_FILE_PATH` and modify the layer adjustment for all routable layers, i.e., from `$MIN_ROUTING_LAYER` to `$MAX_ROUTING_LAYER`.
* `_FR_LAYER_ADJUST_NAME`
  - Layer adjustment for layer NAME. This will create a copy of `_FR_FILE_PATH` and modify the layer adjustment only for the layer NAME.
* `_FR_GR_SEED`
  - Global route random seed. This will create a copy of `_FR_FILE_PATH` and modify the global route random seed.

## How to use

### General Information

The `autotuner.distributed` module uses [Ray's](https://docs.ray.io/en/latest/index.html) job scheduling and management to
fully utilize available hardware resources from a single server 
configuration, on-premise or over the cloud with multiple CPUs.

The two modes of operation:
- `sweep`, where every possible parameter combination in the search space is tested
- `tune`, where we use Ray's Tune feature to intelligently search the space and optimize hyperparameters using one of the algorithms listed above.

The `sweep` mode is useful when we want to isolate or test a single or very few
parameters. On the other hand, `tune` is more suitable for finding
the best combination of a complex and large number of flow 
parameters.

```{note}
The order of the parameters matter. Arguments `--design`, `--platform` and
`--config` are always required and should precede *mode*.
```

The `autotuner.vizier` module integrates OpenROAD flow into the Vizier optimizer.
It is used for multi-objective optimization with an additional features improving chance of finding valid parameters.
Moreover, various algorithms are available for tuning parameters.

Each mode relies on user-specified search space that is 
defined by a `.json` file, they use the same syntax and format, 
though some features may not be available for sweeping.

```{note}
The following commands should be run from `./tools/AutoTuner`.
```

#### Tune only 

* Ray-based AutoTuner: `python3 -m autotuner.distributed tune -h`

Example:

```shell
python3 -m autotuner.distributed --design gcd --platform sky130hd \
                       --config ../../flow/designs/sky130hd/gcd/autotuner.json \
                       tune --samples 5
```
#### Sweep only 

* Parameter sweeping: `python3 -m autotuner.distributed sweep -h`

Example:

```shell
python3 -m autotuner.distributed --design gcd --platform sky130hd \
                       --config src/autotuner/distributed-sweep-example.json \
                       sweep
```

#### Multi-object optimization

* Vizier-based AutoTuner: `python3 -m autotuner.vizier -h`

Example:

```shell
python3 -m autotuner.vizier --design gcd --platform sky130hd \
                       --config ../../flow/designs/sky130hd/gcd/autotuner.json
```

### Google Cloud Platform (GCP) distribution with Ray

GCP Setup Tutorial coming soon.


### List of common input arguments
| Argument                      | Description                                                                                           | Default |
|-------------------------------|-------------------------------------------------------------------------------------------------------|---------|
| `--design`                    | Name of the design for Autotuning.                                                                    ||
| `--platform`                  | Name of the platform for Autotuning.                                                                  ||
| `--config`                    | Configuration file that sets which knobs to use for Autotuning.                                       ||
| `--experiment`                | Experiment name. This parameter is used to prefix the FLOW_VARIANT and to set the Ray log destination.| test |
| `--samples`                   | Number of samples for tuning.                                                                         | 10 |
| `--jobs`                      | Max number of concurrent jobs.                                                                        | # of CPUs / 2 |
| `--openroad_threads`          | Max number of threads usable.                                                                         | 16 |
| `--timeout`                   | Time limit (in hours) for each trial run.                                                             | No limit |
| `-v` or `--verbose`           | Verbosity Level. [0: Only ray status, 1: print stderr, 2: print stdout on top of what is in level 0 and 1. ]                  | 0 |
|                               |                                                                                                       ||

### Input arguments specific to Ray
| Argument                      | Description                                                                                           | Default |
|-------------------------------|-------------------------------------------------------------------------------------------------------|---------|
| `--git_clean`                 | Clean binaries and build files. **WARNING**: may lose previous data.                                  ||
| `--git_clone`                 | Force new git clone. **WARNING**: may lose previous data.                                             ||
| `--git_clone_args`            | Additional git clone arguments.                                                                       ||
| `--git_latest`                | Use latest version of OpenROAD app.                                                                   ||
| `--git_or_branch`             | OpenROAD app branch to use.                                                                           ||
| `--git_orfs_branch`           | OpenROAD-flow-scripts branch to use.                                                                  ||
| `--git_url`                   | OpenROAD-flow-scripts repo URL to use.                                                                | [ORFS GitHub repo](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts) |
| `--build_args`                | Additional arguments given to ./build_openroad.sh                                                     ||
| `--server`                    | The address of Ray server to connect.                                                                 ||
| `--port`                      | The port of Ray server to connect.                                                                    | 10001 |
|                               |                                                                                                       ||

#### Input arguments specific to Ray tune mode
The following input arguments are applicable for tune mode only.

| Argument                      | Description                                                                                           | Default |
|-------------------------------|-------------------------------------------------------------------------------------------------------|---------|
| `--algorithm`                 | Search algorithm to use for Autotuning.                                                               | hyperopt |
| `--eval`                      | Evaluate function to use with search algorithm.                                                       ||
| `--iterations`                | Number of iterations for tuning.                                                                      | 1 |
| `--resources_per_trial`       | Number of CPUs to request for each tuning job.                                                        | 1 |
| `--reference`                 | Reference file for use with PPAImprov.                                                                ||
| `--perturbation`              | Perturbation interval for PopulationBasedTraining                                                     | 25 |
| `--seed`                      | Random seed.                                                                                          | 42 |
| `--resume`                    | Resume previous run.                                                                                  ||
|                               |                                                                                                       ||

### Input arguments specific to Vizier
| Argument                      | Description                                                                                                                                                     | Default |
|-------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| `--orfs`                      | Path to the OpenROAD-flow-scripts repository                                                                                                                    ||
| `--results`                   | Path where JSON file with results will be saved                                                                                                                 ||
| `-a` or `--algorithm`         | Algorithm for the optimization engine, one of GAUSSIAN_PROCESS_BANDIT, RANDOM_SEARCH, QUASI_RANDOM_SEARCH, GRID_SEARCH, SHUFFLED_GRID_SEARCH, NSGA2             | NSGA2 |
| `-m` or `--use-metrics`       | Metrics to optimize, list of worst_slack, clk_period-worst_slack, total_power, core_util, final_util, design_area, core_area, die_area, last_successful_stage   | all available metrics |
| `-i` or `--iterations`        | Max iteration count for the optimization engine                                                                                                                 | 2 ||
| `-s` or `--suggestions`       | Suggestion count per iteration of the optimization engine                                                                                                       | 5 ||
| `--use-existing-server`       | Address of the running Vizier server                                                                                                                            ||
|                               |                                                                                                                                                                 ||

### GUI for optimizations with Ray Tune

Basically, progress is displayed at the terminal where you run, and when all runs are finished, the results are displayed.
You could find the "Best config found" on the screen.

To use TensorBoard GUI, run `tensorboard --logdir=./<logpath>`. While TensorBoard is running, you can open the webpage `http://localhost:6006/` to see the GUI.

We show three different views possible at the end, namely: `Table View`, `Scatter Plot Matrix View` and `Parallel Coordinate View`.

![Table View](../images/Autotuner_Table_view.webp)
<p style="text-align: center;">Table View</p>

![Scatter Plot Matrix View](../images/Autotuner_scatter_plot_matrix_view.webp)
<p style="text-align: center;">Scatter Plot Matrix View</p>

![Parallel Coordinate View](../images/Autotuner_best_parameter_view.webp)
<p style="text-align: center;">Parallel Coordinate View (best run is in green)</p>

## Testing framework

Assuming the virtual environment is setup at `./tools/AutoTuner/autotuner_env`:

```
./tools/AutoTuner/setup.sh
python3 ./tools/AutoTuner/test/smoke_test_sweep.py
python3 ./tools/AutoTuner/test/smoke_test_tune.py
python3 ./tools/AutoTuner/test/smoke_test_vizier.py
python3 ./tools/AutoTuner/test/smoke_test_sample_iteration.py
```

## Citation

Please cite the following paper.

* J. Jung, A. B. Kahng, S. Kim and R. Varadarajan, "METRICS2.1 and Flow Tuning in the IEEE CEDA Robust Design Flow and OpenROAD", [(.pdf)](https://vlsicad.ucsd.edu/Publications/Conferences/388/c388.pdf), [(.pptx)](https://vlsicad.ucsd.edu/Publications/Conferences/388/c388.pptx), [(.mp4)](https://vlsicad.ucsd.edu/Publications/Conferences/388/c388.mp4), Proc. ACM/IEEE International Conference on Computer-Aided Design, 2021.

## Acknowledgments

AutoTuner has been developed by UCSD with the OpenROAD Project.
