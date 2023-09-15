#!/bin/bash
    echo "Stopping Wireguard..."
    sudo wg-quick down wg0
    echo "Wireguard stopped successfully."