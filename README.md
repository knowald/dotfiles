# Dotfiles

Personal development environment configuration for macOS. Built for a zsh + tmux + neovim workflow.

## Quick Start

```bash
# Clone the repo
git clone git@github.com:yourusername/dotfiles.git ~/dotfiles

# Install Homebrew packages
xargs brew install < ~/dotfiles/brew_leaves.txt
xargs brew install --cask < ~/dotfiles/brew_casks.txt

# Symlink configs
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/.config/pgcli ~/.config/pgcli
ln -sf ~/dotfiles/.ssh/config ~/.ssh/config

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

## Terminal Emulator (Alacritty)

**Config:** `.config/alacritty/alacritty.toml`

- **Theme:** Dracula
- **Font:** FiraCode Nerd Font Mono
- **Features:**
  - Option as Alt key (macOS)
  - Word jumping with Alt+Arrow
  - Line delete with Cmd+Backspace

---

## Git

**Config:** `.gitconfig`

- **Pager:** [delta](https://github.com/dandavison/delta) - Syntax-highlighted diffs
- **Merge style:** diff3 (shows base)
- **Color moved:** enabled

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

## Homebrew Packages

### CLI Essentials

| Tool      | Description                       |
| --------- | --------------------------------- |
| `bat`     | Cat with syntax highlighting      |
| `eza`     | Modern ls replacement             |
| `lsd`     | LSDeluxe - another ls replacement |
| `fd`      | Fast find alternative             |
| `ripgrep` | Fast grep alternative             |
| `fzf`     | Fuzzy finder                      |
| `zoxide`  | Smart cd                          |
| `tldr`    | Simplified man pages              |
| `jq`      | JSON processor                    |
| `yq`      | YAML processor                    |

### Development

| Tool         | Description          |
| ------------ | -------------------- |
| `neovim`     | Editor               |
| `tmux`       | Terminal multiplexer |
| `lazygit`    | Git TUI              |
| `lazydocker` | Docker TUI           |
| `git-delta`  | Better git diffs     |
| `gh`         | GitHub CLI           |
| `just`       | Command runner       |
| `pre-commit` | Git hooks framework  |

### Languages & Runtimes

| Tool     | Description                  |
| -------- | ---------------------------- |
| `rbenv`  | Ruby version manager         |
| `node`   | Node.js                      |
| `pnpm`   | Fast npm alternative         |
| `go`     | Golang                       |
| `poetry` | Python dependency management |
| `pipx`   | Python CLI tools             |

### Infrastructure & DevOps

| Tool        | Description                |
| ----------- | -------------------------- |
| `terraform` | Infrastructure as code     |
| `opentofu`  | Terraform fork             |
| `ansible`   | Configuration management   |
| `kubectl`   | Kubernetes CLI             |
| `k9s`       | Kubernetes TUI             |
| `helm`      | Kubernetes package manager |
| `kamal`     | Rails deployment           |
| `docker`    | Containers                 |
| `dive`      | Docker image explorer      |

### Cloud CLIs

| Tool     | Description                      |
| -------- | -------------------------------- |
| `hcloud` | Hetzner Cloud (in history)       |
| `aws`    | Amazon Web Services (in history) |
| `gcloud` | Google Cloud (in history)        |
| `heroku` | Heroku CLI                       |

### Security & Networking

| Tool         | Description                  |
| ------------ | ---------------------------- |
| `sops`       | Encrypted secrets            |
| `age`        | Encryption tool              |
| `trufflehog` | Secrets scanner              |
| `wpscan`     | WordPress scanner            |
| `mitmproxy`  | HTTP proxy                   |
| `dog`        | DNS lookup                   |
| `httpstat`   | HTTP timing                  |
| `nmap`       | Network scanner (in history) |

### Media & Misc

| Tool        | Description         |
| ----------- | ------------------- |
| `ffmpeg`    | Video processing    |
| `yt-dlp`    | Video downloader    |
| `silicon`   | Code screenshots    |
| `asciinema` | Terminal recording  |
| `tokei`     | Code statistics     |
| `ncdu`      | Disk usage analyzer |

---

## macOS Apps (Casks)

### Productivity

| Cask | App | Description |
|------|-----|-------------|
| `raycast` | [Raycast](https://raycast.com/) | Spotlight replacement |
| `rectangle` | [Rectangle](https://rectangleapp.com/) | Window management |
| `alt-tab` | [AltTab](https://alt-tab-macos.netlify.app/) | Windows-style alt-tab |
| `maccy` | [Maccy](https://maccy.app/) | Clipboard manager |
| `hazeover` | [HazeOver](https://hazeover.com/) | Distraction dimmer |
| `obsidian` | [Obsidian](https://obsidian.md/) | Note-taking |

### Development

| Cask | App | Description |
|------|-----|-------------|
| `alacritty` | [Alacritty](https://alacritty.org/) | GPU terminal |
| `cursor` | [Cursor](https://cursor.sh/) | AI code editor |
| `zed` | [Zed](https://zed.dev/) | Fast code editor |
| `docker` | [Docker](https://www.docker.com/) | Containers |
| `beekeeper-studio` | [Beekeeper Studio](https://www.beekeeperstudio.io/) | Database GUI |
| `bruno` | [Bruno](https://www.usebruno.com/) | API client |
| `charles` | [Charles](https://www.charlesproxy.com/) | HTTP proxy/debugger |

### System & Utilities

| Cask | App | Description |
|------|-----|-------------|
| `stats` | [Stats](https://github.com/exelban/stats) | Menu bar system monitor |
| `monitorcontrol` | [MonitorControl](https://github.com/MonitorControl/MonitorControl) | External display brightness |
| `betterdisplay` | [BetterDisplay](https://github.com/waydabber/BetterDisplay) | Display management |
| `linearmouse` | [LinearMouse](https://linearmouse.app/) | Mouse customization |
| `hammerspoon` | [Hammerspoon](https://www.hammerspoon.org/) | macOS automation |
| `the-unarchiver` | [The Unarchiver](https://theunarchiver.com/) | Archive extraction |
| `keka` | [Keka](https://www.keka.io/) | File archiver |
| `balenaetcher` | [balenaEtcher](https://etcher.balena.io/) | USB flasher |
| `flameshot` | [Flameshot](https://flameshot.org/) | Screenshots |

### Media

| Cask | App | Description |
|------|-----|-------------|
| `iina` | [IINA](https://iina.io/) | Video player |
| `vlc` | [VLC](https://www.videolan.org/) | Media player |
| `spotify` | [Spotify](https://www.spotify.com/) | Music |
| `obs` | [OBS](https://obsproject.com/) | Streaming/recording |
| `cog` | [Cog](https://cog.losno.co/) | Audio player |
| `eqmac` | [eqMac](https://eqmac.app/) | System equalizer |
| `audacity` | [Audacity](https://www.audacityteam.org/) | Audio editor |
| `calibre` | [Calibre](https://calibre-ebook.com/) | E-book manager |

### Communication

| Cask | App | Description |
|------|-----|-------------|
| `telegram` | [Telegram](https://telegram.org/) | Messaging |
| `signal` | [Signal](https://signal.org/) | Secure messaging |

### Browsers

| Cask | App | Description |
|------|-----|-------------|
| `google-chrome` | [Google Chrome](https://www.google.com/chrome/) | Chrome browser |
| `firefox` | [Firefox](https://www.mozilla.org/firefox/) | Firefox browser |

### Security & Network

| Cask | App | Description |
|------|-----|-------------|
| `bitwarden` | [Bitwarden](https://bitwarden.com/) | Password manager |
| `nordvpn` | [NordVPN](https://nordvpn.com/) | VPN |
| `wireshark` | [Wireshark](https://www.wireshark.org/) | Network analyzer |
| `cyberduck` | [Cyberduck](https://cyberduck.io/) | FTP/cloud client |
| `ngrok` | [ngrok](https://ngrok.com/) | Localhost tunneling |

### Other

| Cask | App | Description |
|------|-----|-------------|
| `anki` | [Anki](https://apps.ankiweb.net/) | Flashcards |
| `flux` | [f.lux](https://justgetflux.com/) | Blue light filter |
| `stretchly` | [Stretchly](https://hovancik.net/stretchly/) | Break reminder |
| `qbittorrent` | [qBittorrent](https://www.qbittorrent.org/) | Torrent client |
| `bambu-studio` | [Bambu Studio](https://bambulab.com/en/download/studio) | 3D printing slicer |
| `coolterm` | [CoolTerm](https://freeware.the-meiers.org/) | Serial terminal |
| `flowvision` | [FlowVision](https://github.com/netdcy/FlowVision) | Image browser |
| `claude` | [Claude](https://claude.ai/) | AI assistant |

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

## File Structure

```
dotfiles/
├── .config/
│   ├── alacritty/           # Terminal config
│   ├── nvim/                # Neovim (LazyVim)
│   └── pgcli/               # PostgreSQL CLI
├── .hammerspoon/            # macOS automation
├── .ssh/
│   ├── config               # Generic SSH settings (tracked)
│   └── config.local.example # Template for hosts (tracked)
├── .gitconfig               # Git config
├── .gitignore               # Repo ignores
├── .secrets.example         # Secrets template
├── .tmux.conf               # Tmux config
├── .zshrc                   # Shell config (tracked)
├── .zshrc.local.example     # Template for local settings (tracked)
├── brew_casks.txt           # GUI apps
├── brew_leaves.txt          # CLI tools
├── macos_setup.sh           # Full setup script
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
