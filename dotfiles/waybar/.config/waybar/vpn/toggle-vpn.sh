#!/bin/bash
source "$(dirname "$0")/vpn.conf"
if ip link show | grep -q "$VPN_NAME"; then
  echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') - VPN DOWN" >>"$(dirname $0)/vpn.log"
  sudo wg-quick down "$VPN_NAME"
else
  echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') - VPN UP $VPN_NAME" >>"$(dirname $0)/vpn.log"
  resolvconf -u
  wg-quick up "$VPN_NAME"
fi