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

    # Build JSON to send
    $body = @"
    {
        "`$sharedSecret": "$sharedSecret", 
        "`$scriptName": "$scriptName"
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
        #$decodedCodeBytes = [Convert]::FromBase64String($code)
        #$decodedCodeContent = [System.Text.Encoding]::UTF8.GetString($decodedCodeBytes)
        #$scriptText = $decodedCodeContent
        #$scriptPath = [System.IO.Path]::GetTempPath()
        #$scriptName = Split-Path $scriptName -Leaf
        #$scriptText | Out-File "$scriptPath\$scriptName" -Force
        #$fullScriptPath = "$scriptPath$scriptName" 

        #return $fullScriptPath

        # Get code for script content
        $code = [Convert]::FromBase64String($code)
        $code = [System.Text.Encoding]::UTF8.GetString($code)
        $scriptContent = $code

        # Get script name
        $scriptName = [Convert]::FromBase64String($scriptName)
        $scriptName = [System.Text.Encoding]::UTF8.GetString($scriptName)
        $scriptName = Split-Path $scriptName -Leaf

        # Output to temp path
        $scriptPath = [System.IO.Path]::GetTempPath()
        $scriptContent | Out-File "$scriptPath\$scriptName" -Force
        $scriptPath = "$scriptPath$scriptName" 

        return $scriptPath

    } elseif ($dotSource){
        $decodedCodeBytes = [Convert]::FromBase64String($code)
        $decodedCodeContent = [System.Text.Encoding]::UTF8.GetString($decodedCodeBytes)
        return $decodedCodeContent
    } else {
        # Run
        $decodedCodeBytes = [Convert]::FromBase64String($code)
        $decodedCodeContent = [System.Text.Encoding]::UTF8.GetString($decodedCodeBytes)
        Invoke-Expression $decodedCodeContent
    }  
}