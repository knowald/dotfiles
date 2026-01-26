#!/bin/bash
# Claude Code notification script
# Args: $1 = title, $2 = message, $3 = sound (optional, default: Glass)

SOUND="${3:-Glass}"
SEND_NOTIFICATION=true

# Check if Alacritty is frontmost
FRONTMOST=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

if [[ "$FRONTMOST" == "alacritty" ]]; then
  # Alacritty is frontmost - check if we're on the active tmux pane
  if [[ -n "$TMUX" ]]; then
    # Find the pane that is BOTH active in its window AND in the active window
    ACTIVE_PANE=$(tmux list-panes -a -F '#{pane_active}#{window_active} #{pane_id}' 2>/dev/null | grep '^11' | cut -d' ' -f2)
    if [[ "$TMUX_PANE" == "$ACTIVE_PANE" ]]; then
      # User is looking at this pane - skip notification
      SEND_NOTIFICATION=false
    fi
  else
    # Not in tmux but Alacritty is frontmost - skip notification
    SEND_NOTIFICATION=false
  fi
fi

# # Sound and notification only if not actively viewing
if [[ "$SEND_NOTIFICATION" == "true" ]]; then
  afplay "/System/Library/Sounds/${SOUND}.aiff" &
  terminal-notifier -title "$1" -message "$2" -group claude-code
fi

# Terminal bell only if inside tmux
if [[ -n "$TMUX" ]]; then
  printf '\a' >/dev/tty
fi
