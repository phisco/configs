#!/bin/env zsh
#zmodload zsh/zprof
export ZSH=$HOME/.oh-my-zsh

ZSH_DISABLE_COMPFIX=true
[ -f ~/.profile ] && source ~/.profile
ZSH_THEME="bira"

#COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
if [[ -z $ZSH_TMUX_AUTOSTART_OVERRIDE ]]
then
  export ZSH_TMUX_AUTOSTART=true
fi

plugins=(
  asdf
  common-aliases
  command-not-found
  copyfile
  docker
  #encode64
  git
  git-flow
  golang
  #gpg-agent
  #kube-ps1
  kubectl
  sudo
  #suse
  systemd
  tmux
  vagrant
  vi-mode
  vscode
  web-search
  keychain
  gpg-agent
)

source $ZSH/oh-my-zsh.sh
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
    rm -f ~/.zcompdump; compinit
fi

pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
  }

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

export WORKON_HOME=~/Envs
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


_direnv_hook() {
  eval "$(direnv export zsh)";
}
typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]; then
  precmd_functions+=_direnv_hook;
fi

function powerline_precmd() {
    PS1="$($GOPATH/bin/powerline-go -error $? -shell zsh -newline -modules kube,git,jobs,cwd,exit)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

install_powerline_precmd

export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/libxml2/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
#zprof

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
