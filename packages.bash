must_have=(
	zsh
	tmux
	nvim
	fd
	rg
	bat
	git
	http
	jq
	curl
	delta
	ncdu
	htop
	xclip
)

optional=(
	nmap
	alacritty
	i3
	i3status-rs
	dex
	rofi
	docker
	starship
)

check_missing() {
	for cmd; do
		if ! command -v "$cmd" &> /dev/null; then
			printf "%s\n" "$cmd"
		fi
	done
}

missing_must_have=($(check_missing "${must_have[@]}"))
missing_optional=($(check_missing "${optional[@]}"))

if (( "${#missing_must_have}" )); then
	printf "The following MUST HAVE commands are missing:\n  "
	printf "%s " "${missing_must_have[@]}"
	printf "\n\n"
fi

if (( "${#missing_optional}" )); then
	printf "The following optional commands are missing:\n  "
	printf "%s " "${missing_optional[@]}"
	printf "\n"
fi
