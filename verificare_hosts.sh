#!/bin/bash

cat /etc/hosts | while read ip nume aliases; do
    if [[ -z "$ip" || "$ip" == \#* ]]; then
        continue
    fi

    if [[ "$ip" == "127.0.0.1" || "$ip" == "::1" ]]; then
        continue
    fi

    if [[ "$nume" == ip6-* ]]; then
        continue
    fi

    real_ip=$(nslookup "$nume" 8.8.8.8 2>/dev/null | grep "Address: [0-9]" | tail -n1 | awk '{print $2}')

    if [[ -z "$real_ip" ]]; then
        continue
    fi

    if [[ "$ip" != "$real_ip" ]]; then
        echo "Bogus IP for $nume in /etc/hosts!"
    fi
done
