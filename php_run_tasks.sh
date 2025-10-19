#!/bin/bash

# 引数チェック
if [ $# -lt 2 ]; then
  echo "Usage: $0 <container_name> <target_file>"
  exit 1
fi

CONTAINER="$1"
TARGET_FILE="$2"
CONTAINER_TARGET_FILE="/app/"$(basename "$TARGET_FILE")

#echo "*** Through php_run_tasks.sh! ***"
#echo "container is "$CONTAINER"."
#echo "target file is "$TARGET_FILE"."
#echo "container target file is "$CONTAINER_TARGET_FILE
#echo "**********************************"

# コンテナ内でファイル実行
docker exec --user $(id -u):$(id -g) "$CONTAINER" php "$CONTAINER_TARGET_FILE"
