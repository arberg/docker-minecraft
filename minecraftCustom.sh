# https://hub.docker.com/r/itzg/minecraft-server/

DOCKER_NAME=$1
HOSTDATA=/mnt/user/dockerhub/itzg-minecraft-server/$2
SERVER_MESSAGE="Twitch Pokemon Adventure"
PORT=25565
MINECRAFT_VERSION=1.10.2
FORGE_VERSION=12.18.3.2185
OPS=QuirkySpirit,Notebook,Muaddib,QuirkySpirit1,Notebook1,Muaddib1,Pil,Pil1,Lis,Lis1,Alex,LunaKittyCatty,Emma
# Login minecraft
ONLINE_MODE=false
IS_FTB=false
FTBServerZip=FTBServer.zip
# Hmm jeg får pondus seed hele tiden, just set in server.properties.
#SEED=2305120
    # worked well with 4-7 GB ram
    # Mayas OldPil hakker i PondusModded, dog ikke særligt ofte.
INIT_MEMORY="2G"
MAX_MEMORY="7G"
ALLOW_FLIGHT=false

STATE_RUNNING_INSTANCE_FILE=stateRunningInstance.dat

sleepAndStatus() {
    echo "Sleeping 5 sec ..."
    sleep 5
    docker ps -a | grep minecraft
}


start() {
    docker start $DOCKER_NAME
    docker unpause $DOCKER_NAME
    echo "$DOCKER_NAME" > $STATE_RUNNING_INSTANCE_FILE
    sleepAndStatus
}

stopInstance() {
    echo "Force stopping $1"
    docker stop $1
}


stopPrevious() {
    previousDockerName=$(cat $STATE_RUNNING_INSTANCE_FILE)
    if [[ "$previousDockerName" != "$DOCKER_NAME" ]] ; then
	    echo "Stopping previous minecraft instance: $previousDockerName"
	    echo "> docker exec $previousDockerName rcon-cli stop"
	    docker exec $previousDockerName rcon-cli stop
        if (( $? != 0 )) ; then
            echo "Force stopping $previousDockerName"
            docker stop $previousDockerName
        fi
	    [ -f state.${previousDockerName}.dat ] && rm state.${previousDockerName}.dat
	fi
    echo "Force stopping all others manually"
    if [[ "minecraftPondus" == "$DOCKER_NAME" ]] ; then
        stopInstance minecraftFtb
    else
        stopInstance minecraftPondus
    fi
    sleep 1
}

stop() {
    echo "> docker exec $DOCKER_NAME rcon-cli stop"
    docker exec $DOCKER_NAME rcon-cli stop
    if (( $? != 0 )) ; then
        echo "Force stopping $DOCKER_NAME"
      docker stop $DOCKER_NAME
    fi
}

rmDocker() {
    docker rm $DOCKER_NAME
}

#Minecraft version and forgeversions are listed here: https://files.minecraftforge.net/maven/net/minecraftforge/forge/index_1.10.2.html

# Note the enviroment -e variables for the minecraft (not memory, version etc.) only has effect when server.properties has not been created yet.
# Console, GUI: Users say 'nogui' helped avoid lag and 'cannot keep up' messages. Docker guide says put '--noconsole' at the end for Bukkit/Spigot server, reading dockre scripts start-minecraftFinalSetup it seems addeng -e GUI=false and -e CONSOLE=false should do the trick
createAndStartDocker() {
    # Make Docker scripts reuse OPS list given here by deleting ops.txt.converted
	echo "$HOSTDATA" > stateDataFolder.${DOCKER_NAME}.dat
    rm $HOSTDATA/ops.txt.converted
    docker pull itzg/minecraft-server
    echo "/data -> $HOSTDATA"
    if [[ "$IS_FTB" == "true" ]] ; then
        echo "FTBServerZip=$FTBServerZip"
        docker run -d -v $HOSTDATA:/data \
            -e VERSION=$MINECRAFT_VERSION \
            -e TYPE=FTB -e FTB_SERVER_MOD=$FTBServerZip \
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
            -v "/etc/timezone:/etc/timezone:ro" \
            -v "/etc/localtime:/etc/localtime:ro" \
            -p $PORT:25565 -e EULA=TRUE --name $DOCKER_NAME itzg/minecraft-server
    else
        echo "NOT FTB"
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
            -v "/etc/timezone:/etc/timezone:ro" \
            -v "/etc/localtime:/etc/localtime:ro" \
            -p $PORT:25565 -e EULA=TRUE --name $DOCKER_NAME itzg/minecraft-server
    fi

    if (( $? == 0 )) ; then
        echo "$DOCKER_NAME" > $STATE_RUNNING_INSTANCE_FILE
    fi

    #    -e CONSOLE=false \
    #    -e JVM_OPTS="-Dfml.queryResult=confirm" \
    #    --noconsole
    #    -e MEMORY="2G" \
    #    -e ALLOW_FLIGHT=true \

    # Missing params in docker (user server.properties instead)
    #sleep 5
    #echo
    #docker ps -a
}

followLogs() {
    # Note the logs will contain a failure on first download attempt
    docker logs $DOCKER_NAME -f
}
