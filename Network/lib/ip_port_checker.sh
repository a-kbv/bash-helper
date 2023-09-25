#!/bin/bash

check_port_func() {
    local ip="$1"
    local port="$2"
    local result
    result=$(timeout 1 bash -c ">/dev/tcp/$ip/$port" &>/dev/null && echo Open || echo Timed-Out)
    echo -e "$port\t$result"
}

export -f check_port_func

check_ports_func() {
    local ip="$1"
    local ports="$2"
    IFS=',' read -ra port_array <<< "$ports"
    for port in "${port_array[@]}"; do
        echo "$port"
    done | xargs -I {} -P 0 bash -c 'check_port_func '"$ip"' {}' \
        | column -t -s$'\t' | sort -n
}

export -f check_ports_func

trap 'exit 0' INT

echo "Enter IP or domain to check:"
read -r ip

echo "Choose an option:"
echo "1. Custom ports"
echo "2. Server ports"
echo "3. Game ports"
echo "4. Application ports"
echo "5. All common ports"
read -r option

case $option in
    1)
        echo "Enter comma-separated ports to check (e.g., 80,443,8080):"
        read -r custom_ports
        check_ports_func "$ip" "$custom_ports"
        ;;
    2)
        server_ports="21,22,23,25,53,80,110,137,138,139,143,443,445,548,587,993,995,1433,1701,1723,3306,5432,8008,8443"
        check_ports_func "$ip" "$server_ports"
        ;;
    3)
        game_ports="666,2302,3453,3724,4000,5154,6112,6113,6114,6115,6116,6117,6118,6119,7777,10093,10094,12203,14567,25565,26000,27015,27910,28000,50000"
        check_ports_func "$ip" "$game_ports"
        ;;
    4)
        application_ports="515,631,3282,3389,5190,5050,4443,1863,6891,1503,5631,5632,5900,6667"
        check_ports_func "$ip" "$application_ports"
        ;;
    5)
        common_ports="21,22,23,25,53,80,110,115,135,139,143,194,443,445,1433,3306,3389,5632,5900,25565"
        check_ports_func "$ip" "$common_ports"
        ;;
    *)
        echo "Invalid option"
        ;;
esac