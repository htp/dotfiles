# Use colors in `ls` output.
export CLICOLOR=1

# Turn on the completion system.
autoload -Uz compinit
compinit

# Enable showing version control information.
autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats       ' %F{blue}%c%u(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{blue}%c%u(%b|%a)%f'
zstyle ':vcs_info:git:*' stagedstr     '%F{green}'
zstyle ':vcs_info:git:*' unstagedstr   '%F{red}'

# Treat #, ~, and ^ as parts of patterns.
setopt EXTENDED_GLOB

# Treat `%` specially in prompt expansion.
setopt PROMPT_PERCENT

# Perform parameter expansion, command substitution,and arithmetic expansion
# in prompts.
setopt PROMPT_SUBST

# Set left and right prompts.
typeset PROMPT=$'\n%(?.•.%F{red}• (%?%)%f) %# '
typeset RPROMPT='$(prompt_pwd)${vcs_info_msg_0_}'

# Set color for suggested command completions.
typeset ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

# Set colors for command highlighting.
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[arg0]='fg=0,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=0,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=0,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=3'
ZSH_HIGHLIGHT_STYLES[default]='fg=6'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=6'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=1'
ZSH_HIGHLIGHT_STYLES[function]='fg=0,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=6'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=6'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=0,bold'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=3'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=3'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=6'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=1'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=4'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=0,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=1'

# Perform work just before the prompt is displayed.
precmd() {
  vcs_info
}

# Print the current working directory, with ${HOME} replaced by ~,
# and with all but the last path component replaced by their respective
# first letters. Like Fish's prompt_pwd.
prompt_pwd() {
  local pwd="${PWD/#${HOME}/~}"
  echo "${pwd//(#b)([^\/]##)\//${match[1][1,1]}/}"
}

# Load plugins if available. Assumes plugins were installed by Homebrew.
for plugin in zsh-autosuggestions \
              zsh-history-substring-search \
              zsh-syntax-highlighting; do
  if [[ -f "/usr/local/share/${plugin}/${plugin}.zsh" ]]; then
    source "/usr/local/share/${plugin}/${plugin}.zsh"
  fi
done