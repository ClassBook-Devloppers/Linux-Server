#!/bin/bash
user="$(whoami)"
user_home="/home/$user"
classbook_folder="$user_home/classbook"

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

    echo "Mot de passe sauvgardé."

else

    echo "Veuillez entrer à nouveau le mot de passe du superutilisateur :"
    read -s ROOT_PASSWORD
    echo "Votre mot de passe $ROOT_PASSWORD est le suivant ? Y/n"

fi


# Vérification de l'existence du répertoire utilisateur
if [ -d "$user_home" ]; then
    echo "Le répertoire utilisateur de $user existe : $user_home"
else
    echo "Le répertoire utilisateur de $user n'existe pas : $user_home"
    echo "création du répertoire"
    cd $user_home
    md classbook
fi


echo "stockage du Mot de Passe dans $classbook_folder"
echo "$ROOT_PASSWORD" > $classbook_folder/root_password.txt
chmod 600 $classbook_folder/root_password.txt

chmod 755 /src/script.sh
./script.sh