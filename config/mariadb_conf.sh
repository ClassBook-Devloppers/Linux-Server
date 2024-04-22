#!/bin/bash

user="$(whoami)"
user_home="/home/$user"
classbook_folder="$user_home/classbook"
root_password_file="$classbook_folder/root_password.txt"
ROOT_PASSWORD=$(cat $root_password_file)

 


mysql_secure_installation <<EOF

$ROOT_PASSWORD
n
n
y
n
y
y
EOF

if [ $? -eq 0 ]; then
    echo "L'installation sécurisée de MariaDB est terminée avec succès."
else
    echo "Une erreur s'est produite lors de l'installation sécurisée de MariaDB."
fi
