RUN_AS_UID=99
RUN_AS_GID=100


status() {
    echo "##### All"
    docker ps -a | grep minecraft
    echo "##### Only this"
    docker ps -a | grep $DOCKER_NAME
    echo "##### This state"
    getState
}


getState() {
     docker inspect $DOCKER_NAME --format  "{{.State.Status}}"
}

stopDockerInstance() {
    echo "Force stopping $1"
    docker stop $1
    getState
}

rcon() {
    echo "> docker exec $DOCKER_NAME rcon-cli $*"
    docker exec $DOCKER_NAME rcon-cli $*
}


fixOwnership() {
    dir=$1
    # RUN_AS_UID=$[2:-$RUN_AS_UID]
    # RUN_AS_GID=$[3:-$RUN_AS_GID]
    # [[ "$RUN_AS_UID" == "" ]] && echo "Error fixOwnership: Missing argument UID" && exit 1
    # [[ "$RUN_AS_GID" == "" ]] && echo "Error fixOwnership: Missing argument GID" && exit 1
    echo -n "fixOwnership: $dir ..."
    [ -d $dir ] && sudo find $dir \( ! -uid $RUN_AS_UID -o ! -gid $RUN_AS_GID \) -exec chown -R $RUN_AS_UID:$RUN_AS_GID {} \; -exec echo "chown -R $RUN_AS_UID:$RUN_AS_GID {}"  \; -print > /dev/null
    echo "Done!"
}
fixPermissionsAllUsersWrite() {
	echo "fixPermissionsAllUsersWrite $1"
    dir=$1
    fixOwnership $1
    # queries all with missing correct permissionsa and sets the perms on those files/folders
    [ -d $dir ] && sudo find $dir \( -type d \( ! -perm -a+r -o ! -perm -a+w -o ! -perm -a+x \) -print  -exec chmod 777 {} \; \) -o \( -type f \( ! -perm -a+r -o ! -perm -a+w \) -print -exec chmod a+rw {} \; \) > /dev/null
}
fixPermissionsOwnerWrite() {
	echo "fixPermissionsOwnerWrite $1"
    dir=$1
    fixOwnership $1
    # u The user who owns it (1.)
    # g Other users in the file's Group (2.)
    # o Other users not in the file's group (3.)
    # a All users (all)
    sudo find $dir \( -type d \( ! -perm -a+r -o ! -perm -u+w -o -perm -g+w -o -perm -a+w -o ! -perm -a+x \) -print -exec chmod 755 {} \; \) -o  \( -type f \( ! -perm -a+r -o ! -perm -u+w -o -perm -g+w -o -perm -a+w \) -print -exec chmod u+rw,g-w,o-w {} \; \)
}
# Requires root if any are to be changed
fixPermissionsCurrentDockerComposedDir() {
    HOSTDATA=data
    mkSafe $HOSTDATA
    #HOSTDATA_CACHE=/mnt/cache/cacheonly/dockerhub/itzg-minecraft-server/${DATA_DIR}
    fixPermissionsAllUsersWrite $HOSTDATA
    #fixPermissionsOwnerWrite $HOSTDATA_CACHE
}
rmSafe() {
	[[ -f $1 ]] && rm $1
}
mkSafe() {
    [[ ! -d $1 ]] && mkdir $1
}