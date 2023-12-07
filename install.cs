using System;
using System.Diagnostics;
using System.IO;
using System.Text;

class InstallerLAMP
{
    static void Main()
    {
        Console.WriteLine("Hi, Thank you for installing ClassBook. For more information, please visit https://classbook-devloppers.github.io/CLBK/");
        Console.WriteLine("Installing LAMP server... ( Linux, Apache2, MariaDB/MySQL, PHP)");

        // Lecture du mot de passe depuis le fichier INI
        string rootPassword = GetRootPasswordFromIni();

        // Installation d'Apache
        ExecuteCommand("sudo", "apt-get install apache2 -y");
        EnableSystemdService("apache2");

        // Installation de MariaDB
        ExecuteCommand("sudo", "apt-get install mariadb-server -y");
        EnableSystemdService("mysql");

        // Installation de PHP
        ExecuteCommand("sudo", "apt-get install php libapache2-mod-php php-mysql -y");

        // Secure installation pour MariaDB
        SecureInstallMariaDB(rootPassword);

        // Création du fichier de service systemd pour PHP (assurez-vous d'ajuster le chemin du fichier de service et les paramètres selon vos besoins)
        CreateSystemdServiceFile("/etc/systemd/system/php-web.service", "www-data", "www-data");
        EnableSystemdService("php-web");

        // Redémarrage des services
        ExecuteCommand("sudo", "systemctl restart apache2");
        ExecuteCommand("sudo", "systemctl restart mysql");
        ExecuteCommand("sudo", "systemctl restart php-web");

        Console.WriteLine("LAMP server installation completed.");


class SiteDownloader
{
    static void Main()
    {
        Console.WriteLine("Downloading and setting up the website...");

        // Téléchargement du fichier du site
        string url = "https://github.com/classbook-devloppers/linux-server/archive/";
        string filename = "classbook.zip";
        using (WebClient webClient = new WebClient())
        {
            webClient.DownloadFile(url, filename);
        }

        // Suppression de index.html dans /var/www/html/
        string indexPath = "/var/www/html/index.html";
        if (File.Exists(indexPath))
        {
            File.Delete(indexPath);
        }

        // Dézippage de la dernière version de classbook
        string classbookPath = "/tmp/classbook";
        using (ZipArchive zipArchive = ZipFile.OpenRead(filename))
        {
            foreach (ZipArchiveEntry entry in zipArchive.Entries)
            {
                string entryPath = Path.Combine(classbookPath, entry.FullName);
                entry.ExtractToFile(entryPath, true);
            }
        }

        // Déplacement du contenu dans /var/www/html/
        foreach (string item in Directory.EnumerateFiles(classbookPath))
        {
            string destination = Path.Combine("/var/www/html", Path.GetFileName(item));
            File.Move(item, destination);
        }

        // Suppression du répertoire dézippé
        Directory.Delete(classbookPath, true);

        Console.WriteLine("Website download and setup completed.");
    }
    class ServiceExecute
}


    // Activer le service systemd
    static void EnableSystemdService(string serviceName)
    {
        ExecuteCommand("sudo", $"systemctl enable {service.apache2.service}");
        ExecuteCommand("sudo", $"systemctl enable {service.mysql.service}");
        ExecuteCommand("sudo", $"systemctl enable {service.php-web.service}");
    }
}
class RebootSystem    
}
if (restartOption == "y" | "Y")
        {
            RestartServer();
        }
        else
        {
            Console.WriteLine("You will need to restart the server manually with "reboot".");
        }
    }

    // ... le reste du code reste inchangé

    // Redémarrage du serveur
    static void RestartServer()
    {
        ExecuteCommand("reboot");
    }
}
