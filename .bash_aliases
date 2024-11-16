# Misc
alias please="sudo"
alias cls="clear"
alias ping="ping -c 2"
alias zshconfig="nano ~/.zshrc"
alias ls="eza -la --git --icons"
alias rm="rm -fv"
alias tf="terraform"
alias k="kubectl"
alias unfuck-node="rm -rf node_modules && yarn install"
alias delete-zone='find . -name "*Zone.Identifier" -type f -delete'

# Git
alias yeet="git push"
alias yoink="git stash && git pull && git stash pop"
alias gst="git status"
alias yolo='git commit -am "$(curl -s https://whatthecommit.com/index.txt)" && git push'
alias unfuck="git reset HEAD --hard"

# Docker and updates
alias docker-cleanup="docker system prune -f"
alias docker-purge='docker rmi $(docker images -aq) && docker system prune -f'
alias system-update="sudo nala full-upgrade -y"
alias brew-update="brew update && brew upgrade && brew cleanup"
