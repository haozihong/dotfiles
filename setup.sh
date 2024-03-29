#!/usr/bin/env bash

# set -e          # Exit on error
# set -o pipefail # Exit on pipe error
# set -x          # Enable verbosity

# Dont link DS_Store files
find . -name ".DS_Store" -exec rm {} \;

PROGRAMS=(bash vim git tmux zsh)
# PROGRAMS=(alias bash env git python scripts stow tmux vim zsh)

function backup_if_exists() {
    if [ -f $1 ];
    then
      mv $1 $OLD_DOTFILES
    fi
    if [ -d $1 ];
    then
      mv $1 $OLD_DOTFILES
    fi
}

function backup_files() {
    OLD_DOTFILES="dotfile_bk_$(date -u +"%Y%m%d%H%M%S")"
    mkdir $OLD_DOTFILES

    # Clean common conflicts
    # backup_if_exists ~/.bash_profile
    backup_if_exists ~/.bash_logout
    backup_if_exists ~/.bashrc
    # backup_if_exists ~/.zshrc
    backup_if_exists ~/.gitconfig
    backup_if_exists ~/.tmux.conf
    # backup_if_exists ~/.profile


    # mkdir -p ~/.vim/undodir

    # for f in ~/.zprezto/runcoms/z*
    # do
    #     mv "$f" $OLD_DOTFILES
    # done
}

backup_files

for program in ${PROGRAMS[@]}; do
  stow -v --target=$HOME $program
  echo "Configuring $program"
done

echo "Done!"
