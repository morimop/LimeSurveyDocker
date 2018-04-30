#!/bin/bash

CURDIR="$(cd "$(dirname "$0")"; pwd)"
LIME_HOME="$(dirname "${CURDIR}")"
PROJECT=lime${UID}
COMPOSE=${LIME_HOME}/docker/docker-compose.yml

# application settings
MYSQL_USER=limesurvey
MYSQL_PASSWORD="$(cat /dev/urandom | base64 | fold -w 10 | head -n 1)"
MYSQL_DATABASE=mydb

{
    echo "MYSQL_HOSTNAME=${PROJECT}_mysql_1"
    echo "MYSQL_USER=${MYSQL_USER}"
    echo "MYSQL_PASSWORD=${MYSQL_PASSWORD}"
    echo "MYSQL_DATABASE=${MYSQL_DATABASE}" 
} > ${LIME_HOME}/.env

# LimeSurvey Settings
LIME_ADMIN_NAME=admin
LIME_ADMIN_PASSWORD="$(cat /dev/urandom | base64 | fold -w 10 | head -n 1)"
LIME_ADMIN_FULLNAME=Administrator
LIME_ADMIN_EMAIL=admin@your.domain

# run docker
docker-compose -f ${COMPOSE} -p ${PROJECT} up -d

# copy config.php and execute config php install
docker cp ${LIME_HOME}/docker/config_mysql_base.php ${PROJECT}_webap_1:/var/www/html/limesurvey/application/config/config.php

## wait mysql
WAIT_SEC_FOR_MYSQL=10
for i in {0..1}; do
  echo "Wait ${WAIT_SEC_FOR_MYSQL}sec for starting MySQL..."
  sleep ${WAIT_SEC_FOR_MYSQL}
  docker exec ${PROJECT}_webap_1 php /var/www/html/limesurvey/application/commands/console.php install ${LIME_ADMIN_NAME} ${LIME_ADMIN_PASSWORD} ${LIME_ADMIN_FULLNAME} ${LIME_ADMIN_EMAIL} verbose
done

# echo env
echo "settings:"; cat ${LIME_HOME}/.env
set | grep LIME_ADMIN
