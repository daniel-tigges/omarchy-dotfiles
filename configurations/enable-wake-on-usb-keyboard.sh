#!/usr/bin/env bash
#
# enable-usb-wakeup.sh
# Creates a udev rule to enable wake-up for the Apple keyboard and its hub
# Devices: /sys/bus/usb/devices/1-4  and  /sys/bus/usb/devices/1-4.4

RULE_FILE="/etc/udev/rules.d/90-usb-wakeup.rules"

echo " → Creating $RULE_FILE ..."

sudo tee "$RULE_FILE" > /dev/null <<'EOF'
# Enable wake-up for Apple Aluminium keyboard and upstream hub
ACTION=="add", SUBSYSTEM=="usb", KERNEL=="1-4", ATTR{power/wakeup}="enabled"
ACTION=="add", SUBSYSTEM=="usb", KERNEL=="1-4.4", ATTR{power/wakeup}="enabled"
EOF

echo " → Reloading udev rules..."
sudo udevadm control --reload
sudo udevadm trigger

echo " → Manually enabling wake-up now for current session..."
for dev in 1-4 1-4.4; do
    if [ -e /sys/bus/usb/devices/$dev/power/wakeup ]; then
        echo enabled | sudo tee /sys/bus/usb/devices/$dev/power/wakeup
    else
        echo "Device $dev not present or has no wakeup attribute."
    fi
done

echo " → Done.  Verify with:"
echo "      grep enabled /sys/bus/usb/devices/*/power/wakeup"
