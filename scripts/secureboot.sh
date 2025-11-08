#!/bin/bash
sudo pacman -S sbsigntools mokutil refind efitools sbctl --noconfirm 
yay -S shim-signed --noconfirm 
sudo refind-install
sbctl setup --migrate
sbctl create-keys
sbctl enroll-keys -m
sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
sbctl sign -s /boot/EFI/Linux/*.efi
sbctl sign -s /efi/EFI/Linux/*.efi
sbctl sign -s /boot/EFI/refind/refind_x64.efi
sbctl sign -s /efi/EFI/refind/refind_x64.efi
bootctl install
