# Lines configured by zsh-newuser-install
fastfetch
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob notify
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/nerd/.zshrc'

autoload -Uz compinit
compinit

if [[ -d "/data/data/com.termux" ]]; then
  zsh_autosuggestions='~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
  zsh_syntax_highlighting='~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

  u='pkg update -y && pkg upgrade -y'
  i='pkg install -y'
  r='pkg uninstall -y'
elif [[ -f "/etc/arch-release" ]]; then
  zsh_autosuggestions='/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
  zsh_syntax_highlighing='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

  u='sudo pacman -Syu'
  i='sudo pacman -S'
  r='sudo pacman -Rns'
  alias sshstart='eval $(ssh-agent -s) && ssh-add ~/.ssh/id_ed25519'
  alias ts='ts-node'
fi

source $zsh_autosuggestions
source $zsh_syntax_highlighing

zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git

setopt prompt_subst
eval "$(zoxide init zsh --cmd cd)"
setopt AUTO_CD

PROMPT=$'%F{blue}%~%f${vcs_info_msg_0_}\n%(#.%F{red}.%F{yellow}$)%f '

alias ls='clear; eza --group-directories-first --icons'
alias la='clear; eza -a --group-directories-first --icons'
alias lt='clear; eza --group-directories-last --tree --level 2 --icons'
alias lta='clear; eza -a --group-directories-last --tree --level 2 --icons'
alias n='nvim'
alias t='tmux'
alias dd='../'
alias u=$u
alias i=$i
alias r=$r
# End of lines added by compinstall
