# ------------------------------------------------------------------------------
# Git
# ------------------------------------------------------------------------------
alias g='git'
alias ga='git add'
alias gafzf='git ls-files -m -o --exclude-standard | grep -v "__pycache__" | fzf -m --print0 | xargs -0 -o -t git add' # Git add with fzf
alias grmfzf='git ls-files -m -o --exclude-standard | fzf -m --print0 | xargs -0 -o -t git rm' # Git rm with fzf
alias grfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore' # Git restore with fzf
alias grsfzf='git diff --name-only | fzf -m --print0 | xargs -0 -o -t git restore --staged' # Git restore --staged with fzf
alias gf='git fetch'
alias gs='git status'
alias gss='git status -s'
alias gup='git fetch && git rebase'
alias gtd='git tag --delete'
alias gtdr='git tag --delete origin'
alias glo='git pull origin'
alias gl='git pull'
alias gb='git branch '
alias gbr='git branch -r'
alias gd='git diff'
alias gco='git checkout '
alias gcob='git checkout -b '
alias gcofzf='git branch | fzf | xargs git checkout' # Select branch with fzf
alias gre='git remote'
alias gres='git remote show'
alias glgg='git log --graph --max-count=5 --decorate --pretty="oneline"'
alias gm='git merge'
alias gp='git push'
alias gpo='git push origin'
alias ggpush='git push origin $(current_branch)'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gcmnv='git commit --no-verify -m'
alias gcanenv='git commit --amend --no-edit --no-verify'
alias gqc='quick_commit'
alias gqcp='quick_commit push'

# ------------------------------------------------------------------------------
# eza (better `ls`)
# ------------------------------------------------------------------------------
alias l="eza --icons"
alias ls="eza --icons"
alias ll="eza -lg --icons"
alias la="eza -lag --icons"
alias lt="eza -lTg --icons"
alias lt1="eza -lTg --level=1 --icons"
alias lt2="eza -lTg --level=2 --icons"
alias lt3="eza -lTg --level=3 --icons"
alias lta="eza -lTag --icons"
alias lta1="eza -lTag --level=1 --icons"
alias lta2="eza -lTag --level=2 --icons"
alias lta3="eza -lTag --level=3 --icons"

# ------------------------------------------------------------------------------
# Vim
# ------------------------------------------------------------------------------
alias vim="nvim"
alias vi="nvim"
alias n="nvim"

# ------------------------------------------------------------------------------
# Other aliases
# ------------------------------------------------------------------------------
alias ks="tmux kill-server"
alias cat="bat"
alias lazygit="lazygit --use-config-file='$XDG_CONFIG_HOME/lazygit/config.yml'"
alias tc="clean"
alias ta="tmux attach"

alias gh="z"