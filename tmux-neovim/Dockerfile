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


# Create a new image for the runtime phase
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libevent-dev \
    ncurses-dev \
    python3 \
    gcc \
    git \
    ripgrep

ENV TERM xterm-256color

ARG UID=1000
ARG GID=1000
ARG UNAME=user

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
USER $UNAME

# Copy neovim artifact from the neovim-builder phase
COPY --from=neovim-builder /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=neovim-builder /usr/local/share/nvim /usr/local/share/nvim

# Copy tmux artifact from the tmux-builder phase
COPY --from=tmux-builder /usr/local/bin/tmux /usr/local/bin/tmux

# Uncomment the "force_color_prompt=yes" to show color in prompt
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' ~/.bashrc

# Clone Tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy all the needed configurations into /root
COPY --chown=$UNAME:$UNAME config/. /home/$UNAME

WORKDIR /workspace

# Set the entrypoint to run tmux at start
ENTRYPOINT ["/bin/bash", "-c", "~/.tmux/plugins/tpm/scripts/install_plugins.sh && bash"]
