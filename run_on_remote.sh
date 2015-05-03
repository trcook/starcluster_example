#! /usr/bin/zsh

# This script is run remotely, on the image server

# from http://ronert-obst.com/blog/2013-09-01-starcluster.html
echo "deb http://stat.ethz.ch/CRAN/bin/linux/ubuntu precise/" >> /etc/apt/sources.list
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
apt-get update
apt-get install -y r-base r-base-dev
apt-get install curl
apt-get install libcurl4-openssl-dev
apt-get install libxml2-dev

apt-get install python-pip
pip install s3cmd==1.5.0-alpha3

# optional: to install rstudio server: 
# apt-get install gdebi-core
#  apt-get install libapparmor1
# wget http://download2.rstudio.org/rstudio-server-0.98.1103-amd64.deb
# gdebi rstudio-server-0.98.1103-amd64.deb

echo ubuntu | passwd --stdin ubuntu

sudo dd if=/dev/zero of=/swapfile bs=8192 count=256k

sudo mkswap /swapfile
sudo swapon /swapfile

sudo echo "/swapfile       none    swap    sw      0       0 ">>/etc/fstab

Rscript -e "source('packages.R')"