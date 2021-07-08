#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "[ ● ] Script needs to be run as root" && exit
fi

read -p "Masukkan nama pengguna: " NAMAPENGGUNA
systemctl enable shadowsocks-libev-server@$NAMAPENGGUNA-tls.service &>/dev/null
systemctl start shadowsocks-libev-server@$NAMAPENGGUNA-tls.service &>/dev/null
systemctl enable shadowsocks-libev-server@$NAMAPENGGUNA-http.service &>/dev/null
systemctl start shadowsocks-libev-server@$NAMAPENGGUNA-http.service &>/dev/null

echo "================================================"
echo "Akaun [ $NAMAPENGGUNA ] sudah di dayakan!"
echo "------------------------------------------------"
echo "Created by Doctype, Powered by Cybertize."
echo "================================================"
