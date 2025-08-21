# prompt style and colors based on Steve Losh's Prose theme:
# https://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# https://briancarper.net/blog/570/git-info-in-your-zsh-prompt

#use extended color palette if available
if [[ $TERM = (*256color|*rxvt*|*kitty) ]]; then
  fb="%{${(%):-"%F{0}"}%}"
  fp="%{${(%):-"%F{196}"}%}"
  fs="%{${(%):-"%F{160}"}%}"
  ft="%{${(%):-"%F{124}"}%}"
  bb="%{${(%):-"%K{0}"}%}"
  bp="%{${(%):-"%K{196}"}%}"
  bs="%{${(%):-"%K{160}"}%}"
  bt="%{${(%):-"%K{124}"}%}"
else
  fb="%{${(%):-"%F{black}"}%}"
  fp="%{${(%):-"%F{brightred}"}%}"
  fs="%{${(%):-"%F{red}"}%}"
  ft="%{${(%):-"%F{red}"}%}"
  bb="%{${(%):-"%K{black}"}%}"
  bp="%{${(%):-"%K{brightred}"}%}"
  bs="%{${(%):-"%K{red}"}%}"
  bt="%{${(%):-"%K{red}"}%}"
fi

ssh_info=""
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  ssh_info="%B${fb}${bp}⧉ $(whoami) %b%{$reset_color%} "
fi

autoload -Uz vcs_info
# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%{${reset_color}%}"
FMT_BRANCH=" %B${fb}${bs} %b %%b%k%u%c${PR_RST}"
FMT_ACTION=" performing a ${fp}%a${PR_RST}"
FMT_UNSTAGED="%B${fp} M%b"
FMT_STAGED="%B${fp} S%b"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function steeef_chpwd {
  PR_GIT_UPDATE=1
}

function steeef_preexec {
  case "$2" in
  *git*|*svn*) PR_GIT_UPDATE=1 ;;
  esac
}

function steeef_precmd {
  (( PR_GIT_UPDATE )) || return

  # check for untracked files or updated submodules, since vcs_info doesn't
  if [[ -n "$(git ls-files --other --exclude-standard 2>/dev/null)" ]]; then
    PR_GIT_UPDATE=1
    FMT_BRANCH="${PR_RST} %B${fb}${bs} %b %%b%k ${fp}●${PR_RST}"
  #else
  #  FMT_BRANCH="${PR_RST} ${bt} %b %k%u%c${PR_RST}"
  fi
  zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"

  vcs_info 'prompt'
  PR_GIT_UPDATE=
}

# vcs_info running hooks
PR_GIT_UPDATE=1

autoload -U add-zsh-hook
add-zsh-hook chpwd steeef_chpwd
add-zsh-hook precmd steeef_precmd
add-zsh-hook preexec steeef_preexec

# ruby prompt settings
ZSH_THEME_RUBY_PROMPT_PREFIX="with%F{red} "
ZSH_THEME_RUBY_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_RVM_PROMPT_OPTIONS="v g"

# virtualenv prompt settings
ZSH_THEME_VIRTUALENV_PREFIX=" with%F{red} "
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}"

setopt prompt_subst
PROMPT="${ssh_info}${fp}%~%{$reset_color%}\$(virtualenv_prompt_info)\$(ruby_prompt_info)\$vcs_info_msg_0_${fp} 💾%#%{$reset_color%} "
