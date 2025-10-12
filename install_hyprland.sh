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

    if [[ $install = "lie" ]]; then
        nmcli device wifi connect Xiaomi_0298_5G password 59563129
        # Проверка git
        if ! command -v git &> /dev/null; then
            echo "Git is not installed. Installing.../Git не установлен. Устанавливаем..."
            sleep 1
            sudo pacman -S git --noconfirm
            if [ $? -ne 0 ]; then
                echo "Error while installing Git. Command execution is canceled./Ошибка при установке Git. Выполнение команды отменено."
                sleep 1
                exit 1
            fi
        fi
        # Проверка существования папки
        if [ -d "$HOME/Hyprland_Arch" ]; then
            echo "Directory ~/Hyprland_Arch already exists. Removing..."
            rm -rf ~/Hyprland_Arch
        fi
        git clone https://github.com/LiGoZoff/Hyprland_Arch.git
        sudo chmod +x ~/Hyprland_Arch/scripts/install.sh
        ~/Hyprland_Arch/scripts/install.sh
        sudo rm -rf ~/Hyprland_Arch
        sudo rm -rf ~/install_hyprland.sh
        exit 0
    elif [[ $install = "y" ]] || [[ $install = "yes" ]]; then
        # Проверка git
        if ! command -v git &> /dev/null; then
            echo "Git is not installed. Installing.../Git не установлен. Устанавливаем..."
            sleep 1
            sudo pacman -S git --noconfirm
            if [ $? -ne 0 ]; then
                echo "Error while installing Git. Command execution is canceled./Ошибка при установке Git. Выполнение команды отменено."
                sleep 1
                exit 1
            fi
        fi
        # Проверка существования папки
        if [ -d "$HOME/Hyprland_Arch" ]; then
            echo "Directory ~/Hyprland_Arch already exists. Removing..."
            rm -rf ~/Hyprland_Arch
        fi
        git clone https://github.com/LiGoZoff/Hyprland_Arch.git
        sudo chmod +x ~/Hyprland_Arch/scripts/install.sh
        ~/Hyprland_Arch/scripts/install.sh
        sudo rm -rf ~/Hyprland_Arch
        sudo rm -rf ~/install_hyprland.sh
        exit 0
    elif [[ $install = "no" ]] || [[ $install = "n" ]]; then
        echo "GoodBye"
        exit 0
    else
        echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
        sleep 1
    fi
done