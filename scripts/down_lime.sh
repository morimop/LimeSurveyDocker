#!/bin/bash

CURDIR="$(cd "$(dirname "$0")"; pwd)"
LIME_HOME="$(dirname "${CURDIR}")"
PROJECT=lime${UID}
COMPOSE=${LIME_HOME}/docker/docker-compose.yml

# stop & remove docker
docker-compose -f ${COMPOSE} -p ${PROJECT} down
