#!/bin/bash

declare -a TOOLS=()

# Get the directory path of the executing script
SCRIPT_DIR="$(dirname "$BASH_SOURCE")"

# Set color codes
BOLD="$(tput bold)" 
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)" 

## function to print tool options
function print_submenu {
  clear
  INDEX=1
  echo "${YELLOW}"
  echo "╔══════════════════════════╗"
  echo "║     Available Tools      ║"
  echo "╚══════════════════════════╝"
  echo "${RESET}"
  
  for file in "$SCRIPT_DIR"/lib/* ; do
    if [ -f "$file" ]; then
      filename=$(basename -- "$file")
      filename="${filename%.*}"
      if [[ "$filename" != "exclude_tool1" && "$filename" != "exclude_tool2" ]]; then
        TOOLS[INDEX]=$filename
        echo "${GREEN}${BOLD}$INDEX) $filename${RESET}"
        ((INDEX++))
      fi
    fi
  done
  echo "${BLUE}${BOLD}$INDEX) Return${RESET}"   ## Add Return option
  echo "Please enter the number of your choice:"
}

print_submenu

while :; do
  read INPUT
  if [[ "$INPUT" =~ ^[0-9]+$ && $INPUT -ge 1 && $INPUT -lt $INDEX ]]; then
    TOOL=${TOOLS[$INPUT]}
    echo "${WHITE}Running tool: $TOOL${RESET}"
    source "$SCRIPT_DIR"/lib/$TOOL.sh
    echo "Press any key to continue..."
    read -n1 -s
    print_submenu
  elif [ $INPUT -eq $INDEX ]; then
    break  ## Return to previous menu when 'Return' option is selected
  else
    echo "${RED}Invalid input. Please enter a valid number.${RESET}"
  fi
done
