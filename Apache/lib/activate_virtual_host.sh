#!/bin/sh
echo "Enter the name of the virtual host you want to activate:"
read VIRTUAL_HOST_NAME
sudo a2ensite $VIRTUAL_HOST_NAME
sudo service apache2 reload
echo "Virtual host $VIRTUAL_HOST_NAME activated."
echo "Press any key to continue..."