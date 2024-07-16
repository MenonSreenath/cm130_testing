[string]$service_name,
[string]$Options,
[String]$service_backup_folder,
[String]$current_service_folder,
[string]$blade_server,
[string]$service_deployed

<# First decide which option
    - DB_only
    - No_Deploy
    - Service_only
    - DB_and_Service
    - re_Deployment
#>
# if DB only or if steps has DB step too then do this.
if ($Options -eq "DB_Only" -or "DB_and_Service")
{
     #create the worksdpace for label from TFS.
     C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\tf.exe workspace /new D:\TFS\$service_deployed\Development\$label

     #Pull the lable from TFS.
     C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\tf.exe get D:\TFS\$service_deployed\Development\$label /version:"L"$label"" /force /recursive /login:scmbuild,password /noprompt

     #convert .scx to sql

}

#if the steps has only service or has both DB and service then do this
if ($Options -eq "Service_only" -or $Options -eq "DB_and_Service")
{

    # stop the service
    Get-Service -ComputerName $blade_server $service_name | Stop-Service

    #create a backup folder
    New-Item -Path $service_backup_folder -ItemType Directory

    #copy contents from current folder to backup folder
    Robocopy.exe $current_service_folder $service_backup_folder /e /z

    #uninstall a service on the blade
    Get-Service -ComputerName $blade_server $service_name | Remove-serv

    #create the worksdpace for label from TFS.
    C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\tf.exe workspace /new D:\TFS\$service_deployed\Development\$label

    #Pull the lable from TFS.
    C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\tf.exe get D:\TFS\$service_deployed\Development\$label /version:"L$label" /force /recursive /login:scmbuild,password /noprompt

    #Build the solution file.






}


