cls

# Load the Code Fetch function
iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetch.ps1)

# Set the variables
$webhookUri = Read-Host "Webhook Uri"
$sharedSecret = Read-Host "Shared Secret"

# Fetch the code

# Create standard PowerShell profile for the current user 
CodeFetch -scriptName Maintenance-CreatePsProfile.ps1 -sharedSecret $sharedSecret -webhookUri $webhookUri
