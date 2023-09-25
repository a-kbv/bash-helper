#!/bin/bash

RBLS=(
    'all.s5h.net'
    'b.barracudacentral.org'
    'bl.spamcop.net'
    'blacklist.woody.ch'
    'bogons.cymru.com'
    'cbl.abuseat.org'
    'cdl.anti-spam.org.cn'
    'combined.abuse.ch'
    'db.wpbl.info'
    'dnsbl-1.uceprotect.net'
    'dnsbl-2.uceprotect.net'
    'dnsbl-3.uceprotect.net'
    'dnsbl.anticaptcha.net'
    'dnsbl.dronebl.org'
    'dnsbl.inps.de'
    'dnsbl.sorbs.net'
    'dnsbl.spfbl.net'
    'drone.abuse.ch'
    'duinv.aupads.org'
    'dul.dnsbl.sorbs.net'
    'dyna.spamrats.com'
    'dynip.rothen.com'
    'http.dnsbl.sorbs.net'
    'ips.backscatterer.org'
    'ix.dnsbl.manitu.net'
    'korea.services.net'
    'misc.dnsbl.sorbs.net'
    'noptr.spamrats.com'
    'orvedb.aupads.org'
    'pbl.spamhaus.org'
    'proxy.bl.gweep.ca'
    'psbl.surriel.com'
    'relays.bl.gweep.ca'
    'relays.nether.net'
    'sbl.spamhaus.org'
    'short.rbl.jp'
    'singular.ttk.pte.hu'
    'smtp.dnsbl.sorbs.net'
    'socks.dnsbl.sorbs.net'
    'spam.abuse.ch'
    'spam.dnsbl.anonmails.de'
    'spam.dnsbl.sorbs.net'
    'spam.spamrats.com'
    'spambot.bls.digibase.ca'
    'spamrbl.imp.ch'
    'spamsources.fabel.dk'
    'ubl.lashback.com'
    'ubl.unsubscore.com'
    'virus.rbl.jp'
    'web.dnsbl.sorbs.net'
    'wormrbl.imp.ch'
    'xbl.spamhaus.org'
    'z.mailspike.net'
    'zen.spamhaus.org'
    'zombie.dnsbl.sorbs.net'
)

# Function to ask for an IP or domain.
ask_for_ip_or_domain() {
    read -p "Please enter an IP address or domain: " ip_input
    echo "$ip_input"
}

IP_OR_DOMAIN=$(ask_for_ip_or_domain)

# Function to check RBL for an IP or domain.
check_rbl() {
    rbl="$1"
    ip="$2"
    lookup="$ip.$rbl"

    # adding a timeout of 2 seconds using the `timeout` command
    listed=$(timeout 2 getent hosts "$lookup" | awk '{ print $1 }')

    if [ $? -eq 124 ]; then
        echo "$ip [Timeout] via $lookup"
    elif [[ -z $listed ]]; then
        echo "$ip [OK] via $lookup"
    else
        echo "$ip [LISTED] via $lookup"
    fi
}

# Run checks for the provided IP or domain
for rbl in "${RBLS[@]}"; do
    check_rbl "$rbl" "$IP_OR_DOMAIN"
done

echo "All checks completed"