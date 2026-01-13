export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#eval `ssh-agent`

export EDITOR=nvim
alias takeover="tmux detach -a"

export GO111MODULE=on
export npm_config_prefix=$HOME/.node_modules

alias sudo="sudo "
alias wa="watch -n 1 -d "
alias vas='viddy -n 1s -d -p '
alias va='vas --disable_auto_save '
alias v="nvim"
alias vimdiff="nvim -d"
alias vim="nvim"
alias ls='ls -A --color '
alias c='clear'

alias lg='lazygit'
alias lzd='lazydocker'
alias dsp='docker system prune -a --group-directories-first'

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# Go settings
export GOPATH="${HOME}/go"
export PATH=$HOME/.local/bin:$HOME/go/bin:$PATH
# Homebrew settings
export PATH=$PATH:$HOME/.node_modules/bin
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
export PATH=$PATH:/Applications/GoLand.app/Contents/MacOS
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="/opt/homebrew/opt/gettext/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
export MANPATH="/opt/homebrew/opt/findutils/libexec/gnuman:$MANPATH"
export MANPATH="/opt/homebrew/opt/gnu-getopt/share/man:$MANPATH"
export MANPATH="/opt/homebrew/opt/gnu-sed/libexec/gnuman:$MANPATH"
export MANPATH="/opt/homebrew/opt/gnu-tar/libexec/gnuman:$MANPATH"
export LDFLAGS="-L/opt/homebrew/opt/zlib/lib $LDFLAGS"
export LDFLAGS="-L/opt/homebrew/opt/gettext/lib $LDFLAGS"
export LDFLAGS="-L/opt/homebrew/opt/readline/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/zlib/include $CPPFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/gettext/include $CPPFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/readline/include $CPPFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig"

# GPGv2 backward compatibility
export GPG_AGENT_INFO=~/.gnupg/S.gpg-agent::1
if gpg_tty=$(tty); then
  export GPG_TTY=$gpg_tty
fi

alias "rm"="rm -i"

. "$HOME/.cargo/env"

export GOPRIVATE=github.com/phisco/up-sdk-go,github.com/phisco/up-sdk-go/apis,github.com/upbound/up-sdk-go,github.com/upbound/up-sdk-go/apis,github.com/upbound/uxp-licensing,github.com/upbound/controller-manager,github.com/upbound/upbound-runtime,
