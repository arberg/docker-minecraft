. minecraftCustom.sh

# Custom Server.properties - I don't know which server.properties is used dataFtbRevelation-v1.12\FeedTheBeast or its parent
# max-tick-time=-1 # Disable [minecraft/ServerHangWatchdog] so it does not kill server on resume due to lag


# Note the enviroment -e variables for the minecraft (not memory, version etc.) only has effect when server.properties has not been created yet.
# Console, GUI: Users say 'nogui' helped avoid lag and 'cannot keep up' messages. Docker guide says put '--noconsole' at the end for Bukkit/Spigot server, reading dockre scripts start-minecraftFinalSetup it seems addeng -e GUI=false and -e CONSOLE=false should do the trick
createAndStartDocker() {
    # Make Docker scripts reuse OPS list given here by deleting ops.txt.converted
	echo "$DOCKER_NAME" > $STATE_RUNNING_INSTANCE_FILE
	echo "$HOSTDATA" > stateDataFolder.${DOCKER_NAME}.dat
    rm $HOSTDATA/ops.txt.converted
    docker pull itzg/minecraft-server
    # Downloaded FTBServer: https://www.feed-the-beast.com/projects/ftb-revelation
    echo "/data -> $HOSTDATA"
    docker run -d -v $HOSTDATA:/data \
        -e VERSION=$MINECRAFT_VERSION \
        -e TYPE=FTB -e FTB_SERVER_MOD=FTBRevelationServer_2.5.0.zip \
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
