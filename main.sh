#!/bin/bash

# navigate to your repo directory
SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd -P)"
cd "$SCRIPT_DIR"

# ANSI/VT100 Terminal Control Escape Sequences
# Set color codes
BOLD="$(tput bold)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)" # reset everything

spin() {
  local -a spinner
  spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  local end=$((SECONDS+1))

  while [ $SECONDS -lt $end ]; do
    for i in "${spinner[@]}"; do
      echo -ne "\r$i"
      sleep 0.1
      if [ $SECONDS -ge $end ]; then
        echo -ne "\r "
        return
      fi
    done
  done
}

spin

# function to check for updates
function check_for_updates {
  # only run if git is installed
   function is_git_installed {
    git --version >/dev/null 2>&1
    return $?
  }
  if is_git_installed; then
    # checks if you are connected to the internet
    if nc -zw1 google.com 443; then 
      # check if the current directory is a git repository
      if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        # check if the current directory has a remote repository
        if git config --get remote.origin.url > /dev/null 2>&1; then
          # fetch the latest updates from the remote repository
          
          git fetch > /dev/null 2>&1

          # check for changes on the remote
          UPSTREAM=${1:-'@{u}'}
          LOCAL=$(git rev-parse @ 2>/dev/null)
          REMOTE=$(git rev-parse "$UPSTREAM" 2>/dev/null)
          BASE=$(git merge-base @ "$UPSTREAM" 2>/dev/null)

          if [ $LOCAL = $REMOTE ]; then
            echo "Up to date"
          elif [ $LOCAL = $BASE ]; then
            echo "Updates available"
            read -p "${YELLOW}Do you want to update the scripts menu? (y/n) ${RESET}" ans
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
          echo "No remote git repository found. Skipping update check."
        fi
      else
        echo "This directory is not a git repository. Skipping update check."
      fi
    else
      echo "You are currently offline. Skipping update check."
    fi
  else
    echo "Git is not installed. Skipping update check."
  fi
}

declare -a TOOLS=()

# Print tool options
function print_menu {
  clear
  INDEX=1
  UPDATES_CHECK=$(check_for_updates)

echo "${YELLOW}"
echo "╔═══════════════════════════════════╗"
echo "║     ${BOLD}Welcome to the Tools Menu${RESET}${YELLOW}     ║"
if [ "$UPDATES_CHECK" = "Updates available" ]
then
  echo "║       ⚠️ $UPDATES_CHECK         ║"

elif [ "$UPDATES_CHECK" = "Up to date" ]
then
  echo "║           ✅ $UPDATES_CHECK           ║"
fi
echo "╚═══════════════════════════════════╝"
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
