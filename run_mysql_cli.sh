#!/bin/bash

# This script runs the MySQL command-line interface in a docker
# container that is removed afterwards.
#
# NOTE: The client container is connected to the server instance
# running in another container by using the deprecated --link option.

SCRIPTROOT=$(dirname "$(readlink -f "$0")")

IMAGE_NAME=docker.io/mysql
IMAGE_TAG=latest

CLIENT_CONTAINER_NAME=tracking-mysql-client
SERVER_CONTAINER_NAME=tracking-mysql-server

MYSQL_ROOT_PASSWORD=root

docker run -it --rm \
    --name ${CLIENT_CONTAINER_NAME} \
    --link ${SERVER_CONTAINER_NAME}:mysql \
    ${IMAGE_NAME}:${IMAGE_TAG} \
    mysql \
        --host=mysql \
        --user=root \
        --password=${MYSQL_ROOT_PASSWORD}
