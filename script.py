# site_downloader.py
import os
import subprocess
import urllib.request
import zipfile
import shutil

def main():
    print("Downloading and setting up the website...")

    # Téléchargement du fichier du site
    url = "URL_DU_FICHIER_ZIP"
    filename = "classbook.zip"
    urllib.request.urlretrieve(url, filename)

    # Suppression de index.html dans /var/www/html/
    index_path = "/var/www/html/index.html"
    if os.path.exists(index_path):
        os.remove(index_path)

    # Dézippage de la dernière version de classbook
    with zipfile.ZipFile(filename, 'r') as zip_ref:
        zip_ref.extractall("/tmp/classbook")

    # Déplacement du contenu dans /var/www/html/
    classbook_path = "/tmp/classbook"
    for item in os.listdir(classbook_path):
        s = os.path.join(classbook_path, item)
        d = os.path.join("/var/www/html", item)
        shutil.move(s, d)

    # Suppression du répertoire dézippé
    shutil.rmtree(classbook_path)

    print("Website download and setup completed. Your Computer Must be restart, Restart Now? [Y/n]")

if __name__ == "__main__":
    main()
