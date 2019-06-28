#! /usr/bin/env sh

DOTFILES_HOME="${DOTFILES_HOME:-"$HOME/dotfiles"}"

linkit() {
  if [ -e "$2" ]; then
    echo "File $2 already exists, override it? (y/N) "
    read confirmed
    case "$confimerd" in
      [yY]|[yY][eE][sS]);;
      *)
        return 0
	;;
    esac
  fi

  echo "Creating file $2..."
  ln -s "$1" "$2"
}

# Basic
linkit "$DOTFILES_HOME/.zshrc" "$HOME/.zshrc"

# Zsh themes and plugins
linkit "$DOTFILES_HOME/oh-my-zsh" "$HOME/.oh-my-zsh"
linkit "$DOTFILES_HOME/functions" "$HOME/functions"
linkit "$DOTFILES_HOME/third-party/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$HOME/highlighting.zsh"
linkit "$DOTFILES_HOME/third-party/zsh-autosuggestions/zsh-autosuggestions.zsh" "$HOME/autosuggestion.zsh"

# Tmux
linkit "$DOTFILES_HOME/third-party/tmux-theme/.tmux.conf" "$HOME/.tmux.conf"
linkit "$DOTFILES_HOME/.tmux.conf.local" "$HOME/.tmux.conf.local"

# VIM
linkit "$DOTFILES_HOME/.vimrc" "$HOME/.vimrc"
linkit "$DOTFILES_HOME/.vimrc" "$HOME/.config/nvim/init.vim"

