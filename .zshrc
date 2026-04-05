if [[ -o login && -f ~/.profile ]]; then
  source ~/.profile
fi

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey "^?" backward-delete-char # Fix the back delete issue: https://github.com/spaceship-prompt/spaceship-prompt/issues/91#issuecomment-327996599
bindkey "^X" clear-screen

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zsh-users/zsh-completions
zinit light nix-community/nix-zsh-completions
# zinit light zsh-users/zsh-autosuggestions
#
# zinit ice atinit"
#         ZSH_TMUX_FIXTERM=true;
#         ZSH_TMUX_AUTOSTART=true;
#         ZSH_TMUX_AUTOCONNECT=true;"
# zinit snippet OMZP::tmux

zinit snippet OMZ::lib/compfix.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZP::common-aliases
zinit snippet OMZP::command-not-found
zinit snippet OMZP::copyfile
zinit snippet OMZP::git
zinit snippet OMZP::golang
zinit snippet OMZP::kubectl
zinit snippet OMZP::sudo
zinit snippet OMZP::vscode
zinit snippet OMZP::brew

# Tmux integration.
# SSH clients usually can't pass arbitrary env vars unless sshd AcceptEnv permits them.
IS_SSH_SESSION=false
if [[ -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]; then
  IS_SSH_SESSION=true
fi

# Auto-enable tmux integration for SSH logins so TMUX_ENABLED from the client isn't required.
if [[ "$IS_SSH_SESSION" == "true" && -z "$TMUX_ENABLED" ]]; then
  TMUX_ENABLED=true
fi

# Target tmux session name.
# Priority:
# 1) TMUX_SESSION_NAME from environment (if forwarded by SSH)
# 2) ~/.config/tmux/session-name (single-line value)
# 3) TMUX_SESSION_NAME_DEFAULT
TMUX_SESSION_NAME_DEFAULT="${TMUX_SESSION_NAME_DEFAULT:-</>}"
TMUX_SSH_SESSION_NAME_DEFAULT="${TMUX_SSH_SESSION_NAME_DEFAULT:-phone}"
if [[ "$IS_SSH_SESSION" == "true" ]]; then
  TMUX_SESSION_NAME_DEFAULT="$TMUX_SSH_SESSION_NAME_DEFAULT"
fi
TMUX_SESSION_NAME_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/session-name"
if [[ "$IS_SSH_SESSION" == "true" && -z "$TMUX_SESSION_NAME" && -r "$TMUX_SESSION_NAME_FILE" ]]; then
  TMUX_SESSION_NAME="$(<"$TMUX_SESSION_NAME_FILE")"
fi
TMUX_SESSION_NAME="${TMUX_SESSION_NAME:-$TMUX_SESSION_NAME_DEFAULT}"

TMUX_BIN="${commands[tmux]}"

if [[ "$TMUX_ENABLED" == "true" || "$TMUX_ENABLED" == "1" ]]; then
  export ZSH_TMUX_FIXTERM=false
  if [[ "$IS_SSH_SESSION" == "true" ]]; then
    export ZSH_TMUX_AUTOSTART=false
  else
    export ZSH_TMUX_AUTOSTART=true
  fi
  export ZSH_TMUX_AUTOCONNECT=true
  export ZSH_TMUX_DEFAULT_SESSION_NAME="$TMUX_SESSION_NAME"

  zinit snippet OMZP::tmux
  zinit snippet OMZL::history.zsh
fi

# Fallback: force tmux attach for interactive SSH shells if plugin autostart didn't trigger.
if [[ -o interactive && -z "$TMUX" && "$IS_SSH_SESSION" == "true" ]]; then
  if [[ "$TMUX_ENABLED" == "true" || "$TMUX_ENABLED" == "1" ]]; then
    if [[ -n "$TMUX_BIN" ]]; then
      "$TMUX_BIN" new-session -A -s "$TMUX_SESSION_NAME"
    fi
  fi
fi

# Toggle between two tmux sessions on the same socket by default.
# Defaults are:
#   1) /private/tmp/tmux-$UID/default session "</>"
#   2) /private/tmp/tmux-$UID/default session "phone"
# You can override with:
#   TMUX_FLIP_PRIMARY_SOCKET, TMUX_FLIP_PRIMARY_SESSION
#   TMUX_FLIP_SECONDARY_SOCKET, TMUX_FLIP_SECONDARY_SESSION
_tmux_flip_followup() {
  [[ -n "$TMUX" ]] && return 0

  local tmux_bin="${commands[tmux]}"
  [[ -z "$tmux_bin" ]] && return 0

  local state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
  local pending_file="$state_dir/tmux-flip-pending"
  [[ ! -r "$pending_file" ]] && return 0

  local next_key
  next_key="$(<"$pending_file")"
  rm -f "$pending_file"
  [[ -z "$next_key" ]] && return 0

  local next_socket="${next_key%%|*}"
  local next_session="${next_key#*|}"

  if [[ ! -S "$next_socket" ]]; then
    echo "tmux_flip: socket not found: $next_socket"
    return 1
  fi

  if ! "$tmux_bin" -S "$next_socket" has-session -t "$next_session" 2>/dev/null; then
    echo "tmux_flip: session '$next_session' not found on socket '$(basename "$next_socket")'"
    return 1
  fi

  TMUX= "$tmux_bin" -S "$next_socket" attach -t "$next_session"
}

typeset -ga precmd_functions
if (( ${precmd_functions[(I)_tmux_flip_followup]} == 0 )); then
  precmd_functions+=_tmux_flip_followup
fi

tmux_flip() {
  local tmux_bin="${commands[tmux]}"
  if [[ -z "$tmux_bin" ]]; then
    echo "tmux_flip: tmux not found in PATH"
    return 1
  fi

  local socket_dir="${TMUX_SOCKET_DIR:-/private/tmp/tmux-${UID}}"
  local default_socket="${TMUX_FLIP_SOCKET:-$socket_dir/default}"
  local primary_socket="${TMUX_FLIP_PRIMARY_SOCKET:-$default_socket}"
  local primary_session="${TMUX_FLIP_PRIMARY_SESSION:-</>}"
  local secondary_socket="${TMUX_FLIP_SECONDARY_SOCKET:-$default_socket}"
  local secondary_session="${TMUX_FLIP_SECONDARY_SESSION:-${TMUX_SSH_SESSION_NAME_DEFAULT:-phone}}"

  local state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
  local state_file="$state_dir/tmux-flip-last"
  local pending_file="$state_dir/tmux-flip-pending"
  mkdir -p "$state_dir" 2>/dev/null || true

  local primary_key="${primary_socket}|${primary_session}"
  local secondary_key="${secondary_socket}|${secondary_session}"
  local current_key=""
  local next_key="$primary_key"

  if [[ -r "$state_file" ]]; then
    current_key="$(<"$state_file")"
  fi

  if [[ "$current_key" == "$primary_key" ]]; then
    next_key="$secondary_key"
  elif [[ "$current_key" == "$secondary_key" ]]; then
    next_key="$primary_key"
  fi

  local next_socket="${next_key%%|*}"
  local next_session="${next_key#*|}"

  if [[ ! -S "$next_socket" ]]; then
    echo "tmux_flip: socket not found: $next_socket"
    return 1
  fi

  if ! "$tmux_bin" -S "$next_socket" has-session -t "$next_session" 2>/dev/null; then
    echo "tmux_flip: session '$next_session' not found on socket '$(basename "$next_socket")'"
    return 1
  fi

  print -r -- "$next_key" >| "$state_file"

  if [[ -n "$TMUX" ]]; then
    print -r -- "$next_key" >| "$pending_file"
    if ! "$tmux_bin" detach-client; then
      rm -f "$pending_file"
      echo "tmux_flip: failed to detach tmux client"
      return 1
    fi
    return 0
  fi

  TMUX= "$tmux_bin" -S "$next_socket" attach -t "$next_session"
}

alias tmx='tmux_flip'

zinit light zsh-users/zsh-syntax-highlighting


eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# Completion Options.
setopt complete_in_word         # Complete From Both Ends Of A Word.
setopt always_to_end            # Move Cursor To The End Of A Completed Word.
setopt path_dirs                # Perform Path Search Even On Command Names With Slashes.
setopt auto_menu                # Show Completion Menu On A Successive Tab Press.
setopt auto_list                # Automatically List Choices On Ambiguous Completion.
setopt auto_param_slash         # If Completed Parameter Is A Directory, Add A Trailing Slash.
setopt no_complete_aliases

setopt menu_complete            # Do Not Autoselect The First Completion Entry.
unsetopt flow_control           # Disable Start/Stop Characters In Shell Editor.

# Zstyle.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' rehash true
zstyle ':completion:*' special-dirs true

 # History
HIST_STAMPS="yyyy/mm/dd"
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt bang_hist                # Treat The '!' Character Specially During Expansion.
setopt extended_history         # Show Timestamp In History.
setopt hist_expire_dups_first   # Expire A Duplicate Event First When Trimming History.
setopt hist_find_no_dups        # Do Not Display A Previously Found Event.
setopt hist_ignore_all_dups     # Delete An Old Recorded Event If A New Event Is A Duplicate.
setopt hist_ignore_dups         # Do Not Record An Event That Was Just Recorded Again.
setopt hist_ignore_space        # Do Not Record An Event Starting With A Space.
setopt hist_save_no_dups        # Do Not Write A Duplicate Event To The History File.
setopt hist_verify              # Do Not Execute Immediately Upon History Expansion.
setopt inc_append_history       # Write To The History File Immediately, Not When The Shell Exits.
setopt prompt_subst
setopt share_history            # Share History Between All Sessions.
setopt autocd

# to make cd also see .hidden directories/files
setopt globdots

eval "$(starship init zsh)"
# function powerline_precmd() {
#   PS1="$($GOPATH/bin/powerline-go -shorten-eks-names -shorten-gke-names -numeric-exit-codes -cwd-mode fancy -git-mode fancy -error $? -shell zsh -newline -jobs ${${(%):%j}:-0} -modules kube,cwd,git,jobs,exit)"
# }
#
#
# function install_powerline_precmd() {
#   for s in "${precmd_functions[@]}"; do
#     if [ "$s" = "powerline_precmd" ]; then
#       return
#     fi
#   done
#   precmd_functions+=(powerline_precmd)
# }
#
# install_powerline_precmd

[[ ! -f ~/.fzf.zsh ]] || source ~/.fzf.zsh

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# export ZELLIJ_AUTO_ATTACH=true
# export ZELLIJ_AUTO_EXIT=true
# eval "$(zellij setup --generate-auto-start zsh)"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=("$HOME/.docker/completions" $fpath)
# End of Docker CLI completions

# Dotfiles management
DOTFILES_DIR="$HOME/dotfiles"

# Add a config file to the dotfiles repo
# Usage: stow_add ~/.config/app/config.yaml
stow_add() {
  if [[ -z "$1" ]]; then
    echo "Usage: stow_add <file-path>"
    echo "Example: stow_add ~/.config/app/config.yaml"
    return 1
  fi

  if ! command -v stow >/dev/null 2>&1; then
    echo "Error: stow is not installed or not in PATH"
    return 1
  fi

  local file="${1:A}"  # Get absolute path

  # Check if file exists and is not a symlink
  if [[ ! -e "$file" ]]; then
    echo "Error: File does not exist: $file"
    return 1
  fi

  if [[ -L "$file" ]]; then
    echo "Error: File is already a symlink: $file"
    return 1
  fi

  # Check if file is under $HOME
  if [[ "$file" != "$HOME"/* ]]; then
    echo "Error: File must be under \$HOME: $file"
    return 1
  fi

  # Get relative path from $HOME
  local relpath="${file#$HOME/}"
  local dest="$DOTFILES_DIR/$relpath"
  local destdir="$(dirname "$dest")"

  # Create destination directory if needed
  mkdir -p "$destdir"

  # Move file to dotfiles repo
  mv "$file" "$dest" || {
    echo "Error: Failed to move $file -> $dest"
    return 1
  }
  echo "Moved $file -> $dest"

  # Re-run stow and rollback on failure
  if ! (cd "$DOTFILES_DIR" && stow .); then
    echo "Error: stow failed, rolling back move"
    mv "$dest" "$file" || echo "Warning: rollback failed, manual recovery required"
    return 1
  fi
  echo "Symlink created: $file -> $dest"
}

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Codex CLI completions
fpath=("$HOME/.zfunc" $fpath)
autoload -Uz compinit && compinit
zinit cdreplay -q
