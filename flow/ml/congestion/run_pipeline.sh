#!/usr/bin/env bash
# Full congestion ML pipeline runner.
# Extracts data from existing ORFS results, trains all models, evaluates, and predicts.
#
# Usage (from the flow/ directory):
#   bash ml/congestion/run_pipeline.sh [OPTIONS]
#
# Options:
#   --grid N          Grid resolution (default: 64)
#   --epochs N        Training epochs for deep models (default: 50)
#   --skip-extract    Skip extraction if data/*.npz files already exist
#   --skip-train      Skip training, go straight to evaluate/predict
#   --models MODELS   Comma-separated list: unet,swin,gnn,diffusion,classical (default: all)
#   --predict DESIGN  Run inference on this design after training (e.g. nangate45_aes)
#   -h, --help        Show this help

set -euo pipefail
cd "$(dirname "$0")/../.."   # always run from flow/

GRID=64
EPOCHS=50
SKIP_EXTRACT=false
SKIP_TRAIN=false
MODELS="unet,swin,gnn,classical"   # diffusion excluded by default (very slow)
PREDICT_TAG=""

usage() {
    grep '^#' "$0" | sed 's/^# \{0,1\}//'
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --grid)         GRID="$2";         shift 2 ;;
        --epochs)       EPOCHS="$2";       shift 2 ;;
        --skip-extract) SKIP_EXTRACT=true; shift ;;
        --skip-train)   SKIP_TRAIN=true;   shift ;;
        --models)       MODELS="$2";       shift 2 ;;
        --predict)      PREDICT_TAG="$2";  shift 2 ;;
        -h|--help)      usage ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

DATA_DIR="ml/congestion/data"
CKPT_DIR="ml/congestion/checkpoints"
SCRIPT_DIR="ml/congestion"

_has_model() { echo "$MODELS" | grep -qw "$1"; }

echo "============================================================"
echo " Congestion ML Pipeline"
echo " Grid: ${GRID}x${GRID}   Epochs: $EPOCHS   Models: $MODELS"
echo "============================================================"
echo ""

# ----------------------------------------------------------------
# Step 1: Extract features + labels from existing ODB results
# ----------------------------------------------------------------
if $SKIP_EXTRACT; then
    echo "[Step 1] Skipping extraction (--skip-extract)"
    npz_count=$(ls "$DATA_DIR"/*_features.npz 2>/dev/null | wc -l)
    echo "         Found $npz_count existing feature files in $DATA_DIR"
else
    echo "[Step 1] Extracting features and labels from existing ODB results..."
    bash "$SCRIPT_DIR/data_collection/extract_existing.sh" "$GRID"
    npz_count=$(ls "$DATA_DIR"/*_features.npz 2>/dev/null | wc -l)
    echo ""
    echo "         Extracted $npz_count designs."
fi

if [[ $(ls "$DATA_DIR"/*_features.npz 2>/dev/null | wc -l) -eq 0 ]]; then
    echo "ERROR: No feature files found in $DATA_DIR. Run extract_existing.sh first." >&2
    exit 1
fi

echo ""

# ----------------------------------------------------------------
# Step 2: Train models
# ----------------------------------------------------------------
if $SKIP_TRAIN; then
    echo "[Step 2] Skipping training (--skip-train)"
else
    echo "[Step 2] Training models..."
    echo ""

    if _has_model "classical"; then
        echo "--- Random Forest + XGBoost ---"
        python3 "$SCRIPT_DIR/training/train_classical.py" \
            --data-dir "$DATA_DIR" \
            --checkpoint-dir "$CKPT_DIR"
        echo ""
    fi

    if _has_model "unet"; then
        echo "--- U-Net ---"
        python3 "$SCRIPT_DIR/training/train_unet.py" \
            --data-dir "$DATA_DIR" \
            --checkpoint-dir "$CKPT_DIR" \
            --epochs "$EPOCHS"
        echo ""
    fi

    if _has_model "swin"; then
        echo "--- Swin Transformer ---"
        python3 "$SCRIPT_DIR/training/train_swin.py" \
            --data-dir "$DATA_DIR" \
            --checkpoint-dir "$CKPT_DIR" \
            --epochs "$EPOCHS"
        echo ""
    fi

    if _has_model "gnn"; then
        echo "--- GNN ---"
        python3 "$SCRIPT_DIR/training/train_gnn.py" \
            --data-dir "$DATA_DIR" \
            --checkpoint-dir "$CKPT_DIR" \
            --epochs "$EPOCHS"
        echo ""
    fi

    if _has_model "diffusion"; then
        echo "--- Diffusion (slow — use --epochs 50 --models diffusion for a quick run) ---"
        python3 "$SCRIPT_DIR/training/train_diffusion.py" \
            --data-dir "$DATA_DIR" \
            --checkpoint-dir "$CKPT_DIR" \
            --epochs "$EPOCHS" \
            --timesteps 200
        echo ""
    fi
fi

# ----------------------------------------------------------------
# Step 3: Evaluate all trained models side by side
# ----------------------------------------------------------------
echo "[Step 3] Evaluating all trained models..."
echo ""
python3 "$SCRIPT_DIR/inference/evaluate.py" \
    --data-dir "$DATA_DIR" \
    --checkpoint-dir "$CKPT_DIR" \
    --grid "$GRID"
echo ""

# ----------------------------------------------------------------
# Step 4: Optional inference on a specific design
# ----------------------------------------------------------------
if [[ -n "$PREDICT_TAG" ]]; then
    echo "[Step 4] Running inference on: $PREDICT_TAG"
    feat_file="$DATA_DIR/${PREDICT_TAG}_features.npz"

    if [[ ! -f "$feat_file" ]]; then
        echo "  WARNING: $feat_file not found — skipping inference."
    else
        for model in unet swin gnn; do
            ckpt="$CKPT_DIR/${model}_best.pt"
            if _has_model "$model" && [[ -f "$ckpt" ]]; then
                echo "  Predicting with $model..."
                python3 "$SCRIPT_DIR/inference/predict.py" \
                    --features "$feat_file" \
                    --model "$model" \
                    --checkpoint "$ckpt" \
                    --out-dir "$DATA_DIR"
                echo "  Saved: ${DATA_DIR}/${PREDICT_TAG}_${model}_vis.png"
            fi
        done
    fi
    echo ""
fi

echo "============================================================"
echo " Done!"
echo " Checkpoints: $CKPT_DIR/"
echo " Data:        $DATA_DIR/"
if [[ -n "$PREDICT_TAG" ]]; then
    echo " Visualisations: ${DATA_DIR}/${PREDICT_TAG}_*_vis.png"
fi
echo "============================================================"
