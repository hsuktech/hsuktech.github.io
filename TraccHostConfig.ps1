### TRACC HOST CONFIG ###

function Show-Menu
{
    param (
        [string]$Title = 'TRACC HOST CONFIG'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to run stage 1."
    Write-Host "2: Press '2' to run stage 2."
    Write-Host "Q: Press 'Q' to quit."
}

Show-Menu –Title 'TRACC HOST CONFIG'
$selection = Read-Host "Please make a selection"
switch ($selection)
{
   '1' {
          # Install ScreenConnect 
          CodeFetch -scriptName Install-ScreenConnect.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Rename computer
          CodeFetch -scriptName Maintenance-RenameComputer.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Show file extensions
          CodeFetch -scriptName Maintenance-ShowFileExtensions.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Set execution policy unrestricted
          CodeFetch -scriptName Maintenance-SetExecutionPolicyUnrestricted.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Set Locale and Culture for the current user
          CodeFetch -scriptName Maintenance-SetLocaleAndCulture.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Set GMT (Required: set locale and culture first)
          CodeFetch -scriptName Maintenance-SetGMT.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # EnableLinkedConnections (Required: restart)
          CodeFetch -scriptName Maintenance-EnableLinkedConnections.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # AllowInsecureGuestAuth (Required: restart)
          CodeFetch -scriptName Maintenance-AllowInsecureGuestAuth.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Activate Windows
          CodeFetch -scriptName Maintenance-ActivateWindowsOnOvh.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Install Hyper-V (Restarts)
          CodeFetch -scriptName Install-HyperV.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri
   } '2' {
          # Map Basemap share to Z 
          CodeFetch -scriptName TRACC-MapBasemapShare.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Map OVH backup share to H (Requires CIFS rule and AllowInsecureGuestAuth)
          CodeFetch -scriptName TRACC-MapOvhBackupShare.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Install Acronis
          CodeFetch -scriptName Install-AcronisAgentHyperV.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Create VM Network
          CodeFetch -scriptName TRACC-CreateVmNetwork.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Cloudflared setup
          CodeFetch -scriptName TRACC-CloudflaredSetup.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Run VMEditor.exe
          CodeFetch -scriptName TRACC-VMEditor.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

          # Resize VM
          CodeFetch -scriptName TRACC-ResizeVM.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri
   } 'q' {
       return
   }
}
