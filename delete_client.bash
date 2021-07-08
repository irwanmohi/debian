#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "[ ● ] Script needs to be run as root" && exit
fi

read -p "Masukkan nama pengguna: " NAMAPENGGUNA
systemctl disable shadowsocks-libev-server@$NAMAPENGGUNA-tls.service &>/dev/null
systemctl stop shadowsocks-libev-server@$NAMAPENGGUNA-tls.service &>/dev/null
systemctl disable shadowsocks-libev-server@$NAMAPENGGUNA-http.service &>/dev/null
systemctl stop shadowsocks-libev-server@$NAMAPENGGUNA-http.service &>/dev/null

rm /etc/shadowsocks-libev/$NAMAPENGGUNA-tls.json &>/dev/null
rm /etc/shadowsocks-libev/$NAMAPENGGUNA-http.json &>/dev/null

sed -i "/$NAMAPENGGUNA/d" /usr/src/shadowsocks/.accounts &>/dev/null

echo "================================================"
echo "Akaun pengguna [ $NAMAPENGGUNA ] sudah di padam!"
echo "------------------------------------------------"
echo "Created by Doctype, Powered by Cybertize."
echo "================================================"
