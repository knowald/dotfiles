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
echo "[2/6] Installing Homebrew packages from Brewfile..."
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    brew bundle install --file="$DOTFILES_DIR/Brewfile" || true
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
mkdir -p "$HOME/.claude"

symlink() {
    local src="$1"
    local dest="$2"
    local name="$(basename $dest)"

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" = "$src" ]; then
            echo "  $name: already linked"
        else
            echo "  $name: repointing link"
            ln -sfn "$src" "$dest"
        fi
    elif [ -e "$dest" ]; then
        echo "  $name: backing up and linking"
        mv "$dest" "$BACKUP_DIR/${name}.bak.$(date +%s)"
        ln -sfn "$src" "$dest"
    else
        echo "  $name: linking"
        ln -sfn "$src" "$dest"
    fi
}

symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
symlink "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
symlink "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty"
symlink "$DOTFILES_DIR/.config/pgcli" "$HOME/.config/pgcli"
symlink "$DOTFILES_DIR/.hammerspoon" "$HOME/.hammerspoon"
symlink "$DOTFILES_DIR/.claude/notify.sh" "$HOME/.claude/notify.sh"
symlink "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"

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

# Set default shell to zsh (optional; never abort setup)
zsh_path="$(command -v zsh)"
if [ -n "$zsh_path" ] && [ "$SHELL" != "$zsh_path" ]; then
    echo "  Setting zsh as default shell..."
    grep -qxF "$zsh_path" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    chsh -s "$zsh_path" || echo "  Could not change shell; run 'chsh -s $zsh_path' manually."
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
echo "  4. (optional) Apply macOS system defaults: ./macos_defaults.sh"
echo "  5. (optional) Enable git hooks: pre-commit install"
echo ""
echo "Backups stored in: $BACKUP_DIR"
