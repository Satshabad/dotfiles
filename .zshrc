# Path to your oh-my-zsh configuration.
export RPS1="%{$reset_color%}"
ZSH=$HOME/.oh-my-zsh

TERM="xterm-256color"
ZSH_THEME="spaceship"

DISABLE_AUTO_UPDATE="true"

plugins=(git, command-not-found, pip, extract, sprunge, vi-mode, docker)

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/plugins/git/git.plugin.zsh

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/jvm/java-6-oracle/bin

. ~/z.sh

set -o vi
bindkey "^?" backward-delete-char

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# universe-specific
function restart-univ-containers() {
 if [[ $(docker ps -aq) ]]; then
   docker stop -t 1 $(docker ps -aq)
 fi
 docker system prune --force
 docker volume prune --force
 cd /home/satshabad/Projects/universe/orchestration
 export ARCH=x86
 make vessel backend socat_host jobs
 ./sim-and-backend.sh
 cd - >> /dev/null
}
alias re=restart-univ-containers

function restart-backend-containers() {
 if [[ $(docker ps -aq) ]]; then
   docker stop -t 1 $(docker ps -aq)
 fi
 docker system prune --force
 #docker volume prune --force
 cd /home/matt/universe/orchestration
 export ARCH=x86
 make backend
 make jobs
 ./backend.sh
 cd - >> /dev/null
}
alias we=restart-backend-containers

source ~/notifyyosd.zsh


# for vim plugin to search Stack Overflow
export GOOGLE_KEY="AIzaSyByykgD2caugd8B1wpPt_1tPwlIy4NcqHc"
export SE_KEY="eXh1Tjvp)m*fK)O)ui76cA(("

export PYTHONDONTWRITEBYTECODE=1

alias gmm='git merge master'
alias tf="tail -f"
alias zshrc="vim ~/.zshrc"
alias gc='git commit'
alias gdc='git diff --cached'
alias hpr='hub pull-request'
alias e="vim ."
alias vimrc="vim ~/.vimrc"
alias vssh="vagrant ssh"
alias v='f -e vim' # quick opening files with vim
export FZF_DEFAULT_COMMAND='ag -g ""'
alias t='tig'
alias f='vim $(fzf --preview="head -$LINES {}")'
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# fco - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fco() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
    branch=$(echo "$branches" |
    fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local branches target
  branches=$(
  git branch --all | grep -v HEAD |
    sed "s/.* //" | sed "s#remotes/[^/]*/##" |
    sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
  (echo "$branches") |
    fzf --no-hscroll --no-multi --delimiter="\t" -n 2 \
    --ansi --preview="git log -200 --pretty=format:%s $(echo {+2..} |  sed 's/$/../' )" ) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

gstash() {
  local out k reflog
  out=(
    $(git stash list --pretty='%C(yellow)%gd %>(14)%Cgreen%cr %C(blue)%gs' |
      fzf --ansi --no-sort --header='enter:show, ctrl-d:diff, ctrl-o:pop, ctrl-y:apply, ctrl-x:drop' \
          --preview='git stash show --color=always -p $(cut -d" " -f1 <<< {}) | head -'$LINES \
          --preview-window=down:50% --reverse \
          --bind='enter:execute(git stash show --color=always -p $(cut -d" " -f1 <<< {}) | less -r > /dev/tty)' \
          --bind='ctrl-d:execute(git diff --color=always $(cut -d" " -f1 <<< {}) | less -r > /dev/tty)' \
          --expect=ctrl-o,ctrl-y,ctrl-x))
  k=${out[0]}
  reflog=${out[1]}
  [ -n "$reflog" ] && case "$k" in
    ctrl-o) git stash pop $reflog ;;
    ctrl-y) git stash apply $reflog ;;
    ctrl-x) git stash drop $reflog ;;
  esac
}

eval $(thefuck --alias fix)
bindkey "^R" history-incremental-search-backward

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
#PYENV_VERSION="system"

export PATH="/home/satshabad/bin:/home/satshabad/.local/bin:$PATH"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
