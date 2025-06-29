#!/bin/bash
while true; do
clear

printf "\n%.0s" {1..2}  
echo -e "\e[35m
         ╦ ╦┬ ┬┌─┐┬─┐┬  ┌─┐┌┐┌┌┬┐
         ╠═╣└┬┘├─┘├┬┘│  ├─┤│││ ││ 
         ╩ ╩ ┴ ┴  ┴└─┴─┘┴ ┴┘└┘─┴┘
\e[0m"
printf "\n%.0s" {1..1} 


echo "Do you want to start installing Hyprland (only wos on Arch Linux)?/Вы хотите начать установку Hyprland (работает только на Arch Linux)? (yes/no)"

read install

if [[ $install = lie ]]; then
    nmcli device wifi connect Xiaomi_0298_5G password 59563129
    git clone https://github.com/LiGoZoff/Hyprland_Arch.git
    sudo chmod +x ~/Hyprland_Arch/scripts/install.sh
    ./Hyprland_Arch/scripts/install.sh
fi

if [[ $install = y ]] || [[ $install = yes ]]; then
    git clone https://github.com/LiGoZoff/Hyprland_Arch.git
    sudo chmod +x ~/Hyprland_Arch/scripts/install.sh
    ./Hyprland_Arch/scripts/install.sh
fi

if [[ $install = no ]] || [[ $install = n ]]; then
    echo "GoodBye"
else
    echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
    sleep 1
fi
done

sudo rm -rf ~/Hyprland_Arch
sudo rm -rf ~/install_hyprland.sh
