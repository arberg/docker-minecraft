#!/usr/bin/env bash
echo 'unpausing'
DOCKERNAME=$(cat /mnt/user/dockerhub/itzg-minecraft-server/stateRunningInstance.dat)
docker unpause $DOCKERNAME
echo 'Starting'
docker start $DOCKERNAME
sleep 1
echo
echo State of this container
docker ps --filter name=$DOCKERNAME
echo
echo State of all minecraft containers
docker ps -a --filter name=minecraft*
# 	echo 'sleeping'
	# sleep 1
# 	docker ps -a | grep minecraft
read -p "Press key to continue to read logs " -n 1 -r
docker logs -f $DOCKERNAME
