# 🐳 Docker Quick Start - Python FastAPI Backend

## ⚡ 3-Step Quick Start

### Prerequisites
- Docker Desktop installed and running
- 4GB+ RAM available

### Step 1: Navigate to Project
```powershell
cd d:\react-js\ppt
```

### Step 2: Run the Script
```powershell
.\docker_run.ps1
```

### Step 3: Choose Option 1
- Select option **1** (Build and run with Docker Compose)
- Wait 5-10 minutes for first build
- Access API at http://localhost:8000/docs

---

## 🚀 Alternative: Manual Commands

### Using Docker Compose (Recommended)
```powershell
# Build and start
docker-compose -f docker-compose.python.yml up -d --build

# View logs
docker-compose -f docker-compose.python.yml logs -f

# Stop
docker-compose -f docker-compose.python.yml down
```

### Using Docker CLI
```powershell
# Build image
docker build -f Dockerfile.python -t presenton-fastapi .

# Run container
docker run -d --name presenton-fastapi -p 8000:8000 -v "${PWD}\app_data:/app_data" presenton-fastapi

# View logs
docker logs -f presenton-fastapi

# Stop
docker stop presenton-fastapi
docker rm presenton-fastapi
```

---

## 🌐 Access Your Application

- **API Documentation:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc
- **Base API:** http://localhost:8000

---

## ⚙️ Configuration

### Add API Keys

Create a `.env` file in the project root:

```env
OPENAI_API_KEY=sk-your-key-here
GOOGLE_API_KEY=your-google-key
ANTHROPIC_API_KEY=your-anthropic-key
```

Then restart the container:
```powershell
docker-compose -f docker-compose.python.yml restart
```

---

## 📝 Common Commands

| Task | Command |
|------|---------|
| **Start** | `docker-compose -f docker-compose.python.yml up -d` |
| **Stop** | `docker-compose -f docker-compose.python.yml down` |
| **Logs** | `docker-compose -f docker-compose.python.yml logs -f` |
| **Restart** | `docker-compose -f docker-compose.python.yml restart` |
| **Rebuild** | `docker-compose -f docker-compose.python.yml up -d --build` |

---

## 🐛 Troubleshooting

### Container won't start?
```powershell
# Check logs
docker-compose -f docker-compose.python.yml logs

# Rebuild from scratch
docker-compose -f docker-compose.python.yml down
docker-compose -f docker-compose.python.yml build --no-cache
docker-compose -f docker-compose.python.yml up -d
```

### Port 8000 already in use?
Edit `docker-compose.python.yml` and change:
```yaml
ports:
  - "8001:8000"  # Use port 8001 instead
```

### Need more help?
See `DOCKER_GUIDE.md` for detailed documentation.

---

## 📚 Files Overview

| File | Purpose |
|------|---------|
| `Dockerfile.python` | Docker image definition |
| `docker-compose.python.yml` | Docker Compose config |
| `docker_run.ps1` | Interactive setup script |
| `DOCKER_GUIDE.md` | Complete documentation |
| `DOCKER_QUICK_START.md` | This file |

---

## ✅ What's Included

- ✅ Python 3.11 FastAPI backend
- ✅ All AI providers (OpenAI, Google, Anthropic, Ollama)
- ✅ ChromaDB vector database
- ✅ PowerPoint generation (python-pptx)
- ✅ PDF processing (pdfplumber)
- ✅ Document parsing (docling)
- ✅ Persistent data storage
- ✅ Health checks
- ✅ Auto-restart

---

## 🎯 Next Steps

1. ✅ Start the container
2. ✅ Configure API keys in `.env`
3. ✅ Visit http://localhost:8000/docs
4. ✅ Generate your first presentation!

---

**Created:** December 11, 2025  
**For detailed guide:** See `DOCKER_GUIDE.md`
