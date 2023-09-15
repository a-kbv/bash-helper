#!/bin/bash
echo "Installing Wireguard..."
sudo apt-get update && sudo apt-get upgrade
sudo apt install wireguard resolvconf wireguard-tools
echo "Wireguard installed successfully."
