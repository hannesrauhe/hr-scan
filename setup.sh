#!/bin/bash

# won't do this automatically for now:

# sudo apt install sane imagemagick
# sudo adduser $(whoami) scanner
# udev something
# sudo nano /etc/ImageMagick-6/policy.xml
# lsusb
# echo UBSYSTEM==\"usb\", ATTRS{idVendor}==\"04a9\", ATTRS{idProduct}==\"1608\", MODE=\"0666\" > /tmp/hrscan
# sudo cp /tmp/hrscan  /etc/udev/rules.d/90-scanner.rules
# restart

CONFIG_FILE=~/.hrscan/config.sh

if [ -f $CONFIG_FILE ] ; then
  echo "Config file $CONFIG_FILE exist. Aborting." 
  exit 1; 
fi

mkdir ~/.hrscan || true
cp config.sh.tmpl $CONFIG_FILE

cat $CONFIG_FILE