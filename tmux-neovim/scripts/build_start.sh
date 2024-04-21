#!/bin/bash

export USER="$(id -un)"
export MY_UID="$(id -u)"
export MY_GID="$(id -g)"
export DOCKER_GID=$(getent group docker | cut -d: -f3)

# Change to the parent directory of /scripts
cd "$(dirname "$0")/.."

docker compose up -d --build
