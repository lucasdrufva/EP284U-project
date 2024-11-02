#!/bin/bash

# Path to your Docker Compose file
COMPOSE_FILE_PATH="./docker-compose.yml"  # Adjust path as needed

# Start server for creating user
docker compose -f "$COMPOSE_FILE_PATH" up -d
sleep 200

docker compose -f "$COMPOSE_FILE_PATH" down

sleep 10

# Loop indefinitely
while true; do
    # Start the Docker Compose services
    echo "Starting Docker Compose services..."
    docker compose -f "$COMPOSE_FILE_PATH" up -d

    # Simulate an admin login
    sleep 20
    curl http://localhost:9200/ -H "Authorization: Basic ZWxhc3RpYzp2S21uZXVOMWZG"

    # Wait for 10 minutes
    echo "Waiting for 5 minutes..."
    sleep 300

    # Stop the Docker Compose services
    echo "Stopping Docker Compose services..."
    docker compose -f "$COMPOSE_FILE_PATH" down
    sleep 10
done
