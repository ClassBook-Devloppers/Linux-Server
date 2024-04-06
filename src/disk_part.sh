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

echo "Les disques disponibles sont :"
lsblk -d -o NAME,SIZE | grep -v "NAME\|loop"


read -p "Veuillez choisir un disque (ex. /dev/sda) : " selected_disk

# Vérifie si le disque sélectionné existe
if [ ! -e "$selected_disk" ]; then

    echo "Erreur : Disque inexistant. Réessayez"

else
    echo "Votre disque $selected_disk est le suivant ? Voulez vous l'utiliser ? Y/n"
    read -n 1 confirmation

        if [[ $confirmation == "Y" || $confirmation == "y" ]]; then

            echo ""
            echo ""
            echo "Disque sauvegardé"
            
        else

            read -p "Veuillez choisir un disque (ex. /dev/sda) : " selected_disk
            echo "le disque choisi est le suivant : $selected_disk. Voulez vous l'utiliser ? Y/n"

        fi

fi

# Affiche les partitions existantes sur le disque sélectionné
echo "Les partitions existantes sur $selected_disk sont :"
lsblk $selected_disk


size_web="10G"
size_smb="30G"
size_admin="15G"


parted $selected_disk mklabel gpt
parted -a opt $selected_disk mkpart primary ext4 1MiB $size_web
parted -a opt $selected_disk mkpart primary ext4 $size_web $(echo "$size_web + $size_smb" | bc) 
parted -a opt $selected_disk mkpart primary ext4 $(echo "$size_web + $size_smb" | bc) $(echo "$size_web + $size_smb + $size_admin" | bc)
parted -a opt $selected_disk mkpart primary ext4 $(echo "$size_web + $size_smb + $size_admin" | bc) 100%

# Met à jour la table de partition
parted $selected_disk align-check optimal 1

# Formate les partitions
mkfs.ext4 ${selected_disk}1
mkfs.ext4 ${selected_disk}2
mkfs.ext4 ${selected_disk}3
mkfs.ext4 ${selected_disk}4

# Renommer les partitions
e2label ${selected_disk}1 /classbook/web
e2label ${selected_disk}2 /classbook/smb
e2label ${selected_disk}3 /classbook/admin

exit 1