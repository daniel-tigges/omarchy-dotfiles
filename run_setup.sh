#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

export DOTFILES_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Install
source "$DOTFILES_PATH/packages/all.sh"
source "$DOTFILES_PATH/webapps/all.sh"
source "$DOTFILES_PATH/configurations/all.sh"
source "$DOTFILES_PATH/dotfiles/all.sh"
