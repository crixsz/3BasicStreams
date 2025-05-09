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
function install_qbittorrent_nox() {
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
    sleep 2
    clear 
    sleep 2
    chmod +x /etc/systemd/system/qbittorrent-nox.service
    systemctl start qbittorrent-nox
    # Check if qbittorrent-nox service is running
    if systemctl is-active --quiet qbittorrent-nox; then
        echo "qbittorrent-nox service is running."
    else
        echo "qbittorrent-nox service is not running. Exiting..."
        exit 1
    fi
}

function install_stable_filebrowser() {
    echo "[ FileBrowser ]"
    sleep 3
    echo "Installing filebrowser on ::1001 ...."
    sleep 3
    # Detect system architecture
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        FILE="linux-amd64-filebrowser.tar.gz"
    elif [[ "$ARCH" == "aarch64" ]]; then
        FILE="linux-arm64-filebrowser.tar.gz"
    elif [[ "$ARCH" == "armv7l" ]]; then
        FILE="linux-armv7-filebrowser.tar.gz"
    else
        echo "Unsupported architecture: $ARCH"
        exit 1
    fi
    echo "Downloading FileBrowser v2.31.2 for $ARCH..."
    wget -O filebrowser.tar.gz "https://github.com/filebrowser/filebrowser/releases/download/v2.31.2/linux-amd64-filebrowser.tar.gz"

    echo "Extracting..."
    tar -xzf filebrowser.tar.gz

    chmod +x filebrowser

    # Move to /usr/local/bin
    mv filebrowser /usr/local/bin/

    # Cleanup
    rm -rf filebrowser.tar.gz
    rm -rf CHANGELOG.md
    rm -rf README.md
    rm -rf LICENSE
    # Remove existing filebrowser binary if it exists
    if [ -f "/root/filebrowser" ]; then
        rm -rf /root/filebrowser
    fi
    if [ -f "/usr/local/bin/filebrowser" ]; then
         echo "FileBrowser installed"
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
    sleep 2
    clear
    chmod +x /etc/systemd/system/filebrowser.service 
    echo "Installed filebrowser on ::1001"
    else
        echo "FileBrowser not installed.. exiting..."
        exit 1
    fi
   
}
function install_filebrowser_qbittorrent() {
    #create directory
    if [ ! -d "/usr/Downloads" ]; then
        mkdir /usr/Downloads
    fi
    if [ ! -d "/usr/Movies" ]; then
        mkdir /usr/Movies
    fi
    clear
    echo "Please wait ..."
    sleep 3
    clear
    install_qbittorrent_nox
    clear
    sleep 2
    # installing filebrowser
    echo "Please wait ..."
    sleep 3
    clear
    sleep 3
    install_stable_filebrowser
    sleep 2
    systemctl enable filebrowser
    systemctl enable qbittorrent-nox
    systemctl start qbittorrent-nox
    systemctl start filebrowser
}
function uninstaller() {
    clear
    echo "Uninstalling all tools (Qbittorrent-nox, FileBrowser, Jellyfin).."
    sleep 5
    rm -rf /etc/systemd/system/qbittorrent-nox.service
    rm -rf /etc/systemd/system/filebrowser.service
    apt-get -y remove jellyfin
    systemctl stop jellyfin
    systemctl stop qbittorrent-nox
    systemctl stop filebrowser
    systemctl daemon-reload
    systemctl reset-failed
    echo "[Uninstall Successfully]"

}

function installer() {
    clear
    echo "[ UPDATING THE APT AND INSTALLING NECESSARY FILES ]"
    apt-get update -y >> /dev/null
    apt-get install -y curl >> /dev/null
    apt-get install -y wget >> /dev/null
    #create directory
    if [ ! -d "/usr/Downloads" ]; then
        mkdir /usr/Downloads
    fi
    if [ ! -d "/usr/Movies" ]; then
        mkdir /usr/Movies
    fi
    clear
    #installing qbittorrent-nox
    echo "Please wait ..."
    sleep 3
    clear
    sleep 5
    install_qbittorrent_nox
    # Configure qBittorrent-nox default download location
    echo "Configuring qBittorrent-nox default download location..."
    mkdir -p ~/.config/qBittorrent
    echo "General\DefaultSavePath=/usr/Downloads" > ~/.config/qBittorrent/qBittorrent.conf
    
    echo "Installed qbittorrent-nox on ::8096"
    clear
    sleep 2
    # installing filebrowser
    echo "Please wait ..."
    sleep 3
    clear
    sleep 3
    install_stable_filebrowser
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
    curl -s https://repo.jellyfin.org/install-debuntu.sh | bash
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
echo -e "[ BASIC STREAMING TOOLS SETUP ]"
echo ""
echo -e "1. Install (FileBrowser, Qbittorrent-nox, Jellyfin"
echo -e "2. Install (FileBrowser, Qbittorrent-nox)"
echo -e "3. Uninstall (FileBrowser, Qbittorrent-nox, Jellyfin"
echo ""
echo "Enter your choice: "

read choose
case $choose in
1)
    echo "[ STARTING INSTALLATION (Full)....]"
    installer
    clear
    echo "[ INSTALLATION COMPLETED (Full) ]"
    echo "Filebrowser = http://$(curl -s ipinfo.io/ip):1001"
    echo "Qbittorrent = http://$(curl -s ipinfo.io/ip):8080"
    echo "Jellyfin = http://$(curl -s ipinfo.io/ip):8096"
    ;;
2)
    echo "[ STARTING INSTALLATION (Minimal)....]"
    install_filebrowser_qbittorrent
    clear
    echo "[ INSTALLATION COMPLETED (Minimal) ]"
    echo "Filebrowser = http://$(curl -s ipinfo.io/ip):1001"
    echo "Qbittorrent = http://$(curl -s ipinfo.io/ip):8080"
    ;;
3)
    echo "[ UNINSTALLING TOOLS ....]"
    uninstaller
    clear
    ;;
esac
