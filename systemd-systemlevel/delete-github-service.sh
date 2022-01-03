#!/bin/bash
#
# deletes systemd service that removes followers from github account
#

user=githubservice
service=github

echo "stopping service $service"

sudo systemctl stop $service.timer
sudo systemctl stop $service.service
sudo systemctl disable $service.service $service.timer
echo "stopped and disabled systemd services: $service"

sudo rm /lib/systemd/system/github.service
sudo rm /lib/systemd/system/github.timer
echo "deleted files for $service in /lib/systemd/system"

sudo systemctl daemon-reload
echo "restarted systemd daemon"

echo "==========================="
echo "list of $service services still available..."
sudo systemctl --no-pager | grep github

echo "==========================="
echo "list of timers for $service still available..."
sudo systemctl list-timers --no-pager | grep github
