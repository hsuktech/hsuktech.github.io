### TRACC APP CONFIG ###

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

# EnableLinkedConnections (Required: restart)
CodeFetch -scriptName Maintenance-EnableLinkedConnections.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

# AllowInsecureGuestAuth (Required: restart)
CodeFetch -scriptName Maintenance-AllowInsecureGuestAuth.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

# Activate Windows
CodeFetch -scriptName Maintenance-ActivateWindowsOnOvh.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

# Map OVH backup share to H (Requires CIFS rule and AllowInsecureGuestAuth)
CodeFetch -scriptName TRACC-MapOvhBackupShare.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

# Add backup shortcut to data
CodeFetch -scriptName TRACC-AddBackupShortcut.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

# Fix Start Menu
CodeFetch -scriptName TRACC-FixStartMenu.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

# Resize OS (C) drive to max
CodeFetch -scriptName Maintenance-ResizeOSDrive.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

# Create ZeroSSL certificate
CodeFetch -scriptName ZeroSSL-CreateCert.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri
