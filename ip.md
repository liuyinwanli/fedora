nmcli connection show
ip route
sudo nmcli connection modify "ll" \
  ipv4.method manual \
  ipv4.addresses 192.168.3.2/24 \
  ipv4.gateway 192.168.3.1 \
  ipv4.dns "192.168.3.1 1.1.1.1"
