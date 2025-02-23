#!/bin/bash

# Copyright (c) 2025 Jqshuv
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

mkdir -p instance
mkdir -p instance/config
mkdir -p instance/mods

# get modfiles by list the mods directory
MODFILES=$(ls -1 mods)

# copy config files to instance/config
echo "Copying config files to instance/config"
cp -r config/* instance/config

# for each modfile, create a symlink in the mods directory
for MODFILE in $MODFILES
do
	URL=$(sed -n 's/.*url = "\([^"]*\)".*/\1/p' mods/$MODFILE)
	# Download file from URL and save it to newmods directory with the name of the url
	FILENAME=$(basename "$URL")
	# Filename replace url encoded characters
	FILENAME=$(echo $FILENAME | sed 's/%20/ /g')
	FILENAME=$(echo $FILENAME | sed 's/%2B/+/g')

	echo "Downloading $FILENAME from $URL"

	curl -L -o "instance/mods/$FILENAME" $URL > /dev/null 2>&1
done
