#!/bin/bash
#
# deletes systemd service that removes followers from github account
#

user=$(id -un)
service=github

echo "stopping service $service"

systemctl --user stop $service.timer
systemctl --user stop $service.service
systemctl --user disable $service.service $service.timer
echo "stopped and disabled user-level systemd services: $service"

rm ~/.config/systemd/user/github.service
rm ~/.config/systemd/user/github.timer
echo "deleted files for user-level $service in ~/.config/systemd/user"

systemctl --user daemon-reload
echo "restarted systemd daemon"

echo "==========================="
echo "list of $service user-level services still available..."
systemctl --user --no-pager | grep github

echo "==========================="
echo "list of timers for $service user-level timers still available..."
systemctl --user list-timers --no-pager | grep github
