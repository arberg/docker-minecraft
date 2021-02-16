#!/usr/bin/env bash
set -e

if [[ "x$1" == "x" ]] ; then
	echo "Missing dataDir argument"
	echo "Syntax arg1: dataDir name (not absolute path)"
	echo "Syntax arg2: 'includeBackups'"
	exit 1
fi

target=$1
RootCache=/mnt/cache/cacheonly/dockerhub/itzg-minecraft-server/${target}
RootArray=/mnt/user/dockerhub/itzg-minecraft-server/${target}

if [[ -d "$RootArray/FeedTheBeast" ]]; then
	echo "FTB detected"
	subDir="/FeedTheBeast"
else
	subDir=""
fi

target=$1
DirCache=${RootCache}${subDir}
DirArray=${RootArray}${subDir}
function linkIt() {
	worldDir=$1
	if [[ ! -d $DirCache/$worldDir ]]; then
		mkdir -p $DirCache
	fi
	# If dir (-d this includes symlinked dirs) and not symlink (-h)
	if [[ -d $DirArray/$worldDir ]] && [[ ! -h $DirArray/$worldDir ]]; then
		if [[ -d $DirCache/$worldDir ]]; then
			echo "Error: Both CacheDir and ArrayDir has folder $worldDir"
			echo "$DirCache/$worldDir"
			echo "$DirArray/$worldDir"
			exit 1
		else
			echo "Moving existing from array to cacheOnly: $DirArray/$worldDir => $DirCache/$worldDir"
			mv $DirArray/$worldDir $DirCache
		fi
	elif [[ ! -d $DirCache/$worldDir ]] ; then
		mkdir $DirCache/$worldDir
	fi
	sudo chown -R 1000 $DirCache
	if [[ ! -h $DirArray/$worldDir ]]; then
		ln -s $DirCache/$worldDir $DirArray/$worldDir
	fi
}

echo $DirArray/FeedTheBeast/world

linkIt world
# Spigot style and Forge style (though forge may have only world)
linkIt world_nether
linkIt world_the_end

if [[ "$2" == "includeBackups" ]] ; then
	linkIt backups
fi


echo "CacheOnly: $DirCache"
ls -las $DirCache
echo
echo "Array: $DirArray"
ls -las $DirArray
