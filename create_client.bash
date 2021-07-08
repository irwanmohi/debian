#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "[ ● ] Script needs to be run as root" && exit
fi

ALAMATIP=$( wget -qO- icanhazip.com )
ALAMATHOS=$( cat /etc/hostname )
LIBEV_HTTP_PORT=$( cat /usr/src/shadowsocks/.accounts | tail -n1 | awk '{print $4}' )
LIBEV_TLS_PORT=$( cat /usr/src/shadowsocks/.accounts | tail -n1 | awk '{print $5}' )

if [[ $LIBEV_TLS_PORT == '' ]]; then
	TLS_PORT=6501
else
	TLS_PORT="$(( $LIBEV_TLS_PORT + 1 ))"
fi

if [[ $LIBEV_HTTP_PORT == '' ]]; then
	HTTP_PORT=6001
else
	HTTP_PORT="$(( $LIBEV_HTTP_PORT + 1 ))"
fi

read -p "Masukkan nama pengguna: " NAMAPENGGUNA
read -p "Masukkan kata laluan: " KATALALUAN
read -p "Tempoh masa aktif (Hari) : " TEMPOHMASAAKTIF

IDPENGGUNA=$( openssl rand -hex 8 )
TARIKHBUAT=$( date +%F )
TANGGALHARIINI=$( date +%s )
MASAAKTIFSAAT=$(( $TEMPOHMASAAKTIF * 86400 ))
MASATAMATTEMPOH=$(( $TANGGALHARIINI + $MASAAKTIFSAAT ))
TARIKHLUPUT=$( date -u --date="1970-01-01 $MASATAMATTEMPOH sec GMT" +%F )

egrep "^$NAMAPENGGUNA" /usr/src/shadowsocks/.accounts &>/dev/null
if [ $? -eq 0 ]; then
  echo "Nama pengguna sudah diguna!" && exit 1
fi
egrep "^$KATALALUAN" /usr/src/shadowsocks/.accounts &>/dev/null
if [ $? -eq 0 ]; then
  echo "Kata laluan tidak sah!" && exit 2
fi

cat > /etc/shadowsocks-libev/$NAMAPENGGUNA-tls.json<<END
{
    "server":"0.0.0.0",
    "server_port":$TLS_PORT,
    "local_port":1080,
    "password":"$KATALALUAN",
    "method":"aes-256-cfb",
    "timeout":60,
    "fast_open":true,
    "no_delay":true,
    "plugin":"obfs-server",
    "plugin_opts":"obfs=tls",
    "nameserver":"1.1.1.1",
    "mode":"tcp_and_udp"
}
END

cat > /etc/shadowsocks-libev/$NAMAPENGGUNA-http.json <<-END
{
    "server":"0.0.0.0",
    "server_port":$HTTP_PORT,
    "password":"$KATALALUAN",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "no_delay":true,
    "nameserver":"1.1.1.1",
    "mode":"tcp_and_udp",
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
END

systemctl start shadowsocks-libev-server@$NAMAPENGGUNA-tls.service &>/dev/null
systemctl enable shadowsocks-libev-server@$NAMAPENGGUNA-tls.service &>/dev/null
systemctl start shadowsocks-libev-server@$NAMAPENGGUNA-http.service &>/dev/null
systemctl enable shadowsocks-libev-server@$NAMAPENGGUNA-http.service &>/dev/null
systemctl status shadowsocks-libev-server@$NAMAPENGGUNA-http.service | grep "active" &>/dev/null 
if [[ $? = 0 ]]; then STATUS="Active"; fi

TLSBASE64=$( echo -n "aes-256-cfb:$KATALALUAN@$ALAMATIP:$TLS_PORT" | base64 )
HTTPBASE64=$( echo -n "aes-256-cfb:$KATALALUAN@$ALAMATIP:$HTTP_PORT" | base64 )
LIBEVTLS="ss://$TLSBASE64/?plugin%3Dobfs-local%3Bobfs%3Dtls%3Bobfs-host%3D$ALAMATHOS"
LIBEVHTTP="ss://$HTTPBASE64/?plugin%3Dobfs-local%3Bobfs%3Dhttp%3Bobfs-host%3D$ALAMATHOS"

echo "$IDPENGGUNA | $NAMAPENGGUNA | $KATALALUAN | $TLS_PORT | $HTTP_PORT | $STATUS | $TEMPOHMASAAKTIF hari | $TARIKHBUAT | $TARIKHLUPUT" >> /usr/src/shadowsocks/.accounts

echo ""
echo "========================================="
echo "Maklumat akaun pengguna"
echo "-----------------------------------------"
echo "Alamat IP: $ALAMATIP"
echo "Alamat Hos: $ALAMATHOS"
echo "Ports : $TLS_PORT(TLS) $HTTP_PORT(HTTP)"
echo "Tempoh aktif: $TEMPOHMASAAKTIF hari"
echo "Tarikh luput: $TARIKHLUPUT"
echo "--------------------------------------"
echo "TLS File: $LIBEVTLS#$NAMAPENGGUNA"
echo "HTTP File: $LIBEVHTTP#$NAMAPENGGUNA"
echo "-----------------------------------------"
echo "Created by Doctype, Powered by Cybertize."
echo "========================================="
