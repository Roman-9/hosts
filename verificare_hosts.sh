#!/bin/bash

valideaza_asociere() {
    local host=$1
    local ip_fisier=$2
    local dns_server=$3

    real_ip=$(nslookup "$host" "$dns_server" 2>/dev/null | grep "Address: [0-9]" | tail -n1 | awk '{print $2}')

    if [[ -z "$real_ip" ]]; then
        return
    fi

    if [[ "$ip_fisier" != "$real_ip" ]]; then
        echo "Bogus IP for $host in /etc/hosts!"
        echo "  -> Fisier: $ip_fisier vs DNS($dns_server): $real_ip"
    else
        echo "Valid: $host -> $real_ip"
    fi
}

if [ -z "$1" ]; then
    echo "Utilizare: $0 <server_dns>"
    exit 1
fi

DNS_SERVER_ALES=$1

cat /etc/hosts | while read ip nume aliases; do
    # Aici lipseau operatorii ||
    if [[ -z "$ip" || "$ip" == \#* ]]; then continue; fi
    if [[ "$ip" == "127.0.0.1" || "$ip" == "::1" ]]; then continue; fi
    if [[ "$nume" == ip6-* ]]; then continue; fi

    valideaza_asociere "$nume" "$ip" "$DNS_SERVER_ALES"
done
