# This script contains several useful functions that can be sourced and used from other scripts

# Function to prompt the user with a Yes/No question
function Get-Confirmation {
    param (
        [string]$promptMessage
    )

    while ($true) {
        $response = Read-Host -Prompt $promptMessage

        switch ($response.ToLower()) {
            "yes" { return $true }
            "y"   { return $true }
            "no"  { return $false }
            "n"   { return $false }
            default { Write-Host "Please enter 'Yes' or 'No' (or 'Y' or 'N')." }
        }
    }
}

# Encode a string to Base64
function Get-EncodedBase64 {
    param (
        [string]$text
    )

    $bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
    $encodedText =[Convert]::ToBase64String($Bytes)
    return $encodedText
}

# Decode a string to Base64
function Get-DecodedBase64 {
    param (
        [string]$text
    )

    $decodedText = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($text))
    return $decodedText
}

