#!/bin/bash

echo "========================================"
echo "Presenton FastAPI - First Time Setup"
echo "========================================"
echo ""

echo "Step 1: Creating virtual environment..."
if [ -d "venv" ]; then
    echo "Virtual environment already exists. Skipping..."
else
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create virtual environment"
        echo "Make sure Python 3.11 is installed"
        exit 1
    fi
    echo "Virtual environment created successfully!"
fi
echo ""

echo "Step 2: Activating virtual environment..."
source venv/bin/activate
echo ""

echo "Step 3: Upgrading pip..."
python -m pip install --upgrade pip
echo ""

echo "Step 4: Installing dependencies..."
echo "This may take several minutes..."
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies"
    exit 1
fi
echo ""

echo "Step 5: Creating .env file..."
if [ -f ".env" ]; then
    echo ".env file already exists. Skipping..."
else
    cp .env.example .env
    echo ".env file created from .env.example"
    echo ""
    echo "IMPORTANT: Please edit .env file and add your API keys!"
    echo ""
fi
echo ""

echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Edit .env file and add your API keys"
echo "2. Run: ./run.sh"
echo ""
echo "Or manually run:"
echo "  source venv/bin/activate"
echo "  python server.py --port 8000 --reload true"
echo ""
