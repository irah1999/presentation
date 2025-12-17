.PHONY: help build up down restart logs shell test clean health

# Detect if we need sudo for docker
DOCKER := $(shell docker ps >/dev/null 2>&1 && echo "docker" || echo "sudo docker")
DOCKER_COMPOSE := $(shell docker compose version >/dev/null 2>&1 && echo "docker compose" || echo "sudo docker compose")

# Default target
help:
	@echo "🐳 FastAPI Docker Commands"
	@echo "=========================="
	@echo "make build    - Build Docker image"
	@echo "make up       - Start containers"
	@echo "make down     - Stop containers"
	@echo "make restart  - Restart containers"
	@echo "make logs     - View logs (follow)"
	@echo "make shell    - Access container shell"
	@echo "make test     - Run tests"
	@echo "make health   - Check health status"
	@echo "make clean    - Remove containers and images"
	@echo ""
	@echo "💡 Commands will auto-detect if sudo is needed"
	@echo "💡 To fix permissions: ./docker-setup-permissions.sh"

# Build Docker image
build:
	$(DOCKER_COMPOSE) build

# Start containers
up:
	$(DOCKER_COMPOSE) up -d
	@echo "✅ Container started! Access at http://localhost:8000"
	@echo "📚 API docs: http://localhost:8000/docs"

# Build and start (fresh build)
up-build:
	$(DOCKER_COMPOSE) up -d --build
	@echo "✅ Container started! Access at http://localhost:8000"

# Stop containers
down:
	$(DOCKER_COMPOSE) down

# Restart containers
restart:
	$(DOCKER_COMPOSE) restart

# View logs
logs:
	$(DOCKER_COMPOSE) logs -f fastapi

# Access container shell
shell:
	$(DOCKER) exec -it fastapi-presenton bash

# Run tests
test:
	$(DOCKER) exec fastapi-presenton pytest

# Check health
health:
	@curl -s http://localhost:8000/health | jq || curl -s http://localhost:8000/health

# Clean up everything
clean:
	$(DOCKER_COMPOSE) down -v --rmi all

# Remove only containers and volumes
clean-soft:
	$(DOCKER_COMPOSE) down -v

# View container status
status:
	@$(DOCKER) ps | grep fastapi-presenton || echo "Container not running"

# View resource usage
stats:
	$(DOCKER) stats fastapi-presenton --no-stream
