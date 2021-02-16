#!/usr/bin/env bash
# https://hub.docker.com/r/itzg/minecraft-server
source minecraftFunctions.sh

# Tried with `FORGE_VERSION=28.1.117`, didn't work, got error https://github.com/RobertSkalko/Mine-and-Slash/issues/84
# Tried without mods on `FORGE_VERSION=28.1.117` and it started and had the geminiTray world
# Tried only Xaeros*-mods and it didn't work on `FORGE_VERSION=28.1.117`, like maybe forge/minecraft version issue at that time
# Tried with `FORGE_VERSION=28.1.0`, got error saying minimum 28.1.79 - check the long list of minimum mod version
# Tried with `FORGE_VERSION=28.1.79` now gow the same error as on 28.1.117 above

# http://files.minecraftforge.net/

TYPE=FORGE
MINECRAFT_VERSION=1.14.4
FORGE_VERSION=28.1.117
DOCKER_NAME=minecraftGeminiTrayEpicMedievalKingdomForgeModded
DATA_DIR=dataGeminiTrayEpicMedievalKingdomForgeModded
SERVER_MESSAGE="MedievalKingdom Modded"
PORT=25576
INIT_MEMORY="1G"
MAX_MEMORY="3G"
OPS=Magicilly,QuirkySpirit,QuirkySpirit1,LunaKittyCatty,Emma,Mr_Duckv2,Pil,Pil1,Lis,Lis1,Alex

# Note disabled pausing/stopping of coolcraft in f:\bin\ammonite\minecraftPauseAndBackup.sc

execute $*
