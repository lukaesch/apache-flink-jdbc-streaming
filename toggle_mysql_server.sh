#!/bin/bash

# This script controls the execution of the MySQL server container.
# If no container with the specified name exists a new container is
# created and started. Otherwise the existing container is either
# stopped or restarted depending on its current status. The exposed
# port is published on the host's network interface.

SCRIPTROOT=$(dirname "$(readlink -f "$0")")

IMAGE_NAME=docker.io/mysql
IMAGE_TAG=latest

CONTAINER_NAME=tracking-mysql-server

MYSQL_EXPOSED_PORT=3306
MYSQL_PUBLISHED_PORT=${MYSQL_EXPOSED_PORT}

MYSQL_ROOT_PASSWORD=root

RUNNING_CONTAINER_ID="$(docker ps -aq --filter=status=running --filter=name=${CONTAINER_NAME})"
if [ -n "${RUNNING_CONTAINER_ID}" ]; then
    echo "Stopping ${RUNNING_CONTAINER_ID}"
    docker stop ${RUNNING_CONTAINER_ID}
else
    EXITED_CONTAINER_ID="$(docker ps -aq --filter 'exited=0' --filter=name=${CONTAINER_NAME})"
    if [ -n "${EXITED_CONTAINER_ID}" ]; then
        echo "Restarting ${EXITED_CONTAINER_ID}"
        docker restart ${EXITED_CONTAINER_ID}
        sleep 5
    else
        if [ -z "$(docker ps -aq --filter=name=${CONTAINER_NAME})" ]; then
            echo "Creating ${CONTAINER_NAME}"
            docker run -d \
                --name ${CONTAINER_NAME} \
                --volume "${SCRIPTROOT}/src/main/resources/db/mysql_schema.sql:/docker-entrypoint-initdb.d/mysql_schema.sql:ro" \
                --publish=${MYSQL_PUBLISHED_PORT}:${MYSQL_EXPOSED_PORT} \
                -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
                ${IMAGE_NAME}:${IMAGE_TAG}
            sleep 10
        else
            echo "$(docker ps -a --filter=name=${CONTAINER_NAME})"
        fi
    fi
fi

CONTAINER_ID="$(docker ps -aq --filter=name=${CONTAINER_NAME})"
if [ -n "${CONTAINER_ID}" ]; then
    docker logs --tail 20 ${CONTAINER_ID}
fi
