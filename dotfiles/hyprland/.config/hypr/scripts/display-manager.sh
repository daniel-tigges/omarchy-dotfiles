#!/bin/bash

# --- CONFIGURATION ---
LAPTOP_DISPLAY="eDP-1"
SPECIFIC_DISPLAY="DP-2"

# Defined settings for DP-2
TARGET_RES="3440x1440"
TARGET_HZ="99.98"
TARGET_SCALE="1.0"
# Position: Place external to the right of the laptop (assumes laptop is 1920 wide)
# If you want it auto-positioned, use "auto" instead of "1920x0"
TARGET_POS="1920x0" 

# --- DETECTION ---

# Check Lid Status (Open/Closed)
# We look for "closed" in the ACPI file. 
if grep -q "closed" /proc/acpi/button/lid/*/state 2>/dev/null; then
    LID_CLOSED=true
else
    LID_CLOSED=false
fi

# Check if ANY external monitor is connected (excluding laptop)
# We count lines in hyprctl monitors that are not the laptop
EXT_MONITOR_COUNT=$(hyprctl monitors all | grep "Monitor" | grep -v "$LAPTOP_DISPLAY" | wc -l)

# Check if our specific DP-2 is connected
if hyprctl monitors all | grep -q "Monitor $SPECIFIC_DISPLAY"; then
    SPECIFIC_CONNECTED=true
else
    SPECIFIC_CONNECTED=false
fi

# --- LOGIC APPICATION ---

# 1. Handle External Monitors first (Source of Truth)

if [ "$SPECIFIC_CONNECTED" = true ]; then
    # DP-2 is connected. Let's check if it actually supports the target mode.
    # We grep the monitor info for the resolution AND refresh rate.
    # We use -A 40 to search within the lines following the monitor name.
    if hyprctl monitors all | grep -A 40 "Monitor $SPECIFIC_DISPLAY" | grep -q "${TARGET_RES}@${TARGET_HZ}"; then
        # Mode is available -> Apply specific settings
        echo "Applying specific settings for $SPECIFIC_DISPLAY..."
        hyprctl keyword monitor "$SPECIFIC_DISPLAY, ${TARGET_RES}@${TARGET_HZ}, $TARGET_POS, $TARGET_SCALE"
    else
        # Mode not found -> Fallback to preferred
        echo "Target mode not found for $SPECIFIC_DISPLAY. Using preferred..."
        hyprctl keyword monitor "$SPECIFIC_DISPLAY, preferred, auto, 1"
    fi
else
    # If DP-2 is NOT connected, but another monitor IS, we ensure generic fallback
    # The wildcard "," covers all monitors not explicitly named.
    hyprctl keyword monitor ", preferred, auto, 1"
fi

# 2. Handle Laptop Display (eDP-1) based on Lid & External setup

if [ "$EXT_MONITOR_COUNT" -gt 0 ]; then
    # External monitor(s) exist
    if [ "$LID_CLOSED" = true ]; then
        # Lid closed + External monitor -> Disable Laptop
        echo "Lid closed & External connected. Disabling Laptop."
        hyprctl keyword monitor "$LAPTOP_DISPLAY, disable"
    else
        # Lid open + External monitor -> Enable Laptop
        echo "Lid open. Enabling Laptop."
        hyprctl keyword monitor "$LAPTOP_DISPLAY, preferred, 0x0, 1"
    fi
else
    # No external monitors -> Laptop MUST be on (Safety)
    echo "No external display. Forcing Laptop ON."
    hyprctl keyword monitor "$LAPTOP_DISPLAY, preferred, 0x0, auto, 1"
fi