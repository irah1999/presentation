$env:APP_DATA_DIRECTORY = "$PSScriptRoot\app_data"
$env:USER_CONFIG_PATH = "$PSScriptRoot\app_data\userConfig.json"
$env:TEMP_DIRECTORY = "$PSScriptRoot\app_data\temp"

Write-Host "Setting up environment..."
Write-Host "APP_DATA_DIRECTORY: $env:APP_DATA_DIRECTORY"
Write-Host "USER_CONFIG_PATH: $env:USER_CONFIG_PATH"
Write-Host "TEMP_DIRECTORY: $env:TEMP_DIRECTORY"

# Create directories if they don't exist
if (-not (Test-Path -Path $env:APP_DATA_DIRECTORY)) {
    New-Item -ItemType Directory -Force -Path $env:APP_DATA_DIRECTORY
}
if (-not (Test-Path -Path $env:TEMP_DIRECTORY)) {
    New-Item -ItemType Directory -Force -Path $env:TEMP_DIRECTORY
}

# Start FastAPI Backend
Write-Host "Starting FastAPI Backend on port 8000..."
Start-Process -FilePath "python" -ArgumentList "server.py --port 8000 --reload false" -WorkingDirectory "$PSScriptRoot\servers\fastapi"

# Start MCP Server
Write-Host "Starting MCP Server on port 8001..."
Start-Process -FilePath "python" -ArgumentList "mcp_server.py --port 8001" -WorkingDirectory "$PSScriptRoot\servers\fastapi"

# Start Next.js Frontend
Write-Host "Starting Next.js Frontend on port 3000..."
Set-Location "$PSScriptRoot\servers\nextjs"
npm run dev
