#! /bin/bash

#installing shareable-block
cd /edx/app/edxapp
sudo git clone "https://github.com/collabassess/CPSXblock.git"
sudo -u edxapp /edx/bin/pip.edxapp install CPSXblock/ --no-deps
cd CPSXblock
stty -echo
printf "Mysql root username:\n" 
read -s root
printf "password\n"
read -s password
stty echo

mysql -u $root -p $password -h localhost < Database\ file/collab_assess.sql

sudo /edx/bin/supervisorctl restart edxapp:*