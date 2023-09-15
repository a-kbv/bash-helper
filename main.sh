#!/bin/bash

declare -a TOOLS=()

## function to print tool options
function print_menu {
  clear
  INDEX=1
  echo "Available Tools:"
  for dir in */; do
    dir=${dir%*/}
    if [[ "$dir" != "excluded_dir1" && "$dir" != "excluded_dir2" ]]; then
      TOOLS[INDEX]=$dir
      echo "$INDEX) $dir"
      ((INDEX++))
    fi
  done
  echo "$INDEX) Exit"   ## Add Exit option
  echo "Please enter the number of your choice:"
}

print_menu

while :; do
  read INPUT
  if [[ "$INPUT" =~ ^[0-9]+$ && $INPUT -ge 1 && $INPUT -lt $INDEX ]]; then
    TOOL=${TOOLS[$INPUT]}
    echo "Opening tool: $TOOL"
    source ./$TOOL/main.sh
    print_menu
  elif [ $INPUT -eq $INDEX ]; then
    break   ## Exit when 'Exit' option is selected
  else
    echo "Invalid input. Please enter a valid number."
  fi
done
