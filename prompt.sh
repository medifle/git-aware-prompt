# https://github.com/jimeh/git-aware-prompt/pull/67
NEED_GIT_STATUS=true

calc_git() {
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    git_branch="($branch)"
    if [[ $NEED_GIT_STATUS ]]; then
      local status=$(git status --porcelain 2> /dev/null)
      if [[ "$status" != "" ]]; then
        git_dirty='*'
      else
        git_dirty=''
      fi
    fi
  else
    git_branch=''
    git_dirty=''
  fi
}

function shortwd() {
  num_dirs=3
  pwd_symbol="..."
  newPWD="${PWD/#$HOME/~}"
  if [ $(echo -n $newPWD | awk -F '/' '{print NF}') -gt $num_dirs ]; then
    newPWD=$(echo -n $newPWD | awk -F '/' '{print $1 "/.../" $(NF-1) "/" $(NF)}')
  fi
}

PROMPT_COMMAND="calc_git; shortwd; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
#export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
export PS1="\u@\h:\$newPWD \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
#export PS1="\u@\h:\$newPWD \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\\n\$ "

# Another variant:
# export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
