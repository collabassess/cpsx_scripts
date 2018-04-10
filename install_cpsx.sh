#! /bin/bash

#installing shareable-block
cd /edx/app/edxapp
sudo git clone "https://github.com/collabassess/CPSXblock.git"
sudo -u edxapp /edx/bin/pip.edxapp install CPSXblock/ --upgrade --no-deps
cd CPSXblock
stty -echo
printf "Mysql root username:\n" 
read -s root
stty echo

mysql -u $root -p -h localhost < Database\ file/collab_assess.sql

sudo /edx/bin/supervisorctl restart edxapp:*

mysql -u root -pedx -Bse "insert into collab_assess.user_info select id, ( case when round(rand()) = 1 Then 'male' else 'female' end) from edxapp.auth_user;"

mysql -u root -pedx --delimiter="//" -Bse "CREATE
    TRIGGER edxapp.new_user_add_gender AFTER INSERT
    ON auth_user
    FOR EACH ROW 
    BEGIN INSERT INTO collab_assess.user_info values(New.id,( case when round(rand()) = 1 Then 'male' else 'female' end)); 
    END //"

cd

sudo git clone "https://github.com/collabassess/cpsx-api.git"
cd cpsx-api
sudo npm install
sudo npm install pm2@latest -g
pm2 start bin/www