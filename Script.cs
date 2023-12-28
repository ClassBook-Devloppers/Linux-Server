using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Xml;

class Program
{
    static void Main()
    {
        if (!IsAdministrator())
        {
            Console.WriteLine(GetLocalizedString("Hi, Thank you for installing ClassBook. For more information, please visit https://classbook.webnode.page/"));
            return;
        }
        else
        {
            Console.WriteLine(GetLocalizedString("Please run the installer as an administrator."));
            return;
        }

        Console.WriteLine(GetLocalizedString("Download and Installation"));

        string repositoryOwner = "classbook-devloppers";
        string repositoryName = "classbook";
        string downloadUrl = $"https://github.com/{repositoryOwner}/{repositoryName}/releases/latest/download/Latest.zip";
        string zipFilePath = "Latest.zip";
        string extractPath = "/var/www/html";

        DownloadFile(downloadUrl, zipFilePath);
        ExtractZip(zipFilePath, extractPath);
        DeleteFile(zipFilePath);

        Console.WriteLine(GetLocalizedString("Configuration"));

        ExecuteSudoCommand("mariadb-secure-installation");
        string mariadbConfigPath = "/config/mariadb-config.conf";

        Console.WriteLine(GetLocalizedString("Finalization"));

        ExecuteSudoCommand("sudo service nginx restart");
        ExecuteSudoCommand("sudo service php restart");
        ExecuteSudoCommand("sudo service mariadb restart");

        Console.WriteLine(GetLocalizedString("Do you want to restart the server? (Y/N)"));
        var userInput = Console.ReadLine();

        if (userInput != null && userInput.Trim().ToUpper() == "Y")
        {
            ExecuteSudoCommand("reboot");
        }
        else
        {
            Console.WriteLine(GetLocalizedString("You will need to restart your server with the reboot command!"));
        }
    }

    static string GetLocalizedString(string key)
    {
        string languageCode = "FR"; 

        string translationsFilePath = $"{languageCode}.xml";

        if (!File.Exists(translationsFilePath))
        {
            Console.WriteLine($"Fichier de traduction manquant/Corrompu: {translationsFilePath}");
            return key;
        }

        try
        {
            var doc = new XmlDocument();
            doc.Load(translationsFilePath);

            XmlNode translationNode = doc.SelectSingleNode($"/Lang/{key}");

            return translationNode != null ? translationNode.InnerText : key;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Erreur lors de la lecture du fichier de traduction : {ex.Message}");
            return key;
        }
    }

    static void DownloadFile(string url, string destinationPath)
    {
        using (WebClient webClient = new WebClient())
        {
            webClient.DownloadFile(url, destinationPath);
        }
    }

    static void ExtractZip(string zipFilePath, string extractPath)
    {
        ZipFile.ExtractToDirectory(zipFilePath, extractPath);
    }

    static void DeleteFile(string filePath)
    {
        File.Delete(filePath);
    }

    static void ExecuteSudoCommand(string command)
    {
        var processInfo = new ProcessStartInfo("sudo", command)
        {
            RedirectStandardError = true,
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        var process = new Process { StartInfo = processInfo };

        process.Start();
        process.WaitForExit();

        var output = process.StandardOutput.ReadToEnd();
        var error = process.StandardError.ReadToEnd();

        if (!string.IsNullOrEmpty(output))
        {
            Console.WriteLine(output);
        }

        if (!string.IsNullOrEmpty(error))
        {
            Console.WriteLine(error);
        }
    }

    static bool IsAdministrator()
    {
        var identity = System.Security.Principal.WindowsIdentity.GetCurrent();
        var principal = new System.Security.Principal.WindowsPrincipal(identity);

        return principal.IsInRole(System.Security.Principal.WindowsBuiltInRole.Administrator);
    }
}
