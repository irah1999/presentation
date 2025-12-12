# 🔧 Docker Permission Error - Fixed!

## The Problem

You're seeing this error:
```
permission denied while trying to connect to the Docker daemon socket
```

This happens because your user doesn't have permission to access Docker.

## ✅ Quick Fix (3 Options)

### Option 1: Use sudo (Quick & Easy)

Just add `sudo` before docker commands:

```bash
# Build and start
sudo docker compose build
sudo docker compose up -d

# OR with make
sudo make up-build
```

**This works immediately but you'll need sudo every time.**

---

### Option 2: Fix Permissions Permanently (Recommended)

Run this one-time setup:

```bash
# Run the permission setup script
./docker-setup-permissions.sh

# OR manually:
sudo usermod -aG docker $USER
newgrp docker
```

**After this, you won't need sudo anymore!**

Then you can run:
```bash
docker compose build
docker compose up -d
make up-build
```

---

### Option 3: Use the Updated Makefile

The Makefile has been updated to automatically handle sudo if needed:

```bash
# These will use sudo if needed
make build
make up
make up-build
```

---

## 🚀 Step-by-Step: Start Your Application Now

### Using Option 1 (sudo - fastest):

```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi

# Build and start
sudo docker compose build
sudo docker compose up -d

# Check it's running
sudo docker ps

# View logs
sudo docker compose logs -f
```

### Using Option 2 (fix permissions first):

```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi

# Fix permissions (one time)
./docker-setup-permissions.sh

# Then logout/login OR run:
newgrp docker

# Now build and start (no sudo needed!)
docker compose build
docker compose up -d
```

### Using Option 3 (Makefile with auto-sudo):

```bash
cd /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi

# These handle sudo automatically
make build
make up
```

---

## ✅ Verify It's Working

After starting, check:

```bash
# Check container is running (use sudo if needed)
docker ps | grep fastapi

# Check health endpoint
curl http://localhost:8000/health
```

Expected output:
```json
{"status":"healthy","service":"fastapi-presenton"}
```

---

## 📊 Access Your Application

Once running:
- **API**: http://localhost:8000
- **Swagger Docs**: http://localhost:8000/docs
- **Health**: http://localhost:8000/health

---

## 🔄 Common Commands (with sudo)

```bash
# Start
sudo docker compose up -d

# Stop
sudo docker compose down

# View logs
sudo docker compose logs -f

# Restart
sudo docker compose restart

# Rebuild
sudo docker compose build
sudo docker compose up -d

# Check status
sudo docker ps
```

---

## 💡 Why This Happens

Docker daemon runs as root, and by default, only root can access it. Adding your user to the `docker` group gives permission without needing sudo every time.

---

## 🎯 Recommended Approach

1. **For now**: Use sudo to start quickly
   ```bash
   sudo docker compose build
   sudo docker compose up -d
   ```

2. **For later**: Fix permissions permanently
   ```bash
   ./docker-setup-permissions.sh
   # Then logout/login
   ```

3. **Going forward**: Run without sudo
   ```bash
   docker compose up -d
   make up-build
   ```

---

## ✨ Next Steps

Choose your method above, then:

1. **Start the application**
2. **Verify health**: `curl http://localhost:8000/health`
3. **Open docs**: http://localhost:8000/docs
4. **Start developing!**

Your FastAPI app will be running on port 8000! 🎉
