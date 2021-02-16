#!/usr/bin/env bash

#client is on Muaddib

source minecraftCustom.sh

DOCKER_NAME=minecraft12
HOSTDATA=/mnt/user/app/dockerhub/itzg-minecraft-server/dataModded-v1.12
SERVER_MESSAGE="Berg 1.12.2"
PORT=25567
MINECRAFT_VERSION=1.12.2
FORGE_VERSION=14.23.4.2759 
# Login minecraft 
ONLINE_MODE=false
SEED=2305120

source minecraftActions.sh
