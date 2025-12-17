# 🚀 START HERE - FastAPI Docker Quick Start

## One-Command Start

```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi && docker compose up -d --build
```

That's it! Your FastAPI app is now running on **http://localhost:8000**

## Verify It's Running

```bash
curl http://localhost:8000/health
```

Expected response: `{"status":"healthy","service":"fastapi-presenton"}`

## Access Your Application

- **API**: http://localhost:8000
- **Swagger Docs**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Basic Commands

```bash
# Start
docker compose up -d

# Stop
docker compose down

# View logs
docker compose logs -f

# Restart
docker compose restart
```

## Using Makefile (Easier)

```bash
# Start
make up-build

# Stop
make down

# Logs
make logs

# Help
make help
```

## If You Get Permission Errors

Add `sudo` before commands:
```bash
sudo docker compose up -d --build
sudo make up-build
```

## 📚 Documentation

- **DOCKER_SETUP_COMPLETE.md** - Quick reference guide
- **DOCKER_RUN_GUIDE.md** - Detailed step-by-step guide
- **README_DOCKER.md** - Complete documentation

## Need Help?

```bash
# Check logs
docker compose logs -f

# Check container status
docker ps

# See all make commands
make help
```

---

**That's all you need to get started!** 🎉

The application includes:
- ✅ FastAPI on port 8000
- ✅ Automatic API documentation
- ✅ Health monitoring
- ✅ Hot reload for development
- ✅ Data persistence
- ✅ Easy start/stop
