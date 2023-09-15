#!/bin/sh

echo "Retrieving IP addresses..."

  # Retrieving public IP address
  PUBLIC_IP=$(curl -fSs https://1.1.1.1/cdn-cgi/trace | awk -F= '/ip/ { print $2 }')
  echo "PUBLIC: $PUBLIC_IP"

  # Retrieving local IP address
  LOCAL_IP=$(ifconfig | awk '/inet /{print $2;exit}')
  echo "LOCAL: $LOCAL_IP"
