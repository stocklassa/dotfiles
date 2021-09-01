export ZSH="/home/eric/.oh-my-zsh"
export LANG=en_US.UTF-8
export EDITOR='vim'
export SSH_KEY_PATH="~/.ssh/rsa_id"

ZSH_THEME="robbyrussell"

# Need more plugins! :)
plugins=(
  git
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

alias sc="~/sc-im/src/sc-im"

# OMG, KILL IT WITH FIRE
unsetopt AUTO_CD
