#!/bin/bash

cd "$(dirname "$BASH_SOURCE")"
declare -a TOOLS=()

# ANSI/VT100 Terminal Control Escape Sequences
# Set color codes
BOLD="$(tput bold)" # bold style
RED="$(tput setaf 1)" # red color
GREEN="$(tput setaf 2)" # green color
YELLOW="$(tput setaf 3)" # yellow color
BLUE="$(tput setaf 4)" # blue color
WHITE="$(tput setaf 7)" # white color
RESET="$(tput sgr0)" # reset everything 

## function to print tool options
function print_menu {
  clear
  INDEX=1
  echo "${YELLOW}"
  echo "╔═════════════════════════════════╗"
  echo "║          Available Tools        ║"
  echo "╚═════════════════════════════════╝"
  echo "${RESET}"

  for dir in */; do
    dir=${dir%*/}
    if [[ "$dir" != "Example" && "$dir" != "excluded_dir2" ]]; then
      TOOLS[INDEX]=$dir
      echo "${GREEN}${BOLD}$INDEX) $dir${RESET}"
      ((INDEX++))
    fi
  done
  echo "${BLUE}${BOLD}$INDEX) Exit${RESET}"   ## Add Exit option
  echo "Please enter the number of your choice:"
}

print_menu

while :; do
  read INPUT
  if [[ "$INPUT" =~ ^[0-9]+$ && $INPUT -ge 1 && $INPUT -lt $INDEX ]]; then
    TOOL=${TOOLS[$INPUT]}
    echo "${WHITE}Opening tool: $TOOL${RESET}"
    source ./$TOOL/main.sh
    print_menu
  elif [ $INPUT -eq $INDEX ]; then
    break   ## Exit when 'Exit' option is selected
  else
    echo "${RED}Invalid input. Please enter a valid number.${RESET}"
  fi
done