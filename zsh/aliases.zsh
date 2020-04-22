alias vim="nvim"

alias l="ls -lhF"
alias la="ls -lhAF"
alias rmf="rm -rf"

# tmux aliases
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig wlp58s0 | sed -n '2s/[^:]*:\([^ ]*\).*/\1/p'"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

