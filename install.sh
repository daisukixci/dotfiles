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
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt update
sudo apt install -y gh fzf neovim python3-neovim

##### Shell configuration
set -x
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
set +x

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
cp "${DOTFILES_DIR}/.vimrc" "${HOME}"
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
cd "$VIM_PLUGINS_DIR/coc.nvim" || exit 1
yarn install
cd - || exit 1

mkdir -p "$CONFIG_DIR/nvim"
cp "${DOTFILES_DIR}/init.vim" "${CONFIG_DIR}/nvim"
cp "${DOTFILES_DIR}/coc-settings.json" "${CONFIG_DIR}/nvim"
mkdir -p "$CONFIG_DIR/coc/extensions"
cd "$CONFIG_DIR/coc/extensions" || exit 1
if [ ! -f package.json ]
then
cat << EOF > package.json
{
  "dependencies": {
    "coc-css": ">=2.0.0",
    "coc-diagnostic": ">=0.23.4",
    "coc-git": ">=2.5.3",
    "coc-java": ">=1.5.5",
    "coc-json": ">=1.7.0",
    "coc-go": ">=1.3.0",
    "coc-pyright": ">=1.1.275",
    "coc-snippets": ">=3.1.4",
    "coc-solargraph": ">=1.2.4",
    "coc-yaml": ">=1.9.0",
    "coc-explorer": ">=0.25.4",
    "coc-sh": ">=0.7.0",
    "coc-xml": ">=1.14.1",
    "coc-tsserver": ">=2.1.3",
    "coc-eslint": ">=1.7.0",
    "coc-prettier": ">=9.3.2"
  },
  "lastUpdate": 1713703756777
}
EOF
fi
extensions=$(jq -r '.dependencies | keys | map("coc-" + .) | join(" ")' package.json)
yarn install $extensions
cd - || exit 1

##### ASDF setup
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

##### Workspace setup
cat <<EOF > "${HOME}/first-run.sh"
setup-workspace
setup-repo dogweb
EOF
} > install.log 2>&1
