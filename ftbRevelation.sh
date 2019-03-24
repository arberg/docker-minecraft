#!/usr/bin/env bash

source minecraftCustomFtb.sh

DOCKER_NAME=minecraftFtb
HOSTDATA=/mnt/user/dockerhub/itzg-minecraft-server/dataFtbRevelation-v1.12
SERVER_MESSAGE="FTB Revelation 1.12"
PORT=25565
MINECRAFT_VERSION=1.12.2
FORGE_VERSION=14.23.5.2772
# FORGE_VERSION=14.23.4.2767
# Login minecraft 
ONLINE_MODE=false
# WARNING: With the FtbRevelation modpack, it is necessary to let the docker recreate all config files, in order to change seed, or it will give error about bad config when connecting client to server
SEED=-702071384745498

# WARNING: It seems I need to manually copy mods into dataFtbRevelation-v1.12\FeedTheBeast\mods. Or just place there before starting server initially

source minecraftActions.sh
