function CodeFetch {
param(
    [Parameter(Position=0, Mandatory=$true)]
    [string[]] $scriptId,

    [Parameter(Position=1, Mandatory=$true)]
    [string[]] $sharedSecret,

    [Parameter(Position=2, Mandatory=$false)]
    [string[]] $codeFetchUri,

    [Parameter(Position=3, Mandatory=$false)]
    [switch]$saveLocal,

    [Parameter(Position=4, Mandatory=$false)]
    [switch]$dotSource

    [Parameter(Position=5, Mandatory=$false)]
    [switch]$RunAsSystem
    )

    # Build JSON to send
    $body = @"
    {
        "sharedSecret": "$sharedSecret", 
        "scriptId": "$scriptId"
    }
"@

    # Request webhook, exit if error
    try {
        $result = Invoke-WebRequest -Method Post -Uri "$codeFetchUri" `
        -Headers @{'Content-Type' = 'application/json'} -Body $body -ErrorAction Stop
    }
    catch {
        Write-Host "Error with CodeFetch, please try again" -ForegroundColor Red
        # Exit
    }

    $resultJson = $result.content
    $resultJson = $resultJson -replace '\\', ''
    $resultJson = $resultJson.Trim('"')
    #$resultJson
    $scriptObject = $resultJson | ConvertFrom-Json
    #$scriptObject
    
    $code = $scriptObject.Code
    $scriptExtension = $scriptObject.Extension
    $scriptName = $scriptObject.Name
    
    if($saveLocal){
        # Get code for script content
        $code = [Convert]::FromBase64String($code)
        $code = [System.Text.Encoding]::UTF8.GetString($code)
        $scriptContent = $code

        # Output to temp path
        $scriptPath = [System.IO.Path]::GetTempPath()
        $scriptPath = $scriptPath+"CodeFetch"

        # Create folder if it doesn't exist
        if (-not (Test-Path $scriptPath)) {
            New-Item -Path $scriptPath -ItemType Directory | Out-Null
        }

        $scriptContent | Out-File "$scriptPath\$scriptName" -Force
        $scriptPath = "$scriptPath\$scriptName" 

        return $scriptPath

    } elseif ($dotSource){
        $decodedCodeBytes = [Convert]::FromBase64String($code)
        $decodedCodeContent = [System.Text.Encoding]::UTF8.GetString($decodedCodeBytes)
        return $decodedCodeContent
    } elseif ($RunAsSystem){
        
    } else {
        # Run
        $decodedCodeBytes = [Convert]::FromBase64String($code)
        $decodedCodeContent = [System.Text.Encoding]::UTF8.GetString($decodedCodeBytes)
        $decodedCodeContent
        Invoke-Expression $decodedCodeContent
    }  
}

# TODO: Add a function to run the script as SYSTEM
