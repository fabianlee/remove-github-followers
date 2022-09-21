#!/bin/bash
#
# creates systemd service that removes followers from github account
#

user=githubservice
service=github

if id "$user" >/dev/null 2>&1; then
  echo "$user user already exists"
else
  echo "Creating user $user"
  sudo useradd $user -s /sbin/nologin -M
fi

[ -n "$github_pat" ] || { echo "ERROR define 'github_pat' as environment variable"; exit 3; }

# path to bash script that will be executed
scriptdir=$(realpath ..)
[ -f "$scriptdir/remove-github-followers.sh" ] || { echo "ERROR did not find script: $scriptdir/remove-github-followers.sh"; exit 3; }

# create custom systemd service file
sed "s#\$scriptdir#${scriptdir}#g" $service.service | sudo tee /lib/systemd/system/$service.service >/dev/null
sudo chmod 655 /lib/systemd/system/$service.service
echo "created systemd service file: /lib/systemd/system/$service.service"

# create custom systemd timer file
sudo cp $service.timer /lib/systemd/system/.
sudo chmod 655 /lib/systemd/system/$service.timer

echo "reloading systemctl..."
sudo systemctl daemon-reload

# create custom environment configuration where github personal access token is set
if [ ! -f /etc/default/github ]; then
  echo "github_pat=$github_pat" | sudo tee /etc/default/github
fi
sudo chmod 600 /etc/default/github

echo "configuring syslog"
if [ -d /etc/rsyslog.d ]; then
  echo "rsyslog is already configured, copying custom configuration into /etc/rsyslog.d"
  sudo cp 30-remove-github-followers.conf /etc/rsyslog.d/.
  sudo systemctl restart rsyslog
  echo "rsyslog service restarted"
else
  echo "rsyslog is not configured on this host. Logs will only go to journalctl"
fi

echo "starting service $service"
sudo systemctl enable $service.service $service.timer
sudo systemctl start $service.service
sudo systemctl start $service.timer

echo "==========================="
echo "list of $service services available..."
sudo systemctl --no-pager | grep $service

echo "==========================="
echo "list of timers for $service available..."
sudo systemctl list-timers --no-pager | grep $service

echo ""
echo "==========================="
echo "logs for service $service"
sudo journalctl -u $service.service --no-pager


