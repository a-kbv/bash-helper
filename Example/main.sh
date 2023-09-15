#!/bin/sh

declare -a TOOLS=()

# Get the directory path of the executing script
SCRIPT_DIR="$(dirname "$BASH_SOURCE")"

## function to print tool options
function print_submenu {
  clear
  INDEX=1
  echo "Available Tools:"
  for file in "$SCRIPT_DIR"/lib/* ; do
    if [ -f "$file" ]; then
      filename=$(basename -- "$file")
      filename="${filename%.*}"
      if [[ "$filename" != "exclude_tool1" && "$filename" != "exclude_tool2" ]]; then
        TOOLS[INDEX]=$filename
        echo "$INDEX) $filename"
        ((INDEX++))
      fi
    fi
  done
  echo "$INDEX) Return"   ## Add Return option
  echo "Please enter the number of your choice:"
}

print_submenu

while :
do
  read INPUT
  if [[ "$INPUT" =~ ^[0-9]+$ && $INPUT -ge 1 && $INPUT -lt $INDEX ]]; then
    TOOL=${TOOLS[$INPUT]}
    echo "Running tool: $TOOL"
    source "$SCRIPT_DIR"/lib/$TOOL.sh
    echo "Press any key to continue..."
    read -n1 -s
    print_submenu
  elif [ $INPUT -eq $INDEX ]; then
    break  ## Return to previous menu when 'Return' option is selected
  else
    echo "Invalid input. Please enter a valid number."
  fi
done