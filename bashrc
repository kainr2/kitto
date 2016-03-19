# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return


#################
## LINUX
#################
# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

# Lots of history
export HISTSIZE=10000
export HISTFILESIZE=1000000

# Common alias
alias ls='ls -hF --color=tty'   # classify files in colour
alias ll='ls -l';
alias la='ls -A';
alias rm='rm -i';
alias vi='vim';
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'


# Grep
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Make sudo like normal
# http://serverfault.com/questions/203988/why-do-i-not-have-syntax-highlighting-when-i-sudo-vi-filename
alias sudo='sudo '

# Command prompt
###PS1="\[\033]0;$MSYSTEM:\w\007 \033[32m\]\u@\h \[\033[33m\w$(__git_ps1)\033[0m\] $"
###PS1="\[\033]0;$MSYSTEM:\w\007\033[32m\]\e[0;36m[\T][\u@\h]\e[m \[\033[33m\w \033[0m\] \n$ "
###PS1="\[\033[36m\][\$(date +%H:%M:%S)] \[\033[32m\][\w]$ \[\033[0m\]"
###PS1="\[\033[36m\][\$(date +%H:%M:%S)]\[\033[32m\] \w $ \[\033[0m\]"
PS1="\[\033[36m\][\T]\[\033[32m\] \w $ \[\033[0m\]"

# Directory memory
# pushd/popd/dirs
alias dirs='dirs -v'
function goto() { cd "${DIRSTACK[$@]}"; }


#################
## Cygwin only
#################
# Use d2u to convert a binary text file to ascii text file
# $ d2u hello.cpp

# add to path
export PATH=/bin:/usr/local/bin:$PATH