#!/usr/bin/env bash

for cmd in cliphist fzf chafa wl-copy; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is not found."
        read -p "Do you want to install missing dependencies (cliphist, fzf, chafa, wl-clipboard)? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo pacman -S --noconfirm cliphist fzf chafa wl-clipboard
        else
            exit 1
        fi
        break
    fi
done

PIDFILE="/tmp/niri-buffer-menu.pid"

if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        kill "$old_pid" 2>/dev/null
    fi
fi

echo $$ > "$PIDFILE"

chosen=$(cliphist list | fzf \
    --prompt="Clipboard: " \
    --layout=reverse \
    --preview-window="right:50%" \
    --preview '
        if [[ {} == *"[[ binary data"* ]]; then
            echo {} | cliphist decode | chafa -f sixel -s 40x20 -
        else
            echo {} | cliphist decode
        fi
    ')

[ -n "$chosen" ] && echo "$chosen" | cliphist decode | wl-copy
