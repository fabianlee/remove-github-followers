# remove-github-followers

Script that checks if you have github followers, then temporarily blocks/unblocks which removes them as followers.  

Unfortunately, there is not an option to block followers.
https://stackoverflow.com/questions/31313863/how-to-delete-my-follower-at-github

This script uses a github personal access token for api authentication.
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
