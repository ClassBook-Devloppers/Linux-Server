#!/bin/sh
# postinst

set -e

# Chemin vers le fichier compilé avec dotnet
DOTNET_FILE="ClassBook/Installer.dll"
# Fonction pour installer dotnet
install_dotnet() {
    echo "Installation de dotnet..."
    # Commande pour télécharger et installer dotnet
    wget -q https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
    chmod +x dotnet-install.sh
    ./dotnet-install.sh --version latest
    rm dotnet-install.sh
}

# Vérifier si dotnet est installé
if ! command -v dotnet > /dev/null; then
    echo "Dotnet n'est pas installé. Installation"
    # Appeler la fonction d'installation de dotnet
    install_dotnet
fi

# Vérifier si le fichier compilé existe
if [ ! -f "$DOTNET_FILE" ]; then
    echo "Erreur 005 : Le fichier compilé $DOTNET_FILE n'existe pas."
    exit 1
fi

# Lancer le fichier compilé avec dotnet
dotnet "$DOTNET_FILE"

exit 0
