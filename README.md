# hr-scan

Event script for insaned (https://github.com/abusenius/insaned) to scan and upload PDF to nextcloud/webdav on the command line.

# Setup

## insaned setup on Raspberry Pi

```
# library required for building
sudo apt install sane libsane-dev build-essential

# clone & build
git clone https://github.com/abusenius/insaned.git
cd insaned
make

# install insaned by putting everything in place and starting/enabling the service
sudo cp insaned /usr/bin
sudo cp systemd/insaned.service /etc/systemd/system
touch /etc/default/insaned
systemctl start insaned
systemctl enable insaned

# link the scripts from this repostiory to the place where insaned expects them
sudo ln -s insaned /etc
```

