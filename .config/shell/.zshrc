# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# use the $EDITOR when opening text files
export NNN_USE_EDITOR=1
# use a different color for each context
export NNN_CONTEXT_COLORS="5132"
# trash (needs trash-cli) instead of delete
export NNN_TRASH=1

# enable colors and change prompt:
autoload -U colors && colors

# essentially syncs history between shells
setopt INC_APPEND_HISTORY
# when adding a new entry to history remove any currently present duplicate
setopt HIST_IGNORE_ALL_DUPS
# don't record lines starting with a space in the history
setopt HIST_IGNORE_SPACE

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="$XDG_DATA_HOME"/zhistory

#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

if [ "$LOGNAME" = "root" ] || [ "$(id -u)" -eq 0 ]; then
	PS1="%B%{$fg[red]%}%~%{$reset_color%} "
	#PS1="%B%{$fg[red]%}%~ %{$fg[green]%}>%{$fg[yellow]%}>%{$fg[blue]%}> %{$reset_color%}%b"
else		
	PS1="%B%{$fg[green]%}%~%{$reset_color%} "
	#PS1="%B%{$fg[green]%}%~ %{$fg[red]%}>%{$fg[yellow]%}>%{$fg[blue]%}> %{$reset_color%}%b"
fi

# Automatically cd into typed directory.
setopt autocd		
# Disable ctrl-s to freeze terminal.
stty stop undef	
# disable ctrl-S/ctrl-Q for START/STOP
#stty -ixon -ixoff
setopt interactive_comments
# beeping is annoying
unsetopt beep

autoload -U compinit
#&& compinit -u
zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
# Include hidden files.
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

# Enable searching through history
bindkey '^R' history-incremental-pattern-search-backward

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^k" up-line-or-beginning-search # Up
bindkey "^j" down-line-or-beginning-search # Down

# bug you have to press two times
#autoload -U history-search-end
#zle -N history-beginning-search-backward-end history-search-end
#zle -N history-beginning-search-forward-end history-search-end
#bindkey "^[[A" history-beginning-search-backward-end
#bindkey "^[[B" history-beginning-search-forward-end

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

#bindkey -s "^n" "kak $(fzf)^M"

# initalize zoxide
eval "$(zoxide init zsh)"
#eval "$(zoxide init --cmd y zsh)"
eval "$(dircolors /etc/DIR_COLORS)"

# source aliases and some functions which work like aliases
# it is also sourced by bash
[ -f "$ZDOTDIR/aliasrc" ] && source "$ZDOTDIR/aliasrc"

# source functions
# it is also sourced by bash
[ -f "$ZDOTDIR/functionrc" ] && source "$ZDOTDIR/functionrc"

# source functions specific to zsh
[ -f "$ZDOTDIR/zfuncrc" ] && source "$ZDOTDIR/zfuncrc"

# fzf
#[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
#[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh

# intialize autosuggestions plugin with base01 as color and ctrl-N to accept
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10,bold"
#ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^o' autosuggest-accept

# initalize syntax highlighting and customize colors
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
#ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
typeset -A ZSH_HIGHLIGHT_STYLES

# this have to be customized
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=12,bold' # base0
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=2,bold' # green
ZSH_HIGHLIGHT_STYLES[precommand]='fg=2,bold' # green
ZSH_HIGHLIGHT_STYLES[path]='fg=12,bold' # base0
ZSH_HIGHLIGHT_STYLES[globbing]='fg=3,bold' # yellow
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=12,bold' # base0
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=12,bold' # base0
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=12,bold' # base0
ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=12,bold' # base0
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=9,bold' # orange
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=9,bold' # orange
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=9,bold' # orange
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=12,bold' # base0
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=9,bold' # orange
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=12,bold' # base0
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=9,bold' # orange
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=9,bold' # orange
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=6,bold' # cyan
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=6,bold' # cyan
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=6,bold' # cyan
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=6,bold' # cyan
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=6,bold' # cyan
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=6,bold' # cyan
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=9,bold' # orange
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=1,bold' # red
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=1,bold' # red
ZSH_HIGHLIGHT_STYLES[redirection]='fg=2,bold' # green
ZSH_HIGHLIGHT_STYLES[default]='fg=12,bold' # base0

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
