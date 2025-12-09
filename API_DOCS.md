# API Documentation

## Base URL
```
http://127.0.0.1:8000
```

## Interactive Documentation

- **Swagger UI**: http://127.0.0.1:8000/docs
- **ReDoc**: http://127.0.0.1:8000/redoc

## API Endpoints Overview

### Presentation Management (`/api/v1/ppt`)

#### Files
- Upload and manage presentation files
- File storage and retrieval

#### Fonts
- Font management for presentations
- Custom font support

#### Outlines
- Generate presentation outlines
- Outline management and editing

#### Presentations
- Create new presentations
- Update existing presentations
- Delete presentations
- List all presentations

#### Slides
- Individual slide management
- Slide creation and editing
- Slide ordering

#### PPTX Slides
- Import from PowerPoint files
- Export to PowerPoint format
- PPTX font extraction

#### PDF Slides
- Import from PDF files
- PDF parsing and conversion

#### Slide to HTML
- Convert slides to HTML format
- HTML preview generation

#### HTML to React
- Convert HTML slides to React components
- Component generation

#### HTML Editing
- Edit HTML content
- HTML manipulation

#### Layout Management
- Manage slide layouts
- Template management

#### Images
- Image upload and storage
- Image search integration
- Image generation (if enabled)
- Image management (list, delete)

#### Icons
- Icon search functionality
- Icon library integration

#### LLM Providers

##### OpenAI (`/api/v1/ppt/openai`)
- Generate content using OpenAI models
- GPT-4, GPT-3.5 support

##### Anthropic (`/api/v1/ppt/anthropic`)
- Generate content using Claude models
- Claude 3.5 Sonnet, Claude 3 Opus support

##### Google (`/api/v1/ppt/google`)
- Generate content using Google Gemini models
- Gemini Pro, Gemini Flash support

##### Ollama (`/api/v1/ppt/ollama`)
- Generate content using local Ollama models
- Support for Llama, Mistral, and other models

### Webhooks (`/api/v1/webhook`)
- Webhook event handling
- Integration callbacks

### Mock Endpoints (`/api/v1/mock`)
- Testing and development endpoints
- Mock data generation

## Common Request/Response Patterns

### Success Response
```json
{
  "status": "success",
  "data": { ... }
}
```

### Error Response
```json
{
  "detail": "Error message"
}
```

## Authentication

Currently, the API does not require authentication. For production use, consider implementing:
- API Key authentication
- OAuth 2.0
- JWT tokens

## CORS

CORS is enabled for all origins (`*`). For production, configure specific allowed origins in `api/main.py`.

## Rate Limiting

No rate limiting is currently implemented. Consider adding rate limiting for production use.

## Example API Calls

### Create a Presentation

```bash
curl -X POST "http://127.0.0.1:8000/api/v1/ppt/presentations" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Presentation",
    "description": "A sample presentation"
  }'
```

### Generate Slide Content with OpenAI

```bash
curl -X POST "http://127.0.0.1:8000/api/v1/ppt/openai/generate" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Create a slide about AI in healthcare",
    "model": "gpt-4o"
  }'
```

### Search for Images

```bash
curl -X GET "http://127.0.0.1:8000/api/v1/ppt/images/search?query=technology&per_page=10"
```

### Upload an Image

```bash
curl -X POST "http://127.0.0.1:8000/api/v1/ppt/images/upload" \
  -F "file=@/path/to/image.jpg"
```

## Environment Configuration

The API behavior can be configured through environment variables. See `.env.example` for all available options.

### Key Configuration Options

- `LLM`: Choose LLM provider (openai, anthropic, google, ollama, custom)
- `IMAGE_PROVIDER`: Choose image provider (pexels, pixabay)
- `DISABLE_IMAGE_GENERATION`: Disable AI image generation
- `DATABASE_URL`: Database connection string

## Error Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request |
| 404 | Not Found |
| 422 | Validation Error |
| 500 | Internal Server Error |

## Development Tips

1. **Use Swagger UI** for interactive API testing: http://127.0.0.1:8000/docs
2. **Enable reload mode** during development: `python server.py --port 8000 --reload true`
3. **Check logs** for debugging information
4. **Use mock endpoints** for testing without consuming API credits

## Next Steps

1. Start the server: `python server.py --port 8000 --reload true`
2. Visit http://127.0.0.1:8000/docs
3. Explore the interactive API documentation
4. Test endpoints using the Swagger UI
5. Build your application using the API

## Support

For detailed endpoint documentation, visit the Swagger UI at http://127.0.0.1:8000/docs after starting the server.
