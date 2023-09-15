#!/bin/sh

echo "You opted to switch PHP version."

    # php versions array
    declare -a phpVersioArr=("php8.0" "php8.1" "php8.2")

    # get length of the array
    arraylength=${#phpVersioArr[@]}

    # taking current php version
    php_version_command=`php -v`;
    php_version_current=${php_version_command:3:4}

    # trim the string
    php_version_current=`echo $php_version_current | sed 's/ *$//g'`

    echo "Select PHP Version from the list:"
    echo "========================================="

    # use for loop to read all values and indexes
    for (( i=0; i<${arraylength}; i++ ));
    do
      echo "$i - ${phpVersioArr[$i]}"
    done
    echo "========================================="

    # waiting for user to select correct version of php to switch to
    pattern="^[0-9]{1}$"
    selectedPHPVersion="";
    while [[ (! $selectedPHPVersion =~ $pattern) || (! -v "phpVersioArr[selectedPHPVersion]") ]]
    do
        echo Please enter valid input
        read selectedPHPVersion
    done

    new_php_version="${phpVersioArr[$selectedPHPVersion]:3:4}"

    echo "Switching to PHP$new_php_version. . ."

    sudo a2disconf "php${php_version_current}-fpm";
    sudo a2enconf "${phpVersioArr[$selectedPHPVersion]}-fpm";
    sudo systemctl restart apache2;

    sudo update-alternatives --set php /usr/bin/"${phpVersioArr[$selectedPHPVersion]}";
    sudo update-alternatives --set phar /usr/bin/phar"$new_php_version";
    sudo update-alternatives --set phar.phar /usr/bin/phar.phar"$new_php_version";
    sudo update-alternatives --set phpize /usr/bin/phpize"$new_php_version";
    sudo update-alternatives --set php-config /usr/bin/php-config"$new_php_version";

    echo ""

    echo "---------------------------------------------------------"
    echo "Switched to PHP$new_php_version successfully."
    echo "---------------------------------------------------------"

    echo ""
    echo "Current PHP version:"
    php -v

    echo "---------------------------------------------------------"

    echo "Done!"
    echo "---------------------------------------------------------"
