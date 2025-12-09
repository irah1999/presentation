# Quick Start Guide

## Running the FastAPI Server Locally

### 1. Activate Virtual Environment

**Windows:**
```bash
.\venv\Scripts\activate
```

**Linux/Mac:**
```bash
source venv/bin/activate
```

### 2. Set Environment Variables

Copy `.env.example` to `.env` and configure your API keys:

```bash
cp .env.example .env
```

**Minimum required configuration:**
```env
DATABASE_URL=sqlite+aiosqlite:///./data/database.db
APP_DATA_DIRECTORY=./data
TEMP_DIRECTORY=./temp

# Choose one LLM provider:
LLM=openai
OPENAI_API_KEY=your_api_key_here
OPENAI_MODEL=gpt-4o
```

### 3. Run the Server

```bash
python server.py --port 8000 --reload true
```

### 4. Access the API

- **API Base URL**: http://127.0.0.1:8000
- **Swagger Documentation**: http://127.0.0.1:8000/docs
- **ReDoc Documentation**: http://127.0.0.1:8000/redoc

## Available Commands

### Start Server (Development)
```bash
python server.py --port 8000 --reload true
```

### Start Server (Production)
```bash
python server.py --port 8000 --reload false
```

### Run Tests
```bash
pytest
```

### Install/Update Dependencies
```bash
pip install -r requirements.txt
```

## Project Cleanup Summary

✅ **Removed:**
- All Next.js frontend code (`servers/nextjs/`)
- Docker configuration files (Dockerfile, docker-compose.yml, nginx.conf)
- Frontend-related scripts and configuration
- Unused build scripts

✅ **Kept:**
- FastAPI backend code (moved to root)
- Python services and utilities
- Database models
- API endpoints
- Static assets
- Tests

✅ **Created:**
- `requirements.txt` - Python dependencies
- `.env.example` - Environment configuration template
- `README.md` - Comprehensive documentation
- `QUICKSTART.md` - This quick start guide

## Next Steps

1. Configure your `.env` file with your API keys
2. Start the server: `python server.py --port 8000 --reload true`
3. Visit http://127.0.0.1:8000/docs to explore the API
4. Start building your presentation application!

## Troubleshooting

**Server won't start?**
- Check that Python 3.11 is installed: `python --version`
- Ensure virtual environment is activated
- Verify `.env` file exists and has required variables

**Database errors?**
- Delete the `data/` folder and restart the server
- Check `DATABASE_URL` in `.env`

**Import errors?**
- Reinstall dependencies: `pip install -r requirements.txt --force-reinstall`

**Port already in use?**
- Change port: `python server.py --port 8001 --reload true`
