#!/bin/bash

# Remove all packages added for removal
removals="$DOTFILES_PATH/packages/removal.packages"
while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    # Skip comments
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
    if pacman -Qi "$pkg" &>/dev/null; then
        echo " → $pkg installed. Uninstalling..."
        yay -Rns --noconfirm "$pkg"
    else
        echo " → $pkg is not installed.."
    fi
done < "$removals"

# Install all extension  packages
base="$DOTFILES_PATH/packages/base.packages"
while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    # Skip comments
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
    if pacman -Qi "$pkg" &>/dev/null; then
        echo " → $pkg already installed."
    else
        echo " → $pkg is not installed. Installing it."
        yay  -S --noconfirm --needed "$pkg"
    fi
done < "$base"
