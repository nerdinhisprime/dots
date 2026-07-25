#!/usr/bin/env bash

for cmd in makoctl jq fzf chafa wl-copy; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is not found."
        read -p "Do you want to install missing dependencies (mako, jq, fzf, chafa, wl-clipboard)? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo pacman -S --noconfirm mako jq fzf chafa wl-clipboard
        else
            exit 1
        fi
        break
    fi
done

PIDFILE="/tmp/niri-notification-menu.pid"

if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        kill "$old_pid" 2>/dev/null
    fi
fi

echo $$ > "$PIDFILE"

chosen=$(makoctl history -j | jq -r '.[] | "\(.id)\t[\(.app_name)] \(.summary)"' | fzf \
    --prompt="Notifications: " \
    --layout=reverse \
    --delimiter="\t" \
    --with-nth=2 \
    --preview-window="right:50%:wrap" \
    --preview '
        id={1}
        notif=$(makoctl history -j | jq -r --arg id "$id" ".[] | select(.id == ($id | tonumber))")

        echo "$notif" | jq -r "\"Приложение: \\(.app_name)\nЗаголовок: \\(.summary)\n\nТекст:\n\\(.body)\""

        img=$(echo "$notif" | jq -r ".app_icon // empty")
        if [ -n "$img" ] && [[ "$img" == /* ]] && [ -f "$img" ]; then
            echo -e "\n--- Иконка ---"
            chafa -f sixel -s 40x15 "$img"
        fi
    '
)

if [ -n "$chosen" ]; then
    id=$(echo "$chosen" | cut -d$'\t' -f1)
    makoctl history -j | jq -r --arg id "$id" '.[] | select(.id == ($id | tonumber)) | .body' | wl-copy
fi
