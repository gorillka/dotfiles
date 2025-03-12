if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
fi

# ------------------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------------------
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

# ------------------------------------------------------------------------------
# Starship
# ------------------------------------------------------------------------------
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# ------------------------------------------------------------------------------
# zoxide - a better cd command
# ------------------------------------------------------------------------------
eval "$(zoxide init zsh)"

# ------------------------------------------------------------------------------
# fzf
# ------------------------------------------------------------------------------
# Set up fzf key bindings and fuzzy completion
if [[ -d $HOME/.fzf/bin ]] && [[ ! "$PATH" == */root/.fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}/root/.fzf/bin"
fi
source <(fzf --zsh)
eval "$(fzf --zsh)"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# ------------------------------------------------------------------------------
# -- Use fd instead of fzf --
# ------------------------------------------------------------------------------
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# ------------------------------------------------------------------------------
# ZSH Plugins
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# Activate autosuggestions
# ------------------------------------------------------------------------------
if [ -f "/opt/homebrew/bin/brew" ]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# ------------------------------------------------------------------------------
# Activate syntax highlighting
# ------------------------------------------------------------------------------
if [ -f "/opt/homebrew/bin/brew" ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# Change colors
# export ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue
# export ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue
# export ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue