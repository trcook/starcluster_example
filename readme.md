# running an R cluster
This is basically some startup scripting and tutorial on getting a cluster running on ec2. 
A lot of the actual documentation will be in the ipython document distributed in this file.



## repo contents: 
* bootstrap.sh -- create and launch a virtualenv for the requisite python code
* imageinit.sh -- use starcluster to launch an instance to configure a virtual device image. This image is what will be installed to each of your cluster nodes. DO NOT run this as a script. Run Open it up and run lines one at a time. At the very least, you will need to configure this manually to save your image using an appropriate name and instance id. This can't really be done until you have already started the instance running.

* run_on_remote.sh -- use in conjunction with imageinit.sh. This will install R and some other relevant libraries on your remote machine. 
* packages.R -- will be uploaded by imageinit.sh. Will be run by run_on_remote.sh. It will install listed R packages to your image.


## Things you need to get started: 
an aws account
your aws secret and aws key
Search around and you will find lots of info on how to get that much done. 

install a virtual env for running the requisite python via the bootstrap.sh command included in this repo, or just install out of the requirements text directly.
You also need to setup ssh to work correctly. This works differetnly depending on the machine and I have no idea how to get it to work in windows. 


## Basic idea
### first/One-time setup steps
1. bootstrap into a virtual environment using the bootstrap.sh script
	* this will intall a bunch of stuff. YOu can also just run `pip install -r requirements.txt` but this will install globally
	* After running bootstrap.sh, start the venv for the rest of this (starting from the repo root): `source ./venv/bin/activate`. To leave the venv, type deactivate at any time.
2. Configure star cluster. Type starcluster help. Follow the prompts. Then open up the config file and tweak as needed. The config file in this repo is a basic configuration to build from (but you will still need to edit it to put your info in). At a minimum, you will need to supply your awe secret, key, and id. 
2. configure your local `s3cmd --configure`
	* upload whatever to s3 as needed with `s3cmd put` -- see help files for how to do this, it's pretty straightforward. `s3cmd --help`
	* you may need to go to the s3 website to configure it further, add buckets, etc


3. run imageinit.sh line by line to create your image
	* you will have to do some troubleshooting along the way
	* This will upload and install scripts that install R, s3cmd and packages. 
	* save your image (see last lines of imageinit.sh)
	* to lookup your image number after you have created it: starcluster listimages
	* record the ami number (e.g. ami-abalkdf) 

3. open your starcluster configuration on your local computer
	* fill in the node_image_id with your ami number. 
	* fill in your cluster size and other options

### launching/using cluster (do this every time you want to start/manage cluster)
3. activate venv as above (`source ./venv/bin/activate`)
3. launch your cluster with starcluster start -c smallcluster mycluster
	* use spot instance bidding. TO get an idea of spot prices. see the included ipython notebook. (it also has some other important odds and ends)
3. login to the head node of your cluster with `starcluster sshmaster mycluster`
3. attach to the tmux session with tmux -a 
	* if starcluster has not made a tmux session for you, you can easily do it yourself with `tmux` 
	* see https://gist.github.com/trcook/075583c13db67c63ee83 for key commands in tmux. you need these to gracefully detach
3. once inside your tmux session, configure s3cmd for the REMOTE machines (same process as above). 
3. bring in your data via `s3cmd get` from s3 (using s3 as an intermediary is a really efficient and cost effective way to go with this. you also don't get charged for data ingress into the ebs volume -- i don't think). 
3. pull up R with `R`
1. launch your code with parallelization. for example:
	```r
	# require(doSNOW)
	n = 2 # number of cores on each node
	clist<-c(rep('localhost',n),rep("node001",n)) # i.e. repeat node name for the # of cores on each node
	cl<-makeSOCKcluster(clist)
	registerDoSNOW(cl)
	# parallel code here
	stopCluster(cl)

	```
2. launch a seperate pane in tmux by pressing the following sequence: `ctrl-b` then `shift-6`. type `htop`. Now, type `ctrl-b shift-6` and then `ssh node001` to login to node 001 in a new window. Then type `htop`. Repeat as needed to get  a sense of how each node is performing. You want walled processors across the board -- otherwise you aren't making good use of the server time.
3. save your results in R to a dataset or workspace image and quit R
4. export back out to s3 with `s3cmd put`
4. terminate or stop the cluster with `starcluster terminate mycluster` (or `stop` instead of `terminate` if you just want to hold the cluster as is and come back to it later -- you can't do this with spot instances) on your local machine
5. download locally with `s3 get` on your local machine for further processing
6. profit.
