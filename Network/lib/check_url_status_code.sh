#!/bin/bash

# Ask the user for the URL input
echo "Please enter a URL:"
read url

# Check the status code
response=$(curl --write-out '%{http_code}\n' --silent --output /dev/null $url)

# Print the status code
echo "The HTTP response status code of $url is: $response"