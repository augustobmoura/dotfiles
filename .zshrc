# Uncoment to skip config (test in )
if [ "x$AGT_SKIP_CONFIG" != x ]; then
	return 0
fi

# Path to your oh-my-zsh installation.
export DOTFILES_HOME="${DOTFILES_HOME:-$HOME/dotfiles}"

export ZSH="$HOME/.oh-my-zsh"
export fpath=("$HOME/functions" $fpath)

function isjetbrains() {
	[[ $TERMINAL_EMULATOR =~ 'JetBrains-JediTerm' ]]
	return 
}

function cmd_exists() {
	type "$@" &> /dev/null
	return
}

function isvscode() {
	# Needs to configure VSCode to pass this env var
	[[ $TERMINAL_EMULATOR =~ 'VSCode' ]]
	return
}

path=(
	"$HOME/.local/bin"
	"$DOTFILES_HOME/bin"
	$path
	"$HOME/.cargo/bin"
)

source "$DOTFILES_HOME/shared/variables"

# ---
# Oh my zsh
# ---

# Config
export ZSH_TMUX_AUTOSTART=${ZSH_TMUX_AUTOSTART:-true}
export ZSH_TMUX_AUTOSTART_ONCE=true
export ZSH_TMUX_AUTOCONNECT=false

# Tmux is usually buggy on embedded terminals, also is kinda unecessary in this context
if isjetbrains || isvscode; then
	export ZSH_TMUX_AUTOSTART=false
fi

# Should load before omz for custom directoty configuration
if cmd_exists direnv; then
	eval "$(direnv hook zsh)"
fi

# Should be provided by either Pure or Starship
ZSH_THEME= # OMZ theme

plugins=(
	git
	node
	yarn
	npm
	tmux
	gradle
	asdf
	ripgrep
	cargo
	colored-man-pages
	docker
	fancy-ctrl-z
	httpie
	sdk
	emoji
	kubectl
	bgnotify
	#minikube # Giving some weird prints in random commands, disabled for now
)

# Run OMZ
source $ZSH/oh-my-zsh.sh

# ---
# Customizations
# ---

source "$DOTFILES_HOME/shared/aliases"

# Personal preference
disable r

# Configure fzf, if it exists
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Generate Base16 color schemes
export BASE16_SHELL="$DOTFILES_HOME/third-party/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && 
		eval "$("$BASE16_SHELL/profile_helper.sh")"

# Applies theme
cmd_exists base16_seti && base16_seti

# Enable hightlighting if exists
if [ -e "$HOME/highlighting.zsh" ]; then
	source "$HOME/highlighting.zsh"
fi

# Enable autosuggestions if exists
if [ -e "$HOME/autosuggestion.zsh" ]; then
	source "$HOME/autosuggestion.zsh"
fi

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
function pasteinit() {
	OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
	zle -N self-insert url-quote-magic
}

function  pastefinish() {
	zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Applies sdkman if configured, I mostly use asdf by now, but whatever
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Applies n if configured, I mostly use asdf by now, but whatever
if cmd_exists n; then
	export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi

# Machine local configuration
if [ -e "$HOME/.local.zsh" ]; then
	source "$HOME/.local.zsh"
fi

# Bind alt-j & alt-k to Down & Up for historic in the home row
bindkey -s '^[j' '^[OB'
bindkey -s '^[k' '^[OA'

# Run broot if configured
if [ -e "$HOME/.config/broot/launcher/bash/br" ]; then
	source "$HOME/.config/broot/launcher/bash/br"
fi

if [[ $ZSH_THEME = '' ]]; then
	# Choose theme, prefer starship and then Pure
	if cmd_exists starship; then
		# Activates starship
		eval "$(starship init zsh)"
	else
		# Activates Pure them
		autoload -U promptinit; promptinit
		prompt pure
	fi
fi

# Better expansion on ^X*
# Adapted from the globalias plugin
globalias() {
	zle _expand_alias
	zle expand-word
	zle self-insert

	# Needed to not add * at the end
	zle backward-delete-char
}
zle -N globalias

bindkey '^X*' globalias
