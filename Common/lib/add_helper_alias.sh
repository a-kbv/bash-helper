#!/bin/bash

# Get the current directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Define the path to main.sh in the root of the project.
ROOT_MAIN_SCRIPT="${DIR}/../../main.sh"

# Add an alias that points to the main.sh script in the root of the project.
echo "alias helper='${ROOT_MAIN_SCRIPT}'" >> ~/.bashrc

# Reload the .bashrc file to apply the changes.
source ~/.bashrc

# Inform the user.
echo "Added 'helper' alias command to bashrc. You can now use 'helper' in the terminal to execute the main.sh script. Please restart your terminal to apply the changes."