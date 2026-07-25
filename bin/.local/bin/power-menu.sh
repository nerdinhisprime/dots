#!/usr/bin/env bash

for cmd in fzf; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is not found."
        read -p "Do you want to install missing dependencies fzf? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo pacman -S --noconfirm fzf
        else
            exit 1
        fi
        break
    fi
done

PIDFILE="/tmp/niri-power-menu.pid"

if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        kill "$old_pid" 2>/dev/null
    fi
fi

echo $$ > "$PIDFILE"
chosen=$(printf " poweroff\n reboot\n󰍃 kill niri" | fzf --prompt="power: " --height=20% --layout=reverse)

case "$chosen" in
    *"poweroff"*)
        systemctl poweroff
        ;;
    *"reboot"*)
        systemctl reboot
        ;;
    *"kill niri"*)
        niri msg action quit
        ;;
esac
