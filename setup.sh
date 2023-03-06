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
    echo "Uninstalling all tools (Qbittorrent-nox, FileBrowser, Emby-server).."
    sleep 5
    systemctl stop emby-server
    systemctl stop qbittorrent-nox
    systemctl stop filebrowser
    rm -rf /etc/systemd/system/qbittorrent-nox.service
    rm -rf /etc/systemd/system/filebrowser.service
    apt-get remove emby-server
    echo "[Uninstall Successfully]"

}

function installer() {
    echo "[ UPDATING THE APT AND INSTALLING NECESSARY FILES ]"
    apt-get -y update >> /dev/null
    apt-get -y upgrade >> /dev/null
    apt-get install -y curl >> /dev/null
    apt-get install -y wget >> /dev/null
    apt-get install -y neofetch >> /dev/null
    apt-get install -y net-tools >> /dev/null
    echo "alias ports='netstat -tulpn | grep LISTEN'" >>.profile
    echo "netstat" >> .profile
    #create directory
    mkdir Downloads
    clear

    #installing qbittorrent-nox
    echo "Please wait ..."
    sleep 5
    echo "[ Qbittorent-Nox ]"
    sleep 3
    echo "Installing Qbittorrent-nox on ::8080 ..."
    sleep 3
    sudo add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
    sudo apt install -y qbittorrent-nox >> /dev/null
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
    sudo chmod +x /etc/systemd/system/qbittorrent-nox.service
    echo "Installed qbittorrent-nox on ::8096"
    clear
    sleep 2
    # installing filebrowser
    echo "Please wait ..."
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
 ExecStart=filebrowser -a 0.0.0.0 -p 1001 -r /root/Downloads
 Restart=on-failure
 RestartSec=5s
 
 [Install]
 WantedBy=multi-user.target
 " >>/etc/systemd/system/filebrowser.service
    echo "Installing filebrowser on ::1001"
    clear
    sleep 2
    #installing emby-server
    echo "Please wait ..."
    sleep 5
    echo "[ Emby Server ]"
    sleep 3
    suod chmod +x /etc/systemd/system/filebrowser.service
    echo "Installing emby-server on ::8096"
    sleep 3
    wget https://github.com/MediaBrowser/Emby.Releases/releases/download/4.7.11.0/emby-server-deb_4.7.11.0_amd64.deb
    dpkg -i emby-server-deb_4.7.11.0_amd64.deb
    clear
    echo "Installed emby-server on ::8096"
    sleep 2
    source .profile
    # The text that you want to replace
    old_text="User=emby"

    # The text that you want to replace it with
    new_text="User=root"
    # Use sed to replace the text and save the changes to the same file
    sed -i "s/$old_text/$new_text/g" /lib/systemd/system/emby-server.service
    systemctl enable filebrowser
    systemctl enable qbittorrent-nox
    systemctl start qbittorrent-nox
    systemctl start filebrowser
    systemctl start emby-server
    systemctl restart qbittorrent-nox
    systemctl restart filebrowser
    sleep 3
}

# Show prompt
clear
echo -e "${White}[ BASIC STREAMING TOOLS SETUP ]${ENDCOLOR}"
echo ""
echo -e "${Green}1. Install (FileBrowser, Qbittorrent-nox, Emby-server${ENDCOLOR}"
echo -e "${Red}2. Uninstall (FileBrowser, Qbittorrent-nox, Emby-server${ENDCOLOR}"
echo ":"

read choose
case $choose in
1)
    echo "[ STARTING INSTALLATION ....]"
    installer
    clear
    echo "System will reboot in 5 second"
    sleep 5
    reboot
    ;;
2)
    echo "[ UNINSTALLING TOOLS ....]"
    uninstaller
    clear
    ;;
esac
