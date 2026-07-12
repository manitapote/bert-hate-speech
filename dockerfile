# Step 1: Start from Python 3.10
FROM python:3.10-slim

# Step 2: Install system tools PyTorch needs
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Step 3 Set working folder inside container
WORKDIR /app

# Step 4: Copy requirements and install libraries
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy your code
COPY app.py .
COPY streamlit_app.py .
COPY config/ ./config/
COPY src/ ./src/
COPY search/ ./search/

# Step 6: Copy model weights
COPY outputs/bert_hatespeech/search_20260412_182502/best_model/ ./outputs/bert_hatespeech/search_20260412_182502/best_model/

# Step 7: Tell Docker which ports are used
EXPOSE 8000
EXPOSE 8501

# Step 8: Default command to start FastAPI
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]