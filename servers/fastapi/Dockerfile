# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first for better caching
COPY pyproject.toml ./

# Install uv for faster dependency installation
RUN pip install uv

# Install Python dependencies using uv with unsafe-best-match strategy
# This allows uv to search all indexes for the best version match
RUN uv pip install --system --index-strategy unsafe-best-match -r pyproject.toml

# Copy the entire application
COPY . .

# Create necessary directories
RUN mkdir -p /app/chroma /app/static /app/app_data

# Expose port 8000
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Run the application
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000", "--log-level", "info"]
