# hr-scan

Event script for insaned (https://github.com/abusenius/insaned) to scan and upload PDF to nextcloud/webdav on the command line.

# Setup

## insaned setup on Raspberry Pi

```
# library required for building
sudo apt install sane libsane-dev build-essential git

# clone & build
git clone https://github.com/abusenius/insaned.git
cd insaned
make

# install insaned by putting everything in place and starting/enabling the service
sudo cp insaned /usr/bin
sudo cp systemd/insaned.service /etc/systemd/system
sudo touch /etc/default/insaned
sudo systemctl start insaned
sudo systemctl enable insaned
```

## Enable the scripts from this repository

```
# link the scripts from this repostiory to the place where insaned expects them
sudo ln -s insaned /etc

# make them executable
sudo chmod +x /etc/insaned/events/*
```

For scanners with 3 buttons the scripts should work out of the box. You can customize the scripts by copying `default_options` to `config` and remove the options you don't want to modify. Keep in mind that the `EXEC_*` options are executed as is with root permissions (insaned is executed as root by default).

This is an example config that uploads scans to nextcloud and blinks one of these fancy USB-LEDs while busy:
```
# config:
WEBDAV_USER_PASS=user:passwd
WEBDAV_URL=https://example.com/remote.php/dav/files/user/Documents/Scans/
EXEC_OFF="blink1-tool --off -l2 -m1000"
EXEC_ON="blink1-tool --rgb=0,255,0 -l2 -m1000"
EXEC_START="blink1-tool --rgb=255,120,0 -m1000 -l2"
EXEC_UPLOAD_START="blink1-tool --rgb=255,0,0 -m500 -l2"
EXEC_FINISH="blink1-tool --rgb=0,255,0 -m1000 -l2"
```