#!/bin/bash
# List of color
# Regular Colors
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;37m'  # White
# List of functions
function uninstaller() {
    clear
    echo "Uninstalling all tools (Qbittorrent-nox, FileBrowser, Jellyfin).."
    sleep 5
    systemctl stop jellyfin
    systemctl stop qbittorrent-nox
    systemctl stop filebrowser
    rm -rf /etc/systemd/system/qbittorrent-nox.service
    rm -rf /etc/systemd/system/filebrowser.service
    apt-get -y remove jellyfin
    echo "[Uninstall Successfully]"

}

function installer() {
    clear
    echo "[ UPDATING THE APT AND INSTALLING NECESSARY FILES ]"
    apt-get -y update >> /dev/null
    apt-get -y upgrade >> /dev/null
    apt-get install -y curl >> /dev/null
    apt-get install -y wget >> /dev/null
    apt-get install -y neofetch >> /dev/null
    #create directory
    mkdir /usr/Downloads
    mkdir /usr/Movies
    clear

    #installing qbittorrent-nox
    echo "Please wait ..."
    sleep 3
    clear
    sleep 5
    echo "[ Qbittorent-Nox ]"
    sleep 3
    echo "Installing Qbittorrent-nox on ::8080 ..."
    sleep 3
    apt install -y qbittorrent-nox >> /dev/null
    echo "Creating service file for qbittorrent-nox"
    echo "
[Unit]
Description=Qbittorrent-nox

[Service]
User=root
Type=simple
ExecStart=qbittorrent-nox 
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
" >>/etc/systemd/system/qbittorrent-nox.service
    clear 
    sleep 2
    chmod +x /etc/systemd/system/qbittorrent-nox.service
    echo "Installed qbittorrent-nox on ::8096"
    clear
    sleep 2
    # installing filebrowser
    echo "Please wait ..."
    sleep 3
    clear
    sleep 5
    echo "[ FileBrowser ]"
    sleep 3
    echo "Installing filebrowser on ::1001 ...."
    sleep 3
    curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
    sleep 2
    echo "Creating service file for filebrowser"
    echo "
 [Unit]
 Description= FileBrowser

 [Service]
 User=root
 ExecStart=filebrowser -a 0.0.0.0 -p 1001 -r /usr/Downloads
 Restart=on-failure
 RestartSec=5s
 
 [Install]
 WantedBy=multi-user.target
 " >>/etc/systemd/system/filebrowser.service
    echo "Installing filebrowser on ::1001"
    clear
    chmod +x /etc/systemd/system/filebrowser.service 
    echo "Installed filebrowser on ::1001"
    sleep 2
    #installing Jellyfin
    echo "Please wait ..."
    sleep 3
    clear
    sleep 5
    echo "[ Jellyfin Server ]"
    sleep 3
    echo "Installing jellfin-server on ::8096"
    sleep 3
    printf '\n' | curl https://repo.jellyfin.org/install-debuntu.sh | bash -s --
    clear
    echo "Installed jellyfin-server on ::8096"
    sleep 2
    source .profile
    systemctl enable filebrowser
    systemctl enable qbittorrent-nox
    systemctl start qbittorrent-nox
    systemctl start filebrowser
    systemctl start jellyfin
    systemctl restart qbittorrent-nox
    systemctl restart filebrowser
    sleep 3
}

# Show prompt
clear
echo -e "${White}[ BASIC STREAMING TOOLS SETUP ]${ENDCOLOR}"
echo ""
echo -e "${Green}1. Install (FileBrowser, Qbittorrent-nox, Jellyfin${ENDCOLOR}"
echo -e "${Red}2. Uninstall (FileBrowser, Qbittorrent-nox, Jellyfin${ENDCOLOR}"
echo ""
echo "Enter your choice: "

read choose
case $choose in
1)
    echo "[ STARTING INSTALLATION ....]"
    installer
    clear
    echo "[ INSTALLATION COMPLETED ]"
    ;;
2)
    echo "[ UNINSTALLING TOOLS ....]"
    uninstaller
    clear
    ;;
esac
