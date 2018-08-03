__prompt() {
  local EXIT_CODE="$?"
  local base01='\[\e[1;31m\]'
  local base02='\[\e[1;32m\]'
  local base03='\[\e[1;33m\]'
  local base04='\[\e[1;34m\]'
  local base05='\[\e[1;35m\]'
  local base06='\[\e[1;36m\]'
  local base07='\[\e[1;37m\]'
  local base08='\[\e[1;30m\]'
  local reset='\[\e[0m\]'

  PS1="\n$base04\u$reset at $base06\h$reset in $base03\w"

  
  if [ $EXIT_CODE != 0 ]; then
    PS1="$PS1 $base01[$EXIT_CODE]\n$"
  else
    PS1="$PS1 $base05\n$"
  fi

  PS1="$PS1$reset "
}

export PROMPT_COMMAND=__prompt
