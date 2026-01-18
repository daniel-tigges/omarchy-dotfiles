#!/bin/bash

# Find available VPN configurations
configs_path="/etc/wireguard"
configs=($(ls "$configs_path"/*.conf 2>/dev/null | xargs -n 1 basename -s .conf))

if [ ${#configs[@]} -eq 0 ]; then
  echo "No WireGuard configurations found in $configs_path"
  exit 1
fi

# Present a selection menu
echo "Select a VPN configuration:"
select vpn_name in "${configs[@]}"; do
  if [ -n "$vpn_name" ]; then
    # Get the current VPN name
    source "$(dirname "$0")/vpn.conf"

    # Update vpn.conf
    echo "VPN_NAME=\"$vpn_name\"" >"$(dirname "$0")/vpn.conf"
    echo "VPN configuration updated to $vpn_name"
    # If a VPN is connected, disconnect it
    if ip link show | grep -q "$VPN_NAME"; then
      echo "Disconnecting from $VPN_NAME..."
      sudo wg-quick down "$VPN_NAME"
      # Connect to the new VPN
      echo "Connecting to $vpn_name..."
      sudo wg-quick up "$vpn_name"
    fi

    break
  else
    echo "Invalid selection."
  fi
done