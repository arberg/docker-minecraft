#!/usr/bin/env bash
# https://hub.docker.com/r/itzg/minecraft-server
source minecraftFunctions.sh

TYPE=FORGE
MINECRAFT_VERSION=1.14.4
FORGE_VERSION=28.1.117
DOCKER_NAME=minecraftGeminiTrayEpicMedievalKingdomForgeNonModded
DATA_DIR=dataGeminiTrayEpicMedievalKingdomForgeNonModded
SERVER_MESSAGE="MedievalKingdom Modded"
PORT=25577
INIT_MEMORY="1G"
MAX_MEMORY="3G"
OPS=Magicilly,QuirkySpirit,QuirkySpirit1,LunaKittyCatty,Emma,Mr_Duckv2,Pil,Pil1,Lis,Lis1,Alex

# Note disabled pausing/stopping of coolcraft in f:\bin\ammonite\minecraftPauseAndBackup.sc

execute $*
