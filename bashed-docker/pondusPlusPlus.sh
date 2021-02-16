#!/usr/bin/env bash

source minecraftFunctions.sh

DOCKER_NAME=minecraftPlusPlus
DATA_DIR=dataMinecraft1.13_PondusPlusPlus
SERVER_MESSAGE="Minecraft 1.13"
PORT=25565
MINECRAFT_VERSION=1.13
TYPE=FORGE
#FORGE_VERSION=12.18.3.2185
# Login minecraft
ONLINE_MODE=false
SEED=505544229161414

stopPrevious

echo "$DOCKER_NAME" > $STATE_RUNNING_INSTANCE_FILE
echo "$HOSTDATA" > stateDataFolder.${DOCKER_NAME}.dat

stop
if [ "$1" != "stop" ] ; then
    rm $HOSTDATA/ops.txt.converted
    docker stop $DOCKER_NAME
    docker rm $DOCKER_NAME
    docker run -d -v $HOSTDATA:/data \
        -e "MOTD=$SERVER_MESSAGE" \
        -e "OPS=$OPS" \
        -e SEED=$SEED \
        -e MODE=creative \
        -e FORCE_GAMEMODE=true \
        -e ONLINE_MODE=$ONLINE_MODE \
        -e ALLOW_NETHER=true \
        -e ENABLE_COMMAND_BLOCK=true \
        -e INIT_MEMORY="2G" \
        -e MAX_MEMORY="4G" \
        -e GUI=false \
        -p $PORT:25565 -e EULA=TRUE --name $DOCKER_NAME itzg/minecraft-server 


    followLogs
fi

