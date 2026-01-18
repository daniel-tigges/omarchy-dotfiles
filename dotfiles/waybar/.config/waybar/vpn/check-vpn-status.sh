#!/bin/bash
source "$(dirname "$0")/vpn.conf"
if ip link show | grep -q "$VPN_NAME"; then
  echo "{\"text\": \"\" , \"class\": \"active\", \"tooltip\": \"VPN Connected: $VPN_NAME\"}"
else
  echo "{\"text\": \"\", \"class\": \"inactive\", \"tooltip\": \"VPN Disconnected\"}"
fi