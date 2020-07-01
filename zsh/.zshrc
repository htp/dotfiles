# Use colors in `ls` output.
export CLICOLOR=1

# Turn on the completion system.
autoload -Uz compinit
compinit

# Enable showing version control information.
autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats       ' %F{blue}%c%u(%b%m)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{blue}%c%u(%b|%a%m)%f'
zstyle ':vcs_info:git:*' stagedstr     '%F{green}'
zstyle ':vcs_info:git:*' unstagedstr   '%F{red}'

zstyle ':vcs_info:git*+set-message:*' hooks git-ahead-behind
+vi-git-ahead-behind() {
  typeset ahead_behind
  typeset ahead
  typeset behind

  ahead_behind="$(command git rev-list --count --left-right HEAD...@{upstream} 2>/dev/null)"
  ahead="${ahead_behind[(w)1]}"
  behind="${ahead_behind[(w)2]}"

  if [[ "${ahead}" -eq 0 ]] && [[ "${behind}" -eq 0 ]]; then
    hook_com[misc]=""
  elif [[ "${ahead}" -gt 0 ]] && [[ "${behind}" -eq 0 ]]; then
    hook_com[misc]=" ${ahead}↑"
  elif [[ "${ahead}" -eq 0 ]] && [[ "${behind}" -gt 0 ]]; then
    hook_com[misc]=" ${behind}↓"
  elif [[ "${ahead}" -gt 0 ]] && [[ "${behind}" -gt 0 ]]; then
    hook_com[misc]=" ${ahead}↑ ${behind}↓"
  fi
}

# Treat #, ~, and ^ as parts of patterns.
setopt EXTENDED_GLOB

# Don't save consecutive duplicate commands to the history file.
setopt HIST_IGNORE_DUPS

# Don't record commands that start with a space.
setopt HIST_IGNORE_SPACE

# Remove superfluous blanks before recording commands.
setopt HIST_REDUCE_BLANKS

# Don't execute immediately after expanding history.
setopt HIST_VERIFY

# Write to the history file immediately (not when the shell exits).
setopt INC_APPEND_HISTORY

# Treat `%` specially in prompt expansion.
setopt PROMPT_PERCENT

# Perform parameter expansion, command substitution, and arithmetic expansion
# in prompts.
setopt PROMPT_SUBST

# Share history between all sessions.
setopt SHARE_HISTORY

# Configure history.
typeset HISTFILE="${HOME}/.history"
typeset HISTSIZE=65536
typeset SAVEHIST=65536

# Set left and right prompts.
typeset PROMPT=$'\n%(?.$(prompt_icon).%F{red}$(prompt_icon) (%?%)%f) %# '
typeset RPROMPT='$(prompt_pwd)${vcs_info_msg_0_}$(prompt_hostname)'

# Set color for suggested command completions.
typeset ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

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
  # Set the terminal title.
  echo -n "\e]0;${PWD}\a"

  # Set vcs_info_msg_0_.
  vcs_info
}

# Print the hostname when running in an SSH session; otherwise, print nothing.
prompt_hostname() {
  if [[ -n "${SSH_CONNECTION}" ]]; then
    echo " %F{magenta}(%m%)%f"
  else
    echo ""
  fi
}

# Print the place of interest character when running in an SSH session;
# otherwise, print a bullet.
prompt_icon() {
  echo "•"
}

# Print the current working directory, with ${HOME} replaced by ~,
# and with all but the last path component replaced by their respective
# first letters. Like Fish's prompt_pwd.
prompt_pwd() {
  local pwd="${PWD/#${HOME}/~}"
  echo "${pwd//(#b)([^\/]##)\//${match[1][1,1]}/}"
}

# Load chruby files when available.
for file in chruby auto; do
  if [[ -f "/usr/local/opt/chruby/share/chruby/${file}.sh" ]]; then
    source "/usr/local/opt/chruby/share/chruby/${file}.sh"
  fi
done

# Load plugins when available. Assumes plugins were installed by Homebrew.
for plugin in zsh-autosuggestions \
              zsh-history-substring-search \
              zsh-syntax-highlighting; do
  if [[ -f "/usr/local/share/${plugin}/${plugin}.zsh" ]]; then
    source "/usr/local/share/${plugin}/${plugin}.zsh"
  fi
done
