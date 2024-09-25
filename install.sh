#!/bin/bash
#
{
    DOTFILES_DIR=${HOME}/dotfiles
    CONFIG_DIR=${HOME}/.config
    VIM_PLUGINS_DIR=$HOME/.vim/pack/plugins/start
    echo "DOTFILES_DIR: $DOTFILES_DIR"
    echo "CONFIG_DIR: $CONFIG_DIR"
    echo "VIM_PLUGINS_DIR: $VIM_PLUGINS_DIR"

    ##### Install packages
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update
    sudo apt install -y gh neovim python3-neovim liblzma-dev tig libyaml-dev

    ##### Shell configuration
    cp "${DOTFILES_DIR}/.gitconfig" "${HOME}"
    cp "${DOTFILES_DIR}/.gitignore" "${HOME}"
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:=${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    git clone https://github.com/junegunn/fzf.git "${HOME}/.fzf"

    cp "${DOTFILES_DIR}/.zshrc" "${HOME}"
    cp "${DOTFILES_DIR}/.p10k.zsh" "${HOME}"
    mkdir -p "${HOME}/.env"
    cp "${DOTFILES_DIR}"/*.env "${HOME}/.env"

    ##### Vim configuration
    cp "${DOTFILES_DIR}/.vimrc" "${HOME}"
    mkdir -p "$VIM_PLUGINS_DIR"
    cd "$VIM_PLUGINS_DIR" || exit 1
    git clone https://github.com/neoclide/coc.nvim.git
    git clone https://github.com/wellle/context.vim.git
    git clone https://github.com/github/copilot.vim
    git clone https://github.com/morhetz/gruvbox
    git clone https://github.com/Yggdroot/indentLine.git
    git clone https://github.com/tomasr/molokai
    git clone https://github.com/scrooloose/nerdcommenter
    git clone https://github.com/scrooloose/nerdtree
    git clone https://github.com/majutsushi/tagbar
    git clone https://github.com/challenger-deep-theme/vim
    git clone https://github.com/vim-airline/vim-airline
    git clone https://github.com/vim-airline/vim-airline-themes
    git clone https://github.com/flazz/vim-colorschemes
    git clone https://github.com/ryanoasis/vim-devicons
    git clone https://github.com/kkoomen/vim-doge
    git clone https://github.com/tpope/vim-fugitive.git
    git clone https://github.com/ruanyl/vim-gh-line
    git clone https://github.com/rodjek/vim-puppet
    git clone https://github.com/honza/vim-snippets
    git clone https://github.com/hashivim/vim-terraform.git
    git clone https://github.com/vim-test/vim-test.git
    git clone https://github.com/puremourning/vimspector.git
    cd - || exit 1
    cd "$VIM_PLUGINS_DIR/coc.nvim" || exit 1
    yarn install
    cd - || exit 1

    mkdir -p "$CONFIG_DIR/nvim"
    mkdir -p "$CONFIG_DIR/coc/extensions"
    cp "${DOTFILES_DIR}/init.vim" "${CONFIG_DIR}/nvim"
    cp "${DOTFILES_DIR}/coc-settings.json" "${CONFIG_DIR}/nvim"
    extensions="coc-css coc-diagnostic coc-eslint coc-explorer coc-git coc-go coc-java coc-json coc-prettier coc-pyright coc-sh coc-snippets coc-solargraph coc-tsserver coc-xml coc-yaml"
    nvim --headless +"CocInstall -sync $extensions|qa"

    ##### ASDF setup
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
    asdf install ruby 3.3.5

    ##### Install pyenv
    curl https://pyenv.run | bash
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"

    ##### Install iTerm2 shell integration
    curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

    ##### Install FZF
    git clone https://github.com/junegunn/fzf
    cd fzf || exit 1
    ./install --all
    cd - || exit 1

    ##### Workspace setup
    cat <<EOF >"${HOME}/first-run.sh"
setup-workspace
setup-repo dogweb
nvim -c 'Copilot setup'
gh auth login
git config --global url."git@github.com:".insteadOf "https://github.com/"
cat <<EOF2 > ~/dd/dogweb/.env
source venv3/bin/activate
EOF2
cat <<EOF3 > ~/dd/dogweb/.tool-versions
ruby 3.3.5
EOF3
EOF
} >install.log 2>&1
