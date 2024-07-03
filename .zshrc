source /home/bits/.config/dogweb.shellrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
. "$HOME/.asdf/asdf.sh"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

ZSH_THEME="powerlevel10k/powerlevel10k"

COMPLETION_WAITING_DOTS="true"

plugins=(
    asdf
    colorize
    colored-man-pages
    command-not-found
    docker
    docker-compose
    dotenv
    firewalld
    fzf
    gh
    git
    git-prompt
    pip
    sudo
    terraform
    themes
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

autoload -U compinit && compinit
export ZSH_DISABLE_COMPFIX=true
export DISABLE_UPDATE_PROMPT=true
source $ZSH/oh-my-zsh.sh

# User configuration

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export GITLAB_TOKEN=$(pass gitlab_token)

function lower {
    local to_lower="$1"
    echo "$to_lower" | tr "[:upper:]" "[:lower:]"
}

function get_fingerprint_sha1 {
    openssl pkcs8 -in $1 -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c
}

function updategit {
    local dir
    dir=${1:=.}
    for folder in "${dir}"/**/*; do
        if [[ "$folder" == './**/*' ]] || [[ -f "$folder" ]] || [[ ! -d "${folder}/.git" ]]; then
            continue
        fi
        cd "$folder"
        echo "Updating $folder"
        git pull --prune --tags
        cd - >/dev/null 2>&1
    done
}

function compress {
    local archive
    archive="$1"
    shift

    tar --use-compress-program="pigz --best --recursive | pv" -cf "$archive" $@
}

function _venv_vercomp {
    local version
    local target_version

    version="$1"
    target_version="$2"
    if [[ "$version" == "$target_version" ]]; then
        return 0
    fi

    if [[ "$(echo "$version" | cut -d. -f1-2)" == "$(echo "$target_version" | cut -d. -f1-2)" ]]; then
        return 1
    fi

    if [[ "$(echo "$version" | cut -d. -f1)" -ge "$(echo "$target_version" | cut -d. -f1)" ]]; then
        return 0
    fi
    return 2
}

function _update_venv {
    local venv_name
    local venv_version

    venv_name="$1"
    venv_version="$2"

    read "input?Do you want to do it ? (y|N)"
    input=$(echo "$input" | tr "[:lower:]" "[:upper:]")
    case $input in
        Y|YES)
            ;;
        *)
            return 0
    esac
    pyenv virtualenv-delete -f "$venv_name"
    pyenv virtualenv "$venv_version" "$venv_name"
    if [[ -f requirements.txt ]]; then
        pip install -r requirements.txt
    fi
}

function _create_venv {
    local venv_name
    local venv_version

    venv_name="$1"
    venv_version="$2"

    read "input?Do you want to do it ? (y|N)"
    input=$(echo "$input" | tr "[:lower:]" "[:upper:]")
    case $input in
        Y|YES)
            ;;
        *)
            return 0
    esac
    pyenv virtualenv "$venv_version" "$venv_name"
    if [[ -f requirements.txt ]]; then
        pip install -r requirements.txt
    fi
}

function updatevenvs {
    local target_version

    target_version="$1"
    if [[ "$target_version" == "" ]]; then
        echo "Missing version, aborting"
        return 1
    fi
    venvs=($(find ~/dd -name ".python-version"))

    for venv in "${venvs[@]}"; do
        cd "$(dirname "$venv")" || exit 1
        venv_name=$(cat .python-version)
        echo "$venv_name detected"
        version=$(python --version | cut -d" " -f2)
        _venv_vercomp "$version" "$target_version"
        case "$?" in
            0)
                echo "Nothing to do"
                ;;
            1)
                echo "Updating $venv_name from $version to $target_version"
                _update_venv "$venv_name" "$target_version"
                ;;
            2)
                echo "Creating $venv_name with version $target_version"
                _create_venv "$venv_name" "$target_version"
        esac
        cd - || exit 1
    done
}

function gen_gpg_key_for_export () {
    local key_name
    local real_name
    local email
    local validity
    local id

    key_name="$1"
    real_name="$2"
    email="$3"
    validity="$4"

    gpg --batch --gen-key <<EOF
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Name-Real: $real_name
Name-Email: $email
Expire-Date: $validity
EOF
    id="$(gpg --list-keys | tail -n 4 | sed -n 1p | awk '{print $1}')"
    gpg --export-secret-keys "$id" > "$key_name".public.pgp
    gpg --armor --export-secret-keys "$id" > "$key_name".public.asc.pgp
    gpg --armor --export "$id" > "$key_name".private.asc.pgp
    gpg --export "$id" > "$key_name".private.pgp
}

function sls_install_plugins () {
  plugins=$(yq '.plugins[]' $1)
  echo "Installing plugins ..."
  echo ${plugins[*]}
  echo "----------------------"
  echo ${plugins[*]} | xargs -I {} serverless plugin install -n '{}'
}

for env in "${HOME}/.env/"*.env; do
    source "$env"
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias ls="ls --color=auto"
alias ll="ls -l --color=auto"
alias la="ls -la --color=auto"
alias updatevim="updategit ~/.vim/pack/plugins"
alias cleangitbranch="git checkout -q master && git for-each-ref refs/heads/ \"--format=%(refname:short)\" | while read branch; do mergeBase=\$(git merge-base master \$branch) && [[ \$(git cherry master \$(git commit-tree \$(git rev-parse \$branch^{tree}) -p \$mergeBase -m _)) == "-"* ]] && git branch -D \$branch; done"
alias cdreal="cd \$(realpath \$(pwd))"
alias cdtoolbox="cd ~/go/src/github.com/DataDog/dd-go/apps/security-defense/toolbox"
alias v="nvim"
alias vim="nvim"
alias pipupdateall="pip freeze | awk -F'==' '{print \$1}' | grep -v corpit | xargs pip install --upgrade"
alias updatedogwebdeps="rake python:get_deps && rake python:install_local_deps"
