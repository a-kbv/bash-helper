#!/bin/bash

while true; do
    # Ask for a directory
    read -e -p "Please enter the directory to search in: " dir_path

    # Check if directory exists
    if [[ ! -d "$dir_path" ]]; then
        echo "Directory does not exist. Please try again."
        continue
    fi

    # Ask for file extension
    read -e -p "Please enter the file extension to delete (e.g., jpg, txt): " extension

    # Check for empty extension
    if [[ -z "$extension" ]]; then
        echo "No extension entered. Please try again."
        continue
    fi

        # Find files with the given extension in the specified directory
    files=( $(find "$dir_path" -maxdepth 1 -type f -name "*.$extension") )

    # Check if files were found
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No files found with .$extension extension in $dir_path."
    else
        # Add the "All" option at the beginning of the array
        files=("All" "${files[@]}")

        # Use select to create a file selection menu
        echo "Select the file(s) you want to delete (1 for all):"
        select file in "${files[@]}"; do
            if [[ "$REPLY" == "1" ]]; then
                echo "Are you sure you want to delete ALL .$extension files in $dir_path? (y/n)"
                read -r confirm_delete_all
                if [[ $confirm_delete_all =~ ^[yY]$ ]]; then
                    # Skip the first "All" option and delete files
                    for f in "${files[@]:1}"; do
                        if [[ -e "$f" ]]; then
                            rm -f -- "$f"
                            echo "File $f deleted."
                        fi
                    done
                else
                    echo "No files were deleted."
                fi
                break
            elif [[ -n $file && "$file" != "All" ]]; then
                echo "Are you sure you want to delete $file? (y/n)"
                read -r confirm_delete
                if [[ $confirm_delete =~ ^[yY]$ ]]; then
                    rm -f -- "$file"
                    echo "File $file deleted."
                else
                    echo "File $file not deleted."
                fi
                break
            else
                echo "Invalid option. Please try again."
            fi
        done
    fi

    # Ask if the user wants to delete more files or exit
    echo "Do you want to delete more files with a new extension? (y/n)"
    read -r continue_delete
    if [[ $continue_delete != [yY] ]]; then
        break # Exit the loop
    fi
done

echo "Exiting the script."