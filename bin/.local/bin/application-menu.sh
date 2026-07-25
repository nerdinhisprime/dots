#!/usr/bin/env bash

PIDFILE="/tmp/niri-application-menu.pid"

if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        kill "$old_pid" 2>/dev/null
    fi
fi
echo $$ > "$PIDFILE"

exec sway-launcher-desktop
