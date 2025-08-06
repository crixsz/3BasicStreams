#!/bin/bash

# Stop specific containers
docker stop alist qbittorrent jellyfin

# Remove specific containers
docker rm alist qbittorrent jellyfin
