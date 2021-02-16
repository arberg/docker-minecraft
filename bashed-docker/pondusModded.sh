#!/usr/bin/env bash

source minecraftFunctions.sh

DOCKER_NAME=minecraftPondus
DATA_DIR=dataPondus
SERVER_MESSAGE="Pondus Modded"
PORT=25566
MINECRAFT_VERSION=1.10.2
TYPE=FORGE
FORGE_VERSION=12.18.3.2511
# Login minecraft
ONLINE_MODE=false
SEED=7670100323430838974
#Mushroom
#SEED=-8290517664781417306
#Pondus
# SEED=2305120

execute $*
