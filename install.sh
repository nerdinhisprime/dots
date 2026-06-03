#!/usr/bin/env bash

BASE_PKGS=(zsh git curl openssh neovim tmux zoxide fastfetch stow eza)
BASE_SIMLINKS=(zsh-core user-dirs tmux)

detect_host() {
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

  if [ -f /etc/os-release ] && grep -qqi "id=arch" /etc/os-release; then
    ENV="arch"
    return
  fi

  ENV="unknown"
}

install_zsh_plugins() {
  PLUGINS_DIR="$HOME/.dotfiles/zsh-core/.zsh_plugins"
  mkdir -p "$PLUGINS_DIR"

  if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
      git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
  fi

  if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
      git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGINS_DIR/zsh-syntax-highlighting"
  fi

  ZSHRC="$HOME/.zshrc"
  touch "$ZSHRC"

  if ! grep -q "zsh-autosuggestions.zsh" "$ZSHRC"; then
      echo "source $PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$ZSHRC"
  fi

  if ! grep -q "zsh-syntax-highlighting.zsh" "$ZSHRC"; then
      echo "source $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$ZSHRC"
  fi
}

detect_host

cd "$HOME/.dotfiles" || exit 1

case "$ENV" in
  "arch")
    sudo pacman -Syu --needed --noconfirm "${BASE_PKGS[@]}" niri foot ascii-image-converter
    install_zsh_plugins
    stow "${BASE_SIMLINKS[@]}" zsh-desktop niri foot
    ;;
  "wsl-ubuntu")
    sudo apt update && sudo apt upgrade -y && sudo apt install -y --no-install-recommends git curl build-essential

    if ! command -v brew &> /dev/null && [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    brew install "${BASE_PKGS[@]}"
    install_zsh_plugins
    stow "${BASE_SIMLINKS[@]}"
    ;;
  "termux")
    pkg update -y && pkg upgrade -y && pkg install -y "${BASE_PKGS[@]}"
    install_zsh_plugins
    rm -f "$HOME/.zsh*" "$HOME/.tmux.conf"
    stow "${BASE_SIMLINKS[@]}"
    ;;
  *)
    echo "иди к черту"
    exit 1
    ;;
esac

