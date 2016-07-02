#!/usr/bin/env bash

docker-compose stop
docker-compose rm

docker rm -f dataonly > /dev/null 2>&1
docker rmi dataonly > /dev/null 2>&1

docker build \
    -t dataonly \
    -f Dockerfile.data \
    .

docker run -dit \
    --name dataonly \
    dataonly \
    /bin/bash

docker-compose up -d
