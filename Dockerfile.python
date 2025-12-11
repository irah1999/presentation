# Dockerfile for Python FastAPI Backend Only
# Optimized for Presenton AI Presentation Generator

FROM python:3.11-slim-bookworm

# Set metadata
LABEL maintainer="Presenton"
LABEL description="Presenton FastAPI Backend - Python Only"
LABEL version="1.0"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libreoffice \
    fontconfig \
    chromium \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Set environment variables
ENV APP_DATA_DIRECTORY=/app_data
ENV TEMP_DIRECTORY=/tmp/presenton
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Create necessary directories
RUN mkdir -p /app_data /tmp/presenton

# Copy Python project files
COPY servers/fastapi/ /app/servers/fastapi/

# Set working directory to FastAPI
WORKDIR /app/servers/fastapi

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install Python dependencies manually (avoiding pyproject.toml issues)
RUN pip install --no-cache-dir \
    "aiohttp>=3.12.15" \
    "aiomysql>=0.2.0" \
    "aiosqlite>=0.21.0" \
    "anthropic>=0.60.0" \
    "asyncpg>=0.30.0" \
    "chromadb>=1.0.15" \
    "dirtyjson>=1.0.8" \
    "fastapi[standard]>=0.116.1" \
    "fastmcp>=2.11.0" \
    "google-genai>=1.28.0" \
    "nltk>=3.9.1" \
    "openai>=1.98.0" \
    "pathvalidate>=3.3.1" \
    "pdfplumber>=0.11.7" \
    "pytest>=8.4.1" \
    "python-pptx>=1.0.2" \
    "redis>=6.2.0" \
    "sqlmodel>=0.0.24"

# Install docling with PyTorch CPU-only version
RUN pip install --no-cache-dir docling --extra-index-url https://download.pytorch.org/whl/cpu

# Expose FastAPI port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/docs || exit 1

# Run the FastAPI server
CMD ["python", "server.py", "--port", "8000", "--reload", "false"]
