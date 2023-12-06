using System;
using System.Diagnostics;
using System.IO;
using System.Globalization;

class InstallerLAMP
{
    static void Main()
    {
        console.writeline("Hi , Thank to install ClassBook. For more information, please visit https://classbook-devloppers.github.io/CLBK/")
        Console.WriteLine("Installing LAMP server... ( Linux, Apache2, MariaDB/MySQL, PHP)");

        // Installation d'Apache
        Process.Start("sudo", "apt-get install apache2 -y").WaitForExit();

        // Installation de MariaDB
        Process.Start("sudo", "apt-get install mariadb-server -y").WaitForExit();

        // Installation de PHP
        Process.Start("sudo", "apt-get install php libapache2-mod-php php-mysql -y").WaitForExit();

        // Secure installation pour MariaDB
        SecureInstallMariaDB();

        Console.WriteLine("LAMP server installation completed.");

        // Vérification et installation de Python
        CheckAndInstallPython();

        // Téléchargement et exécution du script Python
        DownloadAndRunPythonScript();
    }

    static void SecureInstallMariaDB()
    {
        // Paramètres à utiliser
        string rootPassword = "admin123";

        // Création du processus
        Process process = new Process();
        ProcessStartInfo startInfo = new ProcessStartInfo
        {
            FileName = "sudo",
            RedirectStandardInput = true,
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true,
            Arguments = "mysql_secure_installation"
        };
        process.StartInfo = startInfo;

        // Démarrage du processus
        process.Start();

        // Rédaction des réponses aux questions du script
        StreamWriter sw = process.StandardInput;
        StreamReader sr = process.StandardOutput;

        // Attendre la demande du mot de passe de l'utilisateur actuel
        WaitForAndRespond(sr, "Enter current password for root (enter for none):", rootPassword);

        // Attendre et répondre à d'autres questions
        WaitForAndRespond(sr, "Switch to unix_socket authentication [Y/n]", "Y"); // Mettez ici la valeur que vous souhaitez (true ou false)
        WaitForAndRespond(sr, "Change the root password? [Y/n]", "n"); // Mettez ici la valeur que vous souhaitez (true ou false)
        WaitForAndRespond(sr, "Remove anonymous users? [Y/n]", "n"); // Mettez ici la valeur que vous souhaitez (true ou false)
        WaitForAndRespond(sr, "Disallow root login remotely? [Y/n]", "n"); // Mettez ici la valeur que vous souhaitez (true ou false)
        WaitForAndRespond(sr, "Remove test database and access to it? [Y/n]", "Y"); // Mettez ici la valeur que vous souhaitez (true ou false)
        WaitForAndRespond(sr, "Reload privilege tables now? [Y/n]", "Y"); // Mettez ici la valeur que vous souhaitez (true ou false)

        // Fermer le flux d'entrée standard
        sw.Close();

        // Attendre que le processus se termine
        process.WaitForExit();

        // Afficher la sortie du processus (à titre indicatif)
        Console.WriteLine(sr.ReadToEnd());
    }

    static void CheckAndInstallPython()
    {
        Console.WriteLine("Checking Python installation...");
        var process = new Process
        {
            StartInfo = new ProcessStartInfo
            {
                FileName = "bash",
                RedirectStandardInput = true,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true
            }
        };

        process.Start();

        // Vérifie si Python est installé
        process.StandardInput.WriteLine("python3 --version");
        process.StandardInput.WriteLine("exit");
        string output = process.StandardOutput.ReadToEnd();
        process.WaitForExit();

        if (!output.ToLower().Contains("python"))
        {
            Console.WriteLine("Python not found. Installing Python...");

            // Installation de Python
            Process.Start("sudo", "apt-get install python3 -y").WaitForExit();
            Console.WriteLine("Python installation completed.");
        }
        else
        {
            Console.WriteLine("Python is already installed.");
        }
    }

    static void DownloadAndRunPythonScript()
    {
        Console.WriteLine("Downloading Python script...");

        // Téléchargement du script Python
        Process.Start("wget", "https://github.com/classbook-devloppers/linux-server/script.py -O script.py").WaitForExit();

        // Exécution du script Python en tant qu'administrateur
        Process.Start("sudo", "python3 script.py").WaitForExit();

        Console.WriteLine("Python script execution completed.");
    }

    static void WaitForAndRespond(StreamReader sr, string question, string response, string password)
    {
        while (true)
        {
            string line = sr.ReadLine();
            Console.WriteLine(line); // Affichez la sortie du script (à titre indicatif)

            if (line.Contains(question) || line.Contains("entrer le mot de passe pour") || line.Contains("Enter the password for"))
            {
                Console.WriteLine(response); // Affichez la réponse (à titre indicatif)
                StreamWriter sw = sr.BaseStream is FileStream fileStream
                    ? new StreamWriter(fileStream) { AutoFlush = true }
                    : new StreamWriter(sr.BaseStream);

                // Si la ligne contient "Enter the password" ou "entrer le mot de passe pour", envoyez le mot de passe
                if (line.Contains("Enter the password") || line.Contains("entrer le mot de passe pour") || line.Contains("enter the mot de passe for"))
                {
                    sw.WriteLine(password); // Répondre avec le mot de passe spécifié
                }
                else
                {
                    sw.WriteLine(response); // Répondre avec la réponse standard
                }

                return;
            }
        }
    }
}
