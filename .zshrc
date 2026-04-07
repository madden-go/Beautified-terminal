# ── History ────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY AUTO_CD

# ── PATH (single declaration, no duplicates) ───────────────
export PATH="/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin:/opt/nvim/bin:$HOME/.bun/bin:/usr/local/bin:$PATH"

# ── Bun ────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ── NVM (lazy — loads only when first needed) ──────────────
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { nvm; node "$@"; }
npm()  { nvm; npm  "$@"; }
npx()  { nvm; npx  "$@"; }

# ── Zinit ──────────────────────────────────────────────────
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Annexes (required, loaded eagerly)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Plugins (deferred — shell is usable immediately)
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-completions

# ── Aliases ────────────────────────────────────────────────
alias ls="eza -a --icons"
alias notepad="gnome-text-editor"
alias editor="gnome-text-editor"   # fixed typo: was editor-

# ── Prompt (Starship) ──────────────────────────────────────
eval "$(starship init zsh)"
