#!/bin/sh

# Check if lsof command is installed
if ! command -v lsof >/dev/null 2>&1 ; then
    echo "lsof command is not found"
    echo "Do you want to install it? (y/n)"
    
    read install_lsof
    if [ "$install_lsof" = "y" ]; then
        # Install lsof using package manager
        if command -v apt >/dev/null 2>&1 ; then
            sudo apt update
            sudo apt install lsof
        elif command -v yum >/dev/null 2>&1 ; then
            sudo yum install lsof
        else
            echo "Unable to install lsof. Please install it manually."
            exit 1
        fi
        echo "lsof has been installed successfully"
    else
        echo "Installation of lsof aborted"
        exit 1
    fi
fi

# Continue with the rest of the script

echo "Enter the port number:"
read port_number

# Get the process ID(s) and the corresponding process name running on the specified port
process_info=$(lsof -i :$port_number | awk 'NR>1 {print $2, $1}')
process_info_array=($process_info)
array_length=${#process_info_array[@]}

if [ $array_length -eq 0 ]; then
  echo "No processes found on port $port_number"
  exit 1
fi

echo "Processes running on port $port_number:"
echo "========================================"

index=1
for (( i=0; i<${array_length}; i+=2 ))
do
  echo "$index - Process ID: ${process_info_array[$i]}, Process Name: ${process_info_array[$i+1]}"
  index=$((index+1))
done

echo "========================================"

pattern="^[1-9]+$"
selected_index=""

while [[ (! $selected_index =~ $pattern) || $selected_index -ge $index ]]
do
    echo "Please enter a valid input"
    read selected_index
done

selected_index=$((selected_index-1))
selected_index=$((selected_index*2))
selected_process_id=${process_info_array[$selected_index]}
selected_process_name=${process_info_array[$selected_index+1]}

# Kill the selected process
kill $selected_process_id

echo "Process $selected_process_id ($selected_process_name) has been killed"

# Verify that the process has been killed
check_process=$(lsof -i :$port_number | awk 'NR>1 {print $2}')

if [[ $check_process =~ $selected_process_id ]]; then
  echo "Failed to kill the process"
else
  echo "Process has been successfully killed"
fi