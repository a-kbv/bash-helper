 #!/bin/sh
 
read -e -p "Enter the directory to analyze: " directory

while true; do
  if [ -d "$directory" ]; then
    echo "Analyzing directory: $directory"
  else
    echo "$directory does not exist."
    continue
  fi

  echo "The 10 largest files/directories in $directory are:"

  subdirectories=$(du -hsx "$directory"/* | sort -rh | head -10)

  options=$(echo "$subdirectories" | awk '{print "[" NR "] - [" $1 "] " $2}')
  echo "$options"

  echo "To exit script press Ctrl+C."
  echo "Enter number corresponding to directory to examine further or just press enter to analyze same directory"

  read -e choice
  if [ -z "$choice" ]; then
    continue
  else
    directory=$(echo "$subdirectories" | awk -v choice="$choice" 'NR==choice {print $2}')
  fi
done