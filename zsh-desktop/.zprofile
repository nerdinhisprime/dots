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
