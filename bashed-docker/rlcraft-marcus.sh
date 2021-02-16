#!/usr/bin/env bash

# RLCraft
# By Shivaxi
# Beta v2.8.zip

# Notes
# OPTIFINE WARNING:  You MUST disable "Fast Render" or you will get the black screen bug when certain effects try to activate, also make sure you have at least "internal shaders" on in the shader settings, anything is fine, just not "none".

# OPTIONAL RECOMMENDATIONS:  I'd personally recommend the use of Optifine (USE E3 ONLY, F4 IS BROKEN AND WILL CRASH) (https://optifine.net/adloadx?f=OptiFine_1.12.2_HD_U_E3.jar) (make sure for 1.12.2) and some shaders if your system can handle them to bring out the best with this modpack and Minecraft, and also the Chroma Hills resourcepack which I used for building this modpack and can be found here:  http://www.chromahills.com/

# Setup resources and shaders see discord pinned messages: https://discordapp.com/channels/199155955206717440/401010137428656128/443125354828398592

source minecraftFunctions.sh

# Custom Server.properties - I don't know which server.properties is used dataFtbRevelation-v1.12\FeedTheBeast or its parent
# max-tick-time=-1 # Disable [minecraft/ServerHangWatchdog] so it does not kill server on resume due to lag

DOCKER_NAME=minecraftRlcraftMarcus
DATA_DIR=dataRlcraft-v1.12-2.8.2-Marcus
SERVER_MESSAGE="RLCraft 1.12.2 - Beta v2.8.2 - Marcus og venner"
PORT=25582
MINECRAFT_VERSION=1.12.2
# RLCraft beto v2.8 tested with forge-1.12.2-14.23.5.2838-universal.jar
# https://files.minecraftforge.net/maven/net/minecraftforge/forge/index_1.12.2.html
FORGE_VERSION=14.23.5.2854
TYPE=FORGE
ONLINE_MODE=true
# WARNING: With the FtbRevelation modpack, it is necessary to let the docker recreate all config files, in order to change seed, or it will give error about bad config when connecting client to server
SEED=-4513
OPS=Magicilly,QuirkySpirit,QuirkySpirit1,LunaKittyCatty,Emma,Mr_Duckv2,Pil,Pil1,Lis,Lis1,Alex

# WARNING: It seems I need to manually copy mods into dataFtbRevelation-v1.12\FeedTheBeast\mods. Or just place there before starting server initially

execute $*
