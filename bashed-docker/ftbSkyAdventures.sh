#!/usr/bin/env bash

source minecraftFunctions.sh

DOCKER_NAME=minecraftFtbSkyAdventure
DATA_DIR=dataFtbSkyAdventures-v1.12
SERVER_MESSAGE="FTB Sky Adventures"
PORT=25568
MINECRAFT_VERSION=1.12.2
FORGE_VERSION=14.23.5.2796
TYPE=FTB
FTBServerZip=FTBSkyAdventuresServer_1.4.0.zip
# Login minecraft
ONLINE_MODE=false
# WARNING: With the FtbRevelation modpack, it is necessary to let the docker recreate all config files, in order to change seed, or it will give error about bad config when connecting client to server
SEED=198901896753628

# WARNING: It seems I need to manually copy mods into dataFtbRevelation-v1.12\FeedTheBeast\mods. Or just place there before starting server initially

execute $*
