FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir \
    --index-url https://download.pytorch.org/whl/cpu \
    torch
    
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY streamlit_app.py .
COPY config/ ./config/
COPY src/ ./src/
COPY search/ ./search/

# Copy existing model
COPY outputs/bert_hatespeech/best_model/ ./outputs/bert_hatespeech/best_model/

# Copy optional training script
COPY train.sh* ./

# Startup logic
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 8000
EXPOSE 8501

ENTRYPOINT ["./entrypoint.sh"]