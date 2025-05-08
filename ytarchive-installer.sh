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

# dependencies
apt install wget -y
apt install unzip -y

# install ffmpeg and ytarchive
apt install ffmpeg -y 

# download ytarchive
wget https://github.com/Kethsar/ytarchive/releases/download/v0.5.0/ytarchive_linux_amd64.zip && unzip ytarchive_linux_amd64.zip
rm -rf ytarchive_linux_amd64.zip
chmod +x ytarchive

# copy ytarchive to /usr/local/bin/
mv ytarchive /usr/local/bin

# download ytcookie
# check if path exists
if [ ! -d "/usr/Downloads" ]; then
    mkdir /usr/Downloads
fi

wget https://raw.githubusercontent.com/crixsz/3BasicStreams/refs/heads/main/files/ytcookie && chmod +x ytcookie
wget https://raw.githubusercontent.com/crixsz/3BasicStreams/refs/heads/main/files/cookie.txt -O /usr/Downloads/cookie.txt
# copy ytcookie to /usr/local/bin/
mv ytcookie /usr/local/bin
