# FastAPI Docker Setup - Running on Port 8000

This guide explains how to run the FastAPI application using Docker on port 8000.

## 📋 Prerequisites

- Docker installed and running
- Docker Compose installed
- At least 2GB of free disk space

## 🚀 Quick Start

### 1. Configure Environment Variables

First, create your `.env` file from the example:

```bash
cp .env.example .env
```

Then edit `.env` and add your API keys:

```bash
# Required for LLM providers you want to use
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here
GOOGLE_API_KEY=your_google_api_key_here
GROQ_API_KEY=your_groq_api_key_here

# For image generation
STABILITY_API_KEY=your_stability_api_key_here
```

### 2. Start the Application

#### Option A: Using the Start Script (Recommended)

```bash
./docker-start.sh
```

#### Option B: Using Docker Compose Manually

```bash
# Build and start
docker-compose up -d --build

# View logs
docker-compose logs -f
```

### 3. Access the Application

Once started, you can access:

- **API Base URL**: http://localhost:8000
- **API Documentation (Swagger)**: http://localhost:8000/docs
- **Alternative API Docs (ReDoc)**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

## 📊 Managing the Container

### View Logs

```bash
# Follow logs in real-time
docker-compose logs -f fastapi

# View last 100 lines
docker-compose logs --tail=100 fastapi
```

### Stop the Application

```bash
# Using script
./docker-stop.sh

# Or manually
docker-compose down
```

### Restart the Application

```bash
docker-compose restart
```

### Rebuild After Code Changes

```bash
docker-compose up -d --build
```

### Access Container Shell

```bash
docker exec -it fastapi-presenton bash
```

## 🗂️ Project Structure

```
servers/fastapi/
├── Dockerfile              # Docker image configuration
├── docker-compose.yml      # Docker Compose configuration
├── .env                    # Environment variables (create from .env.example)
├── .env.example           # Environment template
├── .dockerignore          # Files to exclude from Docker build
├── docker-start.sh        # Start script
├── docker-stop.sh         # Stop script
├── pyproject.toml         # Python dependencies
├── api/                   # FastAPI application
├── services/              # Business logic services
├── models/                # Data models
├── utils/                 # Utility functions
├── constants/             # Constants and configuration
└── enums/                 # Enumerations
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | Database connection string | `sqlite:///./app_data/presenton.db` |
| `OPENAI_API_KEY` | OpenAI API key | - |
| `ANTHROPIC_API_KEY` | Anthropic API key | - |
| `GOOGLE_API_KEY` | Google API key | - |
| `GROQ_API_KEY` | Groq API key | - |
| `OLLAMA_BASE_URL` | Ollama server URL | `http://host.docker.internal:11434` |
| `IMAGE_PROVIDER` | Image generation provider | `stability` |
| `STABILITY_API_KEY` | Stability AI API key | - |
| `LOG_LEVEL` | Logging level | `info` |
| `CORS_ORIGINS` | Allowed CORS origins | `*` |

### Port Configuration

The application runs on **port 8000** by default. To change the port:

1. Edit `docker-compose.yml`:
```yaml
ports:
  - "8080:8000"  # Changes external port to 8080
```

2. Or use environment variable:
```bash
PORT=8080 docker-compose up
```

## 📦 Volumes and Data Persistence

Docker volumes are used to persist data:

- `./chroma` - Vector database storage
- `./app_data` - SQLite database and application data
- `./static` - Static files

These directories are created automatically and persist between container restarts.

## 🐛 Troubleshooting

### Container won't start

Check logs for errors:
```bash
docker-compose logs fastapi
```

### Port already in use

If port 8000 is already in use, change it in `docker-compose.yml`:
```yaml
ports:
  - "8001:8000"  # Use port 8001 instead
```

### Permission issues

If you encounter permission errors:
```bash
sudo chown -R $USER:$USER chroma/ app_data/ static/
```

### Database errors

Reset the database:
```bash
docker-compose down -v
rm -rf app_data/
docker-compose up -d
```

### Out of memory

Increase Docker memory limit:
- Docker Desktop → Settings → Resources → Memory (increase to at least 4GB)

### Can't connect to Ollama

Make sure Ollama is running locally and accessible:
```bash
# Test Ollama connection
curl http://localhost:11434/api/tags
```

## 🔄 Development Mode

For development with hot-reload:

1. Modify `docker-compose.yml` to add reload:
```yaml
command: uvicorn api.main:app --host 0.0.0.0 --port 8000 --reload
```

2. Code changes will automatically reload the server.

## 🧪 Running Tests

```bash
# Run tests inside container
docker exec -it fastapi-presenton pytest

# Run specific test
docker exec -it fastapi-presenton pytest tests/test_file.py
```

## 🔐 Security Notes

1. **Never commit `.env` file** - It contains sensitive API keys
2. **Use strong database passwords** in production
3. **Restrict CORS origins** in production (change from `*` to specific domains)
4. **Use HTTPS** in production environments

## 📚 Additional Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 💡 Tips

1. **Check health**: `curl http://localhost:8000/health`
2. **Monitor resources**: `docker stats fastapi-presenton`
3. **Clean up**: `docker system prune -a` (removes unused images)
4. **Backup data**: Regular backups of `app_data/` and `chroma/` directories

## 🆘 Getting Help

If you encounter issues:

1. Check container logs: `docker-compose logs -f`
2. Verify Docker is running: `docker info`
3. Check disk space: `df -h`
4. Restart Docker service
5. Rebuild from scratch:
   ```bash
   docker-compose down -v
   docker-compose up -d --build
   ```
