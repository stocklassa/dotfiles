#!/bin/bash
cd ~/dotfiles
git submodule init
eval "git submodule add https://github.com/$1/$2.git vim/pack/plugins/start/$2"
eval "git add .gitmodules vim/pack/plugins/start/$2"
