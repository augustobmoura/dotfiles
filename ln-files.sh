#! /usr/bin/env sh

set -eu

# Choose a name not existent to rename the file, echoing it at the end
mv_to_non_existent() (
	file_name="$1"
	i=''

	# A file that always exist, will always fail the while the first time
	# Just to not repeat the logic of building the file name
	new_file_name="."

	while [ -e "$new_file_name" ]; do
		i=$(($i + 1))
		new_file_name="$file_name.old$i"
	done

	mv "$file_name" "$new_file_name"
	echo "$new_file_name"
)

ALWAYS=255
NO=1
YES=0

confirm() {
	printf "%s ([y]es/[n]o/[a]lways) default: no\n" "$*"
	read _confirmed

	case "$confirmed" in
		[yY]|[sS])
			return $YES
			;;
		[aA])
			return $ALWAYS
			;;
		*)
			return $NO
			;;
	esac
}


always_relink=""

# Soft links with confirmation of overriding
# You can pipe `yes` to override all
linkit() (
	original_file="$(realpath "$1")"
	new_file="$2"

	if ! [ -e "$original_file" ]; then
		echo "File $original_file doesn't exist to be linked!"
		exit 1
	fi

	mkdir -p "$(dirname "$new_file")"

	if [ -e "$new_file" ]; then
		new_file_real="$(realpath "$new_file")"

		if [ "$new_file_real" = "$original_file" ]; then
			echo "File $new_file already linked"
			return 0
		fi

		confirm "File $new_file exists and don't point to $original_file, it points to $new_file_real, relink it?"
		confirmation=$?

		if [ "$confimation" = $ALWAYS ]; then
			always_relink=true
		fi

		if [ -n "$always_relink" ] || [ "$confirmation" = $YES ]; then
			moved_file_name="$(mv_to_non_existent "$new_file")"
			echo "File $new_file moved to $moved_file_name"
		else
			echo "Skipping file $new_file"
			return 0
		fi
	fi

	echo "Creating file $new_file..."
	ln -s "$original_file" "$new_file"
)

# Shell
linkit "$DOTFILES_HOME/zsh/.zshrc" "$HOME/.zshrc"

# Tmux
linkit "$DOTFILES_HOME/tmux/oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
linkit "$DOTFILES_HOME/tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"
linkit "$DOTFILES_HOME/tmux/tpm" "$HOME/.tmux/plugins/tpm"

# VIM
linkit "$DOTFILES_HOME/neovim/init.vim" "$HOME/.vimrc"
linkit "$DOTFILES_HOME/neovim/init.vim" "$HOME/.config/nvim/init.vim"
linkit "$DOTFILES_HOME/neovim/plug.vim" "$HOME/.local/share/nvim/site/autoload/plug.vim"
linkit "$DOTFILES_HOME/neovim/plug.vim" "$HOME/.vim/autoload/plug.vim"

# asdf
linkit "$DOTFILES_HOME/asdf" "$HOME/.asdf"

# i3
linkit "$DOTFILES_HOME/i3/i3config" "$HOME/.i3/config"
linkit "$DOTFILES_HOME/i3/i3status-rs.conf.toml" "$HOME/.config/i3status-rust/config.toml"

# Alacritty
linkit "$DOTFILES_HOME/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
