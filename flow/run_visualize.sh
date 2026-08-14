python3 ml/congestion/inference/visualize_thermal.py \
    --data-dir ml/congestion/data \
    --checkpoint ml/congestion/checkpoints/thermal_best.pt \
    --out thermal_report.html \
    2>&1 | tee ml/congestion/visualize_thermal.log
