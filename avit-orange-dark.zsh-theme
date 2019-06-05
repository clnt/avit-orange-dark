# AVIT ZSH Theme

PROMPT='
$(_user_host)${_current_dir} $(git_prompt_info) $(_ruby_version)
%{$FG[$CARETCOLOR]%}▶%{$resetcolor%} '

PROMPT2='%{$FG[$CARETCOLOR]%}◀%{$reset_color%} '

RPROMPT='$(_vi_status)%{$(echotc UP 1)%}$(_git_time_since_commit) $(git_prompt_status) ${_return_status}%{$(echotc DO 1)%}'

local _current_dir="%{$FX[bold]$FG[202]%}%3~%{$reset_color%} "
local _return_status="%{$FX[bold]$FG[001]%}%(?..⍉)%{$reset_color%}"
local _hist_no="%{$FG[249]%}%h%{$reset_color%}"

function _current_dir() {
  local _max_pwd_length="65"
  if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
    echo "%{$FX[bold]$FG[202]%}%-2~ ... %3~%{$reset_color%} "
  else
    echo "%{$FX[bold]$FG[202]%}%~%{$reset_color%} "
  fi
}

function _user_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$FG[202]%}$me%{$reset_color%}:"
  fi
}

function _vi_status() {
  if {echo $fpath | grep -q "plugins/vi-mode"}; then
    echo "$(vi_mode_prompt_info)"
  fi
}

function _ruby_version() {
  if {echo $fpath | grep -q "plugins/rvm"}; then
    echo "%{$FG[249]%}$(rvm_prompt_info)%{$reset_color%}"
  elif {echo $fpath | grep -q "plugins/rbenv"}; then
    echo "%{$FG[249]%}$(rbenv_prompt_info)%{$reset_color%}"
  fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function _git_time_since_commit() {
# Only proceed if there is actually a commit.
  if last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null); then
    now=$(date +%s)
    seconds_since_last_commit=$((now-last_commit))

    # Totals
    minutes=$((seconds_since_last_commit / 60))
    hours=$((seconds_since_last_commit/3600))

    # Sub-hours and sub-minutes
    days=$((seconds_since_last_commit / 86400))
    sub_hours=$((hours % 24))
    sub_minutes=$((minutes % 60))

    if [ $hours -ge 24 ]; then
      commit_age="${days}d"
    elif [ $minutes -gt 60 ]; then
      commit_age="${sub_hours}h${sub_minutes}m"
    else
      commit_age="${minutes}m"
    fi

    color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL
    echo "$color$commit_age%{$reset_color%}"
  fi
}

if [[ $USER == "root" ]]; then
  CARETCOLOR=001
else
  CARETCOLOR=202
fi

MODE_INDICATOR="%{$FX[bold]$FG[226]%}❮%{$reset_color%}%{$FG[226]%}❮❮%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[046]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[196]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$FG[046]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[046]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[226]%}⚑ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[196]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[045]%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[081]%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[007]%}◒ "

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$FG[046]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$FG[226]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$FG[196]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$FG[007]%}"

# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'

