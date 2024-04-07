#!/bin/bash
user="$(whoami)"
user_home="/home/$user"
classbook_folder="$user_home/classbook"
pkg_folder="$classbook_folder/pkg"

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root, mais l'utilisateur actuel est $EUID dont le nom est $user." 
   exit 1
fi

# Password SuperUser
echo "Veuillez entrer le mot de passe du superutilisateur :"
read -s ROOT_PASSWORD
echo "Votre mot de passe $ROOT_PASSWORD est le suivant ? Y/n"
read -n 1 confirmation


if [[ $confirmation == "Y" || $confirmation == "y" ]]; then

    echo "Mot de passe sauvgardé dans $classbook_folder."

else

    echo "Veuillez entrer à nouveau le mot de passe du superutilisateur :"
    read -s ROOT_PASSWORD
    echo "Votre mot de passe $ROOT_PASSWORD est le suivant ? Y/n"

fi


if [ -d "$user_home" ]; then
    echo "Le répertoire utilisateur de $user existe : $user_home"
else
    echo "Le répertoire utilisateur de $user n'existe pas : $user_home"
    echo "création du répertoire"
    cd $user_home
    mkdir classbook
    cd classbook
    mkdir pkg
    cd pkg
fi

wget https://github.com/classbook-devloppers/linux-server/blob/main/src/disk_part.sh
wget https://github.com/classbook-devloppers/linux-server/blob/main/src/script.sh
wget https://github.com/classbook-devloppers/linux-server/blob/main/src/postinstall.sh

wget https://github.com/classbook-devloppers/linux-server/blob/main/config/mariadb_install.sh
wget https://github.com/classbook-devloppers/linux-server/blob/main/config/smb_conf.sh
wget https://github.com/classbook-devloppers/linux-server/blob/main/config/nginx_conf.sh

echo "stockage du Mot de Passe dans $classbook_folder"
echo "$ROOT_PASSWORD" > $classbook_folder/root_password.txt
chmod 600 $classbook_folder/root_password.txt


chmod 755 /$pkg_folder/script.sh
chmod 755 /$pkg_folder/postinstall.sh
chmod 755 /$pkg_folder/disk_part.sh
chmod 755 /$pkg_folder/mariadb_install.sh
chmod 755 /$pkg_folder/smb_conf.sh

./script.sh
