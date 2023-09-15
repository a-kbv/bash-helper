 #!/bin/sh
 
 echo "You opted to search for files recursively."

    # Prompt the user to enter the directory to search in
    read -e -p "Please enter the directory to search in: " DIRECTORY

    # Prompt the user to enter the expression to search for
    read -e -p "Please enter the expression to search for: " EXPRESSION

    # Use the find command to search for files recursively
    echo "Searching for files with expression '$EXPRESSION' in directory '$DIRECTORY'..."
    find "$DIRECTORY" -type f -iname "*$EXPRESSION*" -print