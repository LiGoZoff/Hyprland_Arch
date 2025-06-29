#!/bin/bash
sudo pacman -S dnscrypt-proxy dnsutils
sudo rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
sudo mv ~/myArch/conf/dnscrypt-proxy.toml /etc/dnscrypt-proxy/
sudo rm -rf /etc/resolv.conf
sudo mv ~/myArch/conf/resolv.conf /etc/
sudo chattr +i /etc/resolv.conf
sudo systemctl enable systemd.service
sudo systemctl start systemd.service
sudo systemctl enable dnscrypt-proxy.service
sudo systemctl start dnscrypt-proxy.service
