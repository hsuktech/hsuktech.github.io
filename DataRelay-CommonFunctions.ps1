function Get-EncodedBase64 {
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputString
    )

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
    return [Convert]::ToBase64String($bytes)
}

function Get-DecodedBase64 {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Base64String
    )

    $bytes = [Convert]::FromBase64String($Base64String)
    return [System.Text.Encoding]::UTF8.GetString($bytes)
}

# Example usage
# Get-EncodeBase64
# Get-DecodeBase64 $encoded