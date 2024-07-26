# This script contains several useful Azure functions that can be sourced and used from other scripts

# Load supporting common functions
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/Utilities-CommonFunctions.ps1'))

# Upload a single file to Azure File Share and generate a SAS with a default expiry of 4 hours. Authentication is a Managed Identity
function Add-FileToAzureFileShareAndGenerateSAS {
    param (
        [string]$storageAccountName,
        [string]$resourceGroupName,
        [string]$fileShareName,
        [string]$localFilePath,
        [string]$filePathInShare,
        [int]$sasExpiryInHours = 4,  # SAS token expiry time in hours (default is 4 hours)
        [switch]$toClipboard, # Copy the SAS uri to the clipboard
        [switch]$toBase64 # Base64 encode the SAS uri and copy to clipboard
    )

    # Authenticate
    Add-AzAccount -Identity

    # Get the storage account context
    $storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName 
    $ctx = $storageAccount.Context

    # Ensure the file share exists
    $fileShare = Get-AzStorageShare -Context $ctx -Name $fileShareName -ErrorAction SilentlyContinue
    if (-not $fileShare) {
        Write-Host "File Share not found" -ForegroundColor Red
        exit
    }

    # Upload the file
    Set-AzStorageFileContent -ShareName $fileShareName -Source $localFilePath -Path $filePathInShare -Context $ctx -Force

    Write-Host "File uploaded to Azure File Share successfully."

    # Generate SAS token for the file
    $sasToken = New-AzStorageFileSASToken -Context $ctx -ShareName $fileShareName -Path $filePathInShare -Permission r -ExpiryTime (Get-Date).AddHours($sasExpiryInHours)

    # Changes to New-AzStorageFileSASToken will remove the leading ?, this logic will continue to work on all versions.
    $checkQuestion = $sasToken.Substring(0,1)

    # Construct SAS URI
    if($checkQuestion -eq "?"){
        $sasUri = "{0}/{1}/{2}{3}{4}" -f $storageAccount.PrimaryEndpoints.File.ToString().TrimEnd('/'), $fileShareName, $filePathInShare, '', $sasToken
    } else {
        $sasUri = "{0}/{1}/{2}{3}{4}" -f $storageAccount.PrimaryEndpoints.File.ToString().TrimEnd('/'), $fileShareName, $filePathInShare, '?', $sasToken
    }

    Write-Host "SAS URI: $sasUri"

    if($toClipboard){
        $sasUri | Set-Clipboard
    } elseif($toBase64){
        $sasUri = Get-EncodedBase64 $sasUri
        $sasUri | Set-Clipboard
        Write-Host "Base64 Encoded: $sasUri"
    } else {
        return $sasUri
    }
}

# Example usage
#$sasUri = Add-FileToAzureFileShareAndGenerateSAS -storageAccountName "" `
#                                                    -resourceGroupName "" `
#                                                    -fileShareName "" `
#                                                    -localFilePath "" `
#                                                    -filePathInShare "" `
#                                                    -sasExpiryInHours "" `
#                                                    -toClibpoard `
#                                                    -toBase64