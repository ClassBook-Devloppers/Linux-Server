#!/bin/bash

user="$(whoami)"
user_home="/home/$user"
classbook_folder="$user_home/classbook"
root_password_file="$classbook_folder/root_password.txt"
ROOT_PASSWORD=$(cat $root_password_file)



sudo apt autoremove -y

sudo nginx -s reload

sudo systemctl restart mariadb

sudo systemctl restart smbd

sudo systemctl restart nginx

sync; echo 3 > /proc/sys/vm/drop_caches



echo "Post-installation terminée. Les paquets inutiles ont été supprimés, les caches ont été vidés et tous les services utilisés ont été redémarrés."
echo ""
read -p "Voulez-vous redémarrer le serveur maintenant ? Y/n : " restart_choice

# Vérifier le choix de l'utilisateur
if [[ $restart_choice == "y" || $restart_choice == "Y" ]]; then
    echo ""
    echo "Redémarrage du serveur..."
    reboot
else
    echo ""
    echo ""
    echo "Le serveur n'a pas été redémarré. Vous devrez redémarrer le serveur manuellement "
fi
