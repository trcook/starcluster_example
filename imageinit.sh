#!/usr/bin/env bash



# recommended: ami-52a0c53b. 
# Type starcluster -r us-east-1 listpublic to get list of current
# Basic command is:
# starcluster start -o -s 1 -I <INSTANCE-TYPE> -m <BASE-AMI-ID> imagehost
starcluster start -o -s 1 -b 0.05 -I 'c4.large' -m ami-52a0c53b imagehost
#starcluster start -s 5 -I 't2.micro'
# starcluster start -o -s 1 -b 0.03 -I 'c4.large' -m ami-22bc8b4a imagehost
# to make new image: starcluster ebsimage i-6eb33592 starclusteR_03_31_14
# stop here -- you probably need to wait and be sure that you can login first. 


starcluster put imagehost run_on_remote.zsh /home/run_on_remote.zsh

starcluster put imagehost packages.R /home/packages.R





#from http://ronert-obst.com/blog/2013-09-01-starcluster.html -- ssh into the img server, run the setup and then log the result. As a bonus, we start the tmux session foo, so we can see what's up on the other end. 

    cmd="tmux new-session -d -s foo; tmux send -t foo source\ /home/run_on_remote.zsh >& /home/install.log ENTER"
    starcluster sshmaster imagehost "$cmd"&


