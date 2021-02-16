DATE=$(date +%Y%m%d_%H%M)

pushd $1
tar cvf world_${DATE}.tgz world
popd