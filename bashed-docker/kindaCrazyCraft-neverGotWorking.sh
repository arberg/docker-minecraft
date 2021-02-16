#!/usr/bin/env bash

source minecraftFunctions.sh

# Custom Server.properties - I don't know which server.properties is used dataFtbRevelation-v1.12\FeedTheBeast or its parent
# max-tick-time=-1 # Disable [minecraft/ServerHangWatchdog] so it does not kill server on resume due to lag

POSTFIX_NAME=KindOfCrazyCraft
DOCKER_NAME=minecraft$POSTFIX_NAME
DATA_DIR=data$POSTFIX_NAME
SERVER_MESSAGE="$POSTFIX_NAME 1.7.10"
PORT=25578
MINECRAFT_VERSION=1.7.10
FORGE_VERSION=10.13.4.1566
TYPE=FORGE
ONLINE_MODE=true
# WARNING: With the FtbRevelation modpack, it is necessary to let the docker recreate all config files, in order to change seed, or it will give error about bad config when connecting client to server
SEED=-702071384745498

# WARNING: It seems I need to manually copy mods into dataFtbRevelation-v1.12\FeedTheBeast\mods. Or just place there before starting server initially

execute $*
