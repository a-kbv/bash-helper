#!/bin/bash
    echo "Starting Wireguard..."
    sudo wg-quick up wg0
    echo "Wireguard started successfully."