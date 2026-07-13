#!/bin/bash
set -e

MODEL_PATH="outputs/bert_hatespeech/best_model"

if [ -f "train.sh" ]; then
    echo "Training script found. Starting training..."
    chmod +x train.sh
    ./train.sh
else
    echo "No training script found. Using existing model..."
fi

echo "Starting FastAPI..."
uvicorn app:app --host 0.0.0.0 --port 8000 &

echo "Starting Streamlit..."
streamlit run streamlit_app.py \
    --server.address 0.0.0.0 \
    --server.port 8501