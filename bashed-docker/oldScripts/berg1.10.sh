#!/usr/bin/env bash

#client is on Muaddib

source minecraftCustom.sh

DOCKER_NAME=minecraft10
HOSTDATA=/mnt/user/app/dockerhub/itzg-minecraft-server/dataModded-v1.10
SERVER_MESSAGE="Berg 1.10.2"
PORT=25566
MINECRAFT_VERSION=1.10.2
FORGE_VERSION=12.18.3.2511
# Login minecraft 
ONLINE_MODE=false
SEED=2305120

source minecraftActions.sh
