#!/usr/bin/env bash

if ! command -v sway-launcher-desktop &> /dev/null; then
    echo "Error: sway-launcher-desktop was not found."
    read -p "Should install it right now? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo pacman -S --noconfirm sway-launcher-desktop
    else
        exit 1
    fi
fi

PIDFILE="/tmp/niri-application-menu.pid"

if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        kill "$old_pid" 2>/dev/null
    fi
fi
echo $$ > "$PIDFILE"

exec sway-launcher-desktop
