#!/bin/bash

# Check if whois command is installed
if ! command -v whois &> /dev/null; then
    echo "'whois' command is not installed. Installing..."
    if [ -f /etc/debian_version ]; then
        sudo apt-get update
        sudo apt-get install -y whois
    elif [ -f /etc/redhat-release ]; then
        sudo yum update
        sudo yum install -y whois
    else
        echo "Unable to determine package manager. Please install 'whois' manually."
        exit 1
    fi
fi

# Input domain name
read -p "Enter domain name: " domain

# Get expiry date using whois command
expiry_date=$(whois $domain | awk -F ':' '/Expiration Date/{print $2}' | tr -d ' ')

# Check if expiry date exists
if [ -n "$expiry_date" ]; then
    echo "Domain: $domain"
    echo "Expiry Date: $expiry_date"
else
    echo "Failed to get expiry date for '$domain'"
fi