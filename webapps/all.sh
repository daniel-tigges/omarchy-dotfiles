#!/bin/bash

# Remove all webapps added for removal
mapfile -t removals < <(grep -v '^#' "$DOTFILES_PATH/webapps/removal.webapps" | grep -v '^$')
omarchy-webapp-remove "${removals[@]}"

# Install all extension webapps
mapfile -t base_webapps < <(grep -v '^#' "$DOTFILES_PATH/webapps/base.webapps" | grep -v '^$')
#omarchy-webapp-install "${base_packages[@]}"
