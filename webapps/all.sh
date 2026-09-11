#!/bin/bash

# Remove all webapps added for removal
mapfile -t removals < <(grep -v '^#' "$DOTFILES_PATH/webapps/removal.webapps" | grep -v '^$')
for webapp in "${removals[@]}"; do
    echo "Removing webapp: $webapp"
    omarchy-webapp-remove "$webapp"
done

# Install all extension webapps
mapfile -t base_webapps < <(grep -v '^#' "$DOTFILES_PATH/webapps/base.webapps" | grep -v '^$')
for webapp in "${base_webapps[@]}"; do
    echo "Installing webapp: $webapp"
    omarchy-webapp-install "$webapp"
done
