#!/usr/bin/env bash
. ./env.cfg
sudo docker exec $DOCKER_NAME rcon-cli stop

sudo docker-compose stop