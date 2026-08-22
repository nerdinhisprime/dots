#!/usr/bin/env bash

if ! command -v sway-launcher-desktop &> /dev/null; then
    echo "Error: bluez was not found."
    read -p "Should install it right now? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo pacman -S --noconfirm bluez bluez-utils bluez-obex bluetui bluetuith
    else
        exit 1
    fi
fi

PIDFILE="/tmp/niri-bluetooth-menu.pid"

if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        kill "$old_pid" 2>/dev/null
    fi
fi
echo $$ > "$PIDFILE"

exec foot -e bluetui
