# syntax=docker/dockerfile:1
FROM openroad/orfs:latest
WORKDIR /OpenROAD-flow-scripts/tools/AutoTuner
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --no-deps .
