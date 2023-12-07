#!/bin/bash

echo "Hi, Thank you for installing ClassBook. For more information, please visit https://classbook-devloppers.github.io/CLBK/"
echo "Installing LAMP server... ( Linux, Apache2, MariaDB/MySQL, PHP)"

# Lecture du mot de passe depuis le fichier INI
rootPassword=$(GetRootPasswordFromIni)

# Installation d'Apache
sudo apt-get install apache2 -y
EnableSystemdService apache2

# Installation de MariaDB
sudo apt-get install mariadb-server -y
EnableSystemdService mysql

# Installation de PHP
sudo apt-get install php libapache2-mod-php php-mysql -y

# Secure installation pour MariaDB
SecureInstallMariaDB $rootPassword

# Création du fichier de service systemd pour PHP
CreateSystemdServiceFile "/etc/systemd/system/php-web.service" "www-data" "www-data"
EnableSystemdService php-web

# Redémarrage des services
sudo systemctl restart apache2
sudo systemctl restart mysql
sudo systemctl restart php-web

echo "LAMP server installation completed."

# Téléchargement et configuration du site web
echo "Downloading and setting up the website..."

# Téléchargement du fichier du site
url="https://github.com/classbook-devloppers/linux-server/archive/"
filename="classbook.zip"
wget "$url$filename"

# Suppression de index.html dans /var/www/html/
indexPath="/var/www/html/index.html"
[ -e "$indexPath" ] && rm "$indexPath"

# Dézippage de la dernière version de classbook
classbookPath="/tmp/classbook"
unzip "$filename" -d "$classbookPath"

# Déplacement du contenu dans /var/www/html/
for item in "$classbookPath"/*; do
  destination="/var/www/html/$(basename "$item")"
  mv "$item" "$destination"
done

# Suppression du répertoire dézippé
rm -r "$classbookPath"

echo "Website download and setup completed."

# Activer le service systemd
EnableSystemdService apache2
EnableSystemdService mysql
EnableSystemdService php-web

# Redémarrage du serveur
read -p "Restart the server now? (y/n): " restartOption
if [ "$restartOption" = "y" ] || [ "$restartOption" = "Y" ]; then
  sudo reboot
else
  echo "You will need to restart the server manually with 'reboot'."
fi
