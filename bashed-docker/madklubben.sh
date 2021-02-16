#!/usr/bin/env bash
# https://hub.docker.com/r/itzg/minecraft-server
source minecraftFunctions.sh

TYPE=SPIGOT
VERSION=1.14.4
DOCKER_NAME=minecraftMadklubben
DATA_DIR=dataMadklubben
SERVER_MESSAGE="Madklubben"
PORT=25571
INIT_MEMORY="1G"
MAX_MEMORY="3G"
OPS=QuirkySpirit,LunaKittyCatty
ONLINE_MODE=false
# ,Notebook,Muaddib,QuirkySpirit1,Notebook1,Muaddib1,Pil,Pil1,Lis,Lis1,Alex,LunaKittyCatty,Emma

# Note disabled pausing/stopping of coolcraft in f:\bin\ammonite\minecraftPauseAndBackup.sc

execute $*
