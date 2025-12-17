# 🚀 Quick Start - FastAPI Docker on Port 8000

## ⚡ Start in 2 Steps

### Step 1: Navigate to directory
```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi
```

### Step 2: Build and Start (Choose ONE method)

#### Method A: Using Docker Compose (Recommended)
```bash
sudo docker compose build
sudo docker compose up -d
```

#### Method B: Using Makefile
```bash
sudo make up-build
```

#### Method C: Using Start Script
```bash
sudo ./docker-start.sh
```

That's it! Your app is now running! 🎉

---

## ✅ Verify It's Running

```bash
# Check container status
sudo docker ps | grep fastapi

# Test health endpoint
curl http://localhost:8000/health
```

Expected response: `{"status":"healthy","service":"fastapi-presenton"}`

---

## 🌐 Access Your Application

- **API Base**: http://localhost:8000
- **Swagger UI (Interactive Docs)**: http://localhost:8000/docs ⭐
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

---

## 📋 Essential Commands

```bash
# View logs (real-time)
sudo docker compose logs -f

# Stop application
sudo docker compose down

# Restart
sudo docker compose restart

# Rebuild after changes
sudo docker compose build
sudo docker compose up -d
```

---

## ⚠️ About the "sudo" Requirement

You need `sudo` because your user doesn't have Docker permissions yet.

### Option 1: Keep using sudo (easiest)
Just add `sudo` before all docker commands. Works immediately!

### Option 2: Fix permissions permanently (recommended)
```bash
# Run this once
./docker-setup-permissions.sh

# Then logout and login again
# After that, no more sudo needed!
```

See **DOCKER_PERMISSION_FIX.md** for details.

---

## 🎯 What to Do Now

1. **✅ Access the Swagger UI**: http://localhost:8000/docs
   - This is your interactive API documentation
   - You can test all API endpoints here

2. **📝 Configure API Keys** (Optional):
   ```bash
   cp .env.example .env
   nano .env  # Add your API keys
   sudo docker compose restart
   ```

3. **🔍 View Logs**:
   ```bash
   sudo docker compose logs -f
   ```

4. **🧪 Test an Endpoint**:
   ```bash
   curl http://localhost:8000/health
   ```

---

## 🛑 How to Stop

```bash
# Stop the container
sudo docker compose down

# Stop and remove all data
sudo docker compose down -v
```

---

## 🆘 Having Issues?

### Container won't start?
```bash
# Check logs
sudo docker compose logs

# Rebuild from scratch
sudo docker compose down -v
sudo docker compose build --no-cache
sudo docker compose up -d
```

### Port 8000 already in use?
```bash
# Find what's using it
sudo lsof -i :8000

# Kill the process
sudo kill -9 <PID>
```

### Other issues?
Read **DOCKER_PERMISSION_FIX.md** for permission issues
Read **DOCKER_RUN_GUIDE.md** for detailed troubleshooting

---

## 📚 Need More Help?

- **Quick Start**: This file ⭐
- **Permission Issues**: DOCKER_PERMISSION_FIX.md
- **Detailed Guide**: DOCKER_RUN_GUIDE.md
- **Complete Docs**: README_DOCKER.md

---

## 🎉 Success!

If you can access http://localhost:8000/docs, you're all set!

Your FastAPI application is running in Docker on port 8000! 🚀

**Pro Tip**: Bookmark http://localhost:8000/docs for easy access to your API documentation.
