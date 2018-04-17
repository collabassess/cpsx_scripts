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

mysql -u $root -p -Bse "insert into collab_assess.user_info select id, ( case when round(rand()) = 1 Then 'shark' else 'jet' end) from edxapp.auth_user;"

    
mysql -u $root -p --delimiter="//" -Bse "CREATE
    TRIGGER after_gender_update AFTER UPDATE
    ON edxapp.auth_userprofile
    FOR EACH ROW BEGIN
        IF NEW.gender is not NULL
            THEN UPDATE collab_assess.user_info SET gender=NEW.gender WHERE user_id=New.user_id;
        END IF;
	END//"

mysql -u $root -p --delimiter="//" -Bse "CREATE
    TRIGGER after_gender_insert AFTER INSERT
    ON edxapp.auth_userprofile
    FOR EACH ROW BEGIN
        IF NEW.gender is not NULL
            THEN INSERT INTO collab_assess.user_info values(New.user_id,( case when round(rand()) = 1 Then 'shark' else 'jet' end),NEW.gender);
        END IF;
	END//"

cd

sudo git clone "https://github.com/collabassess/cpsx-api.git"
cd cpsx-api
sudo npm install
sudo npm install pm2@latest -g
pm2 start bin/www