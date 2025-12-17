#!/bin/bash

# FastAPI Docker Start Script
# This script builds and starts the FastAPI application using Docker

set -e

echo "🚀 Starting FastAPI Application with Docker"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env file exists, if not create from example
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  .env file not found. Creating from .env.example...${NC}"
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✅ .env file created. Please update it with your API keys.${NC}"
    else
        echo -e "${RED}❌ .env.example not found!${NC}"
    fi
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker is running${NC}"

# Build the Docker image
echo ""
echo "📦 Building Docker image..."
docker compose build

# Start the containers
echo ""
echo "🔄 Starting containers..."
docker compose up -d

# Wait for the service to be healthy
echo ""
echo "⏳ Waiting for service to be healthy..."
sleep 5

# Check if container is running
if docker ps | grep -q fastapi-presenton; then
    echo -e "${GREEN}✅ FastAPI container is running!${NC}"
    echo ""
    echo "📊 Container status:"
    docker ps | grep fastapi-presenton
    echo ""
    echo -e "${GREEN}🎉 FastAPI application is running at: http://localhost:8000${NC}"
    echo -e "${GREEN}📚 API documentation available at: http://localhost:8000/docs${NC}"
    echo -e "${GREEN}❤️  Health check: http://localhost:8000/health${NC}"
    echo ""
    echo "📋 Useful commands:"
    echo "  - View logs: docker compose logs -f fastapi"
    echo "  - Stop: docker compose down"
    echo "  - Restart: docker compose restart"
    echo "  - Rebuild: docker compose up -d --build"
else
    echo -e "${RED}❌ Container failed to start. Check logs with: docker compose logs${NC}"
    exit 1
fi
