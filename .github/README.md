# Eviber's dotfiles

Nothing much really

## Setup

With fish:
```fish
git clone --bare git@github.com:Eviber/dotfiles.git ~/.dotfiles
alias -s dotfiles 'git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```
