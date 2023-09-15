#!/bin/sh

 echo "Clearing the Linux cache..."
    sudo free && sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
    echo "Linux cache cleared successfully."