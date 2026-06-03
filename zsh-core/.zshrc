# Lines configured by zsh-newuser-install

if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v ascii-image-converter &> /dev/null; then
  ascii-image-converter "$HOME/img/ascii.png" -W 95 -C
fi

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob notify
unsetopt beep nomatch
bindkey -e

autoload -Uz compinit
compinit

source "$HOME/.dotfiles/aliases.list"

TRAPWINCH() {
clear
local width=$(tput cols)

if (( width == 191 )); then
  fastfetch
elif (( width == 95 )) && command -v ascii-image-converter &> /dev/null; then
  ascii-image-converter "$HOME/img/ascii.png" -W 95 -C
elif (( width == 127 )) && command -v ascii-image-converter &> /dev/null; then
  ascii-image-converter "$HOME/img/ascii$(( RANDOM % 3 )).png" -W 127 -C
fi
}

if [[ -d "/data/data/com.termux" ]]; then
  zsh_autosuggestions="$HOME/.dotfiles/zsh-core/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
  zsh_syntax_highlighting="$HOME/.dotfiles/zsh-core/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

  aliases_maps[u]='pkg update -y && pkg upgrade -y'
  aliases_maps[i]='pkg install -y'
  aliases_maps[r]='pkg uninstall -y'
elif [[ -f "/etc/arch-release" ]]; then
  zsh_autosuggestions='/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
  zsh_syntax_highlighting='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
else
  zsh_autosuggestions="$HOME/.dotfiles/zsh-core/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
  zsh_syntax_highlighting="$HOME/.dotfiles/zsh-core/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

[ -f "$zsh_autosuggestions" ] && source "$zsh_autosuggestions"
[ -f "$zsh_syntax_highlighting" ] && source "$zsh_syntax_highlighting"

zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git

setopt prompt_subst
eval "$(zoxide init zsh --cmd cd)"
setopt AUTO_CD

PROMPT=$'%F{blue}%~%f${vcs_info_msg_0_}\n%(#.%F{red}.%F{yellow}$)%f '

for k v in ${(kv)aliases_maps}; do
  alias $k="$v"
done
# End of lines added by compinstall
