#! /bin/bash

#updating cpsxblock
cd /edx/app/edxapp/CPSXblock
sudo git pull
cd ../
sudo -u edxapp /edx/bin/pip.edxapp install CPSXblock/ --upgrade --no-deps
sudo /edx/bin/supervisorctl restart edxapp:*
