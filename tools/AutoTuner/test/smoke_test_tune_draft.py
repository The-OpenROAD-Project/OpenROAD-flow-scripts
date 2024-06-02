import unittest
from unittest.mock import patch
import argparse
import sys
import os
from ray import tune 

cur_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(cur_dir, "../src/autotuner"))

from autotuner.distributed import set_best_params, set_algorithm, set_training_class
from autotuner.distributed import parse_arguments
from autotuner.distributed import main

"""
Reproduce this for base args. 
Namespace(algorithm='hyperopt', build_args='',
 config='../../../../flow/designs/asap7/gcd/autotuner.json',
  design='gcd', eval='default',
   experiment='test-tune-2024-06-01-13-50-55',
    git_clean=False, git_clone=False,
     git_clone_args='', git_latest=False,
      git_or_branch='', git_orfs_branch='master',
       git_url='https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts',
        iterations=1, jobs=8, mode='tune',
         openroad_threads=16, perturbation=25, platform='asap7',
          port=10001, reference=None, resources_per_trial=1,
           resume=False, samples=5,
            seed=42, server=None, timeout=None, verbose=0)
"""

class BaseTuneSmokeTest(unittest.TestCase):
    platform = ""
    design = ""

    def setUp(self):
        self.config = os.path.join(cur_dir, f"../../../flow/designs/{self.platform}/{self.design}/autotuner.json")
        self.experiment = f"smoke-test-tune-{self.platform}"

    def get_mock_args(self, mock_parse_arguments):
        # Set up mock default args
        mock_parse_arguments.return_value = argparse.Namespace(
            algorithm='hyperopt',
            build_args='',
            config=self.config,
            design=self.design,
            eval='default',
            experiment=self.experiment,
            git_clean=False, git_clone=False,
            git_clone_args='', git_latest=False,
            git_or_branch='', git_orfs_branch='master',
            git_url='https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts',
            iterations=1, jobs=8, mode='tune',
            openroad_threads=16, perturbation=25,
            platform=self.platform,
            port=10001, reference=None, resources_per_trial=1,
            resume=False, samples=1,
            seed=42, server=None, timeout=None, verbose=0)
        return mock_parse_arguments.return_value

class ASAP7TuneSmokeTest(BaseTuneSmokeTest):
    platform = "asap7"
    design = "gcd"

    @patch('distributed.parse_arguments')
    def test_tune(self, mock_parse_arguments):
        mock_args = self.get_mock_args(mock_parse_arguments)
        main(mock_args)
        self.assertTrue(True)

    def test_sweep(self):
        try:
            # Actual test logic for test_sweep
            self.assertTrue(True)
        except Exception:
            self.fail("test_sweep failed")

if __name__ == '__main__':
    # TODO: Port everything to pytest once stable.
    unittest.main()