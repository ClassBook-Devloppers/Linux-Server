#!/bin/bash

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
echo "$ROOT_PASSWORD" | sudo -S apt install update -y
echo " MAJ du serveur terminé ! "
echo " Installation du serveur WEB "
echo "$ROOT_PASSWORD" | sudo -S apt install nginx php php-mysql php-pdo php-mbstring php-tokenizer php-xml -y
echo " Installation du serveur WEB terminé ! "
echo " Installation du serveur DB "
echo "$ROOT_PASSWORD" | sudo -S apt install libapache2-mod-php php-mysql mariadb-server -y
echo "Installation du serveur DB terminé ! "
echo " Installation de Parted "
echo "$ROOT_PASSWORD" | sudo -S apt install parted -y
echo " création du volume de 5 Go pour classbook "
chmod 755 disk_part.sh
./postinstall.sh




