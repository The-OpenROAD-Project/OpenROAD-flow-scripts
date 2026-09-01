"""Rank-correlation statistics for the E12 clustered-scorer gate.

Candidate selection is a ranking problem, so the figure of merit is
Spearman's rho, not any absolute error: a scorer that is uniformly
optimistic ranks perfectly. With n = 24 a point estimate alone would
overclaim, so every rho is reported with a bootstrap 95% interval.

These three functions are vendored verbatim from the public bazel-orfs
`macro-selector` branch, test/estimation_ladder/score_vs_flow.py, which
produced the archived reference numbers in score_vs_flow_swerv.json.
Identical code is the point: a reimplementation, however faithful, would
make "rho reproduces the archive" untestable. Do not rewrite them here.
Stdlib only, deliberately -- ORFS's flow/util requirements carry neither
scipy nor numpy.
"""

import math
import random


def rankdata(values):
    order = sorted(range(len(values)), key=lambda i: values[i])
    ranks = [0.0] * len(values)
    i = 0
    while i < len(order):
        j = i
        while j + 1 < len(order) and values[order[j + 1]] == values[order[i]]:
            j += 1
        mean_rank = (i + j) / 2.0 + 1.0
        for k in range(i, j + 1):
            ranks[order[k]] = mean_rank
        i = j + 1
    return ranks


def spearman(x, y):
    rx, ry = rankdata(x), rankdata(y)
    n = len(rx)
    mx = sum(rx) / n
    my = sum(ry) / n
    num = sum((a - mx) * (b - my) for a, b in zip(rx, ry))
    dx = math.sqrt(sum((a - mx) ** 2 for a in rx))
    dy = math.sqrt(sum((b - my) ** 2 for b in ry))
    if dx == 0 or dy == 0:
        return float("nan")
    return num / (dx * dy)


def spearman_ci(x, y, n_boot=4000, seed=0):
    rng = random.Random(seed)
    n = len(x)
    rhos = []
    for _ in range(n_boot):
        idx = [rng.randrange(n) for _ in range(n)]
        rho = spearman([x[i] for i in idx], [y[i] for i in idx])
        if not math.isnan(rho):
            rhos.append(rho)
    rhos.sort()
    lo = rhos[int(0.025 * len(rhos))]
    hi = rhos[int(0.975 * len(rhos)) - 1]
    return lo, hi
