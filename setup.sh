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

# Bold
BBlack='\033[1;30m'  # Black
BRed='\033[1;31m'    # Red
BGreen='\033[1;32m'  # Green
BYellow='\033[1;33m' # Yellow
BBlue='\033[1;34m'   # Blue
BPurple='\033[1;35m' # Purple
BCyan='\033[1;36m'   # Cyan
BWhite='\033[1;37m'  # White

# Underline
UBlack='\033[4;30m'  # Black
URed='\033[4;31m'    # Red
UGreen='\033[4;32m'  # Green
UYellow='\033[4;33m' # Yellow
UBlue='\033[4;34m'   # Blue
UPurple='\033[4;35m' # Purple
UCyan='\033[4;36m'   # Cyan
UWhite='\033[4;37m'  # White

# Background
On_Black='\033[40m'  # Black
On_Red='\033[41m'    # Red
On_Green='\033[42m'  # Green
On_Yellow='\033[43m' # Yellow
On_Blue='\033[44m'   # Blue
On_Purple='\033[45m' # Purple
On_Cyan='\033[46m'   # Cyan
On_White='\033[47m'  # White

# High Intensity
IBlack='\033[0;90m'  # Black
IRed='\033[0;91m'    # Red
IGreen='\033[0;92m'  # Green
IYellow='\033[0;93m' # Yellow
IBlue='\033[0;94m'   # Blue
IPurple='\033[0;95m' # Purple
ICyan='\033[0;96m'   # Cyan
IWhite='\033[0;97m'  # White

# Bold High Intensity
BIBlack='\033[1;90m'  # Black
BIRed='\033[1;91m'    # Red
BIGreen='\033[1;92m'  # Green
BIYellow='\033[1;93m' # Yellow
BIBlue='\033[1;94m'   # Blue
BIPurple='\033[1;95m' # Purple
BICyan='\033[1;96m'   # Cyan
BIWhite='\033[1;97m'  # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'  # Black
On_IRed='\033[0;101m'    # Red
On_IGreen='\033[0;102m'  # Green
On_IYellow='\033[0;103m' # Yellow
On_IBlue='\033[0;104m'   # Blue
On_IPurple='\033[0;105m' # Purple
On_ICyan='\033[0;106m'   # Cyan
On_IWhite='\033[0;107m'  # White
ENDCOLOR="\e[0m"

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
    echo "alias ports='netstat -tulpn | grep LISTEN'" >>.profile

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
ExecStart=qbittorrent-nox 
" >>/etc/systemd/system/qbittorrent-nox.service
    clear 
    sleep 2
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
 " >>/etc/systemd/system/filebrowser.service
    echo "Installing filebrowser on ::1001"
    clear
    sleep 2
    #installing emby-server
    echo "Please wait ..."
    sleep 5
    echo "[ Emby Server ]"
    sleep 3
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
    systemctl restart filebrowserfi
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
