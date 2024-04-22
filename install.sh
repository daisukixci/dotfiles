#!/bin/bash
#
DOTFILES_DIR=${HOME}/dotfiles
CONFIG_DIR=${HOME}/.config
VIM_PLUGINS_DIR=$HOME/.vim/pack/plugins/start
echo "DOTFILES_DIR: $DOTFILES_DIR"
echo "CONFIG_DIR: $CONFIG_DIR"
echo "VIM_PLUGINS_DIR: $VIM_PLUGINS_DIR"

##### Install packages
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install -y gh fzf

##### Shell configuration
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > "${HOME}/install-oh-my-zsh.sh"
source "${HOME}/install-oh-my-zsh.sh"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:=${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

cp "${DOTFILES_DIR}/.zshrc" "${HOME}"
cp "${DOTFILES_DIR}/.p10k.zsh" "${HOME}"
cp "${DOTFILES_DIR}/.gitconfig" "${HOME}"
mkdir -p "${HOME}/.env"
cp "${DOTFILES_DIR}"/*.env "${HOME}/.env"

##### Vim configuration
cp .vimrc "${HOME}"
mkdir -p "$VIM_PLUGINS_DIR"
cd "$VIM_PLUGINS_DIR" || exit 1
git clone https://github.com/neoclide/coc.nvim.git
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
cd - || exit 1

mkdir -p "$CONFIG_DIR/nvim"
cp "${DOTFILES_DIR}/coc-settings.json" "${CONFIG_DIR}/nvim"
mkdir -p "$CONFIG_DIR/coc/extensions"
cd "$CONFIG_DIR/coc/extensions" || exit 1
if [ ! -f package.json ]
then
      echo '{
  "dependencies":{
    "coc-css": ">=1.3.0",
    "coc-explorer": ">=0.22.6",
    "coc-git": ">=2.4.7",
    "coc-go": ">=1.1.0",
    "coc-java": ">=1.5.5",
    "coc-json": ">=1.4.1",
    "coc-pyright": ">=1.1.220",
    "coc-sh": ">=0.6.1",
    "coc-snippets": ">=2.4.7",
    "coc-xml": ">=1.14.1",
    "coc-yaml": ">=1.6.1"
  }
}'> package.json
fi
cd - || exit 1

##### Workspace setup
setup-workspace
setup-repo dogweb
