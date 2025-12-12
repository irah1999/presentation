#!/bin/bash

# Docker Permissions Setup Script
# This script helps you set up Docker permissions so you don't need sudo

set -e

echo "🔧 Docker Permissions Setup"
echo "============================"
echo ""

# Check if docker group exists
if ! getent group docker > /dev/null 2>&1; then
    echo "❌ Docker group doesn't exist. Creating it..."
    sudo groupadd docker
    echo "✅ Docker group created"
else
    echo "✅ Docker group exists"
fi

# Add current user to docker group
echo ""
echo "Adding $USER to docker group..."
sudo usermod -aG docker $USER

echo ""
echo "✅ User added to docker group!"
echo ""
echo "⚠️  IMPORTANT: For changes to take effect, you need to:"
echo "   1. Log out and log back in"
echo "   2. OR run: newgrp docker"
echo "   3. OR restart your system"
echo ""
echo "After that, you can run docker commands without sudo:"
echo "   docker ps"
echo "   docker compose up -d"
echo "   make up-build"
echo ""

# Optionally activate the new group in current session
echo "Would you like to activate docker group for this session? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Activating docker group..."
    newgrp docker << END
    echo "✅ Docker group activated!"
    echo "You can now run docker commands without sudo in this terminal."
    docker ps
END
fi
