#!/usr/bin/env bash

source minecraftCustom.sh

DOCKER_NAME=minecraftPondus
HOSTDATA=/mnt/user/dockerhub/itzg-minecraft-server/dataPondus
SERVER_MESSAGE="Pondus Modded"
PORT=25566
MINECRAFT_VERSION=1.10.2
FORGE_VERSION=12.18.3.2511
# Login minecraft
ONLINE_MODE=false
SEED=7670100323430838974
#Mushroom
#SEED=-8290517664781417306
#Pondus
# SEED=2305120

source minecraftActions.sh
