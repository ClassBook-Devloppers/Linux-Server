// InstallerLAMP.cs
using System;
using System.Diagnostics;
using System.IO;

class InstallerLAMP
{
    static void Main()
    {
        Console.WriteLine("Installing LAMP server...");

        // Installation d'Apache
        Process.Start("sudo", "apt-get install apache2 -y").WaitForExit();

        // Installation de MariaDB
        Process.Start("sudo", "apt-get install mariadb-server -y").WaitForExit();

        // Installation de PHP
        Process.Start("sudo", "apt-get install php libapache2-mod-php php-mysql -y").WaitForExit();

        // Secure installation pour MariaDB
        Process.Start("sudo", "mysql_secure_installation").WaitForExit();

        Console.WriteLine("LAMP server installation completed.");

        // Vérification et installation de Python
        CheckAndInstallPython();

        // Téléchargement et exécution du script Python
        DownloadAndRunPythonScript();
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
        Process.Start("wget", "URL_DU_SCRIPT_PYTHON -O site_downloader.py").WaitForExit();

        // Exécution du script Python en tant qu'administrateur
        Process.Start("sudo", "python3 site_downloader.py").WaitForExit();

        Console.WriteLine("Python script execution completed.");
    }
}
