# Encode a string to Base64
function Get-EncodedBase64 {
    param (
        [string]$text
    )

    $bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
    $encodedText =[Convert]::ToBase64String($Bytes)
    return $encodedText
}

function CodeFetch {
param(
    [Parameter(Position=0, Mandatory=$true)]
    [string[]] $scriptName,

    [Parameter(Position=1, Mandatory=$true)]
    [string[]] $sharedSecret,

    [Parameter(Position=2, Mandatory=$true)]
    [string[]] $codeFetchUri,

    [Parameter(Position=3, Mandatory=$false)]
    [switch]$saveLocal,

    [Parameter(Position=4, Mandatory=$false)]
    [switch]$dotSource
    )


    $codeFetchUri
    $sharedSecret

    # Build JSON to send
    $body = @"
    {
        "`$sharedSecret": "$sharedSecret", 
        "`$scriptName": "$scriptName"
    }
"@

    # Request webhook
    $result = Invoke-WebRequest -Method Post -Uri "$codeFetchUri" `
        -Headers @{'Content-Type' = 'application/json'} -Body $body

    #$result
    $result = $result | ConvertFrom-Json
    $url = $result.resultUrl

    # Loop until status is complete
    do {
        $response = Invoke-WebRequest -Uri $url -Method Get -MaximumRedirection 0
        $status = ($response.Content | ConvertFrom-Json).status
        if($status -ne "Completed"){
            continue
        }
        else{
            break
        }
    } while ($true)

    # Get result
    $response = $response.Content | ConvertFrom-Json
    $code = $response.data.results.tasks.result 
    
    if($saveLocal){
        # Save to temp path
        $scriptText = $code.ScriptText
        $scriptPath = [System.IO.Path]::GetTempPath()
        $scriptText | Out-File "$scriptPath\$scriptName" -Force
        $fullScriptPath = "$scriptPath$scriptName" 

        return $fullScriptPath

    } elseif ($dotSource){
        $codeBase64 = Get-EncodedBase64 $code.ScriptText
        return $codeBase64
    } else {
        # Run
        Invoke-Expression $code.ScriptText
    }  
}