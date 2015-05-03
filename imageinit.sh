#!/usr/bin/env bash
# probably don't run this as a script -- there are parts of this where you need to wait for things to complete



# recommended: ami-52a0c53b. it's ubuntu 12.04 lts
# Type starcluster -r us-east-1 listpublic to get list of current
# Basic command is:
# starcluster start -o -s 1 -I <INSTANCE-TYPE> -m <BASE-AMI-ID> imagehost
starcluster start -o -s 1 -b 0.05 -I 'c4.large' -m ami-52a0c53b imagehost
# stop here -- you probably need to wait and be sure that you can login first. 

# upload the scripts that do the installing and R package installing
starcluster put imagehost run_on_remote.sh /home/run_on_remote.sh

starcluster put imagehost packages.R /home/packages.R





#from http://ronert-obst.com/blog/2013-09-01-starcluster.html -- ssh into the img server, run the setup and then log the result. As a bonus, we start the tmux session foo, so we can see what's up on the other end. 

    cmd="tmux new-session -d -s foo; tmux send -t foo source\ /home/run_on_remote.zsh >& /home/install.log ENTER"
    starcluster sshmaster imagehost "$cmd"
    starcluster sshmaster imagehost
    tmux attach


#get the instance id with starcluster listinstances
# copy the id (something like 'i-6eb33592') and put it inthe following code to make a saved ami image
# to make new image: 
starcluster ebsimage i-6eb33592 cluster_name_here
