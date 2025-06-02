#!/bin/bash
set -e

export IMAGE_TAG=$(date +"%Y-%m-%d")
export IMAGE_NAME=simple-python-app
export DOCKER_REGISTRY_USERNAME=thanhtha

echo "$DOCKER_REGISTRY_USERNAME"
echo "$IMAGE_NAME"
echo "$IMAGE_TAG"

# Pull the Docker image from Docker Hub
docker pull $DOCKER_REGISTRY_USERNAME/$IMAGE_NAME:$IMAGE_TAG

# Run the Docker image as a container
docker run -d -p 5000:5000 $DOCKER_REGISTRY_USERNAME/$IMAGE_NAME:$IMAGE_TAG
