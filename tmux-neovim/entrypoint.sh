#!/bin/bash

if [ ! -d ~/.tmux ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Ubuntu bashrc
cp /etc/skel/.bashrc ~/.bashrc-devcontainer

# Uncomment the "force_color_prompt=yes" to show color in prompt
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' ~/.bashrc-devcontainer

# Check if the .bashrc-devcontainer is referenced, and if not, write it into .bashrc
if ! grep -wq ".bashrc-devcontainer" ~/.bashrc; then
    cat >> ~/.bashrc <<EOF

# Linking devcontainer bashrc
if [ -f ~/.bashrc-devcontainer ]; then
    source ~/.bashrc-devcontainer
fi

EOF
fi

# IFS=';' read -ra install_array <<< "$INSTALL"
#
# for package in "${install_array[@]}"; do
#   # TODO: Error handling
# 	~/install_packages/${package}.sh
# done

tail -f /dev/null # Keep container alive
