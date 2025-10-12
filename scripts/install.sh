#!/bin/bash

sudo chmod +x $HOME/Hyprland_Arch/config/hypr/scripts/vscode.sh
sudo chmod +x $HOME/Hyprland_Arch/config/hypr/scripts/Brightness.sh
sudo chmod +x $HOME/Hyprland_Arch/config/hypr/scripts/Volume.sh
sudo chmod +x $HOME/Hyprland_Arch/config/hypr/scripts/TouchPad.sh
sudo chmod +x $HOME/Hyprland_Arch/conf/blobdrop.sh
sudo chmod +x $HOME/Hyprland_Arch/conf/blobdrop_gif_mp4.sh
sudo chmod +x $HOME/Hyprland_Arch/conf/blobdrop_mp3.sh
sudo chmod +x $HOME/Hyprland_Arch/conf/blobdrop_png_jpg.sh
sudo chmod +x $HOME/Hyprland_Arch/config/rofi/launcher.sh
sudo chmod +x $HOME/Hyprland_Arch/config/rofi/launcher-calc.sh
sudo chmod +x $HOME/Hyprland_Arch/config/rofi/launcher-emoji.sh
sudo chmod +x $HOME/Hyprland_Arch/config/hypr/Themes/pywal-obsidian/pywal-obsidian.sh
sudo chmod +x $HOME/Hyprland_Arch/scripts/secureboot.sh

check_package_installed() {
    command -v "$1" &> /dev/null
    return $?
}

install_aur_helper() {
    local helper_name=$1
    local repo_url="https://aur.archlinux.org/$helper_name.git"
    local build_dir="$HOME/$helper_name-build"

    if ! command -v git &> /dev/null; then
        echo "git not found. Installing git..."
        sudo pacman -S --noconfirm git
        if [ $? -ne 0 ]; then
            echo "Error: Failed to install git. Please install it manually and try again./Ошибка: Не удалось установить git. Пожалуйста, установите его вручную и попробуйте снова."
            exit 1
        fi
    fi

    if [ -d "$build_dir" ]; then
        rm -rf "$build_dir"
    fi

    git clone "$repo_url" "$build_dir"
    if [ $? -ne 0 ]; then
        exit 1
    fi

    (cd "$build_dir" && makepkg -si --noconfirm)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to build and install $helper_name. Dependencies may be missing or there may be a problem with the build./Ошибка: Не удалось собрать и установить $helper_name. Возможно, отсутствуют зависимости или возникли проблемы при сборке."
        echo "Try installing dependencies manually or refer to the documentation./Попробуйте установить зависимости вручную или обратиться к документации."
        exit 1
    fi

    echo "$helper_name Successfully installed!"
}

if check_package_installed "yay"; then
    echo "yay already installed!"
    exit 0
fi

if check_package_installed "paru"; then
    echo "paru already installed!"
    exit 0
fi

while true; do
    clear
    echo "yay and paru not found."
    echo "Choose what to install/Выберите, что установить:"
    echo "  1) yay"
    echo "  2) paru"
    echo "  3) Exit"

    read -p "Your answer/Ваш выбор (1/2/3): " choice

    case "$choice" in
        1 )
            install_aur_helper "yay"
            break
            ;;
        2 )
            install_aur_helper "paru"
            break
            ;;
        3 )
            echo "Installation canceled/Установка отменена."
            exit 0
            ;;
        * )
            echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
            sleep 1
            ;;
    esac
done

sudo rm -rf /etc/pacman.conf
sudo mv ~/Hyprland_Arch/conf/pacman.conf /etc/

while true; do
    clear
    echo "If you have already selected the languages you want, skip this step(add Russian and English languages)./Если вы уже выбрали нужные вам языки, пропустите этот пункт(добавляет Русский и Английский язык). (skip/add)"

    read locale

    if [[ $locale = add ]] || [[ $locale = a ]]; then
        sudo rm -rf /etc/locale.gen
        sudo mv ~/Hyprland_Arch/conf/locale.gen /etc/
        sudo localectl set-locale ru_RU.UTF-8
        sudo locale-gen
        break
    elif [[ $locale = no ]] || [[ $locale = n ]] || [[ $locale = skip ]]; then
        echo "Skipping..."
        sleep 1
        break
    else
        echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
        sleep 1
    fi
done

CONFIG_FILE="$HOME/Hyprland_Arch/config/hypr/conf/General.conf"
TEXT_TO_FIND="us, ru"
while true; do
    clear
    echo "Please specify your preferred keyboard layout languages/Пожалуйста укажите предпочтительные для вас языки раскладки клавиатуры(Example: us, ru):"

    read language

    if [[ "$language" =~ ^[a-zA-Z]{2}(,[ ]?[a-zA-Z]{2})*$ ]]; then
        break
    else
        echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
        sleep 1
    fi
done

if grep -qF "$TEXT_TO_FIND" "$CONFIG_FILE"; then
    sed -i "s/${TEXT_TO_FIND}/$language/g" "$CONFIG_FILE"
fi

echo "Successful"

if check_package_installed "yay"; then
    helper_name="yay"
elif check_package_installed "paru"; then
    helper_name="paru"
else
    helper_name="yay" 
fi

while true; do
    clear
    echo "Installing important dependencies and components, this may take some time, are you ready to proceed?/Установка важных зависимостей и компонентов, это может занять некоторое время, вы готовы продолжить? (yes/no)"

    read install

    if [[ $install = lie ]]; then
        sudo pacman -S nerd-fonts brightnessctl nano ttf-ubuntu-font-family reflector mpv ttf-hack mesa lib32-mesa mesa-vdpau lib32-mesa-vdpau lib32-vulkan-radeon vulkan-radeon glu lib32-glu vulkan-icd-loader lib32-vulkan-icd-loader firefox lib32-gamemode obs-studio solaar ttf-opensans ipset power-profiles-daemon mako mtpfs gvfs-mtp libmtp dotnet-sdk nemo rofi rofi-calc rofi-emoji nftables ibus pavucontrol python-pywal flatpak imv proton-vpn-gtk-app fastfetch neofetch cmatrix waybar qbittorrent pamixer network-manager-applet steam obsidian file-roller nwg-look btop noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-hannom xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal ttf-font-awesome plasma-framework5 lib32-sdl2 telegram-desktop syncthing webkit2gtk blueman -noconfirm
        $helper_name -S hyprpicker swww-git clipse hyprshot cava arch-gaming-meta lact swengine youtube-music-bin vesktop-bin yandex-music bluetuith-bin onlyoffice-bin ttf-font-icons vkbasalt lib32-vkbasalt proton-ge-custom-bin xone-dkms-git dxvk-bin vkd3d-proton-bin ttf-ionicons protontricks bluez blobdrop-git bluez-utils bluez-deprecated-tools cliphist python-pywalfox visual-studio-code-bin spotify portproton waybar-updates shim-signed -noconfirm
        flatpak install flathub io.github.Soundux -y
        sudo pacman -Rns wofi dunst vim dolphin -noconfirm
        break
    elif [[ $install = yes ]] || [[ $install = y ]]; then
        sudo pacman -S nerd-fonts hyprland blueman brightnessctl ttf-ubuntu-font-family ttf-hack firefox ttf-opensans ipset power-profiles-daemon mako mtpfs gvfs-mtp libmtp dotnet-sdk nemo rofi rofi-calc rofi-emoji nftables ibus pavucontrol python-pywal flatpak imv fastfetch neofetch cmatrix waybar pamixer network-manager-applet nwg-look btop noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-hannom xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal ttf-font-awesome plasma-framework5 lib32-sdl2 -noconfirm
        $helper_name -S swww-git clipse hyprshot cava ttf-font-icons ttf-ionicons blobdrop-git cliphist swengine python-pywalfox waybar-updates -noconfirm
        break
    elif [[ $install = no ]] || [[ $install = n ]]; then
        echo "GoodBye"
        sleep 1
        exit 0
    else
        echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
        sleep 1
    fi
done

sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable power-profiles-daemon.service
sudo systemctl start power-profiles-daemon.service
systemctl --user enable gamemoded && systemctl --user start gamemode
sudo chmod +x /usr/bin/gamemoderun
sudo systemctl enable fstrim.timer
sudo rfkill unblock all
sudo mkdir -p /etc/init.d
sudo mv ~/Hyprland_Arch/conf/autostart /etc/init.d/
sudo chmod +x /etc/init.d/autostart
sudo mv ~/Hyprland_Arch/conf/autostart.service /etc/systemd/system/
sudo systemctl start autostart.service
sudo systemctl enable autostart.service
gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty
sudo mv ~/Hyprland_Arch/conf/blobdrop.sh blobdrop_gif_mp4.sh blobdrop_mp3.sh blobdrop_png_jpg.sh $HOME/.local/share/nemo/scripts/
sudo mv ~/Hyprland_Arch/conf/.swengine_after_run.sh ~/

clear
echo "You use SDDM?/Вы используете SDDM? (yes/no)"

read sddm

if [[ $sddm = yes ]] || [[ $sddm = y ]]; then
    clear
    echo "Do you want to install SDDM theme?/Вы хотите установить тему SDDM? (yes/no)"
    read sddm1
    if [[ $sddm1 = yes ]] || [[ $sddm1 = y ]]; then
        sudo cp -i /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
        sudo mv ~/Hyprland_Arch/conf/sddm.conf /etc/
        tar -xJf ~/Hyprland_Arch/themes/Kripton-v40.tar.xz
        tar -xvzf ~/Hyprland_Arch/themes/cursor.tar.gz 
        tar -xJf ~/Hyprland_Arch/themes/papirus-icon-theme-white-folders.tar.xz 
        tar -xvzf ~/Hyprland_Arch/themes/simple-sddm.tar.gz 
        sudo rm -rf ~/Papirus-Light
        mkdir -p ~/.icons
        mkdir -p ~/.themes
        sudo mv ~/Kripton-v40 ~/.themes
        sudo mv ~/oreo_spark_lite_cursors ~/.icons
        sudo mv ~/ePapirus-Dark ~/.icons
        sudo mv ~/ePapirus ~/.icons
        sudo mv ~/Papirus-Dark ~/.icons
        sudo mv ~/Papirus ~/.icons
        sudo mv ~/simple-sddm /usr/share/sddm/themes/
    else
        echo "Skipping..."
        sleep 1
    fi
else
    echo "SDDM is not used. Do you want to install SDDM?/SDDM не используется. Хотите установить SDDM? (yes/no)"
    read install_sddm
    if [[ $install_sddm = yes ]] || [[ $install_sddm = y ]]; then
        sudo pacman -S --noconfirm sddm
        sudo systemctl enable sddm
        sudo systemctl start sddm
        clear
        echo "Do you want to install SDDM theme?/Вы хотите установить тему SDDM? (yes/no)"
        read sddm1
        if [[ $sddm1 = yes ]] || [[ $sddm1 = y ]]; then
            sudo cp -i /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
            sudo mv ~/Hyprland_Arch/conf/sddm.conf /etc/
            tar -xJf ~/Hyprland_Arch/themes/Kripton-v40.tar.xz
            tar -xvzf ~/Hyprland_Arch/themes/cursor.tar.gz 
            tar -xJf ~/Hyprland_Arch/themes/papirus-icon-theme-white-folders.tar.xz 
            tar -xvzf ~/Hyprland_Arch/themes/simple-sddm.tar.gz 
            sudo rm -rf ~/Papirus-Light
            mkdir -p ~/.icons
            mkdir -p ~/.themes
            sudo mv ~/Kripton-v40 ~/.themes
            sudo mv ~/oreo_spark_lite_cursors ~/.icons
            sudo mv ~/ePapirus-Dark ~/.icons
            sudo mv ~/ePapirus ~/.icons
            sudo mv ~/Papirus-Dark ~/.icons
            sudo mv ~/Papirus ~/.icons
            sudo mv ~/simple-sddm /usr/share/sddm/themes/
        else
            echo "Skipping..."
            sleep 1
        fi
    else
        echo "Skipping..."
        sleep 1
    fi
fi

clear

update_monitor_config() {
    local device_choice_num=$1
    local monitor_number=$2
    local placeholder_tag="#monitor${monitor_number}"
    local output_prefix=""
    local default_resolution="1920x1080"
    local default_refresh_rate="60"

    if [[ "$device_choice_num" == "1" ]]; then
        output_prefix="eDP"
    elif [[ "$device_choice_num" == "2" ]]; then
        output_prefix="DP"
    fi

    local output_name="${output_prefix}-${monitor_number}"

    clear
    read -p "Enter the resolution and refresh rate for ${output_name} (At resolutions less than Full HD, there will be problems with Waybar.)/Введите разрешение и частоту обновления для ${output_name} (При разрешении меньше Full HD, будут проблемы с Waybar.) (Example, 1920x1080@60) Default: [${default_resolution}@${default_refresh_rate}]: " monitor_settings
    monitor_settings=${monitor_settings:-"${default_resolution}@${default_refresh_rate}"}

    local full_line="monitor=${output_name}, ${monitor_settings}, 0x0, 1"
    local config_file="$HOME/Документы/Project/Hyprland_Arch/1.conf"

    if grep -q "$placeholder_tag" "$config_file"; then
        sudo sed -i "s|^${placeholder_tag}|$full_line|" "$config_file"
    fi
}


clear
echo "Do you want to install Hyprland dotfiles?/Вы хотите установить Hyprland dotfiles? (yes/no)"
read dots

if [[ $dots = yes ]] || [[ $dots = y ]]; then
    echo "Monitor Setup/Настройка монитора"
    sleep 1
    clear
    read -p "Is your main monitor wired or from a laptop?/Ваш основной монитор подключён по проводу или от ноутбука? (1 - laptop, 2 - wired): " device_choice_1_num
    while [[ "$device_choice_1_num" != "1" && "$device_choice_1_num" != "2" ]]; do
        echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
        sleep 1
        read -p "Is your main monitor wired or from a laptop? (1 - laptop, 2 - wired): " device_choice_1_num
    done

    update_monitor_config "$device_choice_1_num" 1

    clear
    read -p "Do you have a second monitor? (yes/no): " has_second_monitor
    has_second_monitor=$(echo "$has_second_monitor" | tr '[:upper:]' '[:lower:]')

    while [[ "$has_second_monitor" != "yes" && "$has_second_monitor" != "no" && "$has_second_monitor" != "y" && "$has_second_monitor" != "n" ]]; do
        echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
        sleep 1
        read -p "Do you have a second monitor? (yes/no): " has_second_monitor
        has_second_monitor=$(echo "$has_second_monitor" | tr '[:upper:]' '[:lower:]')
    done

    if [[ "$has_second_monitor" == "yes" || "$has_second_monitor" == "y" ]]; then
        clear
        read -p "Is your second monitor wired or from a laptop? (1 - laptop, 2 - wired): " device_choice_2_num
        while [[ "$device_choice_2_num" != "1" && "$device_choice_2_num" != "2" ]]; do
            echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
            sleep 1
            read -p "Is your second monitor wired or from a laptop? (1 - laptop, 2 - wired): " device_choice_2_num
        done
        update_monitor_config "$device_choice_2_num" 2
    fi

    echo "Setup of the screen has been completed successfully!/Настройка экрана завершена успешно!"

    sudo rm -rf ~/.config/hypr
    [ -d ~/Hyprland_Arch/config/hypr ] && sudo mv ~/Hyprland_Arch/config/hypr ~/.config/
    [ -d ~/Hyprland_Arch/config/wal ] && sudo mv ~/Hyprland_Arch/config/wal ~/.config/
    [ -d ~/Hyprland_Arch/config/kitty ] && sudo mv ~/Hyprland_Arch/config/kitty ~/.config/
    [ -d ~/Hyprland_Arch/config/fastfetch ] && sudo mv ~/Hyprland_Arch/config/fastfetch ~/.config/
    [ -d ~/Hyprland_Arch/config/mako ] && sudo mv ~/Hyprland_Arch/config/mako ~/.config/
    [ -d ~/Hyprland_Arch/config/rofi ] && sudo mv ~/Hyprland_Arch/config/rofi ~/.config/
    [ -d ~/Hyprland_Arch/config/waybar ] && sudo mv ~/Hyprland_Arch/config/waybar ~/.config/
    [ -d ~/Hyprland_Arch/config/clipse ] && sudo mv ~/Hyprland_Arch/config/clipse ~/.config/
    [ -f ~/Hyprland_Arch/conf/.swengine_after_run.sh ] && sudo mv ~/Hyprland_Arch/conf/.swengine_after_run.sh ~/
    sudo rm -rf /etc/hosts
    [ -f ~/Hyprland_Arch/conf/hosts ] && sudo mv ~/Hyprland_Arch/conf/hosts /etc/
    mkdir -p ~/Pictures ~/Pictures/Wallpapers ~/Pictures/Screenshots
    sudo rm -rf ~/.bashrc
    [ -f ~/Hyprland_Arch/themes/.bashrc ] && sudo mv ~/Hyprland_Arch/themes/.bashrc ~/
    [ -f ~/Hyprland_Arch/.bashrc ] && sudo mv ~/Hyprland_Arch/.bashrc /root
    sleep 1
elif [[ $dots = lie ]]; then
    sudo rm -rf ~/Hyprland_Arch/config/hypr/conf/KeyBinds.conf
    sudo mv ~/Hyprland_Arch/conf/1.conf ~/Hyprland_Arch/config/hypr/scripts/KeyBinds.conf
    sudo rm -rf ~/Hyprland_Arch/config/hypr/conf/Windowrule.conf
    sudo mv ~/Hyprland_Arch/conf/2.conf ~/Hyprland_Arch/config/hypr/scripts/Windowrule.conf
    sudo rm -rf ~/.config/hypr
    sudo mv ~/Hyprland_Arch/config/hypr ~/.config/
    sudo mv ~/Hyprland_Arch/config/wal ~/.config/
    sudo mv ~/Hyprland_Arch/config/kitty ~/.config/
    sudo mv ~/Hyprland_Arch/config/fastfetch ~/.config/
    sudo mv ~/Hyprland_Arch/config/mako ~/.config/
    sudo mv ~/Hyprland_Arch/config/rofi ~/.config/
    sudo mv ~/Hyprland_Arch/config/waybar ~/.config/
    sudo mv ~/Hyprland_Arch/config/clipse ~/.config/
    sudo mv ~/Hyprland_Arch/conf/.swengine_after_run.sh ~/
    sudo rm -rf /etc/hosts
    sudo mv ~/Hyprland_Arch/conf/hosts /etc/
    mkdir -p ~/Pictures ~/Pictures/Wallpapers ~/Pictures/Screenshots
    sudo rm -rf ~/.bashrc
    sudo mv ~/Hyprland_Arch/themes/.bashrc ~/
    sudo mv ~/Hyprland_Arch/.bashrc /root
    sleep 1

elif [[ $dots = no ]] || [[ $dots = n ]]; then
    echo "Skipping..."
    sleep 1
fi

clear
echo "Do you want install Chaotic-AUR?/Хотите установить Chaotic-AUR (yes/no)"

read chaotic

if [[ $chaotic = yes ]] || [[ $chaotic = y ]]; then
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    sudo mv $HOME/Hyprland_Arch/conf/pacman-chaotic-aur.conf /etc/pacman.conf
    sudo pacman -Syu
else
    echo "Skipping..."
    sleep 1
fi

clear
echo "Whether you will put Windows as a second system (Dual Boot) with Secure Boot support./Будете ли вы ставить Windows второй системой? (yes/no)"

read secureboot

if [[ $secureboot = yes ]] || [[ $secureboot = y ]]; then
    bash $HOME/Hyprland_Arch/scripts/secureboot.sh
else
    echo "Skipping..."
    sleep 1
fi

clear
echo "Do you want install Zapret?(special for russian people)/Будешь ставить обход блокировки ютуба и дс? (yes/no)"

read zapret

if [[ $zapret = yes ]] || [[ $zapret = y ]]; then
   sudo chmod +x ~/Hyprland_Arch/scripts/dpi.sh
   sudo rm -rf /etc/hosts
   sudo mv ~/Hyprland_Arch/conf/hosts /etc/
   bash $HOME/Hyprland_Arch/scripts/dpi.sh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/Snowy-Fluffy/zapret.installer/refs/heads/main/installer.sh)"
else
    echo "Skipping..."
    sleep 1
fi

clear
echo "Presetting... Select the desired theme and wallpaper./Предварительная настройка... Выберите нужную тему и обои."

if [[ $dots = yes ]] || [[ $dots = y ]]; then
    nwg-look 
    sleep 1
fi

read -p "Do you want to set a wallpaper? (yes/no): " wallpaper
if [[ $wallpaper = yes ]] || [[ $wallpaper = y ]]; then
    swengine
    sleep 1
fi
