# Migration Guide: FastAPI to Next.js API Routes

## Overview
This document outlines the migration from Python FastAPI backend to Next.js API routes.

## Current Status
- **FastAPI Endpoints**: 100+ Python files
- **Database**: SQLAlchemy/SQLModel with SQLite/PostgreSQL
- **Key Features**: Presentation generation, LLM integrations, PPTX/PDF export

## Migration Strategy

### Phase 1: Setup (CURRENT)
1. ✅ Update package.json for standalone Next.js
2. ⏳ Remove FastAPI proxy rewrites from next.config.mjs
3. ⏳ Set up Prisma for database
4. ⏳ Create base API route structure

### Phase 2: Core API Migration
1. User configuration endpoints
2. Presentation CRUD operations
3. Template management
4. File uploads

### Phase 3: LLM Integration
1. OpenAI integration
2. Google Gemini integration
3. Anthropic Claude integration
4. Ollama integration

### Phase 4: Advanced Features
1. Image generation
2. PPTX generation (using officegen or pptxgenjs)
3. PDF export (using Puppeteer - already installed)
4. Streaming responses

## Key Challenges

### 1. Database Migration
**Python (SQLAlchemy)** → **Node.js (Prisma)**
- Need to create Prisma schema
- Migrate all models
- Update queries

### 2. Python Libraries → JavaScript Alternatives
- `python-pptx` → `pptxgenjs` or `officegen`
- `PyPDF2` → `pdf-lib`
- `Pillow` → `sharp` (already installed)

### 3. Async Patterns
- Python `asyncio` → Node.js `async/await`
- Background tasks → Next.js API routes with separate processes

## Next Steps

1. **Install Required Packages**:
   ```bash
   cd servers/nextjs
   npm install prisma @prisma/client
   npm install pptxgenjs pdf-lib
   npm install openai @anthropic-ai/sdk @google/generative-ai
   ```

2. **Initialize Prisma**:
   ```bash
   npx prisma init
   ```

3. **Create API Routes** (see `/app/api/v1/ppt/` structure)

4. **Test Each Endpoint** as you migrate

## File Structure

```
servers/nextjs/
├── app/
│   ├── api/
│   │   ├── v1/
│   │   │   └── ppt/
│   │   │       ├── presentation/
│   │   │       │   ├── all/route.ts
│   │   │       │   ├── [id]/route.ts
│   │   │       │   ├── create/route.ts
│   │   │       │   ├── generate/route.ts
│   │   │       │   └── export/route.ts
│   │   │       ├── openai/
│   │   │       │   └── models/
│   │   │       │       └── available/route.ts
│   │   │       ├── google/
│   │   │       ├── anthropic/
│   │   │       ├── ollama/
│   │   │       ├── files/
│   │   │       ├── images/
│   │   │       └── templates/
│   │   └── user-config/route.ts
│   └── ...
├── lib/
│   ├── db.ts (Prisma client)
│   ├── llm/
│   │   ├── openai.ts
│   │   ├── google.ts
│   │   ├── anthropic.ts
│   │   └── ollama.ts
│   └── services/
│       ├── presentation.ts
│       ├── pptx-generator.ts
│       └── pdf-generator.ts
└── prisma/
    └── schema.prisma
```

## Estimated Timeline
- **Phase 1**: 1-2 days
- **Phase 2**: 3-5 days
- **Phase 3**: 3-4 days
- **Phase 4**: 5-7 days
- **Total**: 2-3 weeks for full migration

## Notes
- Some Python-specific logic may need to be rewritten
- Testing is crucial after each phase
- Consider keeping Python backend temporarily for comparison
