# MyApiModule.psm1

function Get-DataRelayApiAuthToken {
    <#
    .SYNOPSIS
    Authenticates to an API using a username and password and retrieves an auth token.

    .PARAMETER ApiUrl
    The URL of the API's authentication endpoint.

    .PARAMETER Username
    The username for authentication.

    .PARAMETER Password
    The password for authentication.

    .OUTPUTS
    The auth token string.

    .EXAMPLE
    $authToken = Get-ApiAuthToken -ApiUrl "https://api.example.com/auth" -Username "user" -Password "pass"
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$ApiUrl,

        [Parameter(Mandatory = $true)]
        [string]$Email,

        [Parameter(Mandatory = $true)]
        [string]$Password
    )

    try {
        $body = @{
            email = $Email
            password = $Password
        } | ConvertTo-Json -Depth 10

        $response = Invoke-RestMethod -Uri $ApiUrl -Method Post -Body $body -ContentType "application/json"

        if ($response.authToken) {
            return $response.authToken
        } else {
            throw "Authentication failed: Token not found in response."
        }
    } catch {
        throw "Failed to authenticate: $_"
    }
}

function Invoke-DataRelayApiEndpoint {
    <#
    .SYNOPSIS
    Calls a specified API endpoint using an auth token and a JSON object as a parameter.

    .PARAMETER ApiUrl
    The URL of the API endpoint to call.

    .PARAMETER AuthToken
    The authentication token to use in the Authorization header.

    .PARAMETER JsonObject
    The JSON object to send as the request body.

    .OUTPUTS
    The API response.

    .EXAMPLE
    $response = Invoke-ApiEndpoint -ApiUrl "https://api.example.com/data" -AuthToken $authToken -JsonObject $json
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$ApiUrl,

        [Parameter(Mandatory = $true)]
        [string]$AuthToken,

        [Parameter(Mandatory = $true)]
        [PSObject]$JsonObject
    )

    try {
        $headers = @{
            Authorization = "Bearer $AuthToken"
        }

        $body = $JsonObject | ConvertTo-Json -Depth 10

        $response = Invoke-RestMethod -Uri $ApiUrl -Method Post -Headers $headers -Body $body -ContentType "application/json"

        return $response
    } catch {
        throw "Failed to invoke API endpoint: $_"
    }
}
