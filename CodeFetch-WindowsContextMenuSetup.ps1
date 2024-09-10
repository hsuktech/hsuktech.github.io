# URLs for the respective .reg files
$addRegFileUrl = "https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetch-WindowsContextMenuAdd.reg"
$removeRegFileUrl = "https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetch-WindowsContextMenuRemove.reg" 

# Define local paths to save the downloaded .reg files
$addRegFilePath = "$env:TEMP\CodeFetch-WindowsContextMenuAdd.reg"
$removeRegFilePath = "$env:TEMP\CodeFetch-WindowsContextMenuRemove.reg"

# Function to download and apply a .reg file
function DownloadAndApplyRegFile {
    param (
        [string]$regFileUrl,
        [string]$localFilePath
    )

    try {
        # Download the .reg file from the URL
        Invoke-WebRequest -Uri $regFileUrl -OutFile $localFilePath -ErrorAction Stop
        Write-Output "Downloaded the .reg file from $regFileUrl successfully."

        # Apply the .reg file
        Start-Process regedit.exe -ArgumentList "/s", "$localFilePath" -Wait
        Write-Output "The .reg file has been applied successfully."
    } catch {
        Write-Output "Failed to download or apply the .reg file. Please check the URL and your permissions."
        Write-Output "Details: $_"
    }
}

# Prompt user to choose to add or remove the registry entries
$choice = Read-Host "Enter 'A' to Add or 'R' to Remove the 'Get CodeFetch Command' context menu"

switch ($choice.ToUpper()) {
    'A' {
        Write-Output "You chose to add the 'Get CodeFetch Command' context menu."
        DownloadAndApplyRegFile -regFileUrl $addRegFileUrl -localFilePath $addRegFilePath
    }
    'R' {
        Write-Output "You chose to remove the 'Get CodeFetch Command' context menu."
        DownloadAndApplyRegFile -regFileUrl $removeRegFileUrl -localFilePath $removeRegFilePath
    }
    Default {
        Write-Output "Invalid choice. Please run the script again and choose 'A' to Add or 'R' to Remove."
    }
}
