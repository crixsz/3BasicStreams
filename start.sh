#!/bin/bash

# Build the ytarchive image
docker-compose build ytarchive

# Start all services in detached mode
docker-compose up -d
