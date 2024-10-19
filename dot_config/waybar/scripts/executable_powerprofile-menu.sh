#!/usr/bin/env bash

CHOICE=$(printf "󰾆 Power Saver\n󰾅 Balanced\n󰓅 Performance" | rofi -dmenu -format 'i' -p " Select Power Profile:  ")

case "$CHOICE" in
    0)
        powerprofilesctl set power-saver
        ;;
    1)
        powerprofilesctl set balanced
        ;;
    2)
        powerprofilesctl set performance
        ;;
esac


