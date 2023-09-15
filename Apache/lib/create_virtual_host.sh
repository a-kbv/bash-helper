#!/bin/sh
echo "Create a new virtual host."

    read -e -p "Please enter the directory: " DIRECTORY
    if [ ! -d "$DIRECTORY" ]; then
        echo "Directory does not exist. Please try again with a valid directory."
        return
    fi

    read -e -p "Please enter the server name: " SERVERNAME
    if [ -z "$SERVERNAME" ]; then
        echo "Server name cannot be empty. Please try again with a valid server name."
        return
    fi

    # Create virtual host file
    sudo tee "/etc/apache2/sites-available/$SERVERNAME.conf" > /dev/null << EOT
<VirtualHost *:80>
    DocumentRoot "$DIRECTORY"
    ServerName $SERVERNAME
    <Directory "$DIRECTORY">
        Options -Indexes +FollowSymLinks +MultiViews
        Require all granted
        AllowOverride All
    </Directory>
    <FilesMatch ".+\.ph(ar|p|tml)$">
        SetHandler "proxy:unix:/run/php/php8.1-fpm.sock|fcgi://localhost"
    </FilesMatch>
</VirtualHost>
<VirtualHost *:443>
    DocumentRoot "$DIRECTORY"
    ServerName $SERVERNAME
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

    <Directory "$DIRECTORY">
        Options -Indexes +FollowSymLinks +MultiViews
        Require all granted
        AllowOverride All
    </Directory>
    <FilesMatch ".+\.ph(ar|p|tml)$">
        SetHandler "proxy:unix:/run/php/php8.1-fpm.sock|fcgi://localhost"
    </FilesMatch>
</VirtualHost>
EOT

    # Create symlink in sites-enabled
    sudo ln -s "/etc/apache2/sites-available/$SERVERNAME.conf" "/etc/apache2/sites-enabled/$SERVERNAME.conf"

    # Restart Apache
    sudo systemctl restart apache2

    echo "Virtual host created successfully."