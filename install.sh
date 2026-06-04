#!/usr/bin/env bash

BASE_PKGS=(zsh git curl openssh neovim tmux zoxide fastfetch stow eza)
ARCH_PKGS=(bemenu niri foot zsh-autosuggestions zsh-syntax-highlighting)
UBUNTU_PKGS=(git curl build-essential zsh-syntax-highlighting zsh-autosuggestions)
BASE_SIMLINKS=(zsh-core user-dirs tmux)

detect_host() {
  if [ -f /etc/os-release ] && grep -qqi "id=arch" /etc/os-release; then
    ENV="arch"
    return
  fi

  if [ -n "$TERMUX_VERSION" ] || [ -d "/data/data/com.termux" ]; then
    ENV="termux"
    return
  fi

  if grep -qqi "microsoft" /proc/version || grep -qqi "wsl" /proc/version; then
    if grep -qqi "ubuntu" /etc/os-release; then
      ENV="wsl-ubuntu"
    else
      ENV="wsl-generic"
    fi
    return
  fi
  ENV="unknown"
}

install_zsh_plugins() {
  if [[ $1 == 'termux' ]]; then
    mkdir -p $PREFIX/share/zsh-autosuggestions
    mkdir -p $PREFIX/share/zsh-syntax-highlighting

    git clone https://github.com/zsh-users/zsh-autosuggestions $PREFIX/share/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $PREFIX/share/zsh-syntax-highlighting
  fi
}

detect_host

cd "$HOME/.dotfiles" || exit 1

case "$ENV" in
  "arch")
    sudo pacman -Syu --needed --noconfirm "${BASE_PKGS[@]}" "${ARCH_PKGS[@]}"
    stow "${BASE_SIMLINKS[@]}" niri foot
    ;;
  "termux")
    pkg update -y && pkg upgrade -y && pkg install -y "${BASE_PKGS[@]}"
    install_zsh_plugins termux
    stow "${BASE_SIMLINKS[@]}"
    ;;
  "wsl-ubuntu")
    sudo apt update && sudo apt upgrade -y && sudo apt install -y --no-install-recommends "${UBUNTU_PKGS[@]}"

    if ! command -v brew &> /dev/null && [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    brew install "${BASE_PKGS[@]}"
    stow "${BASE_SIMLINKS[@]}"
    ;;
  *)
    echo "иди к черту"
    exit 1
    ;;
esac
