#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo -e "[${RED}●${PLAIN}] Script needs to be run as root" && exit
fi

ALAMATIP=$( wget -qO- icanhazip.com )
ALAMATHOS=$( cat /etc/hostname )

if [[ ! -d /usr/src/shadowsocks ]]; then
  mkdir /usr/src/shadowsocks
fi

if [[ ! -f /usr/src/shadowsocks/.accounts ]]; then
  touch /usr/src/shadowsocks/.accounts
fi

apt-get -y -qq install shadowsocks-libev &>/dev/null
apt-get -y -qq install simple-obfs &>/dev/null

systemctl disable shadowsocks-libev &>/dev/null
systemctl stop shadowsocks-libev &>/dev/null

if [[ ! -f /usr/src/shadowsocks/.accounts ]]; then
  touch /usr/src/shadowsocks/.accounts
fi

iptables -A INPUT -p tcp --dport 6501 -m state --state NEW -j ACCEPT
iptables -A INPUT -p udp --dport 6501 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 6001 -m state --state NEW -j ACCEPT
iptables -A INPUT -p udp --dport 6001 -m state --state NEW -j ACCEPT
iptables-save > /etc/iptables/iptables.rules

echo ""
echo ""
echo -e "${GREEN}Congratulation, we are done with ss-libev setup${PLAIN}"
echo ""
echo -e "${CYAN}==============================================${PLAIN}"
echo -e "${PURPLE}[ SS-LIBEV DETAIL ]${PLAIN}"
echo -e "${CYAN}----------------------------------------------${PLAIN}"
echo -e "${YELLOW}Status:${YELLOW} ${GREEN}Active & Enabled${PLAIN}"
echo -e "${YELLOW}Server IP:${YELLOW} ${GREEN}$ALAMATIP${PLAIN}"
echo -e "${YELLOW}Hostname:${YELLOW} ${GREEN}cybertize.tk${PLAIN}"
echo -e "${YELLOW}Server Port:${YELLOW} ${GREEN}7001${PLAIN}"
echo -e "${YELLOW}Password:${YELLOW} ${GREEN}cybertize${PLAIN}"
echo -e "${CYAN}==============================================${PLAIN}"
echo ""
echo ""