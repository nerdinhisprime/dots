#
# ~/.zprofile
#

if [[ -f ~/.profile ]]; then
  source ~/.profile
fi

if [[ "$(tty)" == "/dev/tty1" ]]; then
  print -n ":: Start Niri? [Y/n]: "
  read -k 1 REPLY
  print
      
  if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == $'\n' ]]; then
    exec niri
  fi
fi

# Created by `pipx` on 2026-07-27 11:07:07
export PATH="$PATH:/home/nerd/.local/bin"
