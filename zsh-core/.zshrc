# Lines configured by zsh-newuser-install
if command -v ascii-image-converter &> /dev/null; then
  ascii-image-converter "$HOME/.dotfiles/img/ascii/ascii.png" -W 110 -C
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


typeset -A aliases_maps

zsh_autosuggestions='/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
zsh_syntax_highlighting='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

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

# Created by `pipx` on 2026-07-27 11:07:07
export PATH="$PATH:/home/nerd/.local/bin"
