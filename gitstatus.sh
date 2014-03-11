GITPREFIX="\[$(tput setaf 2)\][\A] \[$(tput bold)\]\[$(tput setaf 0)\]\u@\[$(tput setaf 0)\]\h \[$(tput setaf 4)\]\w $(tput sgr0)"
GITSUFFIX="$ \[$(tput sgr0)\]"

export GITSTATUS
export HAVE_GIT=0
export GIT_TOP_LEVEL

PROMPT=$PS1

set_git_prompt () {
PS1="$GITPREFIX
$GITSTATUS
$GITSUFFIX"
}

cd () {
         builtin cd "$@"
         if ! git status &>/dev/null; then
                 PS1=$PROMPT
                 export HAVE_GIT=0
                 export GIT_TOP_LEVEL=""
         else
                 export HAVE_GIT=1
                 if ! [[ $GIT_TOP_LEVEL = $(git rev-parse --show-toplevel) ]]; then
                         export GIT_TOP_LEVEL=$(git rev-parse --show-toplevel)
                         export  GITSTATUS=$(~/bin/gitstatus)
                 fi
				 set_git_prompt
         fi
}
g () {
         :
}


last_command () {
         last_cmd="$(fc -ln -1 | awk '{print $1}')"
         case "$last_cmd" in
                 vim)
                         ;&
                 g)
                         ;&
                 rm)
                         ;&
                 cp)
                         ;&
                 mv)
                         ;&
                 touch)
                         ;&
                 git)
                         if ! git status &>/dev/null; then
                                 PS1=$PROMPT
                         else
					         export  GITSTATUS=$(~/bin/gitstatus)
							 set_git_prompt
                         fi
                 ;;
                 *)
                         if [[ $HAVE_GIT = 0 ]] ; then
                                 PS1=$PROMPT
                         else
							 set_git_prompt
                         fi
;;

         esac
}
PROMPT_COMMAND=last_command

