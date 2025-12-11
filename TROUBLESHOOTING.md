# 🔧 Troubleshooting Guide - Presenton Python Project

## Common Issues and Solutions

---

## Issue 1: ChromaDB Model Download Fails

### Symptoms
- Server hangs during startup
- Error: `httpx.RemoteProtocolError: peer closed connection`
- Download progress shows but then fails

### Solution A: Manual Model Download (Recommended)
The ChromaDB models can be problematic to download. Here's how to skip this step:

1. **Option 1: Disable ChromaDB temporarily**
   
   Comment out the ChromaDB initialization in the code or use a simpler embedding model.

2. **Option 2: Use a different embedding provider**
   
   Configure the application to use a different vector database or embedding provider.

3. **Option 3: Download manually**
   
   Download the model file manually and place it in the correct directory:
   - URL: https://chroma-onnx-models.s3.amazonaws.com/all-MiniLM-L6-v2/onnx.tar.gz
   - Extract to: `d:\react-js\ppt\servers\fastapi\chroma\models\`

### Solution B: Retry with Better Connection
```powershell
# Navigate to fastapi directory
cd d:\react-js\ppt\servers\fastapi

# Activate venv
.\venv\Scripts\Activate.ps1

# Start server (it will retry download)
python server.py --port 8000 --reload false
```

---

## Issue 2: Virtual Environment Activation Fails

### Symptoms
- Error: `cannot be loaded because running scripts is disabled`
- PowerShell execution policy error

### Solution
```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or for current session only
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

---

## Issue 3: Port Already in Use

### Symptoms
- Error: `Address already in use`
- Error: `OSError: [WinError 10048]`

### Solution A: Use Different Port
```powershell
python server.py --port 8001 --reload false
```

### Solution B: Find and Kill Process
```powershell
# Find process using port 8000
netstat -ano | findstr :8000

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

---

## Issue 4: Import Errors / Module Not Found

### Symptoms
- `ModuleNotFoundError: No module named 'fastapi'`
- `ImportError: cannot import name 'X'`

### Solution
```powershell
# Ensure virtual environment is activated
.\venv\Scripts\Activate.ps1

# Verify you're in the right directory
pwd
# Should show: d:\react-js\ppt\servers\fastapi

# Reinstall dependencies
pip install -e .

# Or install specific package
pip install fastapi uvicorn
```

---

## Issue 5: Python Version Mismatch

### Symptoms
- Error: `requires-python >=3.11,<3.12`
- Syntax errors with modern Python features

### Solution
```powershell
# Check Python version
python --version

# Should show Python 3.11.x
# If not, install Python 3.11 from python.org

# Recreate virtual environment with correct Python
python -m venv venv --clear
```

---

## Issue 6: Database Connection Errors

### Symptoms
- Error: `could not connect to database`
- SQLite/PostgreSQL/MySQL errors

### Solution
```powershell
# Check if app_data directory exists
Test-Path d:\react-js\ppt\app_data

# Create if missing
New-Item -ItemType Directory -Force -Path d:\react-js\ppt\app_data

# Set environment variables
$env:APP_DATA_DIRECTORY = "d:\react-js\ppt\app_data"
$env:TEMP_DIRECTORY = "d:\react-js\ppt\app_data\temp"
```

---

## Issue 7: API Key Not Working

### Symptoms
- Error: `Invalid API key`
- Error: `Authentication failed`

### Solution
1. **Check .env file**
   ```powershell
   # Create .env file in servers/fastapi/
   cd d:\react-js\ppt\servers\fastapi
   notepad .env
   ```

2. **Add your API keys**
   ```env
   OPENAI_API_KEY=sk-...
   GOOGLE_API_KEY=...
   ANTHROPIC_API_KEY=...
   ```

3. **Restart the server**

---

## Issue 8: Server Starts But No Output

### Symptoms
- Command runs but shows no output
- Server appears to hang

### Solution
```powershell
# Use uvicorn directly for verbose output
.\venv\Scripts\Activate.ps1
uvicorn api.main:app --host 127.0.0.1 --port 8000 --log-level debug
```

---

## Issue 9: Slow First Startup

### Explanation
This is **NORMAL**! First startup includes:
- ChromaDB model download (~79 MB)
- Database initialization
- Icon collection setup
- Model loading

**Expected time:** 5-15 minutes on first run

**Subsequent startups:** 5-10 seconds

### What to Do
- Be patient
- Don't interrupt the process
- Check internet connection
- Monitor progress in terminal

---

## Issue 10: Dependencies Installation Fails

### Symptoms
- Error during `pip install`
- Package conflicts
- Build errors

### Solution A: Install in Stages
```powershell
# Activate venv
.\venv\Scripts\Activate.ps1

# Install core packages first
pip install fastapi uvicorn

# Install AI packages
pip install openai anthropic google-genai

# Install document processing
pip install python-pptx pdfplumber

# Install database packages
pip install sqlmodel asyncpg aiomysql aiosqlite

# Install remaining packages
pip install chromadb docling nltk
```

### Solution B: Use Requirements File
```powershell
# If you have a requirements.txt
pip install -r requirements.txt

# Or from pyproject.toml
pip install -e .
```

---

## Quick Diagnostics

### Check Virtual Environment
```powershell
# Should show (venv) in prompt
.\venv\Scripts\Activate.ps1

# Check Python location
Get-Command python | Select-Object Source
# Should point to venv\Scripts\python.exe
```

### Check Installed Packages
```powershell
pip list | Select-String "fastapi|uvicorn|openai"
```

### Check Server Process
```powershell
# Check if server is running
netstat -ano | findstr :8000
```

### Test API Connection
```powershell
# Test if server is responding
curl http://127.0.0.1:8000/docs
```

---

## Environment Variables Checklist

Create `.env` file in `d:\react-js\ppt\servers\fastapi\`:

```env
# Required for AI features
OPENAI_API_KEY=your_key_here
GOOGLE_API_KEY=your_key_here
ANTHROPIC_API_KEY=your_key_here

# Image generation
IMAGE_PROVIDER=dall-e-3
PEXELS_API_KEY=your_key_here

# Application paths
APP_DATA_DIRECTORY=d:\react-js\ppt\app_data
TEMP_DIRECTORY=d:\react-js\ppt\app_data\temp

# Optional settings
CAN_CHANGE_KEYS=true
DISABLE_IMAGE_GENERATION=false
DISABLE_ANONYMOUS_TELEMETRY=true
```

---

## Clean Reinstall Steps

If nothing works, try a clean reinstall:

```powershell
# 1. Navigate to fastapi directory
cd d:\react-js\ppt\servers\fastapi

# 2. Remove virtual environment
Remove-Item -Recurse -Force venv

# 3. Remove downloaded models (optional)
Remove-Item -Recurse -Force chroma

# 4. Create new virtual environment
python -m venv venv

# 5. Activate it
.\venv\Scripts\Activate.ps1

# 6. Upgrade pip
python -m pip install --upgrade pip

# 7. Install dependencies
pip install fastapi[standard] uvicorn
pip install aiohttp aiomysql aiosqlite anthropic asyncpg
pip install chromadb dirtyjson docling fastmcp google-genai
pip install nltk openai pathvalidate pdfplumber pytest
pip install python-pptx redis sqlmodel

# 8. Start server
python server.py --port 8000 --reload false
```

---

## Getting Help

### Check Logs
Look for error messages in the terminal output.

### Community Support
- **Discord:** https://discord.gg/9ZsKKxudNE
- **GitHub Issues:** Check the repository for similar issues
- **Documentation:** https://docs.presenton.ai

### Provide Information When Asking for Help
1. Python version: `python --version`
2. OS version: `systeminfo | findstr /B /C:"OS Name" /C:"OS Version"`
3. Error message (full traceback)
4. Steps you've already tried
5. Output of `pip list`

---

## Performance Tips

### Speed Up Startup
1. Use `--reload false` in production
2. Pre-download ChromaDB models
3. Use SSD for app_data directory

### Reduce Memory Usage
1. Use smaller AI models
2. Limit concurrent requests
3. Configure ChromaDB memory limits

### Improve Response Time
1. Use local Ollama models
2. Cache frequently used data
3. Enable Redis caching

---

## Alternative: Run Without Virtual Environment (Not Recommended)

If you absolutely cannot use a virtual environment:

```powershell
# Install globally (not recommended)
pip install -e .

# Run server
cd d:\react-js\ppt\servers\fastapi
python server.py --port 8000 --reload false
```

**Warning:** This may cause conflicts with other Python projects!

---

## Still Having Issues?

### Create a Minimal Test
```python
# test_server.py
from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/")
def read_root():
    return {"status": "ok"}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
```

```powershell
# Run minimal test
python test_server.py

# If this works, the issue is with the main application
# If this fails, the issue is with your Python/FastAPI installation
```

---

**Last Updated:** December 11, 2025
