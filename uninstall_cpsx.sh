#! /bin/bash

#uninstalling cpsxblock
sudo -u edxapp /edx/bin/pip.edxapp uninstall cpsxblock-xblock
sudo /edx/bin/supervisorctl restart edxapp:*
