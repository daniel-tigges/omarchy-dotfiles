#!/bin/bash

# Sicherstellen, dass DOTFILES_PATH gesetzt ist
export DOTFILES_PATH="${DOTFILES_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)}"

# Wenn das Skript nicht als Root gestartet wurde, Root-Rechte per sudo abfragen und fortfahren
if [ "$EUID" -ne 0 ]; then
    echo "==> Root-Rechte werden für Systemkonfigurationen benötigt. Bitte Passwort eingeben..."
    if ! sudo -v; then
        echo "❌ Authentifizierung fehlgeschlagen. Abbruch."
        exit 1
    fi

    # Sudo-Session im Hintergrund aktiv halten, solange das Skript läuft
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    SUDO_KEEP_ALIVE_PID=$!
    trap 'kill "$SUDO_KEEP_ALIVE_PID" 2>/dev/null' EXIT
fi

source "$DOTFILES_PATH/configurations/register-systemd-services.sh"
source "$DOTFILES_PATH/configurations/disable-bluetooth-idle-timeout.sh"
#source "$DOTFILES_PATH/configurations/enable-wake-on-usb-keyboard.sh"
#source "$DOTFILES_PATH/configurations/set-power-button-behavior.sh"
source "$DOTFILES_PATH/configurations/mask-services.sh"
source "$DOTFILES_PATH/configurations/setup-nvidia-browser.sh"

