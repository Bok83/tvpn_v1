#!/bin/bash

# give ip local
echo -e "network:\n  version: 2\n  tunnels:\n    tunel01:\n      mode: sit\n      local: $2\n      remote: $1\n      addresses:\n        - fd34:7d71:4e57:ffff::1/64\n      mtu: 1500" > /etc/netplan/pdtun.yaml
netplan apply
echo -e "[Network]\nAddress=fd34:7d71:4e57:ffff::1/64\nGateway=fd34:7d71:4e57:ffff::2/64" > /etc/systemd/network/tun0.network
systemctl restart systemd-networkd
# install need apps & new resolv.conf
apt install curl socat resolvconf -y ;rm /etc/resolv.conf ;echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf
# install panel sanaei
yes n | bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
# replace backup x-ui
rm /etc/x-ui/x-ui.db
mv x-ui.db /etc/x-ui/x-ui.db
x-ui restart
# netspeed server
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
# netspeed apply
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
# clear history
cat /dev/null > ~/.bash_history
history -c
