#!/bin/bash
#
# This script is designed to bootstrap a Coder workspace with the nix-config dotfiles.
# Coder will automatically execute this script when setting up a new workspace with
# this repository configured as the dotfiles source.
#
# It can also be used manually to install the configuration on any Linux system.

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect the current user
CURRENT_USER="${USER:-$(whoami)}"
log_info "Installing dotfiles for user: $CURRENT_USER"

# Detect system architecture
ARCH=$(uname -m)
log_info "Detected architecture: $ARCH"

# Check if we're in a Coder environment
if [ -n "$CODER" ] || [ -n "$CODER_WORKSPACE_NAME" ]; then
    log_info "Detected Coder environment"
    IN_CODER=true
else
    IN_CODER=false
    log_info "Not in a Coder environment, proceeding with standard installation"
fi

# Check if Nix is already installed
if command -v nix >/dev/null 2>&1; then
    log_info "Nix is already installed"
else
    log_info "Installing Nix..."
    
    # Install Nix in single-user mode (no daemon)
    curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
    
    # Source nix profile
    if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
fi

# Ensure nix is available in PATH
if ! command -v nix >/dev/null 2>&1; then
    log_info "Sourcing Nix profile..."
    if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
fi

# Enable flakes and nix-command
log_info "Configuring Nix with flakes support..."
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf

# Get the directory where this script is located (the dotfiles repo)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log_info "Dotfiles directory: $DOTFILES_DIR"

# Backup existing shell configs if they exist
for file in ~/.bashrc ~/.profile ~/.zshrc; do
    if [ -f "$file" ] && [ ! -L "$file" ]; then
        log_warn "Backing up existing $file to ${file}.backup"
        mv "$file" "${file}.backup"
    fi
done

# Determine which flake to use based on environment
FLAKE_PATH="${DOTFILES_DIR}/flakes/coder"

# Check if home-manager is available
log_info "Installing home-manager configuration..."
if nix run nixpkgs#home-manager -- switch --flake "${FLAKE_PATH}"; then
    log_info "Home-manager configuration applied successfully!"
else
    log_error "Failed to apply home-manager configuration"
    log_info "You can try running it manually with:"
    log_info "  nix run nixpkgs#home-manager -- switch --flake ${FLAKE_PATH}"
    exit 1
fi

log_info "Installation complete!"
log_info ""
log_info "You may need to restart your shell or source your profile:"
log_info "  source ~/.bashrc  # or ~/.zshrc"
log_info ""
log_info "If you installed Nix for the first time, you may need to log out and back in"
log_info "for all environment changes to take effect."
