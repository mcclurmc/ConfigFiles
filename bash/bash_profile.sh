# Common settings for my .bashrc scripts. Source this at the end of .bashrc.

# Aliases
alias ec='emacsclient -n'
alias ect='emacsclient -c -t'
alias ecw='emacsclient -c -n'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color'
alias ec='emacsclient -n'
alias em='emacs -nw -q'
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
alias pd='pushd -0'
alias df='df --si'
alias du='du --si'

# Exports
export DEBEMAIL="mike.mcclurg@citrix.com"
export DEBFULLNAME="Mike McClurg"
export EDITOR=/usr/bin/vim
export GIT_USER=mcclurmc
export GOPATH=~/go

# Set path
PATH=~/Dropbox/bin:${PATH}
PATH=~/bin:${PATH}
PATH=${GOPATH}/bin:${PATH}
PATH=${PATH}:/sbin:/usr/sbin
PATH=${PATH}:~/mir-inst/bin/
PATH=${PATH}:~/.cabal/bin/
PATH=${PATH}:/home/mike/Projects/Oxford/bin
PATH=${PATH}:/home/mike/Dropbox/Coursera/Scala/sbt/bin
PATH=${PATH}:/opt/mongo/bin/
PATH=/opt/qt5/bin:${PATH}
export PATH

# Show git branch on PS
[ -f .bash_pimp_prompt.sh ] && . .bash_pimp_prompt.sh # ~/Dropbox/conf/bash_pimp_prompt.sh

#export OCAMLPATH=/usr/lib/ocaml/:/usr/lib/ocaml/METAS/:/usr/lib/ocaml/xcp/

# For Oxford CSP apps
export FDRHOME=/home/mike/Projects/Oxford/fdr-2.91-academic-linux64
export TRANSITHOME=~/Projects/Oxford/transit-0.2c
export FDRGRAPH=true
export FDRPAGEDIRS=/tmp

# Tomcat
CATALINA_HOME=/usr/share/tomcat6
CATALINA_ROOT=/usr/share/tomcat6

# Opam
which opam &> /dev/null && eval `opam config -env`
