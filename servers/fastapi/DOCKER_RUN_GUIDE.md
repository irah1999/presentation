# 🐳 FastAPI Docker Run Guide - Port 8000

Complete guide to run your FastAPI application using Docker on port 8000.

## 🚀 Quick Start Commands

### Option 1: Using Docker Compose (Recommended)

```bash
# Navigate to the fastapi directory
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi

# Build and start the container
docker compose up -d --build

# View logs
docker compose logs -f
```

### Option 2: Using the Start Script

```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi
./docker-start.sh
```

### If you need sudo for Docker:

```bash
# Build and start
sudo docker compose up -d --build

# View logs
sudo docker compose logs -f
```

## 📋 Step-by-Step Setup

### Step 1: Configure Environment Variables

```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi

# Create .env file from example
cp .env.example .env

# Edit .env file with your API keys (optional)
nano .env
```

**Important:** Add your API keys in the `.env` file if you want to use external LLM providers:

```env
OPENAI_API_KEY=sk-your-key-here
ANTHROPIC_API_KEY=sk-ant-your-key-here
GOOGLE_API_KEY=your-google-key-here
STABILITY_API_KEY=sk-your-stability-key-here
```

### Step 2: Build Docker Image

```bash
# Build the image
docker compose build

# OR with sudo
sudo docker compose build
```

This will:
- Create a Docker image with Python 3.11
- Install all dependencies from pyproject.toml
- Set up the FastAPI application

### Step 3: Start the Container

```bash
# Start in detached mode
docker compose up -d

# OR with sudo
sudo docker compose up -d
```

### Step 4: Verify It's Running

```bash
# Check container status
docker ps | grep fastapi-presenton

# Check health
curl http://localhost:8000/health

# Expected response:
# {"status":"healthy","service":"fastapi-presenton"}
```

### Step 5: Access the Application

Open your browser or API client:

- **API Base**: http://localhost:8000
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

## 🔧 Common Docker Commands

### View Logs

```bash
# Follow logs in real-time
docker compose logs -f fastapi

# View last 100 lines
docker compose logs --tail=100 fastapi

# With sudo
sudo docker compose logs -f fastapi
```

### Stop the Application

```bash
# Stop containers
docker compose down

# Stop and remove volumes
docker compose down -v

# Using script
./docker-stop.sh
```

### Restart the Application

```bash
# Restart
docker compose restart

# Rebuild and restart
docker compose up -d --build
```

### Access Container Shell

```bash
# Open bash shell in container
docker exec -it fastapi-presenton bash

# Run Python shell
docker exec -it fastapi-presenton python

# With sudo
sudo docker exec -it fastapi-presenton bash
```

### Check Container Stats

```bash
# View resource usage
docker stats fastapi-presenton

# With sudo
sudo docker stats fastapi-presenton
```

## 🛠️ Troubleshooting

### Issue 1: Permission Denied

**Error:** `permission denied while trying to connect to the Docker daemon socket`

**Solutions:**

1. **Use sudo** (quick fix):
   ```bash
   sudo docker compose up -d
   ```

2. **Add user to docker group** (permanent fix):
   ```bash
   sudo usermod -aG docker $USER
   newgrp docker
   # Then logout and login again
   ```

3. **Verify docker group**:
   ```bash
   groups | grep docker
   ```

### Issue 2: Port 8000 Already in Use

**Error:** `port is already allocated`

**Solutions:**

1. **Find what's using port 8000**:
   ```bash
   sudo lsof -i :8000
   # OR
   sudo netstat -tlnp | grep 8000
   ```

2. **Kill the process**:
   ```bash
   sudo kill -9 <PID>
   ```

3. **Change port** in `docker-compose.yml`:
   ```yaml
   ports:
     - "8001:8000"  # Use port 8001 externally
   ```

### Issue 3: Container Exits Immediately

**Check logs**:
```bash
docker compose logs fastapi
```

**Common causes**:
- Missing dependencies
- Configuration errors
- Database connection issues

**Solution**:
```bash
# Rebuild from scratch
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

### Issue 4: Health Check Failing

**Check health status**:
```bash
docker ps
# Look for (unhealthy) status
```

**Test health endpoint**:
```bash
curl -v http://localhost:8000/health
```

**Solutions**:
- Wait longer (container might be starting)
- Check logs for errors
- Verify all services are up

### Issue 5: Build Fails

**Error:** Dependencies won't install

**Solutions**:

1. **Clear Docker cache**:
   ```bash
   docker builder prune -a
   docker compose build --no-cache
   ```

2. **Check disk space**:
   ```bash
   df -h
   ```

3. **Update Docker**:
   ```bash
   docker version
   ```

## 🔄 Development Workflow

### For Active Development

1. **Enable hot-reload** by modifying the Dockerfile CMD:
   ```dockerfile
   CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
   ```

2. **Mount source code** (already configured in docker-compose.yml):
   ```yaml
   volumes:
     - ./api:/app/api
     - ./services:/app/services
   ```

3. **Restart after changes**:
   ```bash
   docker compose restart fastapi
   ```

### Running Tests

```bash
# Run all tests
docker exec fastapi-presenton pytest

# Run specific test file
docker exec fastapi-presenton pytest tests/test_pptx_creator.py

# Run with verbose output
docker exec fastapi-presenton pytest -v

# With sudo
sudo docker exec fastapi-presenton pytest
```

## 📊 Monitoring

### Real-time Logs

```bash
# All logs
docker compose logs -f

# Specific service
docker compose logs -f fastapi

# Since specific time
docker compose logs --since 5m fastapi
```

### Container Health

```bash
# Check health status
docker inspect --format='{{json .State.Health}}' fastapi-presenton | jq

# Continuous health monitoring
watch -n 5 'curl -s http://localhost:8000/health'
```

### Resource Usage

```bash
# CPU and Memory
docker stats fastapi-presenton --no-stream

# Detailed info
docker inspect fastapi-presenton
```

## 🧹 Cleanup

### Remove Everything

```bash
# Stop and remove containers
docker compose down

# Remove with volumes
docker compose down -v

# Remove images too
docker compose down --rmi all -v

# Complete cleanup
docker system prune -a --volumes
```

### Remove Only Old Images

```bash
# List images
docker images

# Remove specific image
docker rmi <image-id>

# Remove dangling images
docker image prune
```

## 📦 Data Persistence

The following directories persist data outside the container:

```
servers/fastapi/
├── chroma/          # Vector database
├── app_data/        # SQLite database
└── static/          # Static files
```

**Backup command**:
```bash
tar -czf backup-$(date +%Y%m%d).tar.gz chroma/ app_data/ static/
```

**Restore command**:
```bash
tar -xzf backup-YYYYMMDD.tar.gz
```

## 🚦 Production Deployment

For production use:

1. **Use environment-specific .env**:
   ```bash
   cp .env.example .env.production
   # Edit with production values
   ```

2. **Update docker-compose.yml**:
   ```yaml
   environment:
     - LOG_LEVEL=warning
     - CORS_ORIGINS=https://yourdomain.com
   ```

3. **Use proper secrets management**:
   - Docker secrets
   - AWS Secrets Manager
   - HashiCorp Vault

4. **Enable HTTPS**:
   - Use nginx reverse proxy
   - Let's Encrypt certificates

5. **Resource limits**:
   ```yaml
   deploy:
     resources:
       limits:
         cpus: '2'
         memory: 2G
   ```

## 📝 Environment Variables Reference

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DATABASE_URL` | No | `sqlite:///./app_data/presenton.db` | Database connection |
| `OPENAI_API_KEY` | No | - | OpenAI API key |
| `ANTHROPIC_API_KEY` | No | - | Anthropic API key |
| `GOOGLE_API_KEY` | No | - | Google API key |
| `OLLAMA_BASE_URL` | No | `http://host.docker.internal:11434` | Ollama server URL |
| `IMAGE_PROVIDER` | No | `stability` | Image provider |
| `STABILITY_API_KEY` | No | - | Stability AI key |
| `LOG_LEVEL` | No | `info` | Logging level |
| `CORS_ORIGINS` | No | `*` | CORS origins |

## 🎯 Testing the API

### Using curl

```bash
# Health check
curl http://localhost:8000/health

# Get API documentation
curl http://localhost:8000/openapi.json

# Example POST request (replace with actual endpoint)
curl -X POST http://localhost:8000/api/v1/ppt/generate \
  -H "Content-Type: application/json" \
  -d '{"topic": "Docker Tutorial"}'
```

### Using Python

```python
import requests

# Health check
response = requests.get("http://localhost:8000/health")
print(response.json())

# API call example
response = requests.post(
    "http://localhost:8000/api/v1/ppt/generate",
    json={"topic": "Docker Tutorial"}
)
print(response.json())
```

## 🆘 Getting Help

1. **Check logs first**:
   ```bash
   docker compose logs -f
   ```

2. **Verify container is running**:
   ```bash
   docker ps -a
   ```

3. **Check Docker daemon**:
   ```bash
   docker info
   ```

4. **Common fixes**:
   - Restart Docker service
   - Rebuild from scratch
   - Check disk space
   - Update Docker version

## 🎉 Success Checklist

- [ ] Docker is installed and running
- [ ] .env file is created and configured
- [ ] Docker image builds successfully
- [ ] Container starts and stays running
- [ ] Health check returns success
- [ ] API docs accessible at /docs
- [ ] Can view logs
- [ ] Can stop and restart container

Once all items are checked, you're good to go! 🚀
