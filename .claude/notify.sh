#!/bin/bash
# Claude Code notification script (Notification + Stop hooks)
# Args: $1 = title, $2 = fallback message, $3 = sound (optional, default: Glass)
# Hook JSON on stdin provides message, cwd, hook_event_name, transcript_path.

SOUND="${3:-Glass}"
SEND_NOTIFICATION=true

HOOK_INPUT=$(cat)
hook_field() {
  jq -r "$1 // empty" <<<"$HOOK_INPUT" 2>/dev/null
}

HOOK_EVENT=$(hook_field '.hook_event_name')
HOOK_MESSAGE=$(hook_field '.message')
HOOK_CWD=$(hook_field '.cwd')
PROJECT=$(basename "${HOOK_CWD:-$PWD}")

# On Stop there is no message, so show the start of Claude's last reply
if [[ "$HOOK_EVENT" == "Stop" && -z "$HOOK_MESSAGE" ]]; then
  TRANSCRIPT=$(hook_field '.transcript_path')
  if [[ -f "$TRANSCRIPT" ]]; then
    HOOK_MESSAGE=$(tail -200 "$TRANSCRIPT" | jq -rs \
      '[.[] | select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text] | last // empty' \
      2>/dev/null | tr '\n' ' ' | cut -c1-160)
  fi
fi

SUBTITLE="$PROJECT"
if [[ -n "$TMUX" && -n "$TMUX_PANE" ]]; then
  TMUX_LOCATION=$(tmux display-message -p -t "$TMUX_PANE" 'tmux #{session_name}:#{window_index} #{window_name}' 2>/dev/null)
  SUBTITLE="$PROJECT | $TMUX_LOCATION"
fi

# Check if Ghostty is frontmost
FRONTMOST=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

if [[ "$FRONTMOST" == "ghostty" ]]; then
  # Ghostty is frontmost - check if we're on the active tmux pane
  if [[ -n "$TMUX" ]]; then
    # Find the pane that is BOTH active in its window AND in the active window
    ACTIVE_PANE=$(tmux list-panes -a -F '#{pane_active}#{window_active} #{pane_id}' 2>/dev/null | grep '^11' | cut -d' ' -f2)
    if [[ "$TMUX_PANE" == "$ACTIVE_PANE" ]]; then
      # User is looking at this pane - skip notification
      SEND_NOTIFICATION=false
    fi
  else
    # Not in tmux but Ghostty is frontmost - skip notification
    SEND_NOTIFICATION=false
  fi
fi

# # Sound and notification only if not actively viewing
if [[ "$SEND_NOTIFICATION" == "true" ]]; then
  afplay "/System/Library/Sounds/${SOUND}.aiff" &
  if [[ -n "$TMUX" && -n "$TMUX_PANE" ]]; then
    # Click jumps tmux to the pane that sent the notification, then focuses
    # Ghostty. Runs outside tmux, so full binary path and captured pane id.
    CLICK_COMMAND="/opt/homebrew/bin/tmux switch-client -t '$TMUX_PANE'; /opt/homebrew/bin/tmux select-window -t '$TMUX_PANE'; /opt/homebrew/bin/tmux select-pane -t '$TMUX_PANE'; open -b com.mitchellh.ghostty"
    terminal-notifier -title "$1" -subtitle "$SUBTITLE" -message "${HOOK_MESSAGE:-$2}" \
      -group "claude-code-$PROJECT" -execute "$CLICK_COMMAND"
  else
    terminal-notifier -title "$1" -subtitle "$SUBTITLE" -message "${HOOK_MESSAGE:-$2}" \
      -group "claude-code-$PROJECT" -activate com.mitchellh.ghostty
  fi
fi

# Hooks run without terminal access since Claude Code 2.1.140, so /dev/tty
# is unavailable. Write BEL to the pane's own tty instead - tmux treats it
# as pane output and sets window_bell_flag, which the status bar renders
# as a red window name with "!".
if [[ -n "$TMUX" && -n "$TMUX_PANE" ]]; then
  PANE_TTY=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null)
  if [[ -w "$PANE_TTY" ]]; then
    printf '\a' > "$PANE_TTY"
  fi
fi

exit 0
