# https://hub.docker.com/r/itzg/minecraft-server/

NAME=minecraftPondus
HOSTDATA=/mnt/user/app/dockerhub/itzg-minecraft-server/dataPondus

sudo docker exec $NAME rcon-cli stop
sudo docker stop $NAME
sudo docker rm $NAME
#Minecraft version and forgeversions are listed here: https://files.minecraftforge.net/maven/net/minecraftforge/forge/index_1.10.2.html

# Note the enviroment -e variables for the minecraft (not memory, version etc.) only has effect when server.properties has not been created yet. 
# Console, GUI: Users say 'nogui' helped avoid lag and 'cannot keep up' messages. Docker guide says put '--noconsole' at the end for Bukkit/Spigot server, reading dockre scripts start-minecraftFinalSetup it seems addeng -e GUI=false and -e CONSOLE=false should do the trick
sudo docker run -d -v $HOSTDATA:/data \
    -e VERSION=1.10.2 \
    -e TYPE=FORGE -e FORGEVERSION=12.18.3.2511 \
    -e 'MOTD=Pondus' \
    -e OPS=QuirkySpirit,Notebook,Muaddib \
    -e SEED=2305120 \
    -e MODE=creative \
    -e FORCE_GAMEMODE=true \
    -e ONLINE_MODE=FALSE \
    -e ALLOW_NETHER=true \
    -e ENABLE_COMMAND_BLOCK=true \
    -e INIT_MEMORY="2G" \
    -e MAX_MEMORY="4G" \
    -e GUI=false \
    -p 25565:25565 -e EULA=TRUE --name $NAME itzg/minecraft-server 
#    -e CONSOLE=false \
#    -e JVM_OPTS="-Dfml.queryResult=confirm" \
    #--noconsole
#    -e MEMORY="2G" \
#worked well with 4-7 GB ram

# Missing params in docker (user server.properties instead)
#     -e ALLOW_FLIGHT=true \


#sleep 5
# Note the logs will contain a failure on first download attempt
sudo docker logs $NAME -f
#echo
#sudo docker ps -a
