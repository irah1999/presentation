# Docker Build and Run Script for Presenton FastAPI
# This script builds and runs the Python backend using Docker

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Presenton Docker Setup" -ForegroundColor Cyan
Write-Host "  Python FastAPI Backend Only" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed and running
Write-Host "Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not installed or not running!" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    exit 1
}

# Check if Docker is running
try {
    docker ps | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Choose an option:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "1. Build and run with Docker Compose (Recommended)" -ForegroundColor White
Write-Host "2. Build and run with Docker CLI" -ForegroundColor White
Write-Host "3. Stop and remove containers" -ForegroundColor White
Write-Host "4. View logs" -ForegroundColor White
Write-Host "5. Rebuild from scratch" -ForegroundColor White
Write-Host "6. Exit" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (1-6)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Building and starting with Docker Compose..." -ForegroundColor Yellow
        Write-Host ""
        
        # Check if .env file exists
        if (Test-Path ".env") {
            Write-Host "✓ Found .env file" -ForegroundColor Green
        } else {
            Write-Host "⚠ No .env file found. You may need to configure API keys." -ForegroundColor Yellow
            Write-Host "  Create a .env file with your API keys (see DOCKER_GUIDE.md)" -ForegroundColor Gray
        }
        
        Write-Host ""
        Write-Host "Starting containers..." -ForegroundColor Yellow
        docker-compose -f docker-compose.python.yml up -d --build
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✓ Container started successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Access your application at:" -ForegroundColor Cyan
            Write-Host "  • API Docs: http://localhost:8000/docs" -ForegroundColor White
            Write-Host "  • ReDoc: http://localhost:8000/redoc" -ForegroundColor White
            Write-Host ""
            Write-Host "View logs with:" -ForegroundColor Gray
            Write-Host "  docker-compose -f docker-compose.python.yml logs -f" -ForegroundColor White
        } else {
            Write-Host "❌ Failed to start container!" -ForegroundColor Red
        }
    }
    
    "2" {
        Write-Host ""
        Write-Host "Building Docker image..." -ForegroundColor Yellow
        docker build -f Dockerfile.python -t presenton-fastapi .
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Image built successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Starting container..." -ForegroundColor Yellow
            
            docker run -d `
                --name presenton-fastapi `
                -p 8000:8000 `
                -v "${PWD}\app_data:/app_data" `
                -e APP_DATA_DIRECTORY=/app_data `
                -e TEMP_DIRECTORY=/tmp/presenton `
                presenton-fastapi
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ Container started successfully!" -ForegroundColor Green
                Write-Host ""
                Write-Host "Access your application at:" -ForegroundColor Cyan
                Write-Host "  • API Docs: http://localhost:8000/docs" -ForegroundColor White
                Write-Host "  • ReDoc: http://localhost:8000/redoc" -ForegroundColor White
            } else {
                Write-Host "❌ Failed to start container!" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ Failed to build image!" -ForegroundColor Red
        }
    }
    
    "3" {
        Write-Host ""
        Write-Host "Stopping and removing containers..." -ForegroundColor Yellow
        
        # Try Docker Compose first
        docker-compose -f docker-compose.python.yml down
        
        # Also try to stop individual container
        docker stop presenton-fastapi 2>$null
        docker rm presenton-fastapi 2>$null
        
        Write-Host "✓ Containers stopped and removed" -ForegroundColor Green
    }
    
    "4" {
        Write-Host ""
        Write-Host "Viewing logs (Press Ctrl+C to exit)..." -ForegroundColor Yellow
        Write-Host ""
        
        # Try Docker Compose first
        if (docker ps --filter "name=presenton" --format "{{.Names}}" | Select-String "presenton") {
            docker-compose -f docker-compose.python.yml logs -f
        } else {
            Write-Host "No running containers found!" -ForegroundColor Red
        }
    }
    
    "5" {
        Write-Host ""
        Write-Host "Rebuilding from scratch..." -ForegroundColor Yellow
        Write-Host ""
        
        Write-Host "Stopping containers..." -ForegroundColor Gray
        docker-compose -f docker-compose.python.yml down
        docker stop presenton-fastapi 2>$null
        docker rm presenton-fastapi 2>$null
        
        Write-Host "Removing old images..." -ForegroundColor Gray
        docker rmi presenton-fastapi 2>$null
        
        Write-Host "Building new image (no cache)..." -ForegroundColor Gray
        docker-compose -f docker-compose.python.yml build --no-cache
        
        Write-Host "Starting containers..." -ForegroundColor Gray
        docker-compose -f docker-compose.python.yml up -d
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✓ Rebuild complete!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Access your application at:" -ForegroundColor Cyan
            Write-Host "  • API Docs: http://localhost:8000/docs" -ForegroundColor White
        } else {
            Write-Host "❌ Rebuild failed!" -ForegroundColor Red
        }
    }
    
    "6" {
        Write-Host ""
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit 0
    }
    
    default {
        Write-Host ""
        Write-Host "Invalid choice. Please run the script again." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "For more information, see DOCKER_GUIDE.md" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
