#!/usr/bin/env bash

source minecraftFunctions.sh

# Custom Server.properties - I don't know which server.properties is used dataFtbRevelation-v1.12\FeedTheBeast or its parent
# max-tick-time=-1 # Disable [minecraft/ServerHangWatchdog] so it does not kill server on resume due to lag

DOCKER_NAME=minecraftFtbDragons
DATA_DIR=dataFtbRevelation-v1.12Dragons
SERVER_MESSAGE="FTB Revelation 1.12 Dragons"
PORT=25569
MINECRAFT_VERSION=1.12.2
FORGE_VERSION=14.23.5.2772
TYPE=FTB
FTBServerZip=FTBRevelationServer_3.0.1.zip
# Online so they can change skins
ONLINE_MODE=true
# WARNING: With the FtbRevelation modpack, it is necessary to let the docker recreate all config files, in order to change seed, or it will give error about bad config when connecting client to server
SEED=198901896753628

# WARNING: It seems I need to manually copy mods into dataFtbRevelation-v1.12\FeedTheBeast\mods. Or just place there before starting server initially

execute $*
