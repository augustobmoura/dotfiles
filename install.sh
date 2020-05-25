#! /usr/bin/env sh

set -eu

export DOTFILES_HOME="${DOTFILES_HOME:-"$HOME/dotfiles"}"

yes n | "$DOTFILES_HOME/ln-files.sh"

yes y | "$DOTFILES_HOME/third-party/fzf/install"
