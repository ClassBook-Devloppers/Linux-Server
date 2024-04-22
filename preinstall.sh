#!/bin/bash

user="$(whoami)"
user_home="/home/$user"
classbook_folder="$user_home/classbook"

 

# Password SuperUser
echo "Veuillez entrer le mot de passe du superutilisateur :"
read -s ROOT_PASSWORD
echo "Votre mot de passe $ROOT_PASSWORD est le suivant ? Y/n"
echo ""
read -n 1 confirmation


if [[ $confirmation == "Y" || $confirmation == "y" ]]; then

    echo ""
    echo "Mot de passe sauvgardé dans $classbook_folder."

else

    echo ""
    echo ""
    echo "Veuillez entrer à nouveau le mot de passe du superutilisateur :"
    read -s ROOT_PASSWORD
    echo "Votre mot de passe $ROOT_PASSWORD est le suivant ? Y/n"
    read -n 1 confirmation

fi


if [ -d "$user_home" ]; then
    echo "Le répertoire de classbook existe : $classbook_folder"
else
    echo "Le répertoire utilisateur de $user n'existe pas : $classbook_folder"
    echo "création du répertoire"
    cd $user_home
    mkdir classbook
    cd classbook

fi

sudo apt install git -y

wget https://raw.githubusercontent.com/classbook-devloppers/linux-server/main/src/script.sh
wget https://raw.githubusercontent.com/classbook-devloppers/linux-server/main/src/disk_part.sh
wget https://raw.githubusercontent.com/classbook-devloppers/linux-server/main/src/postinstall.sh

wget https://raw.githubusercontent.com/classbook-devloppers/linux-server/main/config/mariadb_conf.sh
wget https://raw.githubusercontent.com/classbook-devloppers/linux-server/main/src/nginx_conf.sh
wget https://raw.githubusercontent.com/classbook-devloppers/linux-server/main/src/smb_conf.sh

echo "stockage du Mot de Passe dans $classbook_folder"
echo "$ROOT_PASSWORD" > $classbook_folder/root_password.txt
chmod 600 $classbook_folder/root_password.txt


sudo chmod 313 script.sh
sudo chmod 313 postinstall.sh
sudo chmod 313 disk_part.sh
sudo chmod 313 mariadb_install.sh 
sudo chmod 313 smb_conf.sh

./script.sh
