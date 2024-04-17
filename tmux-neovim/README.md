# Overview

Containerized development environment, which contains `TMUX`, `NEOVIM`, `GIT` and more.

## Usage

It is good to keep the container as is and not recreate it each time. That is why the following commands will safely keep the container alive (it can be stopped at any time).

* ### Build with compose

    This will create a user based on the host user inside the container. This allowes writing access for the files.

    ```
    docker compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$USER
    ```

* ### Start container
    ```
    docker compose up -d
    ```

* ### Exec into running container
    ```
    docker exec -it tmux-neovim-devcontainer bash
    ```

* ### Stop container
    ```
    docker compose down
    ```