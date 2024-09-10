param (
    [string]$filePath
)

# Function to get secure variable or prompt if not found, and store securely
function Get-SecureVariableOrPrompt {
    param (
        [string]$VarName,
        [string]$PromptMessage
    )

    # Path to store the credential XML securely
    $securePath = "$env:LOCALAPPDATA\$VarName.xml"

    # Try to retrieve the secure value from the stored XML file
    if (Test-Path $securePath) {
        try {
            $credential = Import-Clixml -Path $securePath
            $secureValue = $credential.GetNetworkCredential().Password
            return $secureValue
        }
        catch {
            Write-Output "Failed to load the secure value for '$VarName'. Please re-enter."
        }
    }

    # Prompt the user to input the value securely if not found
    $value = Read-Host -Prompt $PromptMessage -AsSecureString

    # Store the secure value in the Credential Manager XML
    $credential = New-Object PSCredential -ArgumentList $VarName, $value
    $credential | Export-Clixml -Path $securePath

    # Convert the SecureString to plain text only for internal use in the script
    $plainTextValue = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($value))

    return $plainTextValue
}

# Get CF_SHAREDSECRET securely from stored file or prompt
$cfSharedSecret = Get-SecureVariableOrPrompt -VarName 'CF_SHAREDSECRET' -PromptMessage 'Enter the CF_SHAREDSECRET:'

# Get CF_URI securely from stored file or prompt
$cfUri = Get-SecureVariableOrPrompt -VarName 'CF_URI' -PromptMessage 'Enter the CF_URI:'

# Encode the script name to avoid unsupported character errors
$bytes = [System.Text.Encoding]::UTF8.GetBytes($filePath)
$encodedFilePath = [Convert]::ToBase64String($bytes)

# Generate CodeFetch command with securely retrieved values and copy to clipboard
$code = @"
iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetch.ps1); CodeFetch -scriptName "$encodedFilePath" -sharedSecret "$cfSharedSecret" -codeFetchUri "$cfUri"
"@

# Copy the generated command to the clipboard
Set-Clipboard -Value $code

# Output to confirm action
Write-Output "CodeFetch command copied to clipboard successfully."
