current_dir = $(shell pwd)

.PHONY: update
update-all:
	git submodule update --init --recursive
	env PATH="$(current_dir)/bin:$$PATH" git submodule foreach 'git checkout $$(git_main_branch); git pull'
