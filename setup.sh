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

function install_stable_AList() {
    echo "[ AList ]"
    echo "Installing AList..."
        
    # Stop the service if it exists
    if [ -f /etc/systemd/system/alist.service ]; then
        systemctl stop alist || true
    fi
    
    # Create the data directory
    mkdir -p /var/lib/alist
    
    # Download the AList tarball
    wget https://github.com/AlistGo/alist/releases/download/v3.45.0/alist-linux-amd64.tar.gz -O /tmp/alist-linux-amd64.tar.gz
    
    # Extract the tarball
    tar -zxvf /tmp/alist-linux-amd64.tar.gz -C /tmp
    
    # Move the binary to /usr/local/bin and make it executable
    mv /tmp/alist /usr/local/bin/alist
    chmod +x /usr/local/bin/alist
    
    # Set the admin password in the data directory
    cd /var/lib/alist
    /usr/local/bin/alist admin set zoxxenon
    
    # Create the systemd service file
    cat > /etc/systemd/system/alist.service <<EOF
[Unit]
Description=AList Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/lib/alist
ExecStart=/usr/local/bin/alist server
Restart=always

[Install]
WantedBy=multi-user.target
EOF
        
    # Reload systemd, start, and enable the service
    systemctl daemon-reload
    systemctl start alist
    systemctl enable alist
    
    # Clean up the temporary tarball
    rm /tmp/alist-linux-amd64.tar.gz
    
    echo "AList installed successfully."
}

function install_AList_qbittorrent() {
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
    # installing AList
    echo "Please wait ..."
    sleep 3
    clear
    sleep 3
    install_stable_AList
    sleep 2
    systemctl enable AList
    systemctl enable qbittorrent-nox
    systemctl start qbittorrent-nox
    systemctl start AList
}
function uninstaller() {
    clear
    echo "Uninstalling all tools (Qbittorrent-nox, AList, Jellyfin).."
    sleep 5
    rm -rf /etc/systemd/system/qbittorrent-nox.service
    rm -rf /etc/systemd/system/AList.service
    apt-get -y remove jellyfin
    systemctl stop jellyfin
    systemctl stop qbittorrent-nox
    systemctl stop AList
    systemctl daemon-reload
    systemctl reset-failed
    echo "Uninstalling AList..."
    systemctl stop alist || true
    systemctl disable alist || true
    rm -f /etc/systemd/system/alist.service
    systemctl daemon-reload
    rm -f /usr/local/bin/alist
    rm -rf /var/lib/alist
    echo "AList uninstalled successfully."
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
    # installing AList
    echo "Please wait ..."
    sleep 3
    clear
    sleep 3
    install_stable_AList
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
    systemctl enable AList
    systemctl enable qbittorrent-nox
    systemctl start qbittorrent-nox
    systemctl start AList
    systemctl start jellyfin
    systemctl restart qbittorrent-nox
    systemctl restart AList
    sleep 3
}

# Show prompt
clear
# Check if any already installed
if [ -f /usr/local/bin/alist ] || [ -f /usr/bin/jellyfin ] || [ -f /usr/bin/qbittorrent-nox ]; then
    echo "[ WARNING ]"
    echo "It seems that you already have AList, Qbittorrent-nox, or Jellyfin installed."
    echo "Uninstalling ..."
    uninstaller
fi
echo -e "[ BASIC STREAMING TOOLS SETUP ]"
echo ""
echo -e "1. Install (AList, Qbittorrent-nox, Jellyfin"
echo -e "2. Install (AList, Qbittorrent-nox)"
echo -e "3. Uninstall (AList, Qbittorrent-nox, Jellyfin"
echo ""
echo "Enter your choice: "

read choose
case $choose in
1)
    echo "[ STARTING INSTALLATION (Full)....]"
    installer
    clear
    echo "[ INSTALLATION COMPLETED (Full) ]"
    echo "AList = http://$(curl -s ipinfo.io/ip):5244"
    echo "Qbittorrent = http://$(curl -s ipinfo.io/ip):8080"
    echo "Jellyfin = http://$(curl -s ipinfo.io/ip):8096"
    ;;
2)
    echo "[ STARTING INSTALLATION (Minimal)....]"
    install_AList_qbittorrent
    clear
    echo "[ INSTALLATION COMPLETED (Minimal) ]"
    echo "AList = http://$(curl -s ipinfo.io/ip):5244"
    echo "Qbittorrent = http://$(curl -s ipinfo.io/ip):8080"
    ;;
3)
    echo "[ UNINSTALLING TOOLS ....]"
    uninstaller
    clear
    ;;
esac
