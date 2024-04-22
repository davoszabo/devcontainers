#!/bin/bash

~/.tmux/plugins/tpm/scripts/install_plugins.sh

IFS=';' read -ra install_array <<< "$INSTALL"

for package in "${install_array[@]}"; do
  # TODO: Error handling
	~/install_packages/${package}.sh
done

tail -f /dev/null # Keep container alive
