#!/bin/bash

#This script will install Wireguard

echo "Installing Wireguard..."
sudo apt-get update && sudo apt-get upgrade
sudo apt install wireguard resolvconf wireguard-tools
echo "Wireguard installed successfully."
