#!/bin/bash
sudo pacman -S sbsigntools mokutil refind efitools sbctl --noconfirm 
yay -S shim-signed --noconfirm 
sudo refind-install
sudo sbctl create-keys
sudo sbctl enroll-keys -m
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
sudo sbctl sign -s /boot/EFI/Linux/*.efi
sudo sbctl sign -s /efi/EFI/Linux/*.efi
sudo sbctl sign -s /boot/EFI/refind/refind_x64.efi
sudo sbctl sign -s /efi/EFI/refind/refind_x64.efi
sudo bootctl install
