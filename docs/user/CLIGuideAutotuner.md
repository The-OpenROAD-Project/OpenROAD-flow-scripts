# Autotuner CLI Guide

AutoTuner may be triggered by specifying a configuration path instead of
typing every single argument one-by-one.

## Motivation of Configuration files

Why configuration files?
- Improve CLI user experience - less typing, less mistakes.
- Greatly simplify the reproducibility of experiments - share your configuration
file for easier experiment tracking!

Previously for a command like tune, you might have had to do:

```shell
openroad_autotuner --design gcd --platform sky130hd --experiment abcdef \
                   --verbose \
                   --jobs 4 --openroad_threads 16 \
                   tune \
                   --config ../../flow/designs/sky130hd/gcd/autotuner.json \
                   --samples 5 --iterations 1 --algorithm hyperopt \
                   --resources_per_trial 1.0 --seed 42
```

With our new approach all you have to do is specify a YAML document `test.yaml`

```yaml
---
# Common
design: gcd
platform: sky130hd
experiment: test
verbose: 0

# Workload
jobs: 4 
openroad_threads: 16

# Tune-specific (set these if mode is tune)
tune:
  algorithm: hyperopt
  eval: default
  samples: 10
  iterations: 1
  resources_per_trial: 1.0
  reference: null
  perturbation: 25
  seed: 42
  config: ../../flow/designs/sky130hd/gcd/autotuner.json
```

and run:

```bash
openroad_autotuner --yaml test.yaml tune
```

## How to generate new config files

```bash
openroad_autotuner --design gcd --platform sky130hd --experiment abcdef \
                   --verbose \
                   --jobs 4 --openroad_threads 16 \
                   --print_config \
                   tune \
                   --config ../../flow/designs/sky130hd/gcd/autotuner.json \
                   --samples 5 --iterations 1 --algorithm hyperopt \
                   --resources_per_trial 1.0 --seed 42 > new_test.yaml
```
