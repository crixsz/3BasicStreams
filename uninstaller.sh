#!/bin/bash

# Stop specific containers
docker stop alist qbittorrent jellyfin ytarchive

# Remove specific containers
docker rm alist qbittorrent jellyfin ytarchive
