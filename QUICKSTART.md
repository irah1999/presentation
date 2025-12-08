# Quick Start Guide - Next.js Presenton

## Prerequisites
- Node.js 18+ installed
- npm or yarn package manager

## Setup Steps

### 1. Navigate to the Next.js directory
```bash
cd servers/nextjs
```

### 2. Run the setup script
```bash
node setup.js
```

This will:
- Install all dependencies
- Create .env file from .env.example
- Generate Prisma client
- Create the database

### 3. Configure your API keys
Edit the `.env` file and add your API keys:

```env
# Choose your LLM provider
LLM="openai"  # or "google", "anthropic", "ollama", "custom"

# Add your API key
OPENAI_API_KEY="your-api-key-here"
# OR
GOOGLE_API_KEY="your-api-key-here"
# OR
ANTHROPIC_API_KEY="your-api-key-here"

# Configure image generation
IMAGE_PROVIDER="dall-e-3"  # or "gemini_flash", "pexels", "pixabay"
```

### 4. Start the development server
```bash
npm run dev
```

### 5. Open your browser
Navigate to [http://localhost:3000](http://localhost:3000)

## Manual Setup (Alternative)

If you prefer to set up manually:

```bash
cd servers/nextjs

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Edit .env with your API keys
# (use your preferred text editor)

# Generate Prisma client
npx prisma generate

# Create database
npx prisma db push

# Start development server
npm run dev
```

## Troubleshooting

### Port 3000 is already in use
Change the port in package.json or use:
```bash
npm run dev -- -p 3001
```

### Database errors
Delete the database and recreate:
```bash
rm prisma/dev.db
npx prisma db push
```

### Module not found errors
Reinstall dependencies:
```bash
rm -rf node_modules package-lock.json
npm install
```

## Next Steps

1. **Configure LLM Provider**: Edit `.env` to set your preferred LLM
2. **Add API Keys**: Add your API keys for the chosen providers
3. **Test the Application**: Try creating a presentation
4. **Read the Docs**: Check `README.md` for more information

## Migration Status

This is a work-in-progress migration from FastAPI to Next.js. See `MIGRATION_GUIDE.md` for details on what's been migrated and what's still in progress.

## Need Help?

- Check the [README.md](./README.md) for detailed documentation
- Review [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) for migration details
- Open an issue on GitHub if you encounter problems
