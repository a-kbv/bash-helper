#!/bin/bash

php_versions=$(for x in /etc/php/*/; do basename "$x"; done)
php_versions_array=($php_versions)

echo "Enter website name:"
read websiteName

echo "Enter document root path: (NOTICE: start typing and then use tab for autocomplete)"
read -e documentRoot

echo "Enter SSL certificate file path or leave it empty to use default  (/etc/ssl/certs/apache-selfsigned.crt): (NOTICE: start typing and then use tab for autocomplete)"
read -e sslCrt
sslCrt=${sslCrt:-"/etc/ssl/certs/apache-selfsigned.crt"}

echo "Enter SSL key file path or leave it empty to use default (/etc/ssl/private/apache-selfsigned.key): (NOTICE: start typing and then use tab for autocomplete)"
read -e sslKey
sslKey=${sslKey:-"/etc/ssl/private/apache-selfsigned.key"}

echo "Select PHP version:"
select phpVersion in "${php_versions_array[@]}"; do
  [[ -n $phpVersion ]] && break
done

configFile="/etc/apache2/sites-available/${websiteName}.conf"

sudo bash -c "cat > ${configFile}" << EOL
<VirtualHost *:80>
    DocumentRoot "$documentRoot"
    ServerName $websiteName
    <Directory "$documentRoot">
        Options -Indexes +FollowSymLinks +MultiViews
        Require all granted
        AllowOverride All
    </Directory>
    <FilesMatch ".+\.ph(ar|p|tml)\$">
        SetHandler "proxy:unix:/run/php/php${phpVersion}-fpm.sock|fcgi://localhost"
    </FilesMatch>
</VirtualHost>

<VirtualHost *:443>
    DocumentRoot "$documentRoot"
    ServerName $websiteName
    SSLEngine on
    SSLCertificateFile $sslCrt
    SSLCertificateKeyFile $sslKey

    <Directory "$documentRoot">
        Options -Indexes +FollowSymLinks +MultiViews
        Require all granted
        AllowOverride All
    </Directory>
    <FilesMatch ".+\.ph(ar|p|tml)\$">
        SetHandler "proxy:unix:/run/php/php${phpVersion}-fpm.sock|fcgi://localhost"
    </FilesMatch>
</VirtualHost>
EOL
sudo a2ensite ${websiteName}.conf
sudo systemctl restart apache2
echo "All done, you can now access your site at http://${websiteName} and https://${websiteName}"