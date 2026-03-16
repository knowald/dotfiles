# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme - see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Plugins - add wisely, too many slow down shell startup
plugins=(git zsh-autosuggestions zsh-history-substring-search docker docker-compose zsh-syntax-highlighting fzf-tab)

ZSH_DISABLE_COMPFIX="true"

source $ZSH/oh-my-zsh.sh

# Language
export LANG=en_US.UTF-8

# Ruby
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# Autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Python
export PATH="$PATH:/opt/homebrew/opt/python@3.13/libexec/bin"

# Terraform completion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# History
HISTSIZE=1000000
SAVEHIST=1000000
setopt INC_APPEND_HISTORY        # Write immediately, not on shell exit
setopt HIST_FIND_NO_DUPS         # Don't show duplicates when searching
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
unsetopt HIST_IGNORE_SPACE       # Keep commands that start with space
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Aliases
alias findpls="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias lzg="lazygit"
alias lzd="lazydocker"
alias dce="docker compose exec"
alias dcu="docker compose up"
alias dcub="docker compose up --build"
alias vim="nvim"
alias logbat="bat -l syslog --paging=never"
alias rlyclear='printf "\ec\e[3J"'
alias dockhere="docker run --rm -it -v \"\$pwd\":/mnt"
alias gpoh="git push origin HEAD"
alias j="z"
alias b64pbcopy=base64pbcopy
alias killaudio="sudo pkill coreaudiod"
alias dex='docker compose exec app bundle exec'
alias okciao="tmux kill-server"
alias tks="tmux kill-server"
alias tn="tmux new"
alias n="nvim ."
alias dunno="echo '¯\\_(ツ)_/¯' | pbcopy'"
alias tw='tmux rename-window "$(basename "$PWD")"'
alias flame="pkill flameshot && open /Applications/flameshot.app"
# Copy zsh prompt setup to clipboard
alias setupasta="echo 'apt update && apt install zsh && curl -sSL https://github.com/knowald/jovial/raw/master/installer.sh | sudo -E bash -s \${USER:=\`whoami\`}' | pbcopy"

# Functions
function base64pbcopy() {
  if [ -z "$1" ]; then
    echo "Usage: base64pbcopy <filename>"
    return 1
  fi
  cat "$1" | base64 | pbcopy
  echo "Encoded file contents copied to clipboard"
}

function gitstrip() {
    local result="${1#*@}"
    result="${result%.git}"
    result="https://${result//://}"
    echo "$result"
}

function gitstripstdin() {
    while IFS= read -r line; do
        gitstrip "$line"
    done
}

# Open git remote in browser
alias glopen="open \$(git remote get-url origin | gitstripstdin)"

# Quick Claude prompt (no quotes needed)
ask() { claude -p --model haiku --no-session-persistence --tools "" --system-prompt "Give a short, direct answer. No explanations unless asked. For translations, just the translation. For commands, just the command. For code, just the code." "$*"; }

# PATH additions
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$PATH"

# Go
export PATH=$PATH:$(go env GOPATH)/bin

# Environment
export TERM=xterm-256color
export EDITOR=nvim
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export _ZO_ECHO=1

# Shell integrations
eval "$(zoxide init zsh)"
eval "$(rbenv init -)"
eval "$(thefuck --alias)"

# FZF-tab in tmux popup
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Keybindings
bindkey '^Q' push-line-or-edit

# Google Cloud SDK (if installed)
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

# Load secrets (API tokens, passwords - not tracked)
[ -f ~/.secrets ] && source ~/.secrets

# Load local machine-specific config (SSH keys, paths - not tracked)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# bun completions
[ -s "/Users/knowald/.oh-my-zsh/completions/_bun" ] && source "/Users/knowald/.oh-my-zsh/completions/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export AWS_DEFAULT_PROFILE="NONE"
alias cwd="pwd | pbcopy"

if [ -n "$TMUX" ]; then
    precmd_tmux_reset() {
        local cmd=$(tmux display-message -p '#{pane_current_command}')
        if [ "$cmd" != "ssh" ]; then
            tmux set -p @is_ssh 0 2>/dev/null
        fi
    }
    precmd_functions+=(precmd_tmux_reset)
fi

# Prevent zsh from overwriting the pane title
DISABLE_AUTO_TITLE="true"  # if using oh-my-zsh
# or for plain zsh:
emulate -L zsh
setopt no_auto_name_dirs
