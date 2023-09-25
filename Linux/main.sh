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
        # Replace underscores with spaces and capitalize each word
        formatted_filename="$(echo ${filename//_/ } | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')"
        TOOLS[INDEX]=$formatted_filename
        echo "${GREEN}${BOLD}$INDEX) $formatted_filename${RESET}"
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
    # Change back to underscores and lowercase for source file
    filename_tool="$(echo ${TOOL// /_} | awk '{print tolower($0)}')"
    source "$SCRIPT_DIR"/lib/$filename_tool.sh
    echo "Press any key to continue..."
    read -n1 -s
    print_submenu
  elif [ $INPUT -eq $INDEX ]; then
    break  ## Return to previous menu when 'Return' option is selected
  else
    echo "${RED}Invalid input. Please enter a valid number.${RESET}"
  fi
done