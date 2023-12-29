using System;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.IO.Compression;

class Program
{
    static async Task Main()
    {
        Console.WriteLine("Téléchargement et installation");

        // Remplacez ces valeurs par les informations de votre référentiel GitHub
        string repositoryOwner = "classbook-devlopers";
        string repositoryName = "classbook";
        string releaseTagName = "latest";

        string downloadUrl = GetGitHubReleaseDownloadUrl(repositoryOwner, repositoryName, releaseTagName);
        string zipFilePath = "Latest.zip";
        string extractPath = "/var/www/html";

        using (var httpClient = new HttpClient())
        {
            await DownloadFileAsync(httpClient, downloadUrl, zipFilePath);
            ExtractZip(zipFilePath, extractPath);
            DeleteFile(zipFilePath);
        }

        Console.WriteLine("Configuration");

        // Utilisation de la lecture du fichier de configuration
        string mariadbConfigPath = "/config/mariadb-config.conf";
        var mariadbConfig = ReadConfigFile(mariadbConfigPath);

        string mariadbUser = mariadbConfig.GetValueOrDefault("MariaDBUser", "defaultUser");
        string mariadbPassword = mariadbConfig.GetValueOrDefault("MariaDBPassword", "defaultPassword");

        Console.WriteLine($"MariaDB User: {mariadbUser}");
        Console.WriteLine($"MariaDB Password: {mariadbPassword}");

        // Reste du code...
        // Ajoutez ici le reste du code en fonction de votre logique d'installation/configuration
    }

    static string GetGitHubReleaseDownloadUrl(string owner, string repo, string tag)
    {
        return $"https://github.com/{owner}/{repo}/releases/{tag}/download/Latest.zip";
    }

    static async Task DownloadFileAsync(HttpClient httpClient, string url, string destinationPath)
    {
        try
        {
            var response = await httpClient.GetAsync(url);
            response.EnsureSuccessStatusCode();
            using (var stream = await response.Content.ReadAsStreamAsync())
            using (var fileStream = File.Create(destinationPath))
            {
                await stream.CopyToAsync(fileStream);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Erreur de téléchargement du fichier : {ex.Message}");
        }
    }

    static void ExtractZip(string zipFilePath, string extractPath)
    {
        try
        {
            ZipFile.ExtractToDirectory(zipFilePath, extractPath);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Erreur d'extraction du fichier ZIP : {ex.Message}");
        }
    }

    static void DeleteFile(string filePath)
    {
        try
        {
            File.Delete(filePath);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Erreur de suppression du fichier : {ex.Message}");
        }
    }

    static Dictionary<string, string> ReadConfigFile(string filePath)
    {
        var configValues = new Dictionary<string, string>();

        try
        {
            if (File.Exists(filePath))
            {
                var lines = File.ReadAllLines(filePath);

                foreach (var line in lines)
                {
                    var parts = line.Split('=');

                    if (parts.Length == 2)
                    {
                        var key = parts[0].Trim();
                        var value = parts[1].Trim();
                        configValues[key] = value;
                    }
                }
            }
            else
            {
                Console.WriteLine($"Le fichier de configuration n'existe pas : {filePath}");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Erreur lors de la lecture du fichier de configuration : {ex.Message}");
        }

        return configValues;
    }
}
