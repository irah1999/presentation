# MySQL Setup Script for Presenton Application
# This script helps set up the MySQL database for the Presenton application

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Presenton MySQL Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if MySQL is installed
Write-Host "Checking MySQL installation..." -ForegroundColor Yellow
$mysqlService = Get-Service -Name "MySQL*" -ErrorAction SilentlyContinue

if ($null -eq $mysqlService) {
    Write-Host "ERROR: MySQL service not found!" -ForegroundColor Red
    Write-Host "Please install MySQL Server from: https://dev.mysql.com/downloads/mysql/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "MySQL service found: $($mysqlService.Name)" -ForegroundColor Green
Write-Host "Service status: $($mysqlService.Status)" -ForegroundColor Green
Write-Host ""

# Check if MySQL is running
if ($mysqlService.Status -ne "Running") {
    Write-Host "MySQL service is not running. Attempting to start..." -ForegroundColor Yellow
    try {
        Start-Service $mysqlService.Name
        Write-Host "MySQL service started successfully!" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to start MySQL service!" -ForegroundColor Red
        Write-Host "Please start MySQL manually and run this script again." -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Database Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get MySQL credentials
Write-Host "Please enter MySQL credentials:" -ForegroundColor Yellow
$mysqlUser = Read-Host "MySQL Username (default: root)"
if ([string]::IsNullOrWhiteSpace($mysqlUser)) {
    $mysqlUser = "root"
}

$mysqlPassword = Read-Host "MySQL Password (default: root)" -AsSecureString
$mysqlPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($mysqlPassword)
)
if ([string]::IsNullOrWhiteSpace($mysqlPasswordPlain)) {
    $mysqlPasswordPlain = "root"
}

$mysqlHost = Read-Host "MySQL Host (default: localhost)"
if ([string]::IsNullOrWhiteSpace($mysqlHost)) {
    $mysqlHost = "localhost"
}

$mysqlPort = Read-Host "MySQL Port (default: 3306)"
if ([string]::IsNullOrWhiteSpace($mysqlPort)) {
    $mysqlPort = "3306"
}

$dbName = Read-Host "Database Name (default: presenton_db)"
if ([string]::IsNullOrWhiteSpace($dbName)) {
    $dbName = "presenton_db"
}

Write-Host ""
Write-Host "Configuration Summary:" -ForegroundColor Cyan
Write-Host "  Username: $mysqlUser" -ForegroundColor White
Write-Host "  Host: $mysqlHost" -ForegroundColor White
Write-Host "  Port: $mysqlPort" -ForegroundColor White
Write-Host "  Database: $dbName" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Proceed with this configuration? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "Setup cancelled." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 0
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Running Migration Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if migration script exists
$migrationScript = Join-Path $PSScriptRoot "mysql_migration.sql"
if (-not (Test-Path $migrationScript)) {
    Write-Host "ERROR: Migration script not found at: $migrationScript" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Migration script found: $migrationScript" -ForegroundColor Green
Write-Host "Executing migration script..." -ForegroundColor Yellow
Write-Host ""

# Execute migration script
try {
    # Create temporary file with password
    $tempPasswordFile = [System.IO.Path]::GetTempFileName()
    Set-Content -Path $tempPasswordFile -Value $mysqlPasswordPlain
    
    # Run mysql command
    $mysqlCmd = "mysql"
    $mysqlArgs = @(
        "-u", $mysqlUser,
        "-p$mysqlPasswordPlain",
        "-h", $mysqlHost,
        "-P", $mysqlPort,
        "<", $migrationScript
    )
    
    # Execute using cmd to handle input redirection
    $cmdLine = "mysql -u $mysqlUser -p$mysqlPasswordPlain -h $mysqlHost -P $mysqlPort < `"$migrationScript`""
    cmd /c $cmdLine 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Migration script executed successfully!" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Migration script may have encountered errors." -ForegroundColor Yellow
        Write-Host "Please check MySQL manually." -ForegroundColor Yellow
    }
    
    # Clean up temp file
    Remove-Item -Path $tempPasswordFile -Force -ErrorAction SilentlyContinue
    
} catch {
    Write-Host "ERROR: Failed to execute migration script!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "You can run the migration manually with:" -ForegroundColor Yellow
    Write-Host "  mysql -u $mysqlUser -p -h $mysqlHost -P $mysqlPort < `"$migrationScript`"" -ForegroundColor White
    Write-Host ""
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Creating .env File" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create .env file
$envFile = Join-Path $PSScriptRoot ".env"
$databaseUrl = "mysql://${mysqlUser}:${mysqlPasswordPlain}@${mysqlHost}:${mysqlPort}/${dbName}"

$envContent = @"
# Database Configuration
DATABASE_URL=$databaseUrl

# Application Data Directory
APP_DATA_DIRECTORY=./app_data

# Temp Directory
TEMP_DIRECTORY=./tmp

# LLM Configuration (Update with your actual keys)
LLM=openai
OPENAI_API_KEY=your_openai_api_key_here
OPENAI_MODEL=gpt-4

# Image Provider
IMAGE_PROVIDER=pexels
PEXELS_API_KEY=your_pexels_api_key_here
"@

try {
    # Check if .env already exists
    if (Test-Path $envFile) {
        Write-Host ".env file already exists." -ForegroundColor Yellow
        $overwrite = Read-Host "Overwrite existing .env file? (Y/N)"
        if ($overwrite -ne "Y" -and $overwrite -ne "y") {
            Write-Host "Keeping existing .env file." -ForegroundColor Yellow
        } else {
            Set-Content -Path $envFile -Value $envContent -Force
            Write-Host ".env file updated successfully!" -ForegroundColor Green
        }
    } else {
        Set-Content -Path $envFile -Value $envContent
        Write-Host ".env file created successfully!" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Database URL: $databaseUrl" -ForegroundColor Cyan
    
} catch {
    Write-Host "ERROR: Failed to create .env file!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please create .env file manually with:" -ForegroundColor Yellow
    Write-Host "  DATABASE_URL=$databaseUrl" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Verifying Database Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verify database and tables
Write-Host "Checking database and tables..." -ForegroundColor Yellow

try {
    $verifyCmd = "mysql -u $mysqlUser -p$mysqlPasswordPlain -h $mysqlHost -P $mysqlPort -e `"USE $dbName; SHOW TABLES;`""
    $tables = cmd /c $verifyCmd 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Database verified successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Tables created:" -ForegroundColor Cyan
        Write-Host $tables -ForegroundColor White
    } else {
        Write-Host "WARNING: Could not verify database." -ForegroundColor Yellow
        Write-Host "Please verify manually with:" -ForegroundColor Yellow
        Write-Host "  mysql -u $mysqlUser -p -h $mysqlHost -P $mysqlPort" -ForegroundColor White
        Write-Host "  USE $dbName;" -ForegroundColor White
        Write-Host "  SHOW TABLES;" -ForegroundColor White
    }
} catch {
    Write-Host "WARNING: Could not verify database." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Update .env file with your API keys (OPENAI_API_KEY, PEXELS_API_KEY)" -ForegroundColor White
Write-Host "  2. Install Python dependencies: uv sync" -ForegroundColor White
Write-Host "  3. Start the application: python -m uvicorn server:app --reload --port 8000" -ForegroundColor White
Write-Host ""

Write-Host "Documentation:" -ForegroundColor Cyan
Write-Host "  - Migration Guide: MYSQL_MIGRATION_GUIDE.md" -ForegroundColor White
Write-Host "  - Query Reference: MYSQL_QUERIES_REFERENCE.md" -ForegroundColor White
Write-Host "  - Summary: MYSQL_MIGRATION_SUMMARY.md" -ForegroundColor White
Write-Host ""

Write-Host "Database Connection:" -ForegroundColor Cyan
Write-Host "  $databaseUrl" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"
