#!/bin/bash
set -e # エラー発生は終了

# ホスト環境IP
export XDEBUG_CLIENT_HOST=$(grep '^nameserver' /etc/resolv.conf | awk '{print $2}')

# Xdebug.ini作成 ----------------------------------------------------------
cat <<EOF > ./docker/xdebug.ini
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_host=${XDEBUG_CLIENT_HOST}
xdebug.client_port=9003
xdebug.log_level=0
xdebug.idekey=VSCODE
EOF


# compose.yml作成 ----------------------------------------------------------
cat <<EOF > ./docker/compose.yml
services:
  # ----------------------------------------
  # PHP-FPM 7.0 コンテナ
  # ----------------------------------------
  php70:
    build:
      context: .
      dockerfile: Dockerfile_PHP7.0
    container_name: php70
    volumes:
      - ../src:/app:delegated
    environment:
      # PHP-FPM プロセス数など調整可能
      PHP_UPLOAD_MAX_FILESIZE: 20M
      PHP_POST_MAX_SIZE: 20M
    networks:
      - myapp_network

  # ----------------------------------------
  # PHP-FPM 7.4 コンテナ
  # ----------------------------------------
  php74:
    build:
      context: .
      dockerfile: Dockerfile_PHP7.4
    container_name: php74
    volumes:
      - ../src:/app:delegated
      - ./xdebug.ini:/usr/local/etc/php/conf.d/xdebug.ini:ro
    environment:
      # PHP-FPM プロセス数など調整可能
      PHP_UPLOAD_MAX_FILESIZE: 20M
      PHP_POST_MAX_SIZE: 20M
    networks:
      - myapp_network

  # ----------------------------------------
  # PHP-FPM 8.0 コンテナ
  # ----------------------------------------
  php80:
    build:
      context: .
      dockerfile: Dockerfile_PHP8.0
    container_name: php80
    volumes:
      - ../src:/app:delegated
      - ./xdebug.ini:/usr/local/etc/php/conf.d/xdebug.ini:ro
    environment:
      # PHP-FPM プロセス数など調整可能
      PHP_UPLOAD_MAX_FILESIZE: 20M
      PHP_POST_MAX_SIZE: 20M
    networks:
      - myapp_network

  # ----------------------------------------
  # PHP-FPM 8.2 コンテナ
  # ----------------------------------------
  php82:
    build:
      context: .
      dockerfile: Dockerfile_PHP8.2
    container_name: php82
    volumes:
      - ../src:/app:delegated
      - ./xdebug.ini:/usr/local/etc/php/conf.d/xdebug.ini:ro
    environment:
      # PHP-FPM プロセス数など調整可能
      PHP_UPLOAD_MAX_FILESIZE: 20M
      PHP_POST_MAX_SIZE: 20M
    networks:
      - myapp_network

networks:
  myapp_network:
    driver: bridge
EOF
# ----------------------------------------------------------------

HOST_UID=$(id -u)
HOST_GID=$(id -g)
docker compose -f ./docker/compose.yml -p php_version build --build-arg UID=$HOST_UID --build-arg GID=$HOST_GID --no-cache
docker compose -f ./docker/compose.yml -p php_version up -d
