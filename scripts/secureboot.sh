#!/bin/bash
sudo pacman -S sbsigntools mokutil refind efitools
yay -S shim-signed
sudo refind-install --shim /usr/share/shim-signed/shimx64.efi --localkeys
sudo mkdir -p /usr/share/secureboot/keys 
cd /usr/share/secureboot/keys/
sudo openssl req -newkey rsa:4096 -nodes -keyout KEK.key -new -x509 -sha256 -days 3650 -subj "/CN=my Key Exchange Key/" -out KEK.crt
sudo openssl x509 -outform DER -in KEK.crt -out KEK.cer
sudo openssl req -newkey rsa:4096 -nodes -keyout db.key -new -x509 -sha256 -days 3650 -subj "/CN=my Signature Database key/" -out db.crt
sudo openssl x509 -outform DER -in db.crt -out db.cer
sudo sbsign --key db.key --cert db.crt --output /boot/EFI/BOOT/BOOTX64.EFI /boot/EFI/BOOT/BOOTX64.EFI 
sudo cp /usr/share/secureboot/keys/*.cer /usr/share/secureboot/keys/*.esl /usr/share/secureboot/keys/*.auth /boot/EFI
sudo sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output /boot/vmlinuz-linux-zen /boot/vmlinuz-linux-zen
sudo sbsign --key /etc/refind.d/keys/refind_local.key --cert /etc/refind.d/keys/refind_local.crt --output /boot/vmlinuz-5.15-x86_64 /boot/vmlinuz-5.15-x86_64
