#!/bin/bash

# Build the ytarchive image
docker compose build ytarchive

# Start all services in detached mode
docker compose up -d

echo "Waiting for services to initialize..."
sleep 10

# Set Alist password
echo "Setting Alist (admin) password to: admin"
docker compose exec alist ./alist admin set admin

echo ""
echo "==================================================="
echo "Service Credentials:"
echo "---------------------------------------------------"
echo "Alist:       admin / admin"
echo "qBittorrent: admin / admin"
echo "Jellyfin:    admin / admin (Attemping auto-setup...)"
echo "==================================================="

echo "Running Jellyfin auto-configuration..."
python setup_jellyfin.py
echo "Done."
