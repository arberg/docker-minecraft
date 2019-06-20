#!/usr/bin/env bash

source minecraftCustom.sh

DOCKER_NAME=minecraftFtbSkyAdventure
HOSTDATA=/mnt/user/dockerhub/itzg-minecraft-server/dataFtbSkyAdventures-v1.12
SERVER_MESSAGE="FTB Sky Adventures"
PORT=25568
MINECRAFT_VERSION=1.12.2
FORGE_VERSION=14.23.5.2796
IS_FTB=true
FTBServerZip=FTBSkyAdventuresServer_1.4.0.zip
# Login minecraft
ONLINE_MODE=false
# WARNING: With the FtbRevelation modpack, it is necessary to let the docker recreate all config files, in order to change seed, or it will give error about bad config when connecting client to server
SEED=198901896753628

# WARNING: It seems I need to manually copy mods into dataFtbRevelation-v1.12\FeedTheBeast\mods. Or just place there before starting server initially

source minecraftActions.sh
