#!/bin/bash

set -e

echo "Installing DevOps tools..."

sudo apt update || true

#Docker
if ! command -v docker &>/dev/null; then
	echo "Installing Docker..."
	sudo apt install -y docker.io
else
	echo "Docker Compose already installed"
fi

#Docker Compose
if ! command -v docker-compose  &>/dev/null; then
        echo "Installing Docker Compose..."
        sudo apt install -y docker-compose
else
        echo "Docker Compose already installed"
fi

#Python
if ! command -v python3 &>/dev/null; then
        echo "Installing Python..."
        sudo apt install -y python3 python3-pip
else
        echo "Python  already installed"
fi

#Django
if ! python3 -c "import django" &>/dev/null; then
        echo "Installing Django..."
        pip3 install django
else
        echo "Django already installed"
fi

echo "Done."


