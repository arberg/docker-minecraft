#!/usr/bin/env bash
DIRNAME=$(basename $(pwd))
DATE=$(date '+%Y%m%d_%H%M%S')
FILE="$DIRNAME-update-$DATE$1.zip"
echo zip -r $FILE data
zip -r $FILE data
