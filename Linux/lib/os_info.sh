#!/bin/bash

# Function to get the IPv4 address
get_ip() {
    ip=$(hostname -I | awk '{print $1}')
    echo "${ip}"
}

# Get OS information
opsy=$(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2 | tr -d '"')

# Get hostname
host=$(hostname)

# Get CPU information
cname=$(grep 'model name' /proc/cpuinfo | awk -F ': ' '{print $2}' | head -n 1 | sed 's/^\s*//')
cores=$(grep -c '^processor' /proc/cpuinfo)
freq=$(awk -F ': ' '/^cpu MHz/{print $2}' /proc/cpuinfo | head -n 1)

# Get RAM information
tram=$(free -m | awk '/^Mem:/ {print $2}')
swap=$(free -m | awk '/^Swap:/ {print $2}')

# Get system uptime
up=$(uptime -p)

# Get load average
load=$(uptime | awk -F 'load average:' '{print $2}' | sed -e 's/^\s*//' | tr -s ' ')

# Get architecture information
arch=$(uname -m)
lbit=$(getconf LONG_BIT)

# Get kernel version
kern=$(uname -r)

echo "--------------------- System Information ----------------------------"
echo
echo "CPU model            : ${cname}"
echo "Number of cores      : ${cores}"
echo "CPU frequency        : ${freq} MHz"
echo "Total amount of ram  : ${tram} MB"
echo "Total amount of swap : ${swap} MB"
echo "System uptime        : ${up}"
echo "Load average         : ${load}"
echo "OS                   : ${opsy}"
echo "Arch                 : ${arch} (${lbit} Bit)"
echo "Kernel               : ${kern}"
echo "Hostname             : ${host}"
echo "IPv4 address         : $(get_ip)"
echo
echo "---------------------------------------------------------------------"