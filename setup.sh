#!/bin/bash

## won't do this automatically for now:

# sudo apt install sane imagemagick
## remove the wild PDF policy
# sudo nano /etc/ImageMagick-6/policy.xml

## only if you want to be able to run scripts as non-root
# sudo adduser $(whoami) scanner
# lsusb
# echo UBSYSTEM==\"usb\", ATTRS{idVendor}==\"04a9\", ATTRS{idProduct}==\"1608\", MODE=\"0666\" > /tmp/hrscan
# sudo cp /tmp/hrscan  /etc/udev/rules.d/90-scanner.rules
## restart

## insaned on raspberry pi
# git clone https://github.com/abusenius/insaned.git
# sudo apt install libsane-dev
# cd insaned
# make
# sudo cp insaned /usr/bin
# sudo cp systemd/insaned.service /etc/systemd/system
# touch /etc/default/insaned
# systemctl start insaned
# systemctl enable insaned
# copy this repo to /etc/insaned/events

# puckjs
sudo apt install python3-pip libglib2.0-dev
sudo pip3 install bluepy
sudo python3 puckwatcher.py