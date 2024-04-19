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


# Use a base image with the necessary build tools and dependencies for lazygit
FROM ubuntu:22.04 AS lazygit-builder

# Install build dependencies for tmux
RUN apt-get update && apt-get install -y \
    curl

# Install lazygit
RUN export LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && install lazygit /usr/local/bin


# Create a new image for the runtime phase
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libevent-dev \
    ncurses-dev \
    ripgrep \
    gcc \
    git \
    sudo

ENV TERM xterm-256color

# Create new user
ARG UID=1000
ARG GID=1000
ARG UNAME=user

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME \
    && mkdir -p /etc/sudoers.d \
    && echo "$UNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$UNAME \
    && chmod 0440 /etc/sudoers.d/$UNAME

# Change user to new user
USER $UNAME

# Copy neovim artifact from the neovim-builder phase
COPY --from=neovim-builder /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=neovim-builder /usr/local/share/nvim /usr/local/share/nvim

# Copy tmux artifact from the tmux-builder phase
COPY --from=tmux-builder /usr/local/bin/tmux /usr/local/bin/tmux

# Copy lazygit artifact from the lazygit-builder phase
COPY --from=lazygit-builder /usr/local/bin/lazygit /usr/local/bin/lazygit

# Uncomment the "force_color_prompt=yes" to show color in prompt
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' ~/.bashrc

# Clone Tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy all the needed configurations into user's folder
COPY --chown=$UNAME:$UNAME config/. /home/$UNAME

WORKDIR /workspace

# Set the entrypoint to run tmux at start
ENTRYPOINT ["/bin/bash", "-c", "~/.tmux/plugins/tpm/scripts/install_plugins.sh && bash"]
