# ============================================================================
# Shell Configuration
# ============================================================================
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY AUTO_CD

# ============================================================================
# PATH Configuration
# ============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:/usr/local/go/bin"

# ============================================================================
# Ghostty Terminal Integration
# ============================================================================
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
    source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# ============================================================================
# Zinit (Plugin Manager)
# ============================================================================
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ============================================================================
# Zsh Plugins (deferred for performance)
# ============================================================================
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-completions

# ============================================================================
# FZF Configuration
# ============================================================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS=" \
  --color=bg:-1,bg+:#1e1e2e \
  --color=fg:#cdd6f4,fg+:#cdd6f4 \
  --color=hl:#f38ba8,hl+:#f38ba8 \
  --color=border:#313244,separator:#313244,scrollbar:#313244 \
  --color=label:#cdd6f4,query:#cdd6f4 \
  --color=info:#cba6f7,prompt:#cba6f7,pointer:#f5c2e7 \
  --color=marker:#a6e3a1,spinner:#f5c2e7,header:#89b4fa \
  --border=rounded \
  --border-label='' \
  --padding=1 \
  --margin=1 \
  --prompt='  ' \
  --pointer='▌' \
  --marker='●' \
  --separator='─' \
  --scrollbar='▐' \
  --info=right"

# ============================================================================
# Aliases
# ============================================================================
alias ls="eza -a --icons"
alias notepad="gnome-text-editor"
alias wg="wordgrinder"
alias desk="cd ~/Desktop/"
alias proj="cd ~/Desktop/projects"
alias docs="cd ~/Documents/"
alias dl="cd ~/Downloads/"
alias cd="z"
# ============================================================================
# Shell Initializations
# ============================================================================
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# bun completions
[ -s "/home/den/.bun/_bun" ] && source "/home/den/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
