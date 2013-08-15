# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

TERM="xterm-256color"
ZSH_THEME="candy"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git, django, command-not-found, pip, extract, sprunge)

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/plugins/git/git.plugin.zsh
alias gc='git commit -m'

# Customize to your needs...
#export PATH=/home/satshabad/.rvm/gems/ruby-1.9.3-p194/bin:/home/satshabad/.rvm/gems/ruby-1.9.3-p194@global/bin:/home/satshabad/.rvm/rubies/ruby-1.9.3-p194/bin:/home/satshabad/.rvm/bin:/home/satshabad/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/home/satshabad/bin:/usr/lib/jvm/java-6-oracle/bin:/home/satshabad/.rvm/bin



alias p="grep -l  "http://xyzzx.com/" * | xargs rm"


. ~/z.sh

set -o vi
alias e="vim ."
bindkey "^R" history-incremental-search-backward

export WORKON_HOME=~/envs

alias vimrc="vi ~/.vimrc"
alias vssh="vagrant ssh"
