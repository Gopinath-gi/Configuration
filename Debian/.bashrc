export HISTDIR="/var/log/history"
export HISTFILE
export HISTSIZE=10000
export PROMPT_COMMAND="history -a"
REAL_USER=`who a mi | awk '{print $1}' | head -1`
[ -n "$WHOas" ] || export WHOas="${REAL_USER}.as.${LOGNAME}"
[ -d $HISTDIR ] || mkdir $HISTDIR
HISTFILE="$HISTDIR/.hist.${WHOas}.bash"
[ -f $HISTFILE ] || printf "\001\001\n\000\000" > $HISTFILE
echo "#\n# Begin $WHOas ($(tty)) on $(date +%m-%d-%Y@%T)" >> $HISTFILE
printf "\000\000" >> $HISTFILE
export PS1='[\u@\h \W]\$ ' EDITOR=vim

alias ls='ls --color'
alias grep='grep --color'
alias ts="tail -f /var/log/squid3/access.log"
alias sts="tail -f /var/log/dansguardian/access.log"
alias ss="tail -f /var/log/squidguard/squidGuard.log"
alias sb="tail -f /var/log/squidguard/blocked.log"
