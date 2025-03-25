# Define paths for the secure XML files
$secretPath = "$env:LOCALAPPDATA\CF_SHAREDSECRET.xml"
$uriPath = "$env:LOCALAPPDATA\CF_URI.xml"

# Remove CF_SHAREDSECRET if the file exists
if (Test-Path $secretPath) {
    Remove-Item -Path $secretPath -Force
    Write-Output "CF_SHAREDSECRET has been removed successfully."
} else {
    Write-Output "CF_SHAREDSECRET does not exist or has already been removed."
}

# Remove CF_URI if the file exists
if (Test-Path $uriPath) {
    Remove-Item -Path $uriPath -Force
    Write-Output "CF_URI has been removed successfully."
} else {
    Write-Output "CF_URI does not exist or has already been removed."
}
