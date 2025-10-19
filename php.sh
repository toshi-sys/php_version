#!/bin/bash

echo "*** Through php.sh! ***"
echo "container is "$1"."
echo "target file is "$2"."
echo "***********************"

docker exec $1 php "$2"