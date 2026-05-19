#!/bin/bash

sudo chmod +x $HOME/Hyprland_Arch/config/hypr/scripts/vscode.sh
sudo chmod +x $HOME/Hyprland_Arch/config/hypr/scripts/Brightness.sh
sudo chmod +x $HOME/Hyprland_Arch/config/hypr/scripts/Volume.sh
sudo chmod +x $HOME/Hyprland_Arch/config/hypr/scripts/TouchPad.sh
sudo chmod +x $HOME/Hyprland_Arch/config/waybar/scripts/generate-config.sh
sudo chmod +x $HOME/Hyprland_Arch/conf/blobdrop.sh
sudo chmod +x $HOME/Hyprland_Arch/conf/blobdrop_gif_mp4.sh
sudo chmod +x $HOME/Hyprland_Arch/conf/blobdrop_mp3.sh
sudo chmod +x $HOME/Hyprland_Arch/conf/blobdrop_png_jpg.sh
sudo chmod +x $HOME/Hyprland_Arch/conf/mp4togif.sh
sudo chmod +X $HOME/Hyprland_Arch/conf/Scripts/proxy_toggle.sh
sudo chmod +x $HOME/Hyprland_Arch/config/rofi/launcher.sh
sudo chmod +x $HOME/Hyprland_Arch/config/rofi/launcher-calc.sh
sudo chmod +x $HOME/Hyprland_Arch/config/rofi/launcher-emoji.sh
sudo chmod +x $HOME/Hyprland_Arch/config/rofi/config-menu.sh
sudo chmod +x $HOME/Hyprland_Arch/config/hypr/Themes/pywal-obsidian/pywal-obsidian.sh
sudo chmod +x $HOME/Hyprland_Arch/scripts/secureboot.sh

CONFIG_FILE="$HOME/Hyprland_Arch/config/hypr/conf/General.conf"
TEXT_TO_FIND="us, ru"
while true; do
    clear
    echo "Please specify your preferred keyboard layout languages (Example: us, ru):"

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
    read -p "Enter the resolution and refresh rate for ${output_name} (At resolutions less than Full HD, there will be problems with Waybar.) (Example, 1920x1080@60) (Default:1920x1080@60):" monitor_settings
    monitor_settings=${monitor_settings:-"${default_resolution}@${default_refresh_rate}"}

    local full_line="monitor=${output_name}, ${monitor_settings}, 0x0, 1"
    local config_file="$HOME//Hyprland_Arch/config/hypr/conf/General.conf"

    if grep -q "$placeholder_tag" "$config_file"; then
        sudo sed -i "s|^${placeholder_tag}|$full_line|" "$config_file"
    fi
}

echo "Monitor Setup"
    clear
    read -p "Is your main monitor wired or from a laptop?(1 - laptop, 2 - wired): " device_choice_1_num
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

    echo "Setup of the screen has been completed successfully! You need to edit plugin hyprsplit in .config/hypr/conf/General.conf"
    sleep 3

clear

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
            echo "Error: Failed to install git. Please install it manually and try again."
            exit 1
        fi
    fi

    if [ -d "$build_dir" ]; then
        rm -rf "$build_dir"
    fi
    sudo pacman -S base-devel --noconfirm
    git clone "$repo_url" "$build_dir"
    if [ $? -ne 0 ]; then
        exit 1
    fi

    (cd "$build_dir" && makepkg -si --noconfirm)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to build and install $helper_name. Dependencies may be missing or there may be a problem with the build."
        echo "Try installing dependencies manually or refer to the documentation."
        exit 1
    fi

    echo "$helper_name Successfully installed!"
    sleep 1
}

if check_package_installed "yay"; then
    echo "yay already installed!"
    helper_name="yay"
elif check_package_installed "paru"; then
    echo "paru already installed!"
    helper_name="paru"
else
    helper_name=""
fi

if [[ -z "$helper_name" ]]; then
    while true; do
        clear
        echo "yay and paru not found."
        echo "Choose what to install:"
        echo "  1) yay"
        echo "  2) paru"
        echo "  3) Exit"

        read -p "Your answer (1/2/3): " choice

        case "$choice" in
            1 )
                install_aur_helper "yay"
                helper_name="yay"
                break
                ;;
            2 )
                install_aur_helper "paru"
                helper_name="paru"
                break
                ;;
            3 )
                echo "Installation canceled."
                exit 0
                ;;
            * )
                echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
                sleep 1
                ;;
        esac
    done
fi

while true; do
clear
echo "Do you want install Chaotic-AUR? (yes/no)"

read chaotic

if [[ $chaotic = yes ]] || [[ $chaotic = y ]]; then
clear
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    sudo mv $HOME/Hyprland_Arch/conf/pacman-chaotic-aur.conf /etc/pacman.conf
    sudo pacman -Syu --noconfirm 
    sleep 1
    break
elif [[ $chaotic = no ]] || [[ $chaotic = n ]]; then
clear
    sudo mv ~/Hyprland_Arch/conf/pacman.conf /etc/
    echo "Skipping..."
    sleep 1
    break
else
    echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
    sleep 1
fi
done

echo "Successful"

while true; do
    clear
    echo "Installing important dependencies and components, this may take some time, are you ready to proceed? (yes/no)"

    read install

    if [[ $install = lie ]]; then
        sudo pacman -S nerd-fonts zip brightnessctl zoxide parallel qt5-graphicaleffects qt5-quickcontrols qt5-quickcontrols2 cpio nano nemo firefox ttf-ubuntu-font-family gamemode reflector mpv ttf-hack mesa lib32-mesa lib32-vulkan-radeon vulkan-radeon glu lib32-glu unzip vulkan-icd-loader lib32-vulkan-icd-loader firefox lib32-gamemode obs-studio solaar ttf-opensans ipset power-profiles-daemon swaync mtpfs gvfs-mtp libmtp dotnet-sdk nemo rofi rofi-calc rofi-emoji nftables ibus pavucontrol python-pywal flatpak imv fastfetch cmatrix waybar qbittorrent pamixer network-manager-applet fish steam obsidian file-roller nwg-look btop noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-hannom xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal ttf-font-awesome lib32-sdl2 telegram-desktop syncthing webkit2gtk blueman qt5-graphicaleffects qt5-quickcontrols qt5-quickcontrols2
        $helper_name -S hyprpicker hyprquickframe-git lib32-gst-plugins-base-libs protonplus waypaper linux-wallpaperengine-git awww lib32-gsttreamer clipse hyprshot happ cava vesktop-bin bluetuith-bin ttf-font-icons vkbasalt lib32-vkbasalt osu-lazer-bin proton-ge-custom-bin xone-dkms-git dxvk-bin vkd3d-proton-bin ttf-ionicons protontricks bluez blobdrop-git bluez-utils bluez-deprecated-tools cliphist python-pywalfox visual-studio-code-bin spotify portproton waybar-updates proton-ge-custom-bin
        cd  $HOME/.cache/yay/
        git clone https://aur.archlinux.org/walcord.git
        cd walcord
        sed -i 's/pip install -r requirements-linux.txt/pip install pywal pyinstaller/g' PKGBUILD
        makepkg -si
        flatpak install -y flathub io.github.Soundux
        sudo pacman -Rns wofi dunst vim dolphin
        break
    elif [[ $install = yes ]] || [[ $install = y ]]; then
        sudo pacman -S nerd-fonts zip hyprland blueman cpio brightnessctl qt5-graphicaleffects qt5-quickcontrols qt5-quickcontrols2 ttf-ubuntu-font-family ttf-hack firefox ttf-opensans ipset power-profiles-daemon swaync mtpfs gvfs-mtp libmtp dotnet-sdk nemo rofi rofi-calc rofi-emoji nftables ibus pavucontrol python-pywal flatpak imv fastfetch cmatrix waybar pamixer network-manager-applet nwg-look btop noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-hannom xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal ttf-font-awesome lib32-sdl2 fish qt5-graphicaleffects qt5-quickcontrols qt5-quickcontrols2 --noconfirm
        $helper_name -S clipse hyprshot hyprquickframe-git cava waypaper awww ttf-font-icons ttf-ionicons blobdrop-git cliphist python-pywalfox waybar-updates --noconfirm
        
        sudo pacman -Rns wofi dunst vim dolphin
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
clear

if check_package_installed "sddm"; then
    clear
    echo "SDDM is already installed. Do you want to install the SDDM theme? (yes/no)"
    read sddm_theme
    if [[ $sddm_theme = yes ]] || [[ $sddm_theme = y ]]; then
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
    clear
    echo "SDDM is not installed. Do you want to install SDDM and the SDDM theme? (yes/no)"
    read install_sddm
    if [[ $install_sddm = yes ]] || [[ $install_sddm = y ]]; then
        sudo pacman -S sddm --noconfirm
        sudo systemctl enable sddm
        sudo systemctl start sddm
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
fi

clear
echo "Do you want to install Hyprland dotfiles?(yes/no)"
read dots

if [[ $dots = yes ]] || [[ $dots = y ]]; then
    
    sudo rm -rf ~/.config/hypr
    mv ~/Hyprland_Arch/config/hypr ~/.config/
    mv ~/Hyprland_Arch/config/wal ~/.config/
    mv ~/Hyprland_Arch/config/kitty ~/.config/
    
    mv ~/Hyprland_Arch/config/fastfetch ~/.config/
    mv ~/Hyprland_Arch/config/swaync ~/.config/
    mv ~/Hyprland_Arch/config/rofi ~/.config/
    mv ~/Hyprland_Arch/config/fish ~/.config/
    sudo mv ~/Hyprland_Arch/config/fish /root/.config/
    mv ~/Hyprland_Arch/config/waybar ~/.config/
    sed -i "s/\$USER/$USER/g" $HOME/.config/waybar/style.css
    mv ~/Hyprland_Arch/config/clipse ~/.config/
    mkdir -p ~/Pictures ~/Pictures/Wallpapers ~/Pictures/Screenshots
    mv $HOME/Hyprland_Arch/themes/Wallpaper.png $HOME/Pictures/Wallpapers/
    mv $HOME/Hyprland_Arch/config/waypaper /$HOME/.config/
    sudo chmod +x $HOME/.config/waypaper/post_script.sh
    sleep 1

elif [[ $dots = lie ]]; then
    sudo rm -rf ~/Hyprland_Arch/config/hypr/conf/KeyBinds.conf
    sudo mv ~/Hyprland_Arch/conf/1.conf ~/Hyprland_Arch/config/hypr/conf/KeyBinds.conf
    sudo rm -rf ~/Hyprland_Arch/config/hypr/conf/Windowrule.conf
    sudo mv ~/Hyprland_Arch/conf/2.conf ~/Hyprland_Arch/config/hypr/conf/Windowrule.conf
    sudo rm -rf ~/.config/hypr
    sudo mv ~/Hyprland_Arch/config/hypr ~/.config/
    mv $HOME/Hyprland_Arch/config/waypaper /$HOME/.config/
    sudo chmod +x $HOME/.config/waypaper/post_script.sh
    mv ~/Hyprland_Arch/config/wal ~/.config/
    mv ~/Hyprland_Arch/config/fish ~/.config/
    sudo mv ~/Hyprland_Arch/config/fish /root/.config/
    mv ~/Hyprland_Arch/config/kitty ~/.config/
    mv ~/Hyprland_Arch/config/fastfetch ~/.config/
    mv ~/Hyprland_Arch/config/swaync ~/.config/
    mv ~/Hyprland_Arch/config/rofi ~/.config/
    mv ~/Hyprland_Arch/config/waybar ~/.config/
    sed -i "s/\$USER/$USER/g" $HOME/.config/waybar/style.css
    mv ~/Hyprland_Arch/config/clipse ~/.config/
    mkdir -p ~/Pictures ~/Pictures/Wallpapers ~/Pictures/Screenshots
    mv $HOME/Hyprland_Arch/themes/Wallpaper.png $HOME/Pictures/Wallpapers/
    mv ~/Hyprland_Arch/conf/Scripts ~/.config/fish/
    sudo rm -rf /etc/locale.gen
    sudo mv ~/Hyprland_Arch/conf/locale.gen /etc/
    sudo localectl set-locale ru_RU.UTF-8
    sudo locale-gen
    git clone https://github.com/SpotX-Official/SpotX-Bash.git
    cd SpotX-Bash
    sudo chmod +x spotx.sh
    ./spotx.sh
    sleep 1

elif [[ $dots = no ]] || [[ $dots = n ]]; then
    echo "Goodbye"
    sleep 1
    exit 0
fi

sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable power-profiles-daemon.service
sudo systemctl start power-profiles-daemon.service
systemctl --user enable gamemode && systemctl --user start gamemode
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
sudo mv ~/Hyprland_Arch/conf/blobdrop.sh $HOME/.local/share/nemo/scripts/
sudo mv ~/Hyprland_Arch/conf/blobdrop_gif_mp4.sh $HOME/.local/share/nemo/scripts/
sudo mv ~/Hyprland_Arch/conf/blobdrop_mp3.sh $HOME/.local/share/nemo/scripts/
sudo mv ~/Hyprland_Arch/conf/blobdrop_png_jpg.sh $HOME/.local/share/nemo/scripts/
sudo mv ~/Hyprland_Arch/conf/mp4togif.sh $HOME/.local/share/nemo/scripts/
awww-daemon & awww img $HOME/Pictures/Wallpapers/Wallpaper.png --transition-type simple & sed -i "s|^wallpaper =.*|wallpaper = $HOME/Pictures/Wallpapers/Wallpaper.png|" ~/.config/waypaper/config.ini & wal -i $HOME/Pictures/Wallpapers/Wallpaper.png & hyprctl reload


while true; do
clear

echo " Do you need Secure Boot support? (yes/no)"

read secureboot

if [[ $secureboot = yes ]] || [[ $secureboot = y ]]; then
    sudo chmod +x $HOME/Hyprland_Arch/scripts/secureboot.sh
    bash $HOME/Hyprland_Arch/scripts/secureboot.sh
    sleep 1
    break
elif [[ $secureboot = no ]] || [[ $secureboot = n ]]; then
    echo "Skipping..."
    sleep 1
    break
else
    echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
    sleep 1
fi
done

while true; do
clear
echo "Do you want install Zapret?(special for russian people)(yes/no)"

read zapret

if [[ $zapret = yes ]] || [[ $zapret = y ]]; then
   sudo chmod +x ~/Hyprland_Arch/scripts/dpi.sh
   bash $HOME/Hyprland_Arch/scripts/dpi.sh
   cd ~
   git clone https://github.com/LiGoZoff/zapret-windows-linux.git
   echo "zapret находится в корневой директории"
   sleep 1
   break
elif [[ $zapret = no ]] || [[ $zapret = n ]]; then
     echo "Skipping..."
     sleep 1
     break
else
     echo -e "\e[31mERROR: WRONG ANSWER\e[0m"
fi
done
clear

echo "Successfuly installation"
chsh -s /bin/fish
sudo -s /usr/bin/fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install IlanCosman/tide@v6
