# Overview

Containerized development environment, which contains `TMUX`, `NEOVIM`, `LAZYGIT` and more.

## Usage

It is good to keep the container as is and not recreate it each time. That is why the following commands will safely keep the container alive (it can be stopped at any time).

* ### Build with compose

    This will create a user based on the host user inside the container. This allowes writing access for the files.

    ```
    ./scripts/build_start.sh
    ```
    or execute the command:
    ```
    docker compose build \
        --build-arg USER=$(id -un) \
        --build-arg MY_UID=$(id -u) \
        --build-arg MY_GID=$(id -g) \
        --build-arg DOCKER_GID=$(getent group docker | cut -d: -f3)
    ```

* ### Start container
    ```
    docker compose up -d
    ```

* ### Exec into running container
    ```
    ./scripts/exec.sh
    ```
    or:
    ```
    docker exec -it tmux-neovim-devcontainer bash
    ```

* ### Stop container (won't remove)
    ```
    docker stop tmux-neovim-devcontainer
    ```

* ### Kill container (will remove)
    ```
    docker compose down
    ```
