#!/bin/bash
#
# setup_openlst_401_native_ubuntu.sh
# A bash script that sets up OpenLST 401 natively on Ubuntu-like systems
#
# Usage: sudo ./setup_openlst_401_native_ubuntu.sh
# Assumptions:
#  - Ubuntu OS with sudo permissions
# Arguments:
#  - None
# Results:
#  - Sets up OpenLST 401 natively
#
# Written by Bradley Denby
# Other contributors: None
#
# See the top-level LICENSE file for the license.

# Install dependencies
sudo apt install --assume-yes linux-image-extra-virtual git build-essential \
 pkg-config libusb-1.0-0-dev libboost-all-dev sdcc

# Install cc-tool
if [ ! -d "$HOME/git-repos/" ]
then
  mkdir $HOME/git-repos/
fi
cd $HOME/git-repos/
git clone https://github.com/dashesy/cc-tool.git
cd cc-tool/
git checkout d5bb566d7ed49e7f7ce7f80015c2ead17de77d48
CPPFLAGS="-P" ./configure
make
sudo make install

# Install udev rules
cd $HOME/git-repos/
git clone https://github.com/CMUAbstract/openlst-401.git
sudo cp openlst-401/open-lst/tools/90-radio.rules \
 /etc/udev/rules.d/90-radio.rules

# Install Python dependencies
sudo apt install --assume-yes python2-dev libpython2-dev curl
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
sudo python2 -m pip install -e openlst-401/open-lst/tools

# Install the radio services
sudo usermod -aG dialout $USER
sed -i -e "s,User=vagrant,User=${USER}," \
 openlst-401/open-lst/tools/radio@.service
sudo cp openlst-401/open-lst/tools/radio@.service \
 /etc/systemd/system/radio@.service
sudo systemctl daemon-reload
sudo systemctl enable radio@0 radio@1

# Useful commands for when the radio services are acting up
#sudo systemctl status radio@1.service
#sudo systemctl stop radio@1.service
#sudo systemctl start radio@1.service

