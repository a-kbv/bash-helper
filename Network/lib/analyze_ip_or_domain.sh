   #!/bin/sh

    echo "You opted to check IP address or domain."
    read -e -p "Please enter the IP address or domain: " IP_OR_DOMAIN

    # Ping the IP address or domain
    echo "Pinging $IP_OR_DOMAIN ..."
    ping -c 5 $IP_OR_DOMAIN

    # Get the public IP address of the domain
    echo "Retrieving public IP address of $IP_OR_DOMAIN ..."
    PUBLIC_IP=$(dig +short $IP_OR_DOMAIN)
    echo "Public IP address: $PUBLIC_IP"

    # Check for open ports
    echo "Checking for open ports on $IP_OR_DOMAIN ..."
    nmap -p 80,443,3306,5432 $IP_OR_DOMAIN

    # Get the location of the IP address
    echo "Getting location of $IP_OR_DOMAIN ..."
    LOCATION=$(curl -s ipinfo.io/$PUBLIC_IP)
    echo "Location: $LOCATION"

    # Zone Transfer
    echo "Checking for zone transfer on $IP_OR_DOMAIN ..."
    dig axfr @nameserver $IP_OR_DOMAIN
    # Replace nameserver with the actual authoritative nameserver for the domain

    # SPF Record
    echo "Verifying SPF record for $IP_OR_DOMAIN ..."
    dig +short TXT $IP_OR_DOMAIN | grep -i "v=spf1"
    # Modify the SPF record check as per your specific SPF configuration

    # MX Record
    echo "Checking MX record for $IP_OR_DOMAIN ..."
    dig +short MX $IP_OR_DOMAIN

    # TXT Records
    echo "Checking TXT records for $IP_OR_DOMAIN ..."
    dig +short TXT $IP_OR_DOMAIN
