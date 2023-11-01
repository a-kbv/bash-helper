#!/bin/bash

# navigate to your repo directory
cd "$(dirname "$BASH_SOURCE")"

# function to check if git is installed
function is_git_installed {
  git --version >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

# function to check for updates
function check_for_updates {
  # only run if git is installed
  if is_git_installed; then
    # checks if you are connected to the internet
    if nc -zw1 google.com 443; then 
      # check for changes on the remote
      UPSTREAM=${1:-'@{u}'}
      LOCAL=$(git rev-parse @ 2>/dev/null)
      REMOTE=$(git rev-parse "$UPSTREAM" 2>/dev/null)
      BASE=$(git merge-base @ "$UPSTREAM" 2>/dev/null)

      if [ $LOCAL = $REMOTE ]; then
          echo "Up-to-date"
      elif [ $LOCAL = $BASE ]; then
          echo "Updates available"
          read -p "Do you want to update? (y/n)" ans
          if [ "$ans" = "y" ]; then
              # update the repo
              git pull
              # Exit after updating to avoid running outdated files
              echo "Please rerun the tool after updating."
              exit
          fi
      elif [ $REMOTE = $BASE ]; then
          echo "Need to push"
      else
          echo "Diverged"
      fi
    else
      echo "You are currently offline. Skipping update check."
    fi
  else
    echo "Git is not installed. Skipping update check."
  fi
}

check_for_updates  # call the function
declare -a TOOLS=()

# ANSI/VT100 Terminal Control Escape Sequences
# Set color codes
BOLD="$(tput bold)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)" # reset everything

# Print tool options
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
  echo "${BLUE}${BOLD}$INDEX) Exit${RESET}"   # Add Exit option
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
