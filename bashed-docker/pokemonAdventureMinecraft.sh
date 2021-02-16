#!/usr/bin/env bash

source minecraftFunctions.sh

DOCKER_NAME=minecraftPokemon
DATA_DIR=dataPokemonAdventureReloaded
SERVER_MESSAGE="Twitch Pokemon Adventure Reloaded"
PORT=25567
MINECRAFT_VERSION=1.10.2
FORGE_VERSION=12.18.3.2185
# Login minecraft
ONLINE_MODE=false

execute $*
