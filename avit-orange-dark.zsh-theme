# AVIT ZSH Theme

PROMPT='
$(_user_host)${_current_dir} $(git_prompt_info) $(_ruby_version)
%{$fg[$CARETCOLOR]%}▶%{$resetcolor%} '

PROMPT2='%{$fg[$CARETCOLOR]%}◀%{$reset_color%} '

RPROMPT='$(_vi_status)%{$(echotc UP 1)%}$(_git_time_since_commit) $(git_prompt_status) ${_return_status}%{$(echotc DO 1)%}'

#local _current_dir="%{$fg_bold[$AVIT_THEME_COLOR_BLUE]%}%3~%{$reset_color%} "
local _current_dir="%{[01$fg_bold[$AVIT_THEME_COLOR_ORANGE]%3~%{$reset_color%} "
local _return_status="%{$fg_bold[$AVIT_THEME_COLOR_RED]%}%(?..⍉)%{$reset_color%}"
local _hist_no="%{$fg[$AVIT_THEME_COLOR_GREY]%}%h%{$reset_color%}"

function _current_dir() {
  local _max_pwd_length="65"
  if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
    echo "%{$fg_bold[$AVIT_THEME_COLOR_ORANGE]%}%-2~ ... %3~%{$reset_color%} "
  else
    echo "%{$fg_bold[$AVIT_THEME_COLOR_ORANGE]%}%~%{$reset_color%} "
  fi
}

function _user_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[$AVIT_THEME_COLOR_ORANGE]%}$me%{$reset_color%}:"
  fi
}

function _vi_status() {
  if {echo $fpath | grep -q "plugins/vi-mode"}; then
    echo "$(vi_mode_prompt_info)"
  fi
}

function _ruby_version() {
  if {echo $fpath | grep -q "plugins/rvm"}; then
    echo "%{$fg[$AVIT_THEME_COLOR_GREY]%}$(rvm_prompt_info)%{$reset_color%}"
  elif {echo $fpath | grep -q "plugins/rbenv"}; then
    echo "%{$fg[$AVIT_THEME_COLOR_GREY]%}$(rbenv_prompt_info)%{$reset_color%}"
  fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function _git_time_since_commit() {
# Only proceed if there is actually a commit.
  if git log -1 > /dev/null 2>&1; then
    # Get the last commit.
    last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null)
    now=$(date +%s)
    seconds_since_last_commit=$((now-last_commit))

    # Totals
    minutes=$((seconds_since_last_commit / 60))
    hours=$((seconds_since_last_commit/3600))

    # Sub-hours and sub-minutes
    days=$((seconds_since_last_commit / 86400))
    sub_hours=$((hours % 24))
    sub_minutes=$((minutes % 60))

    if [ $hours -gt 24 ]; then
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

for color in {000..255}; do
    $fg[$color]="%{[38;5;${color}m%}"
done

for color in {000..255}; do
    $fg_bold[$color]="%{[01${color}m%}"
done

MODE_INDICATOR="%{$fg_bold[$AVIT_THEME_COLOR_YELLOW]%}❮%{$reset_color%}%{$fg[$AVIT_THEME_COLOR_YELLOW]%}❮❮%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[$AVIT_THEME_COLOR_GREEN]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[$AVIT_THEME_COLOR_RED]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[$AVIT_THEME_COLOR_GREEN]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[$AVIT_THEME_COLOR_GREEN]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[$AVIT_THEME_COLOR_YELLOW]%}⚑ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[$AVIT_THEME_COLOR_RED]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[$AVIT_THEME_COLOR_BLUE]%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[$AVIT_THEME_COLOR_CYAN]%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[$AVIT_THEME_COLOR_WHITE]%}◒ "

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[$AVIT_THEME_COLOR_GREEN]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[$AVIT_THEME_COLOR_YELLOW]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[$AVIT_THEME_COLOR_RED]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[$AVIT_THEME_COLOR_WHITE]%}"

AVIT_THEME_COLOR_RED=001
AVIT_THEME_COLOR_GREEN=046
#AVIT_THEME_COLOR_YELLOW=226 Bright
AVIT_THEME_COLOR_YELLOW=184
#AVIT_THEME_COLOR_BLUE=012
AVIT_THEME_COLOR_BLUE=202
AVIT_THEME_COLOR_WHITE=007
AVIT_THEME_COLOR_CYAN=202
#AVIT_THEME_COLOR_CYAN=014
AVIT_THEME_COLOR_GREY=249
#AVIT_THEME_COLOR_ORANGE=166 darker
AVIT_THEME_COLOR_ORANGE=202

# LS colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'
