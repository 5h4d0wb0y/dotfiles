alias balls='git add . && git commit -S -m "misc: small fix or general refactoring" && git push'
alias apt_updater='apt update && apt full-upgrade -Vy && apt autoremove -y && apt autoclean && apt clean'

# List commit hashes
commits() {
  git log $1 --oneline --reverse | cut -d' ' -f 1 | tr '/n' ' '
}