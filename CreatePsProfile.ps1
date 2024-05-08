cls

# Load the LocalCode function
iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/LocalCode.ps1)

# Set the variables
$sharedSecret = Read-Host "Shared Secret"
$webhookUri = Read-Host "Webhook Uri"

# Run the code

# Create standard PowerShell profile for the current user 
RunLocalCode -scriptName Maintenance-CreatePsProfile.ps1 -sharedSecret $sharedSecret -webhookUri $webhookUri
