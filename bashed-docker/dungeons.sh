#!/usr/bin/env bash

source minecraftFunctions.sh

DOCKER_NAME=minecraftDungeons
DATA_DIR=dataDungeonsDragonsAndSpace
SERVER_MESSAGE="Dungeons, Dragons And Space Shuttles"
PORT=25581
MINECRAFT_VERSION=1.12.2
FORGE_VERSION=14.23.5.2836
TYPE=FORGE
# Login minecraft
ONLINE_MODE=false
SEED=7670100323430838974
#Mushroom
#SEED=-8290517664781417306
#Pondus
# SEED=2305120

execute $*
