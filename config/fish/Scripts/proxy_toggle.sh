#!/bin/bash

PROXY_FILE="/etc/profile.d/proxy.sh"
# Укажите здесь актуальные данные из приложения
PROXY_ADDR="10.11.177.93:8181"

logout_system() {
    if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        hyprctl dispatch exit
    else
        pkill -u $USER
    fi
}

if [ "$1" == "on" ]; then
    sudo bash -c "cat > $PROXY_FILE" <<EOF
export http_proxy="http://$PROXY_ADDR"
export https_proxy="http://$PROXY_ADDR"
export ftp_proxy="http://$PROXY_ADDR"
export HTTP_PROXY="http://$PROXY_ADDR"
export HTTPS_PROXY="http://$PROXY_ADDR"
export no_proxy="localhost,127.0.0.1,localaddress"
EOF
    logout_system

elif [ "$1" == "off" ]; then
    if [ -f "$PROXY_FILE" ]; then
        sudo rm "$PROXY_FILE"
        logout_system
    else
        echo "Прокси и так выключен."
    fi

else
    echo "Использование: proxy_toggle [on|off]"
fi
