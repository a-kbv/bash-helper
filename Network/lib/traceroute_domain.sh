#!/bin/bash

# Check if traceroute is installed
if ! [ -x "$(command -v traceroute)" ]; then
  echo "traceroute is not installed." >&2
  # Prompt user to install traceroute
  read -p "Would you like to install traceroute? (y/n): " answer
  case ${answer:0:1} in
    y|Y )
        # Detects which OS the user is running to use the appropriate package manager
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                sudo apt-get install traceroute
        elif [[ "$OSTYPE" == "darwin"* ]]; then
                brew install traceroute
        else
                echo "Unrecognized OS. Please install traceroute manually."
        fi
    ;;
    * )
        echo "Please install traceroute to proceed."
        exit 1
    ;;
  esac
fi

echo "Please enter a domain name or IP address:"
read host
traceroute $host