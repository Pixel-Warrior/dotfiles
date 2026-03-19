#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export bat="/sys/class/power_supply/BAT0"

PROMPT_COMMAND='exit_code=$?; [ -e "$bat" ] && chg_status=$(cat "${bat}/status") && export bat_level=$(cat "${bat}/capacity"); git_status=$(git branch --show-current 2> /dev/null)'

#Changing window title
PS1='\[\e]2;$TERM \w\a\]'

#Printing battery charge
PS1+='$([ "$chg_status" = "Discharging" ]&& echo "\[\e[31m\]" || echo "\[\e[32m\]")$([ -e "$bat" ] && echo "$bat_level% ")\[\e[0m\]'

#Printing name
PS1+='\[\e[90m\]$( [ "$(whoami)" = "root" ] && echo "\[\e[31m\]" )\u'

#Printing host and pwd
PS1+='\[\e[90m\]@\h \[\e[34m\]\W '

#Printing git branch
PS1+='\[\e[33m\]$git_status$([ ! -z $git_status ]&& echo " ")\[\e[0m\]'

#Printing exit code
PS1+='$([ $exit_code = "0" ]&& echo "\[\e[32m\]"|| echo "\[\e[31m\]$exit_code ")> \[\e[0m\]'

#Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ccat='highlight -O ansi --force'
