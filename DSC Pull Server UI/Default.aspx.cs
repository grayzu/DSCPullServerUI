using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Management.Automation;
using System.Collections.ObjectModel;
using System.IO.Compression;

namespace DSC_Pull_Server_UI
{
    public partial class PullServer : System.Web.UI.Page
    {
        string tempPath = "c:\\Program Files\\WindowsPowerShell\\DscService\\Staging\\";
        string configurationPath = "c:\\Program Files\\WindowsPowerShell\\DscService\\Configuration\\";
        string modulePath = "c:\\Program Files\\WindowsPowerShell\\DscService\\Modules\\";

        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void UploadFiles_Click(object sender, EventArgs e)
        {
            if(UIConfigurationFiles.HasFiles)
            {
                string configTempPath = tempPath + "Configurations";
                makeTempDirectory(configTempPath);
                UploadFiles(UIConfigurationFiles, configTempPath);
                createChecksum(configTempPath);
                moveFiles(configTempPath, configurationPath,true);
                cleanUp(configTempPath);
            }

            if (UIResourceFiles.HasFiles)
            {
                string moduleTempPath = tempPath + "Modules";
                makeTempDirectory(moduleTempPath);
                UploadFiles(UIResourceFiles, moduleTempPath);
                renameModuleFile(UIResourceFiles.PostedFiles, moduleTempPath);
                createChecksum(moduleTempPath); //TODO: Update so that this takes list of files instead of dir
                moveFiles(moduleTempPath, modulePath, true); //TODO: Update so that this takes list of files instead of dir
                cleanUp(moduleTempPath);
            }
            
                Results.Text = "Successfully uploaded and processed the following files:";
            
        }

        private void UploadFiles(FileUpload Files2Upload, string DesitinationPath)
        {
            try
            {
                foreach (HttpPostedFile file in Files2Upload.PostedFiles)
                {
                    string FileName = file.FileName.Split('\\').Last();
                    file.SaveAs(DesitinationPath + "\\" + FileName);
                }
                
            }
            catch (ArgumentException e)
            {
                throw new Exception("Failed to upload files to " + DesitinationPath + " with with error: " + e.Message);
                //Do something here.
            }
            
        }

        private void createChecksum(string SourcePath, string DesitinationPath)
        {
            using (PowerShell PowerShellInstance = PowerShell.Create())
            {
                //PowerShellInstance.AddScript("New-DscChecksum -Path " + SourcePath + "-OutputPath " + DesitinationPath + "-Force");
                ///*
                PowerShellInstance.AddCommand("New-DscChecksum");
                PowerShellInstance.AddParameter("Path",SourcePath);
                PowerShellInstance.AddParameter("OutPath",DesitinationPath);
                PowerShellInstance.AddParameter("ErrorAction", "SilentlyContinue");
                PowerShellInstance.AddParameter("Force");
                //*/
                try
                {
                    Collection<PSObject> PSOutput = PowerShellInstance.Invoke();
                    //PowerShellInstance.Dispose();
                }
                catch
                {
                    if (PowerShellInstance.Streams.Error.Count > 0)
                    {
                        // Report the errors
                    }
                }
            }
        }

        private void createChecksum(string Path)
        {
            createChecksum(Path,Path);
        }

        private void compressModule(string ParentPath, string DestinationPath)
        {

        }

        private void moveFiles(string SourceDirectory, string DestinationDirectory, bool Overwrite)
        {
            System.IO.DirectoryInfo DestinationDirInfo = new System.IO.DirectoryInfo(DestinationDirectory);
            //Create destination if it does not already exist
            if (DestinationDirInfo.Exists == false) System.IO.Directory.CreateDirectory(DestinationDirectory);

            //Get list of files to move
            List<string> SourceFiles = System.IO.Directory.GetFiles(SourceDirectory,"*.*").ToList();

            foreach(string file in SourceFiles)
            {
                System.IO.FileInfo SourceFileInfo = new System.IO.FileInfo(file);

                if ((new System.IO.FileInfo(DestinationDirInfo + "\\" + SourceFileInfo.Name).Exists == true) && (Overwrite == true))
                {
                    System.IO.File.Delete(DestinationDirInfo + "\\" + SourceFileInfo.Name);
                }

                SourceFileInfo.MoveTo(DestinationDirInfo + "\\" + SourceFileInfo.Name);
            }
        }

        protected void makeTempDirectory(string tempDir)
        {
            bool exists = System.IO.Directory.Exists(tempDir);
            if (!exists)
            {
                System.IO.Directory.CreateDirectory(tempDir);
            }
        }

        protected void renameModuleFile(IList<HttpPostedFile> ZipFiles, string DestPath)
        {
            foreach (HttpPostedFile zip in ZipFiles)
            {
                string ModuleVersion;
                string ModuleName;
                string ZipFileFullName = zip.FileName.Split('\\').Last();
                //string ZipFileBaseName = ZipFileFullName.Split('.').First();
                string ZipPath = DestPath + "\\" + ZipFileFullName;
                ZipFile.ExtractToDirectory(ZipPath, DestPath);
                string[] Directories = System.IO.Directory.GetDirectories(DestPath);

                if(Directories.Count() == 1)
                {
                    string DirName = Directories[0].Split('\\').Last();
                    string PSD1Path = DestPath + "\\" + DirName + "\\" + DirName + ".psd1";

                    using (PowerShell PowerShellInstance = PowerShell.Create())
                    {
                        PowerShellInstance.AddCommand("Get-Module");
                        PowerShellInstance.AddParameter("Name", PSD1Path);
                        PowerShellInstance.AddParameter("ListAvailable");
                    
                        Collection<PSObject> PSOutput = PowerShellInstance.Invoke();
                        ModuleName = PSOutput[0].Properties["Name"].Value.ToString();
                        ModuleVersion = PSOutput[0].Properties["Version"].Value.ToString();
                        PowerShellInstance.Dispose();
                    }

                    string NewZipPath = DestPath + "\\" + ModuleName + "_" + ModuleVersion + ".zip";
                    System.IO.File.Move(ZipPath, NewZipPath);
                    System.IO.Directory.Delete(DestPath + "\\" + DirName, true);
                }
                    
            }
        }

        protected void cleanUp(string tempDir)
        {
            if (System.IO.Directory.Exists(tempDir))
            {
                System.IO.Directory.Delete(tempDir);
            }
        }
        
    }
}