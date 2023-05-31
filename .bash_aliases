alias please="sudo"
alias cls="clear"
alias ping="ping -c 4"
alias zshconfig="nano ~/.zshrc"
alias ls="exa -a --long"
# Git
alias yeet="git push"
alias yoink="git stash && git pull && git stash pop"
alias gst="git status"
alias yolo='git commit -m "$(curl -s https://whatthecommit.com/index.txt)"'
alias unfuck="git reset HEAD --hard"
alias unfuck-node="rm -rf node_modules && npm i"
# Docker and updates
alias docker-cleanup="docker system prune -f"
alias system-update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
alias brew-update="brew update && brew upgrade && brew cleanup"
alias docker-compose="docker compose"
