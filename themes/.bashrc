#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='\e[0;90m┬─[\@\u: \W]\n╰─> \# $ '

fastfetch
fish
