# remove-github-followers

Script that checks if you have github followers, then temporarily blocks/unblocks to remove them as followers.  

Accesses the github api using a github personal access token.
https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

## for one-time run
export github_pat=<github_personal_access_token>
./remove-github-followers.sh


## for periodic run with user-level systemd service
cd systemd-userlevel
./create-github-userservice.sh
vi ~/default/githubservice

tail -f ~/log/githubservice/*


## for periodic run with system-level systemd service
cd systemd-systemlevel
./create-github-service.sh
vi /etc/default/githubservice

tail -f /var/log/githubservice/github.log
