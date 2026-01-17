#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.config_backup"

echo "=== macOS Dotfiles Setup ==="
echo ""

# Check if running from correct directory
if [ ! -f "$DOTFILES_DIR/macos_setup.sh" ]; then
    echo "Error: Please clone dotfiles to ~/dotfiles first"
    echo "  git clone <your-repo> ~/dotfiles"
    exit 1
fi

# ===================
# Homebrew
# ===================
echo "[1/6] Checking Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to path for Apple Silicon
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

# ===================
# Brew Packages
# ===================
echo ""
echo "[2/6] Installing Homebrew packages..."
if [ -f "$DOTFILES_DIR/brew_leaves.txt" ]; then
    xargs brew install < "$DOTFILES_DIR/brew_leaves.txt" || true
fi

if [ -f "$DOTFILES_DIR/brew_casks.txt" ]; then
    xargs brew install --cask < "$DOTFILES_DIR/brew_casks.txt" || true
fi

# ===================
# Oh My Zsh
# ===================
echo ""
echo "[3/6] Setting up Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

# Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    echo "Installing zsh-history-substring-search..."
    git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]; then
    echo "Installing fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"
fi

# ===================
# Symlinks
# ===================
echo ""
echo "[4/6] Creating symlinks..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.ssh"

symlink() {
    local src="$1"
    local dest="$2"
    local name="$(basename $dest)"

    if [ -L "$dest" ]; then
        echo "  $name: already linked"
    elif [ -e "$dest" ]; then
        echo "  $name: backing up and linking"
        mv "$dest" "$BACKUP_DIR/${name}.bak.$(date +%s)"
        ln -sf "$src" "$dest"
    else
        echo "  $name: linking"
        ln -sf "$src" "$dest"
    fi
}

symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
symlink "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
symlink "$DOTFILES_DIR/.config/alacritty" "$HOME/.config/alacritty"
symlink "$DOTFILES_DIR/.config/pgcli" "$HOME/.config/pgcli"
symlink "$DOTFILES_DIR/.hammerspoon" "$HOME/.hammerspoon"

# ===================
# Local configs (not tracked)
# ===================
echo ""
echo "[5/6] Setting up local configs..."

setup_local() {
    local template="$1"
    local dest="$2"
    local name="$(basename $dest)"

    if [ ! -f "$dest" ]; then
        echo "  Creating $name from template..."
        cp "$template" "$dest"
        chmod 600 "$dest"
    else
        echo "  $name already exists"
    fi
}

setup_local "$DOTFILES_DIR/.secrets.example" "$HOME/.secrets"
setup_local "$DOTFILES_DIR/.zshrc.local.example" "$HOME/.zshrc.local"
setup_local "$DOTFILES_DIR/.ssh/config.local.example" "$HOME/.ssh/config.local"
setup_local "$DOTFILES_DIR/.gitconfig.local.example" "$HOME/.gitconfig.local"

echo ""
echo "  ⚠️  Edit these files with your actual values:"
echo "     ~/.secrets         - API tokens, passwords"
echo "     ~/.zshrc.local     - SSH keys, personal paths"
echo "     ~/.ssh/config.local - SSH host definitions"
echo "     ~/.gitconfig.local  - Git name/email"

# ===================
# Post-install
# ===================
echo ""
echo "[6/6] Post-install tasks..."

# fzf keybindings
if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    echo "  Installing fzf keybindings..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# Set default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "  Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi

# ===================
# Done
# ===================
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Edit ~/.secrets with your API keys and passwords"
echo "  2. Restart your terminal or run: source ~/.zshrc"
echo "  3. Open nvim and run :Lazy to install plugins"
echo ""
echo "Backups stored in: $BACKUP_DIR"
