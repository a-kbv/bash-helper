#!/bin/bash

vhosts=$(ls /etc/apache2/sites-available/)
vhosts_array=($vhosts)

echo "Select vhost to delete:"
select vhost in "${vhosts_array[@]}"; do
  [[ -n $vhost ]] && break
done

sudo a2dissite ${vhost}
sudo rm -f /etc/apache2/sites-available/${vhost}
sudo systemctl restart apache2

echo "Virtual host ${vhost} has been deleted."