#!/bin/sh

#This script will switch PHP version

echo "You have opted to switch PHP version"

php_versions=$(for x in /etc/php/*/; do basename "$x"; done)
php_versions_array=($php_versions)

array_length=${#php_versions_array[@]}

current_php_version_command=`php -v`
current_php_version=${current_php_version_command:4:3}

echo "Select PHP Version from the list"
echo "========================================="

for (( i=1; i<${array_length}; i++ ))
do
  echo "$i - php${php_versions_array[$i]}"
done

echo "========================================="

pattern="^[0-9]{1}$"
selected_index="";

while [[ (! $selected_index =~ $pattern) || (! -v "php_versions_array[selected_index]") ]]
do
    echo "Please enter a valid input"
    read selected_index
done

new_php_version=${php_versions_array[$selected_index]}

sudo a2dismod php$current_php_version;
sudo a2enmod php$new_php_version;
sudo systemctl restart apache2;

sudo update-alternatives --set php /usr/bin/php$new_php_version;
sudo update-alternatives --set phar /usr/bin/phar$new_php_version;
sudo update-alternatives --set phar.phar /usr/bin/phar.phar$new_php_version;
sudo update-alternatives --set phpize /usr/bin/phpize$new_php_version;
sudo update-alternatives --set php-config /usr/bin/php-config$new_php_version;

echo "PHP has been switched to PHP$new_php_version"

php -v