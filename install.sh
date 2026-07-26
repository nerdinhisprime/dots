#!/usr/bin/env bash

BASE_PKGS=(zsh git curl openssh neovim tmux zoxide fastfetch stow eza)
ARCH_PKGS=(bemenu niri foot alacritty pcmanfm yazi zsh-autosuggestions zsh-syntax-highlighting openh264 docker docker-compose waybar cliphist fzf awww bluetui impala pulsemixer brightnessctl btop)
FONT_PKGS=(noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-dejavu ttf-liberation)
SIMLINKS=(zsh-core user-dirs tmux niri alacritty waybar mako bin fonts)

C_RESET="\033[0m"
C_BOLD="\033[1m"
C_RED="\033[1;31m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_BLUE="\033[1;34m"
C_MAGENTA="\033[1;35m"
C_CYAN="\033[1;36m"

print_info() {
    echo -e "${C_CYAN}==>${C_RESET} ${C_BOLD}$1${C_RESET}"
}

print_success() {
    echo -e "${C_GREEN}==>${C_RESET} ${C_BOLD}$1${C_RESET}"
}

print_error() {
    echo -e "${C_RED}==>${C_RESET} ${C_BOLD}$1${C_RESET}"
}


DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    print_error "Directory .dotfiles wasn't found: $DOTFILES_DIR"
    exit 1
fi

cd "$DOTFILES_DIR" || exit 1

print_info "Updating and installing packages..."
sudo pacman -Syu --needed --noconfirm "${BASE_PKGS[@]}" "${ARCH_PKGS[@]}" "${FONT_PKGS[@]}"


print_info "Creating directories and creating simlinks with stow..."
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/bin
mkdir -p ~/.config
stow "${SIMLINKS[@]}"
git clone https://github.com/nerdinhisprime/nvim "$HOME/.config"

print_info "Getting permissions for scripts from ~/.local/bin..."
chmod +x ~/.local/bin/* 2>/dev/null || true

print_info "Update fonts cache..."
fc-cache -fv

print_info "Set wallpaper..."
awww-daemon &
# sleep 1
awww img "$DOTFILES_DIR/img/ascii/ascii.png"

print_info "Installing yay и AUR-packages..."
TMP_YAY="/tmp/yay-bin"
rm -rf "$TMP_YAY"
git clone https://aur.archlinux.org/yay-bin.git "$TMP_YAY"
cd "$TMP_YAY" && makepkg -si --noconfirm
cd "$DOTFILES_DIR"

yay -S --noconfirm ungoogled-chromium-bin librewolf-bin

print_info "Docker setup..."
sudo systemctl enable --now docker.service
sudo usermod -aG docker "$USER"

print_info "Set zsh as a default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

print_success "Installing and configuration completed successfully!"
