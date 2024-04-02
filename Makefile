# Auto genrated from ./configure


export PATH := $(DOTFILES_HOME)/_scripts:$(PATH)

define link
@safe-link.sh $< $@
endef


.PHONY: all
all:


.PHONY: neovim
neovim: $(HOME)/.config/nvim/init.lua $(HOME)/.vimrc $(HOME)/.config/nvim/after $(HOME)/.vim/autoload/plug.vim $(HOME)/.vim/after

.PHONY: $(HOME)/.config/nvim/init.lua
$(HOME)/.config/nvim/init.lua: $(DOTFILES_HOME)/neovim/init.lua
	$(link)

.PHONY: $(HOME)/.vimrc
$(HOME)/.vimrc: $(DOTFILES_HOME)/neovim/init.vim
	$(link)

.PHONY: $(HOME)/.config/nvim/after
$(HOME)/.config/nvim/after: $(DOTFILES_HOME)/neovim/after
	$(link)

.PHONY: $(HOME)/.vim/autoload/plug.vim
$(HOME)/.vim/autoload/plug.vim: $(DOTFILES_HOME)/neovim/plug.vim
	$(link)

.PHONY: $(HOME)/.vim/after
$(HOME)/.vim/after: $(DOTFILES_HOME)/neovim/after
	$(link)


.PHONY: asdf
asdf: $(HOME)/.asdf

.PHONY: $(HOME)/.asdf
$(HOME)/.asdf: $(DOTFILES_HOME)/asdf
	$(link)


.PHONY: zsh
zsh: $(HOME)/.zshrc

.PHONY: $(HOME)/.zshrc
$(HOME)/.zshrc: $(DOTFILES_HOME)/zsh/zshrc.zsh
	$(link)


.PHONY: starship
starship: $(HOME)/.config/starship.toml

.PHONY: $(HOME)/.config/starship.toml
$(HOME)/.config/starship.toml: $(DOTFILES_HOME)/starship/starship.toml
	$(link)


.PHONY: alacritty
alacritty: $(HOME)/.config/alacritty/alacritty.yml

.PHONY: $(HOME)/.config/alacritty/alacritty.yml
$(HOME)/.config/alacritty/alacritty.yml: $(DOTFILES_HOME)/alacritty/alacritty.yml
	$(link)


.PHONY: tmux
tmux: $(HOME)/.tmux/plugins/tpm $(HOME)/.tmux.conf $(HOME)/.tmux.conf.local

.PHONY: $(HOME)/.tmux/plugins/tpm
$(HOME)/.tmux/plugins/tpm: $(DOTFILES_HOME)/tmux/tpm
	$(link)

.PHONY: $(HOME)/.tmux.conf
$(HOME)/.tmux.conf: $(DOTFILES_HOME)/tmux/oh-my-tmux/.tmux.conf
	$(link)

.PHONY: $(HOME)/.tmux.conf.local
$(HOME)/.tmux.conf.local: $(DOTFILES_HOME)/tmux/local.tmux.conf
	$(link)


.PHONY: i3
i3: $(HOME)/.i3/config $(HOME)/.config/i3status-rust/config.toml $(HOME)/.config/i3/config

.PHONY: $(HOME)/.i3/config
$(HOME)/.i3/config: $(DOTFILES_HOME)/i3/i3config
	$(link)

.PHONY: $(HOME)/.config/i3status-rust/config.toml
$(HOME)/.config/i3status-rust/config.toml: $(DOTFILES_HOME)/i3/i3status-rs.conf.toml
	$(link)

.PHONY: $(HOME)/.config/i3/config
$(HOME)/.config/i3/config: $(DOTFILES_HOME)/i3/i3config
	$(link)


all: neovim asdf zsh starship alacritty tmux i3
