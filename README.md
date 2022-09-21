# remove-github-followers

blog: https://fabianlee.org/2022/01/06/github-removing-followers-with-the-github-api/

Script that checks if you have github followers, then temporarily blocks/unblocks which removes them as followers.  
Unfortunately, there is [not an option to block followers](https://stackoverflow.com/questions/31313863/how-to-delete-my-follower-at-github).

This script uses a [github personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for api authentication.


## for one-time run

```
export github_pat=<github_personal_access_token>
./remove-github-followers.sh
```
    
## for periodic run with user-level systemd service

```
export github_pat=<github_personal_access_token>
cd systemd-userlevel
./create-github-userservice.sh
vi ~/default/github
    
tail -f ~/log/github/*
```
    
## for periodic run with system-level systemd service

```
export github_pat=<github_personal_access_token>
cd systemd-systemlevel
./create-github-service.sh
vi /etc/default/github
    
tail -f /var/log/github/github.log
```
