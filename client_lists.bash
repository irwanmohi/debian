#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "[ ● ] Script needs to be run as root" && exit
fi

echo "========================================="
echo "Senarai akaun shadowsocks-libev"
echo "-----------------------------------------"
if [[ -f /usr/src/shadowsocks/.accounts ]]; then
  while read line
  do
    echo "$line" | awk '{print $1,$2,$6}'
  done < /usr/src/shadowsocks/.accounts
fi
echo "-----------------------------------------"
echo "Created by Doctype, Powered by Cybertize."
echo "========================================="