# Presenton FastAPI Server Startup Script
# This script activates the virtual environment and starts the FastAPI server

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Presenton FastAPI Server Startup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if virtual environment exists
if (-not (Test-Path ".\venv\Scripts\Activate.ps1")) {
    Write-Host "❌ Virtual environment not found!" -ForegroundColor Red
    Write-Host "Please run the following command first:" -ForegroundColor Yellow
    Write-Host "  python -m venv venv" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "✓ Virtual environment found" -ForegroundColor Green

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

# Check if activation was successful
if ($LASTEXITCODE -ne 0 -and $null -ne $LASTEXITCODE) {
    Write-Host "❌ Failed to activate virtual environment!" -ForegroundColor Red
    Write-Host "Try running: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Virtual environment activated" -ForegroundColor Green
Write-Host ""

# Set environment variables
$env:APP_DATA_DIRECTORY = "$PSScriptRoot\..\..\app_data"
$env:TEMP_DIRECTORY = "$PSScriptRoot\..\..\app_data\temp"

Write-Host "Environment Configuration:" -ForegroundColor Cyan
Write-Host "  APP_DATA_DIRECTORY: $env:APP_DATA_DIRECTORY" -ForegroundColor Gray
Write-Host "  TEMP_DIRECTORY: $env:TEMP_DIRECTORY" -ForegroundColor Gray
Write-Host ""

# Create directories if they don't exist
if (-not (Test-Path -Path $env:APP_DATA_DIRECTORY)) {
    New-Item -ItemType Directory -Force -Path $env:APP_DATA_DIRECTORY | Out-Null
    Write-Host "✓ Created app_data directory" -ForegroundColor Green
}

if (-not (Test-Path -Path $env:TEMP_DIRECTORY)) {
    New-Item -ItemType Directory -Force -Path $env:TEMP_DIRECTORY | Out-Null
    Write-Host "✓ Created temp directory" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting FastAPI Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Server will be available at:" -ForegroundColor Yellow
Write-Host "  • API: http://127.0.0.1:8000" -ForegroundColor White
Write-Host "  • Docs: http://127.0.0.1:8000/docs" -ForegroundColor White
Write-Host "  • ReDoc: http://127.0.0.1:8000/redoc" -ForegroundColor White
Write-Host ""
Write-Host "Press CTRL+C to stop the server" -ForegroundColor Gray
Write-Host ""

# Start the server
try {
    python server.py --port 8000 --reload false
}
catch {
    Write-Host ""
    Write-Host "❌ Server stopped with error: $_" -ForegroundColor Red
    exit 1
}
