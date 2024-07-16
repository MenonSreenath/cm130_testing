[string]$service_name,
[String]$service_backup_folder,
[String]$current_service_folder,
[string]$blade_server,
[string]$service_deployed,
[string]$solution_file_name
[string]$tfs_file_path
[string]$RITM
[string]$username
[string]$password


 #Check the worksdpace for label from TFS.
 tf workspaces /collection:http://denw1scmma01:8080/tfs/FDTFSCollection/DataMovement/

 #Pull the lable from TFS.
 tf get D:\TFS\$service_deployed\Development\$label /version:"L$label" /force /recursive /login:scmbuild,password /noprompt

 #Build the solution file.
 Set-Location D:\TFS\$tfs_file_path
 msbuild /target:Build /p:Configuration=Release .\$solution_file_name 

 #stop the service
 Get-Service -ComputerName $blade_server $service_name | Stop-Service

 #create a backup folder
 New-Item -Path $service_backup_folder -ItemType Directory

 #copy contents from current folder to backup folder
 Robocopy.exe $current_service_folder $service_backup_folder /e /z

 #uninstall a service on the blade
 Get-Service -ComputerName $blade_server $service_name | Remove-Service

 #copy the contents to the blade server to deploy there
 if ($service_name -eq "Falcron" -or $Options -eq "falcron")
 {
    Robocopy.exe "D:\TFS\DataMovement\Central Apps\FalCron\FalCron\Setup_FalCron\Release" "\\$blade_server\D$\Artifactory\RITM\" /e /z
 }

 elseif($service_name -eq "SnapInMecV2" -or $Options -eq "snapinmecv2")
 {
    Robocopy.exe "D:\TFS\DataMovement\Central Apps\SnapInMecV2\Setup_SnapInMecV2\Release" "\\$blade_server\D$\Artifactory\RITM\" /e /z
 }

 elseif($service_name -eq "SnapInMecV2" -or $Options -eq "snapinmecv2")
 {
    Robocopy.exe "D:\TFS\DataMovement\Central Apps\SnapInSimulator\SnapInSimulator\Setup_SnapinSimulator\Release" "\\$blade_server\D$\Artifactory\RITM\" /e /z
 }

 #install the service using the creds given
 New-Service -name $service_name -BinaryPath "\\$blade_server\D$\Artifact\$RITM\Setup_$service_name.msi" -Credential -u $username -p $password -StartupType Automatic

 #start service on the server
 Get-Service -ComputerName $blade_server $service_name | Start-Service