# Multi-stage build for gcli2api - FIXED VERSION
FROM python:3.13-slim as base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    TZ=Asia/Shanghai

# --- FIX STARTS HERE ---
# Install tzdata for timezone AND tk-dev for tkinter dependency
# This fixes the "libtk8.6.so" ImportError
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata tk-dev && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# --- FIX ENDS HERE ---

WORKDIR /app

# Copy only requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port (optional, good for documentation)
EXPOSE 7861

# Default command
CMD ["python", "web.py"]
