#!/bin/sh

echo "Delete a virtual host."
    list_vhosts

    read -e -p "Please enter the server name to delete: " SERVERNAME
    if [ -z "$SERVERNAME" ]; then
        echo "Server name cannot be empty. Please try again with a valid server name."
        return
    fi

    # Remove virtual host file
    sudo rm "/etc/apache2/sites-available/$SERVERNAME.conf"
    sudo rm "/etc/apache2/sites-enabled/$SERVERNAME.conf"

    # Restart Apache
    sudo systemctl restart apache2

    echo "Virtual host deleted successfully."