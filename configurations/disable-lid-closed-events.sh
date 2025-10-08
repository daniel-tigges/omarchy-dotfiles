#!/bin/bash
# This script creates a drop-in for systemd-logind to keep laptop awake
# even when lid is closed, dock disconnected, and on battery.

# Create the drop-in directory if it doesn't exist
sudo mkdir -p /etc/systemd/logind.conf.d

# Create the drop-in file
sudo tee /etc/systemd/logind.conf.d/ignore-lid.conf > /dev/null <<'EOF'
[Login]
# Ignore lid events in all situations
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchBattery=ignore
EOF

echo " → systemd-logind drop-in created and reloaded. Lid closed events will now be ignored."
