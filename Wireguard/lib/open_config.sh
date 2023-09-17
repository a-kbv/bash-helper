#!/bin/bash

#This script will open the Wireguard config file wg0.conf

echo "Starting Wireguard..."
sudo wg-quick up wg0
echo "Wireguard started successfully."