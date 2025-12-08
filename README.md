# Presenton - Next.js AI Presentation Generator

Open-source AI presentation generator built with Next.js. Generate professional presentations using AI - all running locally on your device.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ installed
- npm or yarn package manager

### Setup

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Set up environment variables**:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and add your API keys.

3. **Initialize database**:
   ```bash
   npx prisma generate
   npx prisma db push
   ```

4. **Run development server**:
   ```bash
   npm run dev
   ```

5. **Open your browser**:
   Navigate to [http://localhost:3000](http://localhost:3000)

## ✨ Features

- ✅ **AI-Powered Generation** — Generate presentations from prompts or documents
- ✅ **Multiple LLM Providers** — OpenAI, Google Gemini, Anthropic Claude, Ollama
- ✅ **Custom Templates** — Create unlimited presentation designs
- ✅ **Export Ready** — Save as PowerPoint (PPTX) and PDF
- ✅ **Image Generation** — DALL-E 3, Gemini Flash, Pexels, Pixabay
- ✅ **Fully Open-Source** — Apache 2.0 licensed
- ✅ **Privacy First** — All processing happens on your device

## 📁 Project Structure

```
presenton/
├── app/                    # Next.js app directory
│   ├── api/               # API routes
│   │   └── v1/ppt/       # Presentation API endpoints
│   ├── (presentation-generator)/  # UI pages
│   └── ...
├── components/            # React components
├── lib/                   # Utilities and services
│   └── db.ts             # Prisma database client
├── prisma/               # Database schema
│   └── schema.prisma
├── public/               # Static assets
├── types/                # TypeScript types
├── utils/                # Helper functions
├── .env                  # Environment variables
└── package.json          # Dependencies
```

## 🔧 Configuration

Edit `.env` to configure your LLM provider and API keys:

```env
# Choose your LLM provider
LLM="openai"  # Options: openai, google, anthropic, ollama, custom

# Add your API key
OPENAI_API_KEY="your-api-key-here"
GOOGLE_API_KEY="your-api-key-here"
ANTHROPIC_API_KEY="your-api-key-here"

# Configure image generation
IMAGE_PROVIDER="dall-e-3"  # Options: dall-e-3, gemini_flash, pexels, pixabay
```

## 📚 API Routes

### LLM Providers
- `POST /api/v1/ppt/openai/models/available` - List OpenAI models
- `POST /api/v1/ppt/google/models/available` - List Google models
- `POST /api/v1/ppt/anthropic/models/available` - List Anthropic models
- `GET /api/v1/ppt/ollama/models/available` - List Ollama models

### Presentations
- `GET /api/v1/ppt/presentation/all` - List all presentations
- `GET /api/v1/ppt/presentation/[id]` - Get presentation by ID
- `DELETE /api/v1/ppt/presentation/[id]` - Delete presentation
- `POST /api/v1/ppt/presentation/generate` - Generate presentation (WIP)

## 🛠️ Development

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Start production server
npm start

# View database
npx prisma studio

# Run linting
npm run lint
```

## 📦 Database

Using Prisma ORM with SQLite (can be changed to PostgreSQL in production).

### Models
- `Presentation` - Main presentation data
- `Slide` - Individual slides
- `Template` - Custom templates
- `ImageAsset` - Generated images
- `KeyValue` - Configuration storage

## 🚢 Deployment

### Production Build

```bash
npm run build
npm start
```

### Environment Variables

Make sure to set all required environment variables in your production environment.

## 📖 Documentation

- [QUICKSTART.md](./QUICKSTART.md) - Quick setup guide
- [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) - Migration from FastAPI
- [MIGRATION_STATUS.md](./MIGRATION_STATUS.md) - Current migration status

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

Apache 2.0

## 🔗 Links

- [Documentation](https://docs.presenton.ai)
- [Discord Community](https://discord.gg/9ZsKKxudNE)
- [Twitter/X](https://x.com/presentonai)

---

**Note**: This is a Next.js-only version. The Python FastAPI backend has been removed and all functionality is now handled by Next.js API routes.
