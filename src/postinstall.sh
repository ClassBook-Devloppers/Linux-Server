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

apt autoremove -y

nginx -s reload

systemctl restart mariadb

systemctl restart smbd

systemctl restart nginx

sync; echo 3 > /proc/sys/vm/drop_caches



echo "Post-installation terminée. Les paquets inutiles ont été supprimés, les caches ont été vidés et tous les services utilisés ont été redémarrés."

read -p "Voulez-vous redémarrer le serveur maintenant ? Y/n : " restart_choice

# Vérifier le choix de l'utilisateur
if [[ $restart_choice == "y" || $restart_choice == "Y" ]]; then
    echo "Redémarrage du serveur..."
    reboot
else
    echo "Le serveur n'a pas été redémarré. L'action à été arrété par l'utilisateur "
fi
