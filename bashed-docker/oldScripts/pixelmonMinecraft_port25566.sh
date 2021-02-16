# https://hub.docker.com/r/itzg/minecraft-server/

NAME=minecraftPondus
HOSTDATA=/mnt/user/app/dockerhub/itzg-minecraft-server/dataPixelmon

sudo docker exec $NAME rcon-cli stop
sudo docker stop $NAME
sudo docker rm $NAME
#Minecraft version and forgeversions are listed here: https://files.minecraftforge.net/maven/net/minecraftforge/forge/index_1.10.2.html

# It seems the enviroment changing server, only has effect on initial start, after that edit server.properties
sudo docker run -d -v $HOSTDATA:/data \
    -e VERSION=1.12.2 \
    -e TYPE=FORGE -e FORGEVERSION=14.23.4.2745 \
    -e 'MOTD=Pixelmon' \
    -e OPS=QuirkySpirit,Notebook,Muaddib \
    -e MODE=creative \
    -e FORCE_GAMEMODE=true \
    -e ONLINE_MODE=FALSE \
    -e ALLOW_NETHER=true \
    -e ENABLE_COMMAND_BLOCK=true \
    -e INIT_MEMORY="1G" \
    -e MAX_MEMORY="2G" \
    -p 25568:25565 -e EULA=TRUE --name $NAME itzg/minecraft-server
#    -e MEMORY="2G" \

# Missing params in docker (user server.properties instead)
#     -e ALLOW_FLIGHT=true \


#sleep 5
# Note the logs will contain a failure on first download attempt
sudo docker logs $NAME -f
#echo
#sudo docker ps -a
