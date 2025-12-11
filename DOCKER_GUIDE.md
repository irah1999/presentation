# 🐳 Docker Setup Guide - Python FastAPI Backend

## Overview

This guide will help you run the Presenton Python FastAPI backend using Docker. This setup includes **only the Python backend**, without Next.js or nginx.

---

## 📋 Prerequisites

- **Docker Desktop** installed and running
- **Docker Compose** (included with Docker Desktop)
- **4GB+ RAM** available for Docker
- **10GB+ disk space** for images and models

### Install Docker Desktop

**Windows:**
- Download from: https://www.docker.com/products/docker-desktop/
- Install and restart your computer
- Ensure WSL 2 is enabled

**Verify Installation:**
```powershell
docker --version
docker-compose --version
```

---

## 🚀 Quick Start (3 Steps)

### Method 1: Using Docker Compose (Recommended)

```powershell
# 1. Navigate to project directory
cd d:\react-js\ppt

# 2. Start the container
docker-compose -f docker-compose.python.yml up -d

# 3. Access the API
# Open browser: http://localhost:8000/docs
```

### Method 2: Using Docker CLI

```powershell
# 1. Build the image
docker build -f Dockerfile.python -t presenton-fastapi .

# 2. Run the container
docker run -d `
  --name presenton-fastapi `
  -p 8000:8000 `
  -v "${PWD}\app_data:/app_data" `
  presenton-fastapi

# 3. Access the API
# Open browser: http://localhost:8000/docs
```

---

## 📁 Files Created

| File | Purpose |
|------|---------|
| `Dockerfile.python` | Docker image definition for Python backend |
| `docker-compose.python.yml` | Docker Compose configuration |
| `.dockerignore.python` | Files to exclude from build |
| `DOCKER_GUIDE.md` | This guide |

---

## 🔧 Configuration

### Environment Variables

Edit `docker-compose.python.yml` to configure your API keys:

```yaml
environment:
  # Choose your LLM provider
  - LLM=openai                          # Options: openai, google, anthropic, ollama
  
  # OpenAI Configuration
  - OPENAI_API_KEY=sk-your-key-here
  - OPENAI_MODEL=gpt-4o
  
  # Google Configuration
  # - GOOGLE_API_KEY=your-key-here
  # - GOOGLE_MODEL=models/gemini-2.0-flash
  
  # Anthropic Configuration
  # - ANTHROPIC_API_KEY=your-key-here
  # - ANTHROPIC_MODEL=claude-3-5-sonnet-20241022
  
  # Image Generation
  - IMAGE_PROVIDER=dall-e-3             # Options: dall-e-3, gemini_flash, pexels, pixabay
  # - PEXELS_API_KEY=your-key-here
  # - PIXABAY_API_KEY=your-key-here
```

### Using .env File (Recommended)

Create a `.env` file in the project root:

```env
# .env file
OPENAI_API_KEY=sk-your-actual-key-here
GOOGLE_API_KEY=your-google-key
ANTHROPIC_API_KEY=your-anthropic-key
PEXELS_API_KEY=your-pexels-key
PIXABAY_API_KEY=your-pixabay-key
```

Docker Compose will automatically load these variables.

---

## 📝 Common Commands

### Start the Container

```powershell
# Start in detached mode (background)
docker-compose -f docker-compose.python.yml up -d

# Start with logs visible
docker-compose -f docker-compose.python.yml up

# Start and rebuild if needed
docker-compose -f docker-compose.python.yml up -d --build
```

### Stop the Container

```powershell
# Stop the container
docker-compose -f docker-compose.python.yml down

# Stop and remove volumes
docker-compose -f docker-compose.python.yml down -v
```

### View Logs

```powershell
# View all logs
docker-compose -f docker-compose.python.yml logs

# Follow logs in real-time
docker-compose -f docker-compose.python.yml logs -f

# View last 100 lines
docker-compose -f docker-compose.python.yml logs --tail=100
```

### Restart the Container

```powershell
docker-compose -f docker-compose.python.yml restart
```

### Rebuild the Image

```powershell
# Rebuild without cache
docker-compose -f docker-compose.python.yml build --no-cache

# Rebuild and start
docker-compose -f docker-compose.python.yml up -d --build
```

---

## 🔍 Container Management

### Check Container Status

```powershell
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Check container health
docker inspect presenton-fastapi --format='{{.State.Health.Status}}'
```

### Execute Commands in Container

```powershell
# Open bash shell in container
docker exec -it presenton-fastapi bash

# Run Python command
docker exec -it presenton-fastapi python --version

# Check installed packages
docker exec -it presenton-fastapi pip list
```

### View Container Resources

```powershell
# View resource usage
docker stats presenton-fastapi

# View detailed container info
docker inspect presenton-fastapi
```

---

## 🌐 Access Points

Once the container is running:

- **API Documentation:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc
- **Base API:** http://localhost:8000

### Test the API

```powershell
# Health check
curl http://localhost:8000/docs

# Generate a presentation
curl -X POST http://localhost:8000/api/v1/ppt/presentation/generate `
  -H "Content-Type: application/json" `
  -d '{
    "content": "Introduction to Docker",
    "n_slides": 5,
    "language": "English",
    "template": "general",
    "export_as": "pptx"
  }'
```

---

## 📦 Data Persistence

### Volumes

The `app_data` directory is mounted as a volume to persist:
- Generated presentations
- Database files
- User configurations
- Cached data

**Location:**
- **Host:** `d:\react-js\ppt\app_data`
- **Container:** `/app_data`

### Backup Data

```powershell
# Create backup
docker run --rm -v presenton_app_data:/data -v ${PWD}:/backup alpine tar czf /backup/app_data_backup.tar.gz -C /data .

# Restore backup
docker run --rm -v presenton_app_data:/data -v ${PWD}:/backup alpine tar xzf /backup/app_data_backup.tar.gz -C /data
```

---

## 🐛 Troubleshooting

### Container Won't Start

**Check logs:**
```powershell
docker-compose -f docker-compose.python.yml logs
```

**Common issues:**
1. Port 8000 already in use
   ```powershell
   # Change port in docker-compose.python.yml
   ports:
     - "8001:8000"  # Use 8001 instead
   ```

2. Insufficient memory
   ```powershell
   # Increase Docker Desktop memory limit
   # Settings > Resources > Memory > 4GB+
   ```

### Build Fails

**Clear Docker cache:**
```powershell
# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Rebuild without cache
docker-compose -f docker-compose.python.yml build --no-cache
```

### ChromaDB Download Issues

**First startup may take 10-15 minutes** to download models.

**Check progress:**
```powershell
docker-compose -f docker-compose.python.yml logs -f
```

**If download fails:**
```powershell
# Restart the container
docker-compose -f docker-compose.python.yml restart
```

### API Not Responding

**Check container health:**
```powershell
docker ps
# Look for "healthy" status

# If unhealthy, check logs
docker-compose -f docker-compose.python.yml logs --tail=50
```

### Permission Issues (Linux/Mac)

```bash
# Fix permissions
sudo chown -R $USER:$USER ./app_data
```

---

## 🚀 Advanced Configuration

### Custom Port

Edit `docker-compose.python.yml`:
```yaml
ports:
  - "8001:8000"  # Host:Container
```

### Memory Limits

```yaml
services:
  fastapi:
    deploy:
      resources:
        limits:
          memory: 4G
        reservations:
          memory: 2G
```

### GPU Support (for Ollama)

```yaml
services:
  fastapi:
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

### Multiple Instances

```powershell
# Run multiple instances on different ports
docker run -d --name presenton-1 -p 8001:8000 presenton-fastapi
docker run -d --name presenton-2 -p 8002:8000 presenton-fastapi
docker run -d --name presenton-3 -p 8003:8000 presenton-fastapi
```

---

## 🔒 Security Best Practices

### 1. Use Environment Variables

Never hardcode API keys in docker-compose.yml:
```yaml
environment:
  - OPENAI_API_KEY=${OPENAI_API_KEY}
```

### 2. Limit Container Permissions

```yaml
security_opt:
  - no-new-privileges:true
user: "1000:1000"
```

### 3. Use Read-Only Filesystem

```yaml
read_only: true
tmpfs:
  - /tmp
  - /app_data
```

---

## 📊 Performance Optimization

### 1. Use BuildKit

```powershell
# Enable BuildKit for faster builds
$env:DOCKER_BUILDKIT=1
docker-compose -f docker-compose.python.yml build
```

### 2. Multi-Stage Builds

Already optimized in `Dockerfile.python` with:
- Minimal base image (python:3.11-slim)
- No cache for pip installs
- Cleaned apt cache

### 3. Layer Caching

Dependencies are installed before copying code to maximize cache hits.

---

## 🧪 Testing the Setup

### 1. Build Test

```powershell
# Build the image
docker build -f Dockerfile.python -t presenton-test .

# Should complete without errors
```

### 2. Run Test

```powershell
# Start container
docker run -d --name test-presenton -p 8000:8000 presenton-test

# Wait 30 seconds for startup
Start-Sleep -Seconds 30

# Test API
curl http://localhost:8000/docs

# Cleanup
docker stop test-presenton
docker rm test-presenton
```

### 3. Health Check

```powershell
# Check health status
docker inspect presenton-fastapi --format='{{.State.Health.Status}}'

# Should return: healthy
```

---

## 📚 Docker Commands Cheat Sheet

```powershell
# Build
docker build -f Dockerfile.python -t presenton-fastapi .
docker-compose -f docker-compose.python.yml build

# Run
docker run -d -p 8000:8000 presenton-fastapi
docker-compose -f docker-compose.python.yml up -d

# Stop
docker stop presenton-fastapi
docker-compose -f docker-compose.python.yml down

# Logs
docker logs presenton-fastapi
docker-compose -f docker-compose.python.yml logs -f

# Shell
docker exec -it presenton-fastapi bash

# Clean
docker system prune -a
docker volume prune
```

---

## 🎯 Production Deployment

### Using Docker Compose

```powershell
# Production deployment
docker-compose -f docker-compose.python.yml up -d --build

# Enable auto-restart
docker update --restart=always presenton-fastapi
```

### Using Docker Swarm

```powershell
# Initialize swarm
docker swarm init

# Deploy stack
docker stack deploy -c docker-compose.python.yml presenton

# Scale service
docker service scale presenton_fastapi=3
```

### Using Kubernetes

Convert docker-compose to Kubernetes:
```powershell
# Install kompose
# https://kompose.io/

# Convert
kompose convert -f docker-compose.python.yml
```

---

## 🆘 Getting Help

### Check Logs First
```powershell
docker-compose -f docker-compose.python.yml logs --tail=100
```

### Community Support
- **Discord:** https://discord.gg/9ZsKKxudNE
- **Documentation:** https://docs.presenton.ai
- **GitHub Issues:** Report bugs and issues

### Provide Information
When asking for help, include:
1. Docker version: `docker --version`
2. OS version
3. Container logs
4. docker-compose.yml configuration
5. Error messages

---

## ✅ Quick Reference

| Task | Command |
|------|---------|
| Start | `docker-compose -f docker-compose.python.yml up -d` |
| Stop | `docker-compose -f docker-compose.python.yml down` |
| Logs | `docker-compose -f docker-compose.python.yml logs -f` |
| Restart | `docker-compose -f docker-compose.python.yml restart` |
| Rebuild | `docker-compose -f docker-compose.python.yml up -d --build` |
| Shell | `docker exec -it presenton-fastapi bash` |
| Status | `docker ps` |
| Clean | `docker system prune -a` |

---

**Created:** December 11, 2025  
**Version:** 1.0  
**Docker Image:** presenton-fastapi  
**Base Image:** python:3.11-slim-bookworm
