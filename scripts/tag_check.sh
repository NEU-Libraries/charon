#!/bin/bash
result=$(curl -s https://registry.hub.docker.com/v2/repositories/nakatomi/charon_web/tags/$1/ | jq '.name' | tr -d '"')
if [ $1 = $result ]; then
	echo "Tag already exists"
	exit 1
else
	echo "Tag doesn't yet exist"
	exit 0
fi
