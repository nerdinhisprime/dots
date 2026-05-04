# Lines configured by zsh-newuser-install
fastfetch
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob notify
unsetopt beep nomatch
bindkey -e

autoload -Uz compinit
compinit

source "$HOME/dots/aliases.list"

if [[ -d "/data/data/com.termux" ]]; then
  zsh_autosuggestions='~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
  zsh_syntax_highlighting='~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

  aliases_maps[u]='pkg update -y && pkg upgrade -y'
  aliases_maps[i]='pkg install -y'
  aliases_maps[r]='pkg uninstall -y'
elif [[ -f "/etc/arch-release" ]]; then
  zsh_autosuggestions='/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
  zsh_syntax_highlighing='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
fi

source $zsh_autosuggestions
source $zsh_syntax_highlighing

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
