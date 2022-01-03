#!/bin/bash
#
# deletes systemd service that removes followers from github account
#

service=github

echo "stopping service $service"

sudo systemctl stop $service.timer
sudo systemctl stop $service.service
sudo systemctl disable $service.service $service.timer
echo "stopped and disabled systemd services: $service"

sudo rm /lib/systemd/system/$service.service
sudo rm /lib/systemd/system/$service.timer
echo "deleted files for $service in /lib/systemd/system"

sudo systemctl daemon-reload
echo "restarted systemd daemon"

echo "==========================="
echo "list of $service services still available..."
sudo systemctl --no-pager | grep $service

echo "==========================="
echo "list of timers for $service still available..."
sudo systemctl list-timers --no-pager | grep $service
