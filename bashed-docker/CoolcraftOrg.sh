#!/usr/bin/env bash
# https://hub.docker.com/r/itzg/minecraft-server
source minecraftFunctions.sh

TYPE_CUSTOM=coolcraft
TYPE=SPIGOT
MINECRAFT_VERSION=1.14.4
DOCKER_NAME=minecraftCoolcraftOrg
DATA_DIR=dataCoolcraftInitialWorldCoreProjectData
SERVER_MESSAGE="Coolcraft Org data 2019.11.14"
PORT=25572
INIT_MEMORY="1G"
MAX_MEMORY="2G"
OPS=Magicilly,JDExPlorer
# ,Notebook,Muaddib,QuirkySpirit1,Notebook1,Muaddib1,Pil,Pil1,Lis,Lis1,Alex,LunaKittyCatty,Emma

# Note disabled pausing/stopping of coolcraft in f:\bin\ammonite\minecraftPauseAndBackup.sc

execute $*
