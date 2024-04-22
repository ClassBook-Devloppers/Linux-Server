#!/bin/bash

user="$(whoami)"
user_home="/home/$user"
classbook_folder="$user_home/classbook"
pkg_folder="$classbook_folder/pkg"
alert_script_dir="/etc/classbook/alert/"


 
echo " Création du répertoire des alertes de classbook "
cd /etc
sudo mkdir classbook
cd classbook
sudo mkdir alerts
cd $pkg_folder

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

# Créer le répertoire si nécessaire
mkdir -p "$alert_script_dir"

# Chemin du script d'alerte
alert_script_path="$alert_script_dir/alert.sh"

# Contenu du script d'alerte
alert_script_content=$(cat << 'EOF'
#!/bin/bash

echo "ALERTE : Les services ne sont pas tous disponibles ou il n'y a pas de connectivité Internet."
EOF
)

# Créer le script d'alerte
echo "$alert_script_content" > "$alert_script_path"

# Donner les permissions d'exécution au script d'alerte
chmod +x "$alert_script_path"

echo "Script d'alerte créé : $alert_script_path"

# Exécuter le script d'alerte
"$alert_script_path"

# Si le script d'alerte s'est exécuté avec succès, configurer Samba normalement
if [[ $? -eq 0 ]]; then
    configure_samba
else
    echo "Le script d'alerte n'a pas pu s'exécuter avec succès. Les services ne seront pas configurés."
fi

cd $pkg_folder

exit 0