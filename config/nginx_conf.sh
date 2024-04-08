#!/bin/bash

user="$(whoami)"
user_home="/home/$user"
classbook_folder="$user_home/classbook"

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root, mais l'utilisateur actuel est $EUID dont le nom est $user." 
   exit 1
fi

# Créer la configuration pour le site web dans Nginx
cat << EOF > /etc/nginx/sites-available/classbook
server {
    listen 80;
    server_name example.com;

    root /classbook/web;
    index index.html index.htm;

    location /admin {
        alias /classbook/admin;
    }

    location /datas {
        alias /classbook/datas;
    }
}
EOF

# Activer le site
ln -s /etc/nginx/sites-available/classbook /etc/nginx/sites-enabled/

# Redémarrer Nginx pour appliquer les modifications
systemctl restart nginx

cd $classbook_folder

exit 0
