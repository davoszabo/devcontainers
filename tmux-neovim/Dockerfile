
# NEOVIM
# ====================

# Use a base image with the necessary build tools and dependencies for neovim
FROM ubuntu:22.04 AS neovim-builder

# Install build dependencies for neovim
RUN apt-get update && apt-get install -y \
    ninja-build \
    gettext \
    cmake \
    unzip \
    curl \
    build-essential \
    git

# Clone the neovim repository
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim

# Change to stable release
RUN cd /tmp/neovim && git checkout stable

# Build and install neovim
RUN cd /tmp/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install



# TMUX
# ====================

# Use a base image with the necessary build tools and dependencies for tmux
FROM ubuntu:22.04 AS tmux-builder

# Install build dependencies for tmux
RUN apt-get update && apt-get install -y \
    git \
    automake \
    autoconf \
    build-essential \
    pkg-config \
    libevent-dev \
    ncurses-dev \
    bison

# Clone the tmux repository
RUN git clone https://github.com/tmux/tmux.git /tmp/tmux

# Build and install tmux
RUN cd /tmp/tmux && sh autogen.sh && ./configure && make && make install



# LAZYGIT
# ====================

# Use a base image with the necessary build tools and dependencies for lazygit
FROM ubuntu:22.04 AS lazygit-builder

# Install build dependencies for tmux
RUN apt-get update && apt-get install -y \
    curl

# Install lazygit (WARNING! API rate limit exceed error might get thrown!) 
# RUN export LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
RUN export LAZYGIT_VERSION=0.41.0 \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && install lazygit /usr/local/bin



# DEVCONTAINER-CLI
# ====================
FROM mcr.microsoft.com/devcontainers/typescript-node:1-18-bookworm as devcontainercli-builder

RUN npm install -g @devcontainers/cli


# Creating base editor image
# ==========================

# Create a new image for the runtime phase
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libevent-dev \
    ncurses-dev \
    ripgrep \
    gcc \
    git \
    sudo \ 
    curl \
    xclip

# Add wheel to sudoers list
RUN echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Copy neovim artifact from the neovim-builder phase
COPY --from=neovim-builder /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=neovim-builder /usr/local/share/nvim /usr/local/share/nvim

# Copy tmux artifact from the tmux-builder phase
COPY --from=tmux-builder /usr/local/bin/tmux /usr/local/bin/tmux

# Copy lazygit artifact from the lazygit-builder phase
COPY --from=lazygit-builder /usr/local/bin/lazygit /usr/local/bin/lazygit

# Copy docker-cli and docker-compose-plugin binary from the dind official docker image
COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/
COPY --from=docker:dind /usr/local/libexec/docker/cli-plugins /usr/local/libexec/docker/cli-plugins
RUN ln -s /usr/local/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

# Copy devcontainer-cli binaries
COPY --from=devcontainercli-builder /usr/local/bin/node /usr/local/bin/node
COPY --from=devcontainercli-builder /usr/local/share/npm-global/lib/node_modules/@devcontainers /usr/local/lib/devcontainer
RUN ln -s /usr/local/lib/devcontainer/cli/devcontainer.js /usr/local/bin/devcontainer

# Clone Tmux plugin manager
# RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy all the needed configurations into user's folder
# COPY --chown=$UNAME:$UNAME install_packages $HOME/install_packages

# WORKDIR ${HOME}

COPY ./entrypoint.sh /
RUN sudo chmod +x /entrypoint.sh

# Set the entrypoint to run tmux at start
ENTRYPOINT ["/entrypoint.sh"]
