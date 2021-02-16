DOCKERNAME=$(cat /mnt/user/dockerhub/itzg-minecraft-server/stateRunningInstance.dat);
docker exec $DOCKERNAME rcon-cli stop