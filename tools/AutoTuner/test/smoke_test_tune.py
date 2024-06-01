import unittest
import sys
import os

cur_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(cur_dir, "../src/autotuner"))

from distributed import set_best_params, set_algorithm, set_training_class
from distributed import read_config
from distributed import PPAImprov
from ray import tune 

"""
Reproduce this for base args. 
Namespace(algorithm='hyperopt', build_args='', config='../../../../flow/designs/asap7/gcd/autotuner.json', design='gcd', eval='default', experiment='test-tune-2024-06-01-13-50-55', git_clean=False, git_clone=False, git_clone_args='', git_latest=False, git_or_branch='', git_orfs_branch='master', git_url='https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts', iterations=1, jobs=8, mode='tune', openroad_threads=16, perturbation=25, platform='asap7', port=10001, reference=None, resources_per_trial=1, resume=False, samples=5, seed=42, server=None, timeout=None, verbose=0)
"""

class BaseTuneSmokeTest(unittest.TestCase):
    def setUp(self, platform, design, experiment, config):
        # Platform defaults
        self.platform = platform
        self.design = design
        self.experiment = experiment
        path = os.path.join(os.path.dirname(__file__),
                 f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json")
        self.config, _, _ = read_config(path)
        self.best_params = set_best_params(self.platform, self.design)
        # self.search_algo = set_algorithm

class ASAP7TuneSmokeTest(BaseTuneSmokeTest):
    def setUp(self):
        super().setUp("asap7", "gcd", "asap7_test", "autotuner.json")

    def test_tune(self):
        try:
            return True
        except:
            pass

    def test_sweep(self):
        try:
            return True
        except:
            pass




if __name__ == '__main__':
    # TODO: Port everything to pytest once stable.
    unittest.main()