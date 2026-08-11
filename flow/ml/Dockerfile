# Custom ORFS image with ML dependencies (HotSpot thermal solver + Python packages).
#
# Build:
#   docker build -t openroad/orfs-ml:latest flow/ml/
#
# Use (instead of plain docker_shell):
#   OR_IMAGE=openroad/orfs-ml:latest util/docker_shell <cmd>
#
# The base image already contains OpenROAD, Yosys, KLayout, and all ORFS tooling.
# This layer adds:
#   - HotSpot v7.0  (compact thermal solver, RC circuit model)
#   - Python packages needed by the ML pipeline

FROM openroad/orfs:latest

USER root

# ── System dependencies ────────────────────────────────────────────────────
# git/make/gcc: build HotSpot from source (not packaged in any distro)
# libblas-dev:  HotSpot links against BLAS for matrix ops in its thermal solver
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        gcc \
        make \
        libblas-dev \
    && rm -rf /var/lib/apt/lists/*

# ── HotSpot v7.0 ──────────────────────────────────────────────────────────
# Clone, build, and install to /usr/local/bin so it's on PATH everywhere.
# --depth 1 fetches only the latest commit — faster, no history needed.
# We remove the source tree after installing to keep the image small.
RUN git clone --depth 1 https://github.com/uvahotspot/HotSpot.git /tmp/hotspot \
    && cd /tmp/hotspot \
    && make \
    && cp hotspot /usr/local/bin/hotspot \
    && rm -rf /tmp/hotspot

# ── Python ML packages ─────────────────────────────────────────────────────
# These are needed by training/inference scripts inside the container.
# torch-geometric and its deps (torch-scatter etc.) are installed separately
# because they require matching the PyTorch version already in the base image.
RUN pip3 install --no-cache-dir \
        numpy \
        scipy \
        scikit-learn \
        xgboost \
        torch \
        torch-geometric

