#!/bin/bash
#
# creates systemd service that removes followers from github account
#

user=$(id -un)
service=github

echo $XDG_RUNTIME_DIR
echo $DBUS_SESSION_BUS_ADDRESS

userdir=$(realpath ~)
echo "user home dir: $userdir"

# path to bash script that will be executed
scriptdir=$(realpath ..)
[ -f "$scriptdir/remove-github-followers.sh" ] || { echo "ERROR did not find script: $scriptdir/remove-github-followers.sh"; exit 3; }

# make directory for use-level systemd service
mkdir -p ~/.config/systemd/user/

# create user level systemd service file
sed "s#\$scriptdir#${scriptdir}#g; s#\$userdir#${userdir}#g" github.service | tee ~/.config/systemd/user/github.service >/dev/null
chmod 655 ~/.config/systemd/user/github.service
echo "created systemd service file: ~/.config/systemd/user/github.service"

# create custom systemd timer file
cp github.timer ~/.config/systemd/user/.
chmod 655 ~/.config/systemd/user/github.timer

echo "reloading systemctl..."
systemctl --user daemon-reload

echo "making log directory at $userdir/log/githubservice"
mkdir -p $userdir/log/githubservice
chmod -R 755 $userdir/log

# create custom environment configuration where github personal access token is set
if [ ! -f ~/default/githubservice ]; then
  mkdir -p ~/default
  echo "github_pat=" | tee ~/default/githubservice
fi
chmod 600 ~/default/githubservice

echo "starting service $service"
systemctl --user enable $service.service $service.timer
systemctl --user start $service.service
systemctl --user start $service.timer

echo "==========================="
echo "list of $service services available..."
systemctl --user --no-pager | grep github

echo "==========================="
echo "list of timers for $service available..."
systemctl --user list-timers --no-pager | grep github

echo ""
echo "==========================="
echo "logs for service $service"
journalctl --user -u $service.service --no-pager | tail -n10
