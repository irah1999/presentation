@echo off
echo ========================================
echo Presenton FastAPI - First Time Setup
echo ========================================
echo.

echo Step 1: Creating virtual environment...
if exist "venv" (
    echo Virtual environment already exists. Skipping...
) else (
    python -m venv venv
    if errorlevel 1 (
        echo Error: Failed to create virtual environment
        echo Make sure Python 3.11 is installed
        pause
        exit /b 1
    )
    echo Virtual environment created successfully!
)
echo.

echo Step 2: Activating virtual environment...
call venv\Scripts\activate.bat
echo.

echo Step 3: Upgrading pip...
python -m pip install --upgrade pip
echo.

echo Step 4: Installing dependencies...
echo This may take several minutes...
pip install -r requirements.txt
if errorlevel 1 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)
echo.

echo Step 5: Creating .env file...
if exist ".env" (
    echo .env file already exists. Skipping...
) else (
    copy .env.example .env
    echo .env file created from .env.example
    echo.
    echo IMPORTANT: Please edit .env file and add your API keys!
    echo.
)
echo.

echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Edit .env file and add your API keys
echo 2. Run: .\run.bat
echo.
echo Or manually run:
echo   .\venv\Scripts\activate
echo   python server.py --port 8000 --reload true
echo.

pause
