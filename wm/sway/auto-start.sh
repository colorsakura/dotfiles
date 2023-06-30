#!/bin/bash

# Auto start APPs script for sway
swaymsg workspace 1
swaymsg exec firefox-developer-edition
swaymsg exec telegram-desktop

swaymsg workspace 2
swaymsg exec kitty
swaymsg exec thunderbird

sleep 2
swaymsg '[app_id="org.telegram.desktop"] focus; move scratchpad'
swaymsg '[app_id="thunderbird"] focus; move scratchpad'
