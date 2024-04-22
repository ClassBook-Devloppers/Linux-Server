#!/bin/bash

user="$(whoami)"
user_home="/home/$user"
classbook_folder="$user_home/classbook"
pkg_folder="$classbook_folder/pkg"


# Fonction pour configurer Samba
configure_samba() {
    # Ajouter la configuration de Samba
    cat << EOF > /etc/samba/smb.conf
[datas]
    path = /classbook/datas
    valid users = @admin
    writable = yes
    guest ok = no
    create mode = 0770
    directory mode = 0770
    force group = admin

[shared]
    path = /classbook/smb
    valid users = @admin
    writable = yes
    guest ok = no
    create mode = 0770
    directory mode = 0770
    force group = admin
EOF

    # Redémarrer le service Samba pour appliquer les modifications
    systemctl restart smbd

    echo "Configuration de Samba terminée."
}


echo " Samba à été configuré correctement " 

cd $pkg_folder

exit 0