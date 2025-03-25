#!/bin/bash

# Color codes for output
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# Function to check if Docker is installed and running
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Error: Docker is not installed. Please install Docker and try again.${RESET}"
        exit 1
    fi

    if ! docker info &> /dev/null; then
        echo -e "${RED}Error: Docker is not running. Please start Docker and try again.${RESET}"
        exit 1
    fi
}

# Function to check if a Docker network exists
check_network() {
    if ! docker network ls | grep -q "$1"; then
        echo -e "${YELLOW}Creating network $1...${RESET}"
        docker network create "$1"
    else
        echo -e "${GREEN}Network $1 already exists.${RESET}"
    fi
}

# Function to check and handle existing containers
handle_container() {
    local container_name=$1
    if docker ps -a | grep -q "$container_name"; then
        echo -e "${YELLOW}Container $container_name exists. Stopping and removing...${RESET}"
        docker stop "$container_name" >/dev/null 2>&1
        docker rm "$container_name" >/dev/null 2>&1
    fi
}

# Set variables
NETWORK_NAME="pg_network"
PG_CONTAINER_NAME="postgres-db"
PGADMIN_CONTAINER_NAME="pgadmin4"
VOLUME_NAME="postgres-db-volume"
POSTGRES_USERNAME="admin"
POSTGRES_PASS="geeky@123"
PGADMIN_EMAIL="geeky@krishna.com"
PGADMIN_PASS="geeky@123"

# Check Docker status
check_docker

# Create network if it doesn't exist
check_network "$NETWORK_NAME"

# Handle existing containers
handle_container "$PG_CONTAINER_NAME"
handle_container "$PGADMIN_CONTAINER_NAME"

# Start PostgreSQL container
echo -e "${YELLOW}Starting PostgreSQL container...${RESET}"
docker run -d \
    --name "$PG_CONTAINER_NAME" \
    -e POSTGRES_USER="$POSTGRES_USERNAME" \
    -e POSTGRES_PASSWORD="$POSTGRES_PASS" \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v "$VOLUME_NAME":/var/lib/postgresql/data \
    -p 5432:5432 \
    --network "$NETWORK_NAME" \
    postgres

# Wait for PostgreSQL to be ready
echo -e "${YELLOW}Waiting for PostgreSQL to start...${RESET}"
sleep 5
if docker logs "$PG_CONTAINER_NAME" 2>&1 | grep -q "database system is ready to accept connections"; then
    echo -e "${GREEN}✓ PostgreSQL is ready.${RESET}"
else
    echo -e "${RED}✗ PostgreSQL may not be ready yet.${RESET}"
fi

# Start pgAdmin container
echo -e "${YELLOW}Starting pgAdmin container...${RESET}"
docker run -d \
    --name "$PGADMIN_CONTAINER_NAME" \
    -p 5050:80 \
    -e PGADMIN_DEFAULT_EMAIL="$PGADMIN_EMAIL" \
    -e PGADMIN_DEFAULT_PASSWORD="$PGADMIN_PASS" \
    --network "$NETWORK_NAME" \
    dpage/pgadmin4

# Check if containers are running
echo -e "\n${YELLOW}Checking container status...${RESET}"
if docker ps | grep -q "$PG_CONTAINER_NAME"; then
    echo -e "${GREEN}✓ PostgreSQL container is running.${RESET}"
else
    echo -e "${RED}✗ PostgreSQL container failed to start.${RESET}"
fi

if docker ps | grep -q "$PGADMIN_CONTAINER_NAME"; then
    echo -e "${GREEN}✓ pgAdmin container is running.${RESET}"
else
    echo -e "${RED}✗ pgAdmin container failed to start.${RESET}"
fi

# Connection details
echo -e "\n${GREEN}Access pgAdmin at: http://localhost:5050${RESET}"
echo -e "${GREEN}PostgreSQL Connection Details:${RESET}"
echo "Host: host.docker.internal"
echo "Port: 5432"
echo "Username: $POSTGRES_USERNAME"
echo "Password: $POSTGRES_PASS"