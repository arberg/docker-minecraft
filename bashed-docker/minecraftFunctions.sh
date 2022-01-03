# https://hub.docker.com/r/itzg/minecraft-server/

# See ../@PORT-CONFIGURATION.txt

# Remember Backup in f:\bin\ammonite\minecraftPauseAndBackup.sc
DOCKER_NAME=TO_BE_SET
DATA_DIR=TO_BE_SET
SERVER_MESSAGE="Twitch Pokemon Adventure"
PORT=25565
MINECRAFT_VERSION=MISSING
# https://files.minecraftforge.net/maven/net/minecraftforge/forge/index_1.12.2.html
FORGE_VERSION=12.18.3.2185
TYPE_CUSTOM=
# TYPE: FORGE,SPIGOT,FTB,NATIVE (set correct MINECRAFT_VERSION+FORGE_VERSION)
TYPE=FORGE
# New ops will be added to ops.json, on docker create (not start, as that doesn't run 'docker run' again)
OPS=QuirkySpirit,Notebook,Muaddib,QuirkySpirit1,Notebook1,Muaddib1,Pil,Pil1,Lis,Lis1,Alex,LunaKittyCatty,Emma,Mr_Duckv2,Magicilly
# OPS: Marcus har den ekstra konto: Xug

# Online - with online skins can be set on server. without online names can be changed.
# Login minecraft - Last successful change of online-mode was done by editing ONLINE_MODE + server.properties + run docker create again. Then players were visitors but now online and with skins. Delete data\FeedTheBeast\ops.json, and cleanup data\ops.txt, restart server
ONLINE_MODE=false
IS_FTB=false
FTBServerZip=FTBServer.zip
# WARNING: With the FtbRevelation modpack, it is necessary to let the docker recreate all config files, in order to change seed, or it will give error about bad config when connecting client to server
# Hmm jeg får pondus seed hele tiden, just set in server.properties.
SEED=-702071384745498
    # worked well with 4-7 GB ram
    # Mayas OldPil hakker i PondusModded, dog ikke særligt ofte.
INIT_MEMORY="2G"
MAX_MEMORY="7G"
ALLOW_FLIGHT=true # Changed 2020.12, maybe crashes on some
AUTO_PAUSE=TRUE # Monitor connected users, and pause process when no-one connected, to avoid CPU usage https://github.com/itzg/docker-minecraft-server/blob/master/README.md
# Note setting, FORCE_GAMEMODE=true - I don't know what it means, but gamemode can be changed on server afterwards
# creative, survival
GAME_MODE=creative
# 99
RUN_AS_UID=$(id -u nobody)
# 100
RUN_AS_GID=$(getent group users | awk -F\: '{print $3}')

STATE_RUNNING_INSTANCE_FILE=../state/stateRunningInstance.dat

. ../minecraftCommonFunctions.sh

sleepAndStatus() {
    echo "Sleeping 1 sec ..."
    sleep 1
    getState
}

start() {
    echo "Starting ${DOCKER_NAME}..."
    docker start $DOCKER_NAME
    docker unpause $DOCKER_NAME
    echo "$DOCKER_NAME" > $STATE_RUNNING_INSTANCE_FILE
    sleepAndStatus
}

stopPrevious() {
    echo "Disabled stopping other containers"
 #    previousDockerName=$(cat $STATE_RUNNING_INSTANCE_FILE)
 #    if [[ "$previousDockerName" != "$DOCKER_NAME" ]] ; then
	#     echo "Stopping previous minecraft instance: $previousDockerName"
	#     echo "> docker exec $previousDockerName rcon-cli stop"
	#     docker exec $previousDockerName rcon-cli stop
 #        if (( $? != 0 )) ; then
 #            echo "Force stopping $previousDockerName"
 #            docker stop $previousDockerName
 #        fi
	#     [ -f state.${previousDockerName}.dat ] && rm state.${previousDockerName}.dat
	# fi
 #    echo "Force stopping all others manually"
 #    if [[ "minecraftPondus" == "$DOCKER_NAME" ]] ; then
 #        stopDockerInstance minecraftFtb
 #    else
 #        stopDockerInstance minecraftPondus
 #    fi
    # sleep 1
}


stop() {
	state=$(getState)
	stateResult=$?
	if [[ "$state" != "exited" ]] && [[ "$stateResult" == 0 ]] ; then
	    echo "Stopping ${DOCKER_NAME} gracefully via rcon..."
	    echo "> docker exec $DOCKER_NAME rcon-cli stop"
	    docker exec $DOCKER_NAME rcon-cli stop 2> /dev/null
		if [[ "$?" -eq "0" ]] ; then
			# now wait
		    i=0
		    while (( i < 60 )) ; do
		    	docker exec $DOCKER_NAME rcon-cli status 2> /dev/null
		    	if [[ "$?" -eq "0" ]] ; then
					echo "$DOCKER_NAME: Still running $i"
					sleep 1
				else
					echo "$DOCKER_NAME: Server stopped gracefully"
					break
		    	fi
		    	i=$((i+1))
		    done
		else
			# Failed check docker status
			# Alternative, which fails if docker container does not exists: status=$(docker inspect $DOCKER_NAME --format  "{{.State.Status}}" >2 /dev/null)
			runningLine=$(docker ps | grep $DOCKER_NAME | wc -l)
			if (( runningLine == 0 )) ; then
				echo "$DOCKER_NAME: Docker not running"
			else
				docker ps | grep $DOCKER_NAME
				echo "$DOCKER_NAME: Server could not be stopped gracefully, possibly it is starting up. Use 'stopDocker' to force stop"
				exit 1
			fi
		fi
	    if (( $? != 0 )) ; then
	      echo "Force stopping $DOCKER_NAME"
	      docker stop $DOCKER_NAME
	    fi
	    while [[ $(getState) == "running" ]] ; do
	        sleep 1
	    done
		echo "${DOCKER_NAME}: $(getState)"
    else
		echo "${DOCKER_NAME}: Already $(getState)"
    fi
}

fixPermissions() {
    HOSTDATA=/mnt/user/dockerhub/itzg-minecraft-server/${DATA_DIR}
    # HOSTDATA_CACHE=/mnt/cache/cacheonly/dockerhub/itzg-minecraft-server/${DATA_DIR}
    fixPermissionsAllUsersWrite $HOSTDATA
    # fixPermissionsOwnerWrite $HOSTDATA_CACHE
}

rmDocker() {
    docker rm $DOCKER_NAME
}


fixSpigotBuildRenameError() {
    dataDir=$1
    echo "Checking Spigot build: $dataDir"
    # echo "$dataDir/spigot_server.jar"
    # echo "$dataDir/spigot_server-${MINECRAFT_VERSION}.jar"
    if [[ -f "$dataDir/spigot_server.jar" ]] && [[ ! -f "$dataDir/spigot_server-${MINECRAFT_VERSION}.jar" ]] ; then
        echo "FIXING spigot build: "
        mv "$dataDir/spigot_server.jar" "$dataDir/spigot_server-${MINECRAFT_VERSION}.jar"
    else 
        echo "Spigot build looks good."
    fi
}
#Minecraft version and forgeversions are listed here: https://files.minecraftforge.net/maven/net/minecraftforge/forge/index_1.10.2.html

# Note the enviroment -e variables for the minecraft (not memory, version etc.) only has effect when server.properties has not been created yet.
# Console, GUI: Users say 'nogui' helped avoid lag and 'cannot keep up' messages. Docker guide says put '--noconsole' at the end for Bukkit/Spigot server, reading dockre scripts start-minecraftFinalSetup it seems addeng -e GUI=false and -e CONSOLE=false should do the trick
createAndStartDocker() {
    if [[ $(id -u) != "0" ]]; then
        echo "ERROR: Run as root"
        exit 1
    fi

    #  I want to split into /mnt/cache as I have SSD, and its also not worth the pain
 #    echo ./linkDataWoldsViaCacheOnly.sh ${DATA_DIR} "includeBackups"
 #    if [[ "$TYPE_CUSTOM" == "coolcraft" ]] ; then
 #    	./linkDataWoldsViaCacheOnly.sh ${DATA_DIR} "includeBackups"
 #    else
 #    	./linkDataWoldsViaCacheOnly.sh ${DATA_DIR} "includeBackups"
 #    fi
 #    HOSTDATA=/mnt/user/dockerhub/itzg-minecraft-server/${DATA_DIR}
 #    HOSTDATA_CACHE=/mnt/cache/cacheonly/dockerhub/itzg-minecraft-server/${DATA_DIR}
 #    if [[ -d $HOSTDATA/world/world ]] || [[ -d $HOSTDATA/world_nether/world_nether ]] || [[ -d $HOSTDATA/world_the_end/world_the_end ]] ; then
 #        echo "Error: Loop in $HOSTDATA/world/world"
 #        echo "or world_nether or world_the_end"
 #        rm $HOSTDATA/world/world
 #        rm $HOSTDATA/world_nether/world_nether
 #        rm $HOSTDATA/world_the_end/world_the_end
 #        exit 1
 #    fi
    fixPermissions

	echo "$HOSTDATA" > "state/stateDataFolder.${DOCKER_NAME}.dat"
	echo "Data volume: /data => $HOSTDATA"
    HOSTDATA_CACHE="/UnusedCache" # Still declare it as I havn't removed volumes below
	# echo "World cache volume: $HOSTDATA_CACHE"

    # Make Docker scripts reuse OPS list given here by deleting ops.txt.converted
    rmSafe $HOSTDATA/ops.txt.converted
    docker pull itzg/minecraft-server
    # rcon-port for rcon-cli, or simply exec into docker: docker exec minecraftFtb rcon-cli stop
    RCON_PORT=$((PORT+100))
    # To make it easier to indentify processes in 'psg' I have added this environment variable, which sends a -D to java-vm.
    # -e JVM_DD_OPTS=docker=${DOCKER_NAME} \
    if [[ "$TYPE_CUSTOM" == "coolcraft" ]] ; then
        echo "$TYPE"
        fixSpigotBuildRenameError $HOSTDATA
        docker run -d \
            -v $HOSTDATA:/data \
            -v $HOSTDATA_CACHE:$HOSTDATA_CACHE \
            -e TYPE=SPIGOT \
            -e VERSION=$MINECRAFT_VERSION \
            -e BUILD_FROM_SOURCE=true \
            -e INIT_MEMORY="$INIT_MEMORY" \
            -e MAX_MEMORY="$MAX_MEMORY" \
            -e "OPS=$OPS" \
            -e GUI=false \
            -e ENABLE_AUTOPAUSE="$AUTO_PAUSE"\
            -v "/etc/timezone:/etc/timezone:ro" \
            -v "/etc/localtime:/etc/localtime:ro" \
            -p $PORT:25565 \
            -p $RCON_PORT:25575 \
            -e JVM_DD_OPTS=docker=${DOCKER_NAME} \
			-e UID=$RUN_AS_UID -e GID=$RUN_AS_GID \
            -e EULA=TRUE --name $DOCKER_NAME itzg/minecraft-server --noconsole
    elif [[ "$TYPE" == "SPIGOT" ]] ; then
        echo "$TYPE"
        fixSpigotBuildRenameError $HOSTDATA
        docker run -d \
            -v $HOSTDATA:/data \
            -v $HOSTDATA_CACHE:$HOSTDATA_CACHE \
            -e VERSION=$MINECRAFT_VERSION \
            -e BUILD_FROM_SOURCE=true \
            -e TYPE=SPIGOT \
            -e "MOTD=$SERVER_MESSAGE" \
            -e "OPS=$OPS" \
            -e SEED=$SEED \
            -e MODE=$GAME_MODE \
            -e FORCE_GAMEMODE=true \
            -e ONLINE_MODE=$ONLINE_MODE \
            -e ALLOW_NETHER=true \
            -e ENABLE_COMMAND_BLOCK=true \
            -e INIT_MEMORY="$INIT_MEMORY" \
            -e MAX_MEMORY="$MAX_MEMORY" \
            -e GUI=false \
            -e ENABLE_AUTOPAUSE="$AUTO_PAUSE"\
            -v "/etc/timezone:/etc/timezone:ro" \
            -v "/etc/localtime:/etc/localtime:ro" \
            -p $PORT:25565 \
            -p $RCON_PORT:25575 \
            -e JVM_DD_OPTS=docker=${DOCKER_NAME} \
			-e UID=$RUN_AS_UID -e GID=$RUN_AS_GID \
            -e EULA=TRUE --name $DOCKER_NAME itzg/minecraft-server --noconsole
    elif [[ "$TYPE" == "FTB" ]] ; then #  [[ "$IS_FTB" == "true" ]] ||
        # server.properties: Root takes effect over inner FeedTheBeast, and if its already created server.properties takes effect over environment (eg online mode)
        echo "FTBServerZip=$FTBServerZip"
        docker run -d \
            -v $HOSTDATA:/data \
            -v $HOSTDATA_CACHE:$HOSTDATA_CACHE \
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
            -e ENABLE_AUTOPAUSE="$AUTO_PAUSE"\
            -p $PORT:25565 \
            -p $RCON_PORT:25575 \
            -e JVM_DD_OPTS=docker=${DOCKER_NAME} \
			-e UID=$RUN_AS_UID -e GID=$RUN_AS_GID \
            -e EULA=TRUE --name $DOCKER_NAME itzg/minecraft-server:java8
    elif [[ "$TYPE" == "FORGE" ]] ; then
        echo "FORGE"
        docker run -d \
            -v $HOSTDATA:/data \
            -v $HOSTDATA_CACHE:$HOSTDATA_CACHE \
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
            -e ENABLE_AUTOPAUSE="$AUTO_PAUSE"\
            -v "/etc/timezone:/etc/timezone:ro" \
            -v "/etc/localtime:/etc/localtime:ro" \
            -p $PORT:25565 \
            -p $RCON_PORT:25575 \
            -e JVM_DD_OPTS=docker=${DOCKER_NAME} \
			-e UID=$RUN_AS_UID -e GID=$RUN_AS_GID \
            -e EULA=TRUE --name $DOCKER_NAME itzg/minecraft-server
            # -e JVM_OPTS="-Dfml.queryResult=confirm" \
    elif [[ "$TYPE" == "NATIVE" ]] ; then
        echo "NATIVE"
        docker run -d \
            -v $HOSTDATA:/data \
            -v $HOSTDATA_CACHE:$HOSTDATA_CACHE \
            -e VERSION=$MINECRAFT_VERSION \
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
            -e ENABLE_AUTOPAUSE="$AUTO_PAUSE"\
            -v "/etc/timezone:/etc/timezone:ro" \
            -v "/etc/localtime:/etc/localtime:ro" \
            -p $PORT:25565 \
            -p $RCON_PORT:25575 \
            -e JVM_DD_OPTS=docker=${DOCKER_NAME} \
			-e UID=$RUN_AS_UID -e GID=$RUN_AS_GID \
            -e EULA=TRUE --name $DOCKER_NAME itzg/minecraft-server
    else
        echo "Error: Missing Type"
    fi

    if (( $? == 0 )) ; then
        echo "$DOCKER_NAME" > $STATE_RUNNING_INSTANCE_FILE
    fi

    echo "On Spigot Vanilla 1.16.1 it was necessary to make operator via rcon after starting server."
    echo "docker exec $DOCKER_NAME rcon-cli op Magicilly"
    echo "docker exec $DOCKER_NAME rcon-cli op Mr_Duckv2"
    echo "(or ./fun.sh rcon Magicilly)"

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

execute() {
     [[ "$MINECRAFT_VERSION" == "MISSING" ]] && echo "Please specify MINECRAFT_VERSION" && exit 1

   if [[ "$1" == "logs" ]] ; then
        followLogs
    elif [[ "$1" == "stop" ]] ; then
        stop
    elif [[ "$1" == "state" ]] ; then
        getState
    elif [[ "$1" == "status" ]] ; then
        status
    elif [[ "$1" == "stopDocker" ]] ; then
        stopDockerInstance $DOCKER_NAME
    elif [[ "$1" == "restart" ]] ; then
        stop
        start
    elif [[ "$1" == "fixPermissions" ]] ; then
        fixPermissions
    elif [[ "$1" == "create" ]] ; then
        # stopPrevious
        stop
        sleep 2
        rmDocker
        createAndStartDocker
        followLogs
    elif [[ "$1" == "createOnly" ]] ; then
            rmDocker
            createAndStartDocker
            followLogs
    elif [[ "$1" == "startOnly" ]] ; then
        start
    elif [[ "$1" == "start" ]] ; then
        stopPrevious
        start
        followLogs
    elif [[ "$1" == "rcon" ]] ; then
    	shift
        rcon $*
    elif [[ "$1" == "rcon-it" ]] ; then
    	shift
        docker exec -it $DOCKER_NAME rcon-cli $*
    else
       echo "Unknown command '$1'"
       echo "Commands available: status, logs, stop, stopDocker, restart, create, createOnly, startOnly, start, fixPermissions, rcon, rcon-it"
       echo
       echo "Spigot servers rebuild from source when running create."
       echo "Create deletes old docker instance and creates from scratch. Necessary when ports have changed."
    fi
}