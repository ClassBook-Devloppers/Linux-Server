#!/bin/bash

cd $user_home

user="$(whoami)"
user_home="/home/$user"
classbook_folder="$user_home/classbook"
root_password_file="$classbook_folder/root_password.txt"
ROOT_PASSWORD=$(cat $root_password_file)


if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root, mais l'utilisateur actuel est $EUID dont le nom est $user." 
   exit 1
fi

echo "MAJ du serveur"
echo "$ROOT_PASSWORD" | sudo -S apt-get update -y
echo "$ROOT_PASSWORD" | sudo -S apt install update nano -y
echo ""
echo " MAJ du serveur terminé ! "

echo ""
echo ""
echo " Installation de Parted "
echo "$ROOT_PASSWORD" | sudo -S apt install parted -y
echo ""
echo " Création des volumes pour ClassBook "
echo ""
chmod 755 disk_part.sh
sudo ./disk_part.sh
echo ""
echo " Création des volumes pour ClassBook terminé !"

echo ""
echo ""
echo " Installation du serveur WEB "
echo "$ROOT_PASSWORD" | sudo -S apt install nginx php php-mysql php-pdo php-mbstring php-tokenizer php-xml -y
echo ""
echo " Installation du serveur WEB terminé ! "
echo ""
echo " Configuration du serveur WEB "

echo ""
echo ""
echo " Installation du serveur DB "
echo "$ROOT_PASSWORD" | sudo -S apt install libapache2-mod-php php-mysql mariadb-server -y
echo ""
echo "Installation du serveur DB terminé ! "
echo " Configuration de MariaDB "
echo "$ROOT_PASSWORD" | sudo -S mariadb-secure-installation
sudo ./mariadb_install.sh
echo ""
echo " Configuration de Maria DB terminé ! "

echo ""
echo ""
echo " Installation de Samba " 
echo "$ROOT_PASSWORD" | sudo -S apt install smb -y
echo ""
echo "Installation de Samba Terminé ! "
echo " Configuration de Samba "


echo ""
echo ""
echo "Téléchargement de l'API de classbook"
cd

echo ""
echo ""
echo " Lancement du Post installation "
sudo ./postinstall.sh
echo ""
echo "Post Installation terminé !"
echo ""
echo ""
echo "Merci D'utiliser ClassBook "
