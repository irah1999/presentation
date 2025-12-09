# Presenton - FastAPI Presentation Service

A powerful FastAPI-based service for creating AI-powered presentations using various LLM providers (OpenAI, Anthropic, Google, Ollama).

## Features

- 🤖 Multiple LLM provider support (OpenAI, Anthropic, Google Gemini, Ollama, Custom)
- 🖼️ Image generation and search integration (Pexels, Pixabay)
- 📊 Presentation template management
- 🎨 Customizable layouts and themes
- 🔄 Webhook support
- 📝 Document parsing (PDF, PPTX)
- 💾 SQLite/PostgreSQL/MySQL database support

## Prerequisites

- Python 3.11 (required)
- pip or uv package manager

## Quick Start

### 1. Clone and Navigate

```bash
cd d:\react-js\presentation-1
```

### 2. Create Virtual Environment

```bash
python -m venv venv
```

### 3. Activate Virtual Environment

**Windows:**
```bash
.\venv\Scripts\activate
```

**Linux/Mac:**
```bash
source venv/bin/activate
```

### 4. Install Dependencies

```bash
pip install -r requirements.txt
```

### 5. Configure Environment

Create a `.env` file in the root directory (copy from `.env.example`):

```bash
cp .env.example .env
```

Edit `.env` and configure your settings:

```env
# Database
DATABASE_URL=sqlite+aiosqlite:///./data/database.db

# Directories
APP_DATA_DIRECTORY=./data
TEMP_DIRECTORY=./temp

# LLM Configuration (Choose one)
LLM=openai
OPENAI_API_KEY=your_openai_api_key
OPENAI_MODEL=gpt-4o

# Image Provider (Optional)
IMAGE_PROVIDER=pexels
PEXELS_API_KEY=your_pexels_api_key
```

### 6. Run the Server

```bash
python server.py --port 8000 --reload true
```

The API will be available at: `http://127.0.0.1:8000`

## API Documentation

Once the server is running, visit:
- **Swagger UI**: http://127.0.0.1:8000/docs
- **ReDoc**: http://127.0.0.1:8000/redoc

## Configuration Options

### LLM Providers

#### OpenAI
```env
LLM=openai
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o
```

#### Anthropic Claude
```env
LLM=anthropic
ANTHROPIC_API_KEY=sk-ant-...
ANTHROPIC_MODEL=claude-3-5-sonnet-20240620
```

#### Google Gemini
```env
LLM=google
GOOGLE_API_KEY=...
GOOGLE_MODEL=gemini-2.0-flash-exp
```

#### Ollama (Local)
```env
LLM=ollama
OLLAMA_URL=http://localhost:11434
OLLAMA_MODEL=llama2
```

#### Custom LLM
```env
LLM=custom
CUSTOM_LLM_URL=https://your-api-endpoint.com
CUSTOM_LLM_API_KEY=...
CUSTOM_MODEL=your-model-name
```

### Image Providers

#### Pexels
```env
IMAGE_PROVIDER=pexels
PEXELS_API_KEY=...
```

#### Pixabay
```env
IMAGE_PROVIDER=pixabay
PIXABAY_API_KEY=...
```

#### Disable Image Generation
```env
DISABLE_IMAGE_GENERATION=true
```

### Database Options

#### SQLite (Default)
```env
DATABASE_URL=sqlite+aiosqlite:///./data/database.db
```

#### PostgreSQL
```env
DATABASE_URL=postgresql+asyncpg://user:password@localhost/dbname
```

#### MySQL
```env
DATABASE_URL=mysql+aiomysql://user:password@localhost/dbname
```

## Project Structure

```
presentation-1/
├── api/                    # API routes and endpoints
│   ├── v1/
│   │   ├── ppt/           # Presentation endpoints
│   │   ├── webhook/       # Webhook endpoints
│   │   └── mock/          # Mock endpoints
│   ├── main.py            # FastAPI application
│   ├── lifespan.py        # App lifecycle management
│   └── middlewares.py     # Custom middlewares
├── services/              # Business logic services
├── models/                # Database models
├── utils/                 # Utility functions
├── constants/             # Constants and configurations
├── enums/                 # Enumerations
├── static/                # Static files
├── tests/                 # Test files
├── data/                  # Application data (created on first run)
├── temp/                  # Temporary files (created on first run)
├── server.py              # Server entry point
├── requirements.txt       # Python dependencies
├── pyproject.toml         # Project configuration
└── .env                   # Environment variables (create from .env.example)
```

## API Endpoints

### Presentation Endpoints (`/api/v1/ppt`)
- Create presentations
- Generate slides
- Manage templates
- Upload/manage images
- Search icons

### Webhook Endpoints (`/api/v1/webhook`)
- Webhook integrations
- Event handling

### Mock Endpoints (`/api/v1/mock`)
- Testing and development

## Development

### Running in Development Mode

```bash
python server.py --port 8000 --reload true
```

The `--reload true` flag enables auto-reload on code changes.

### Running Tests

```bash
pytest
```

### Running on Different Port

```bash
python server.py --port 3000 --reload true
```

## Troubleshooting

### Python Version Issues
Ensure you're using Python 3.11:
```bash
python --version
```

### Missing Dependencies
Reinstall dependencies:
```bash
pip install -r requirements.txt --force-reinstall
```

### Database Issues
Delete the database and restart:
```bash
rm -rf data/
python server.py --port 8000 --reload true
```

### Port Already in Use
Change the port number:
```bash
python server.py --port 8001 --reload true
```

## Environment Variables Reference

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `DATABASE_URL` | Database connection string | `sqlite+aiosqlite:///./data/database.db` | No |
| `APP_DATA_DIRECTORY` | Application data directory | `./data` | No |
| `TEMP_DIRECTORY` | Temporary files directory | `./temp` | No |
| `LLM` | LLM provider (openai/anthropic/google/ollama/custom) | - | Yes |
| `OPENAI_API_KEY` | OpenAI API key | - | If using OpenAI |
| `OPENAI_MODEL` | OpenAI model name | `gpt-4o` | If using OpenAI |
| `ANTHROPIC_API_KEY` | Anthropic API key | - | If using Anthropic |
| `ANTHROPIC_MODEL` | Anthropic model name | `claude-3-5-sonnet-20240620` | If using Anthropic |
| `GOOGLE_API_KEY` | Google API key | - | If using Google |
| `GOOGLE_MODEL` | Google model name | `gemini-2.0-flash-exp` | If using Google |
| `OLLAMA_URL` | Ollama server URL | `http://localhost:11434` | If using Ollama |
| `OLLAMA_MODEL` | Ollama model name | - | If using Ollama |
| `CUSTOM_LLM_URL` | Custom LLM endpoint URL | - | If using custom |
| `CUSTOM_LLM_API_KEY` | Custom LLM API key | - | If using custom |
| `CUSTOM_MODEL` | Custom model name | - | If using custom |
| `IMAGE_PROVIDER` | Image provider (pexels/pixabay) | - | No |
| `PEXELS_API_KEY` | Pexels API key | - | If using Pexels |
| `PIXABAY_API_KEY` | Pixabay API key | - | If using Pixabay |
| `DISABLE_IMAGE_GENERATION` | Disable image generation | `false` | No |
| `CAN_CHANGE_KEYS` | Allow runtime key changes | `false` | No |
| `TOOL_CALLS` | Enable tool calls | `true` | No |
| `DISABLE_THINKING` | Disable thinking mode | `false` | No |
| `EXTENDED_REASONING` | Enable extended reasoning | `false` | No |
| `WEB_GROUNDING` | Enable web grounding | `false` | No |

## License

See LICENSE file for details.

## Support

For issues and questions, please create an issue in the repository.
