# Presenton Python Project Setup Guide

## Prerequisites

Before starting, ensure you have:
- **Python 3.11** installed (required version as per `pyproject.toml`)
- **pip** (Python package installer)
- **Git** (for version control)

## Step-by-Step Setup Process

### Step 1: Verify Python Version

First, check if you have Python 3.11 or higher installed:

```powershell
python --version
```

**Expected Output:** `Python 3.11.x` or higher

If you don't have Python 3.11, download it from:
- Official Python website: https://www.python.org/downloads/
- Or use `pyenv` for Windows to manage multiple Python versions

### Step 2: Navigate to the FastAPI Directory

```powershell
cd d:\react-js\ppt\servers\fastapi
```

### Step 3: Create Virtual Environment

Create a new virtual environment named `venv`:

```powershell
python -m venv venv
```

This creates a `venv` folder in the `fastapi` directory containing:
- Python interpreter
- pip package manager
- Isolated package installation location

### Step 4: Activate Virtual Environment

Activate the virtual environment:

```powershell
.\venv\Scripts\Activate.ps1
```

**Note:** If you encounter an execution policy error, run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Expected Result:** Your terminal prompt should now show `(venv)` at the beginning:
```
(venv) PS D:\react-js\ppt\servers\fastapi>
```

### Step 5: Upgrade pip

Ensure you have the latest version of pip:

```powershell
python -m pip install --upgrade pip
```

### Step 6: Install Project Dependencies

The project uses `pyproject.toml` for dependency management. Install all dependencies:

```powershell
pip install -e .
```

This will install all packages listed in `pyproject.toml`, including:
- FastAPI (web framework)
- Uvicorn (ASGI server)
- OpenAI, Anthropic, Google GenAI (AI providers)
- ChromaDB (vector database)
- python-pptx (PowerPoint generation)
- And many more...

**Note:** This may take several minutes depending on your internet connection.

### Step 7: Verify Installation

Check if all packages are installed correctly:

```powershell
pip list
```

You should see a long list of installed packages.

### Step 8: Set Up Environment Variables (Optional)

Create a `.env` file in the `servers/fastapi` directory if you need to configure API keys:

```powershell
# Create .env file
New-Item -Path .env -ItemType File -Force
```

Add your API keys (example):
```
OPENAI_API_KEY=your_openai_key_here
GOOGLE_API_KEY=your_google_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here
```

### Step 9: Run the FastAPI Server

Start the development server:

```powershell
python server.py --port 8000 --reload false
```

Or with auto-reload for development:

```powershell
uvicorn server:app --host 0.0.0.0 --port 8000 --reload
```

**Expected Output:**
```
INFO:     Started server process [xxxx]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000
```

### Step 10: Test the API

Open your browser and navigate to:
- **API Documentation:** http://localhost:8000/docs
- **Alternative Docs:** http://localhost:8000/redoc

You should see the FastAPI interactive documentation.

### Step 11: Run the MCP Server (Optional)

If you need the MCP (Model Context Protocol) server, open a new terminal and:

```powershell
cd d:\react-js\ppt\servers\fastapi
.\venv\Scripts\Activate.ps1
python mcp_server.py --port 8001
```

## Deactivating Virtual Environment

When you're done working, deactivate the virtual environment:

```powershell
deactivate
```

## Troubleshooting

### Issue: Python 3.11 Not Found

**Solution:** Install Python 3.11 from https://www.python.org/downloads/

### Issue: Execution Policy Error

**Solution:** Run PowerShell as Administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Issue: Package Installation Fails

**Solution:** 
1. Ensure you're using Python 3.11
2. Update pip: `python -m pip install --upgrade pip`
3. Try installing packages individually if bulk install fails

### Issue: Port Already in Use

**Solution:** Change the port number:
```powershell
python server.py --port 8001 --reload false
```

## Project Structure

```
d:\react-js\ppt\
├── servers\
│   └── fastapi\
│       ├── api\              # API endpoints
│       ├── models\           # Data models
│       ├── services\         # Business logic
│       ├── utils\            # Utility functions
│       ├── server.py         # Main FastAPI server
│       ├── mcp_server.py     # MCP server
│       ├── pyproject.toml    # Dependencies
│       └── venv\             # Virtual environment (created)
├── app_data\                 # Application data storage
└── README.md                 # Project documentation
```

## Next Steps

1. **Configure API Keys:** Add your AI provider API keys to environment variables
2. **Explore API:** Visit http://localhost:8000/docs to see available endpoints
3. **Generate Presentations:** Use the `/api/v1/ppt/presentation/generate` endpoint
4. **Read Documentation:** Check https://docs.presenton.ai for more details

## Quick Reference Commands

```powershell
# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Deactivate virtual environment
deactivate

# Install dependencies
pip install -e .

# Run FastAPI server
python server.py --port 8000 --reload false

# Run with uvicorn (development)
uvicorn server:app --host 0.0.0.0 --port 8000 --reload

# List installed packages
pip list

# Update a package
pip install --upgrade package_name
```

## Additional Resources

- **Official Documentation:** https://docs.presenton.ai
- **Discord Community:** https://discord.gg/9ZsKKxudNE
- **GitHub Repository:** Check the README.md for latest updates
- **API Tutorials:** https://docs.presenton.ai/tutorial/generate-presentation-over-api

---

**Last Updated:** December 10, 2025
