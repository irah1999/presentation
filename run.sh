#!/bin/bash

echo "========================================"
echo "Presenton FastAPI Server"
echo "========================================"
echo ""

# Check if virtual environment exists
if [ ! -f "venv/bin/activate" ]; then
    echo "Error: Virtual environment not found!"
    echo "Please run: python -m venv venv"
    echo "Then run: ./venv/bin/pip install -r requirements.txt"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Warning: .env file not found!"
    echo "Copying .env.example to .env..."
    cp .env.example .env
    echo ""
    echo "Please edit .env file and add your API keys before running the server."
    echo ""
    exit 1
fi

# Activate virtual environment and run server
echo "Activating virtual environment..."
source venv/bin/activate

echo "Starting FastAPI server on http://127.0.0.1:8000"
echo "Press Ctrl+C to stop the server"
echo ""

python server.py --port 8000 --reload true
