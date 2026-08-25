# Dotfiles

Personal development environment configuration for macOS. Built for a zsh + tmux + neovim workflow.

## Quick Start

```bash
# Clone the repo
git clone git@github.com:yourusername/dotfiles.git ~/dotfiles

# Install Homebrew packages (formulae + casks via Brewfile)
brew bundle install --file=~/dotfiles/Brewfile

# Symlink configs
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global
ln -sf ~/dotfiles/.markdownlint.jsonc ~/.markdownlint.jsonc
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/ghostty ~/.config/ghostty
ln -sf ~/dotfiles/.config/pgcli ~/.config/pgcli
ln -sf ~/dotfiles/.ssh/config ~/.ssh/config
mkdir -p ~/.claude
ln -sf ~/dotfiles/.claude/notify.sh ~/.claude/notify.sh
ln -sf ~/dotfiles/.claude/settings.json ~/.claude/settings.json

# Set up local configs (machine-specific, not tracked)
cp ~/dotfiles/.zshrc.local.example ~/.zshrc.local
cp ~/dotfiles/.ssh/config.local.example ~/.ssh/config.local
chmod 600 ~/.ssh/config.local
# Edit these with your SSH keys, hosts, paths

# Set up secrets (API tokens, passwords - not tracked)
cp ~/dotfiles/.secrets.example ~/.secrets
chmod 600 ~/.secrets
# Edit ~/.secrets with your actual values
```

### File Structure

The repo uses a `.local` pattern to separate shareable configs from machine-specific settings:

| File | Tracked | Purpose |
|------|---------|---------|
| `.zshrc` | Yes | Generic shell config |
| `.zshrc.local` | No | SSH keys, personal paths, project aliases |
| `.ssh/config` | Yes | Generic SSH settings |
| `.ssh/config.local` | No | Host definitions with real IPs |
| `.secrets` | No | API tokens, passwords |

---

## Shell (Zsh)

**Config:** `.zshrc`

### Framework & Plugins

- [oh-my-zsh](https://ohmyz.sh/) - Zsh framework
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - Fish-like suggestions
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - Command highlighting
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) - Better history search
- [fzf-tab](https://github.com/Aloxaf/fzf-tab) - Fuzzy completion

### Key Aliases

| Alias    | Command                | Description                       |
| -------- | ---------------------- | --------------------------------- |
| `j`      | `zoxide`               | Smart directory jumping           |
| `vim`    | `nvim`                 | Neovim                            |
| `lzg`    | `lazygit`              | Git TUI                           |
| `lzd`    | `lazydocker`           | Docker TUI                        |
| `dce`    | `docker compose exec`  | Docker exec shortcut              |
| `dcu`    | `docker compose up`    | Docker up shortcut                |
| `gpoh`   | `git push origin HEAD` | Quick push                        |
| `glopen` | -                      | Open git remote in browser        |
| `n`      | `nvim .`               | Open nvim in current dir          |
| `tks`    | `tmux kill-server`     | Kill tmux                         |
| `tw`     | -                      | Rename tmux window to current dir |
| `ask`    | `claude -p` (function) | Quick Claude prompt (no quotes)   |

### Custom Functions

- `ask` - Quick Claude prompt: `ask how to say hello in polish`
- `base64pbcopy` - Base64 encode file to clipboard
- `gitstrip` / `gitstripstdin` - Convert git SSH URLs to HTTPS
- `generate-password` - 32-char alphanumeric password
- `generate-deploy-keys` - ed25519 deploy keys per project/environment
- `glpipe` - Open the most recent GitLab pipeline in the browser
- `gtoi` - `glab opentofu init` for the current repo and given environment
- `nvm` / `node` / `npm` / `npx` - Shims that lazy-load nvm on first use

---

## Terminal Multiplexer (Tmux)

**Config:** `.tmux.conf`

### Keybindings

| Key                     | Action                             |
| ----------------------- | ---------------------------------- |
| `Ctrl-a`                | Prefix (instead of Ctrl-b)         |
| `Ctrl-a c`              | New window (in current path)       |
| `Ctrl-a "`              | Split horizontal (in current path) |
| `Ctrl-a %`              | Split vertical (in current path)   |
| `Ctrl-Shift-Left/Right` | Reorder windows                    |
| `Ctrl-a h/j/k/l`        | Navigate panes                     |
| `Ctrl-a n/p`            | Next/previous window               |
| `Ctrl-a S`              | Send pane to window (prompt)       |
| `Ctrl-a J`              | Join marked pane to current window |
| `Ctrl-a m`              | Mark pane (built-in)               |
| `Ctrl-a M`              | Clear mark (built-in)              |

### Features

- Mouse support enabled
- Windows/panes start at index 1
- 50,000 line history
- GitHub-inspired color theme
- Auto-renumber windows
- Bell notifications: windows with activity highlight in red (passthrough enabled for terminal notifications)

---

## Editor (Neovim)

**Config:** `.config/nvim/`

Built on [LazyVim](https://www.lazyvim.org/) distribution.

### Theme

- [OneDark](https://github.com/navarasu/onedark.nvim) (deep variant)

### Key Plugins

| Plugin            | Purpose               |
| ----------------- | --------------------- |
| `lazy.nvim`       | Plugin manager        |
| `neo-tree.nvim`   | File explorer         |
| `fzf-lua`         | Fuzzy finder          |
| `gitsigns.nvim`   | Git integration       |
| `git-blame.nvim`  | Inline git blame      |
| `mason.nvim`      | LSP installer         |
| `nvim-treesitter` | Syntax highlighting   |
| `trouble.nvim`    | Diagnostics list      |
| `which-key.nvim`  | Keybinding hints      |
| `bufferline.nvim` | Buffer tabs           |
| `lualine.nvim`    | Status line           |
| `vim-abolish`     | Smart substitution    |
| `vim-surround`    | Surround text objects |

### Custom Keymaps

- `d` deletes without yanking (use `x` to cut)
- `Ctrl-k/j` increment/decrement numbers
- `<leader>go` open file in git browser

---

## Terminal Emulator (Ghostty)

**Config:** `.config/ghostty/config`

- **Theme:** Dracula
- **Font:** FiraCode Nerd Font Mono
- **Features:**
  - Option as Alt key (macOS)
  - Reduced scroll speed

---

## Git

**Config:** `.gitconfig`

- **Pager:** [delta](https://github.com/dandavison/delta) - Syntax-highlighted diffs
- **Merge style:** diff3 (shows base)
- **Color moved:** enabled
- **Global ignore:** `.gitignore_global` via `core.excludesFile` - macOS, editor, and Claude artifacts ignored in every repo. This repo intentionally tracks `.claude/notify.sh` and `.claude/settings.json` (already committed); any new `.claude/` file needs `git add -f`.

---

## Database (pgcli)

**Config:** `.config/pgcli/config`

PostgreSQL CLI with:

- Smart auto-completion
- Syntax highlighting
- Destructive command warnings
- 1000 row limit
- Keyring password storage

---

## SSH

**Config:** `.ssh/config`

Host aliases for quick access (defined in `~/.ssh/config.local`):

```bash
ssh prod          # instead of ssh root@x.x.x.x
ssh staging       # project shortcuts
```

---

## Tasks (just)

Common operations are wrapped in a `justfile`. Run `just` to list them.

| Recipe          | Action                                              |
| --------------- | --------------------------------------------------- |
| `just setup`    | Full machine setup (runs `macos_setup.sh`)          |
| `just brew-install` | Install everything in the `Brewfile`            |
| `just brew-diff`    | Show drift between installed packages and `Brewfile` |
| `just update`   | Update and upgrade brew packages                    |
| `just defaults` | Apply macOS system defaults (`macos_defaults.sh`)   |
| `just lint`     | Run pre-commit hooks (shellcheck + secret scan)     |

### Pre-commit

`pre-commit install` enables hooks that run on every commit: shellcheck on the
shell scripts, [gitleaks](https://github.com/gitleaks/gitleaks) to block
accidental secret commits, and basic file hygiene. Config in
`.pre-commit-config.yaml`.

---

## Homebrew Packages

All formulae and casks live in the [`Brewfile`](Brewfile) (`brew bundle`).
The file is a snapshot of what is installed on the machine: regenerate it
with `brew bundle dump --no-vscode`, prune anything unwanted, and commit.
Use `just brew-diff` to see what is installed but untracked.

### Manual Install

| App | Description |
|-----|-------------|
| [Wally](https://ergodox-ez.com/pages/wally) | ZSA keyboard firmware tool (not in Homebrew)

---

## Secrets & Local Configuration

This repo uses a `.local` pattern to keep sensitive/machine-specific data out of version control:

| File | Template | Contains |
|------|----------|----------|
| `~/.secrets` | `.secrets.example` | API tokens, passwords |
| `~/.zshrc.local` | `.zshrc.local.example` | SSH keys, personal paths, project aliases |
| `~/.ssh/config.local` | `.ssh/config.local.example` | Host definitions with real IPs |

```bash
# Set up local files from templates
cp .secrets.example ~/.secrets && chmod 600 ~/.secrets
cp .zshrc.local.example ~/.zshrc.local
cp .ssh/config.local.example ~/.ssh/config.local && chmod 600 ~/.ssh/config.local

# Edit each with your values
nvim ~/.secrets ~/.zshrc.local ~/.ssh/config.local
```

---

## Hammerspoon

**Config:** `.hammerspoon/`

Lua-based macOS automation:

- `lgtv` - LG TV control integration

---

## Claude Code

**Config:** `.claude/`

[Claude Code](https://claude.ai/claude-code) CLI configuration with smart notifications.

### Features

- **Always thinking** enabled for extended reasoning
- **Notification hooks** - alerts when Claude needs input or completes a task
- **Smart notification suppression** - no alerts when actively viewing the tmux pane
- **Terminal bell integration** - tmux status bar highlights on activity (works with tmux bell settings above)

### Hooks

| Event | Sound | Trigger |
|-------|-------|---------|
| Notification | Ping | Claude needs your input |
| Stop | Funk | Task completed |

### Dependencies

- `terminal-notifier` - macOS notifications (`brew install terminal-notifier`)

---

## File Structure

```
dotfiles/
├── .claude/                 # Claude Code config & hooks
├── .config/
│   ├── ghostty/             # Terminal config
│   ├── nvim/                # Neovim (LazyVim)
│   └── pgcli/               # PostgreSQL CLI
├── .github/workflows/       # CI (pre-commit + Brewfile parse check)
├── .hammerspoon/            # macOS automation
├── .ssh/
│   ├── config               # Generic SSH settings (tracked)
│   └── config.local.example # Template for hosts (tracked)
├── .editorconfig            # Editor formatting rules
├── .gitconfig               # Git config
├── .gitconfig.local.example # Template for git identity (tracked)
├── .gitignore               # Repo ignores
├── .gitignore_global        # Global ignore (core.excludesFile)
├── .markdownlint.jsonc      # Markdown lint rules
├── .pre-commit-config.yaml  # Lint + secret-scan hooks
├── .secrets.example         # Secrets template
├── .shellcheckrc            # ShellCheck config
├── .tmux.conf               # Tmux config
├── .zshrc                   # Shell config (tracked)
├── .zshrc.local.example     # Template for local settings (tracked)
├── Brewfile                 # Brew formulae + casks snapshot (brew bundle)
├── justfile                 # Task runner recipes
├── macos_setup.sh           # Full setup script
├── macos_defaults.sh        # macOS system defaults (opt-in)
├── export_local.sh          # Export local configs for migration
├── import_local.sh          # Import local configs on new machine
└── README.md                # This file

# Not tracked (create from .example files):
~/.zshrc.local               # SSH keys, personal paths
~/.ssh/config.local          # Host definitions with IPs
~/.secrets                   # API tokens, passwords
```

---

## New Machine Setup

1. Install Xcode CLI tools: `xcode-select --install`
2. Install Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Clone this repo: `git clone git@github.com:yourusername/dotfiles.git ~/dotfiles`
4. Run setup: `cd ~/dotfiles && ./macos_setup.sh`
5. Import local configs (see below) or customize from `.example` files
6. Restart terminal or `source ~/.zshrc`

---

## Migrating Local Configs

Transfer your local configs (secrets, SSH hosts, etc.) between machines. Archives are encrypted with [age](https://github.com/FiloSottile/age) using a passphrase.

### On the old machine

```bash
cd ~/dotfiles
./export_local.sh
# Enter a passphrase when prompted
# Creates: ~/dotfiles_local_YYYYMMDD_HHMMSS.tar.gz.age
```

### Transfer the archive

```bash
# Via SSH
scp ~/dotfiles_local_*.tar.gz.age newmachine:~/

# Or via AirDrop, USB, etc. (encrypted, safe to transfer)
```

### On the new machine

```bash
# After running macos_setup.sh
cd ~/dotfiles
./import_local.sh ~/dotfiles_local_*.tar.gz.age
# Enter the same passphrase

# Delete the archive
rm ~/dotfiles_local_*.tar.gz.age
```

### What's included

| File | Contents |
|------|----------|
| `.secrets` | API tokens, passwords |
| `.zshrc.local` | SSH keys to load, personal paths |
| `.ssh/config.local` | SSH host definitions |
| `.gitconfig.local` | Git name/email |
