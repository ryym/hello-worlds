#!/usr/bin/env bash

# Remove old images and containers.
docker rmi sample-log sample-web \
    > /dev/null 2>&1
docker rm -f web-container log-container \
    > /dev/null 2>&1

# Build log and web images.

docker build \
    -t sample-log \
    -f log-Dockerfile \
    .

docker build \
    -t sample-web \
    -f web-Dockerfile \
    .

# Run containers.

docker run -dit \
    --name log-container \
    sample-log \
    /bin/bash

docker run -d \
    --name web-container \
    -p 80:80 \
    --volumes-from log-container \
    sample-web

# You can connect the log-container by:
#   docker start -ia log-container
