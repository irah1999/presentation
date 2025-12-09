@echo off
echo ========================================
echo Presenton FastAPI Server
echo ========================================
echo.

REM Check if virtual environment exists
if not exist "venv\Scripts\activate.bat" (
    echo Error: Virtual environment not found!
    echo Please run: python -m venv venv
    echo Then run: .\venv\Scripts\pip install -r requirements.txt
    pause
    exit /b 1
)

REM Check if .env file exists
if not exist ".env" (
    echo Warning: .env file not found!
    echo Copying .env.example to .env...
    copy .env.example .env
    echo.
    echo Please edit .env file and add your API keys before running the server.
    echo.
    pause
    exit /b 1
)

REM Activate virtual environment and run server
echo Activating virtual environment...
call venv\Scripts\activate.bat

echo Starting FastAPI server on http://127.0.0.1:8000
echo Press Ctrl+C to stop the server
echo.

python server.py --port 8000 --reload true

pause
