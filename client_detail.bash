#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "[ ● ] Script needs to be run as root" && exit
fi

read -p "Masukkan nama pengguna: " NAMAPENGGUNA
echo "================================================================================================="
echo "Maklumat akaun pengguna [ $NAMAPENGGUNA ]"
echo "-------------------------------------------------------------------------------------------------"
egrep "$NAMAPENGGUNA" /usr/src/shadowsocks/.accounts
echo "-------------------------------------------------------------------------------------------------"
echo "Created by Doctype, Powered by Cybertize."
echo "================================================================================================="
