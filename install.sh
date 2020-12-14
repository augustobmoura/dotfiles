#! zsh

set -eu

export DOTFILES_HOME="${DOTFILES_HOME:-"$HOME/dotfiles"}"

if type git &> /dev/null; then
	(
		cd "$DOTFILES_HOME"

		git config user.email augusto.borgesm@gmail.com
		git config user.name "Augusto Moura"

		git submodule update --init --recursive
	)
fi

yes n | "$DOTFILES_HOME/ln-files.sh"

yes y | "$DOTFILES_HOME/third-party/fzf/install"

# Install mons
(
	cd "$DOTFILES_HOME/third-party/mons"
	make -e PREFIX="$PWD/.build" install
)
