#!/usr/bin/env bash
# https://hub.docker.com/r/itzg/minecraft-server
source minecraftFunctions.sh

TYPE_CUSTOM=coolcraft
TYPE=SPIGOT
MINECRAFT_VERSION=1.14.4
DOCKER_NAME=minecraftCoolcraft
DATA_DIR=dataCoolcraft
SERVER_MESSAGE="Coolcraft"
PORT=25565
INIT_MEMORY="1G"
MAX_MEMORY="3G"
OPS=Magicilly,JDExPlorer
# ,Notebook,Muaddib,QuirkySpirit1,Notebook1,Muaddib1,Pil,Pil1,Lis,Lis1,Alex,LunaKittyCatty,Emma

# Note disabled pausing/stopping of coolcraft in f:\bin\ammonite\minecraftPauseAndBackup.sc

execute $*
