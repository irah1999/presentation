# Python Docker Setup Guide

## Problem Diagnosis

The issue you're experiencing (`site can't be reached`) is because:

1. **No server is currently running** - The Python server process that was running has crashed
2. **Missing dependencies** - The virtual environments (.venv and venv) are incomplete or broken
3. **Docker permissions** - Your user needs sudo access to run Docker commands

## Solution: Use Docker (Recommended)

Docker will handle all dependencies and environment setup automatically.

### Quick Start

Run this command in your terminal:

```bash
/tmp/run_docker_python.sh
```

Or manually run these commands:

```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt

# Stop any existing containers
sudo docker compose -f docker-compose.python.yml down

# Build the image
sudo docker compose -f docker-compose.python.yml build

# Start the container
sudo docker compose -f docker-compose.python.yml up -d

# Check status
sudo docker compose -f docker-compose.python.yml logs -f
```

### Access the Application

Once running, visit: **http://localhost:8000/docs**

### Docker Commands Cheat Sheet

```bash
# View logs
sudo docker compose -f docker-compose.python.yml logs -f

# Stop the server
sudo docker compose -f docker-compose.python.yml down

# Restart the server
sudo docker compose -f docker-compose.python.yml restart

# Check container status
sudo docker compose -f docker-compose.python.yml ps

# Access container shell
sudo docker exec -it presenton-fastapi /bin/bash

# Rebuild from scratch
sudo docker compose -f docker-compose.python.yml down
sudo docker compose -f docker-compose.python.yml build --no-cache
sudo docker compose -f docker-compose.python.yml up -d
```

## Alternative: Fix Local Python Environment (Advanced)

If you prefer to run without Docker:

### Step 1: Install python3-venv

```bash
sudo apt update
sudo apt install python3.10-venv python3-pip
```

### Step 2: Create fresh virtual environment

```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi
rm -rf venv .venv  # Remove broken venvs
python3 -m venv venv_new
source venv_new/bin/activate
```

### Step 3: Install dependencies

```bash
pip install --upgrade pip

# Install all dependencies from pyproject.toml
pip install \
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

# Install docling with CPU-only PyTorch
pip install docling --extra-index-url https://download.pytorch.org/whl/cpu
```

### Step 4: Run the server

```bash
python server.py --port 8000 --reload false
```

### Step 5: Access the application

Visit: **http://localhost:8000/docs**

## Troubleshooting

### Issue: "Connection reset by peer"

**Cause:** Server is crashing or binding to wrong interface

**Solution:** 
- Check server logs for errors
- For Docker: `sudo docker compose -f docker-compose.python.yml logs -f`
- For local: Check the terminal where server is running

### Issue: "Port already in use"

**Check what's using port 8000:**
```bash
lsof -i :8000
```

**Kill the process:**
```bash
# Find the PID from lsof output
kill -9 <PID>
```

### Issue: "Permission denied" for Docker

**Add your user to docker group:**
```bash
sudo usermod -aG docker $USER
newgrp docker  # Or log out and back in
```

### Issue: Server starts but crashes immediately

**Check dependencies:**
```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi
source venv_new/bin/activate
python -c "import uvicorn, fastapi; print('Dependencies OK')"
```

## Environment Variables (Optional)

Configure in `docker-compose.python.yml` or set before running:

```bash
# OpenAI
export LLM=openai
export OPENAI_API_KEY=your_key_here
export OPENAI_MODEL=gpt-4o

# Google
export LLM=google
export GOOGLE_API_KEY=your_key_here
export GOOGLE_MODEL=models/gemini-2.0-flash

# Anthropic
export LLM=anthropic
export ANTHROPIC_API_KEY=your_key_here
export ANTHROPIC_MODEL=claude-3-5-sonnet-20241022

# Image generation
export IMAGE_PROVIDER=dall-e-3
export PEXELS_API_KEY=your_key_here
```

## Next Steps

1. **Run the setup script:** `/tmp/run_docker_python.sh`
2. **Wait for build to complete** (first time may take 5-10 minutes)
3. **Access the API docs:** http://localhost:8000/docs
4. **Test the API:** Try making a presentation request

## Need Help?

If you continue to have issues:
1. Share the output of: `sudo docker compose -f docker-compose.python.yml logs`
2. Check if port 8000 is accessible: `curl http://localhost:8000/docs`
3. Verify Docker is running: `sudo docker ps`
