#!/bin/bash

LOGFILE="/var/log/lid-display.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

case "$1" in
    close)
        echo "$DATE - Lid closed: turn off display" >> "$LOGFILE"
        # Bildschirm ausschalten
        #xset dpms force off
        ;;
    open)
        echo "$DATE - Lid opened: turn on display" >> "$LOGFILE"
        # Bildschirm einschalten
        #xset dpms force on
        ;;
esac
