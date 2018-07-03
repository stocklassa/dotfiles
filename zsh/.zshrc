export ZSH="/home/eric/.oh-my-zsh"
export LANG=en_US.UTF-8
export EDITOR='vim'
export SSH_KEY_PATH="~/.ssh/rsa_id"

ZSH_THEME="robbyrussell"

plugins=(
  git
  fancy-ctrl-z
  common-aliases
  composer
  catimg
  colored-man-pages
  bgnotify
  cp
  web-search
)

source $ZSH/oh-my-zsh.sh
