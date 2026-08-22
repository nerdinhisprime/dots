#!/usr/bin/env bash

if ! command -v sway-launcher-desktop &> /dev/null; then
    echo "Error: pulsemixer was not found."
    read -p "Should install it right now? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        yay -S --noconfirm pulsemixer
    else
        exit 1
    fi
fi

PIDFILE="/tmp/niri-audio-menu.pid"

if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        kill "$old_pid" 2>/dev/null
    fi
fi
echo $$ > "$PIDFILE"

exec foot -e pulsemixer
