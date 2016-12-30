# http://www.nparikh.org/unix/prompt.php

# use extended color pallete if available
if [[ $terminfo[colors] -ge 256 ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
    blue="%F{4}"
else
    turquoise="%F{cyan}"
    orange="%F{yellow}"
    purple="%F{magenta}"
    hotpink="%F{red}"
    limegreen="%F{green}"
    blue="%F{blue}"
fi

EMOJI=(🐦 🚀 🐞 🎨 🍕 🐭 👽 ☕️ 💀 🐷 🐼 🐶 🐸 🐧 🐳 🍔 🍣 🍻 🔮 💰 💎 💾 🍪 🌞 🐌 🐓 🍄 )

function random_emoji {
  echo -n "$EMOJI[$RANDOM%$#EMOJI+1]   "
}

function path {
    echo "%c " # %~ for the full path
}

function user_and_host {
    echo "%n@%m "
}

local git_info='$(git_prompt_info) '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$purple%}[%{$turquoise%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$purple%}] %{$orange%}⚡%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$purple%}]"

PROMPT="\
$(random_emoji)\
%{$limegreen%}$(path)%{$reset_color%}\
%{$turquoise%}${git_info}%{$reset_color%}"
# %{$blue%}$(user_and_host)%{$reset_color%}\
