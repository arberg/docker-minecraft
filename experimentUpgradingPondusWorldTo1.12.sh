#!/usr/bin/env bash

source minecraftCustom.sh

DOCKER_NAME=minecraft1.12
HOSTDATA=/mnt/user/dockerhub/itzg-minecraft-server/dataPondusWorld1.12
SERVER_MESSAGE="Pondus World v1.12"
PORT=25566
MINECRAFT_VERSION=1.12.2
FORGE_VERSION=14.23.4.2759  
# MINECRAFT_VERSION=1.10.2
# FORGE_VERSION=12.18.3.2511
# Login minecraft 
ONLINE_MODE=false
SEED=2305120

# Houses are truncated, and only a tiny amount of world is converted. I don't understand why base-world changes. The truncated houses could be because mods are removed and thus everything built with chisel and dots are removed. Perhaps also slabs.
if [ "$1" = "deleteCurrentCopyPondus" ] ; then
	rm -r dataPondusWorld1.12
	rsync -avh --exclude="backups" --exclude="mods" --exclude="mods*" --exclude="libraries" --exclude="config" dataPondus/ dataPondusWorld1.12
	rsync -avh dataModded-v1.12/mods/ $HOSTDATA/mods
	rsync -avh dataModded-v1.12/config/ $HOSTDATA/config
	rsync -avh dataModded-v1.12/libraries/ $HOSTDATA/libraries
	cp dataModded-v1.12/forge* $HOSTDATA
	cp dataModded-v1.12/.forge* $HOSTDATA
	cp dataModded-v1.12/minecraft* $HOSTDATA

	    # Make Docker scripts reuse OPS list given here by deleting ops.txt.converted
    rm $HOSTDATA/ops.txt.converted
    docker stop $DOCKER_NAME
    docker rm $DOCKER_NAME
    # due to confirm
    docker run -d -v $HOSTDATA:/data \
        -e VERSION=$MINECRAFT_VERSION \
        -e TYPE=FORGE -e FORGEVERSION=$FORGE_VERSION \
        -e "MOTD=$SERVER_MESSAGE" \
        -e "OPS=$OPS" \
        -e SEED=$SEED \
        -e MODE=creative \
        -e FORCE_GAMEMODE=true \
        -e ONLINE_MODE=$ONLINE_MODE \
        -e ALLOW_NETHER=true \
        -e ENABLE_COMMAND_BLOCK=true \
        -e INIT_MEMORY="$INIT_MEMORY" \
        -e MAX_MEMORY="$MAX_MEMORY" \
        -e GUI=false \
        -e JVM_OPTS="-Dfml.queryResult=confirm" \
        -v "/etc/timezone:/etc/timezone:ro" \
        -v "/etc/localtime:/etc/localtime:ro" \
        -p $PORT:25565 -e EULA=TRUE --name $DOCKER_NAME itzg/minecraft-server 
else
	source minecraftActions.sh
fi

