#!/bin/bash

{
	DOTFILES_DIR=${HOME}/dotfiles
	CONFIG_DIR=${HOME}/.config
	VIM_DIR=$HOME/.config/nvim
	echo "DOTFILES_DIR: $DOTFILES_DIR"
	echo "CONFIG_DIR: $CONFIG_DIR"
	echo "VIM_DIR: $VIM_DIR"

	##### Install packages
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
	sudo add-apt-repository ppa:git-core/ppa
	sudo add-apt-repository ppa:neovim-ppa/unstable -y
	sudo apt update
	sudo apt install -y gh neovim python3-neovim liblzma-dev tig libyaml-dev git fzf

	##### Shell configuration
	cp "${DOTFILES_DIR}/.gitconfig" "${HOME}"
	cp "${DOTFILES_DIR}/.gitignore" "${HOME}"
	sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:=${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

	cp "${DOTFILES_DIR}/.zshrc" "${HOME}"
	cp "${DOTFILES_DIR}/.p10k.zsh" "${HOME}"
	mkdir -p "${HOME}/.env"
	cp "${DOTFILES_DIR}"/*.env "${HOME}/.env"

	##### ASDF setup
	ASDF_VERSION=0.16.6
	wget https://github.com/asdf-vm/asdf/releases/download/v${ASDF_VERSION}/asdf-v${ASDF_VERSION}-linux-amd64.tar.gz
	tar -xvzf asdf-v$ASDF_VERSION-linux-amd64.tar.gz
	mv asdf "${HOME}/.local/bin"
	rm asdf-v${ASDF_VERSION}-linux-amd64.tar.gz

	##### Install pyenv
	curl https://pyenv.run | bash
	export PYENV_ROOT="$HOME/.pyenv"
	[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
	git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"

	##### Vim configuration
	git clone https://github.com/LazyVim/starter ${VIM_DIR}
	rm -rf ${VIM_DIR}/.git
	cp ${DOTFILES_DIR}/lazyvim/lazyvim.json ${VIM_DIR}/
	cp ${DOTFILES_DIR}/lazyvim/config/* ${VIM_DIR}/lua/config/
	cp ${DOTFILES_DIR}/lazyvim/plugins/* ${VIM_DIR}/lua/plugins/

	##### Install Graphite
	npm install -g @withgraphite/graphite-cli@stable

	##### Workspace setup
	cat <<EOF >"${HOME}/first-run.sh"
nvim
EOF
} >install.log 2>&1
