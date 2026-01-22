import logging
import os
from typing import Any, Union

import ray
from tensorboardX import SummaryWriter

from autotuner.utils import ERROR_METRIC

logger = logging.getLogger(__name__)


@ray.remote
class TensorBoardLogger:
    """TensorBoard logger for AutoTuner experiments"""

    def __init__(self, log_dir: str):
        os.makedirs(log_dir, exist_ok=True)
        self.writer = SummaryWriter(log_dir=log_dir)
        self.log_dir = log_dir
        self.step = 0
        logger.info(f"TensorBoard logs will be written to {log_dir}")

    def log_sweep_metrics(
        self,
        params: dict[str, Any],
        metrics: dict[str, Any],
        score: float,
        effective_clk_period: Union[float, str],
        num_drc: Union[int, str],
        die_area: Union[float, str],
    ) -> None:
        """Log metrics from a single sweep run"""
        self.writer.add_scalar("sweep/score", score, self.step)

        if isinstance(effective_clk_period, (int, float)):
            self.writer.add_scalar(
                "sweep/effective_clk_period", effective_clk_period, self.step
            )

        if isinstance(num_drc, (int, float)):
            self.writer.add_scalar("sweep/num_drc", num_drc, self.step)

        if isinstance(die_area, (int, float)):
            self.writer.add_scalar("sweep/die_area", die_area, self.step)

        for key, value in metrics.items():
            if isinstance(value, (int, float)):
                self.writer.add_scalar(f"metrics/{key}", value, self.step)

        self.writer.add_hparams(
            {
                k: v if isinstance(v, (int, float, str, bool)) else str(v)
                for k, v in params.items()
            },
            {"hparam/metric": score},
        )

        self.step += 1

    def close(self) -> None:
        """Close the TensorBoard writer and log completion message"""
        self.writer.close()
        logger.info(
            f"Sweep complete. View results with: tensorboard --logdir={self.log_dir}"
        )
        logger.info(f"Total runs logged: {self.step}")
