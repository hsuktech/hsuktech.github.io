function CodeFetch {
param(
    [Parameter(Position=0, Mandatory=$true)]
    [string[]] $script,

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
        "sharedSecret": "$sharedSecret", 
        "script": "$script",
        "taskName": "GetCode"
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


    #$code = $response.data.results.tasks[2].result 

    $checkSecret = $response.data.results.tasks | Where-Object { $_.name -eq "Check-Secret" }
    
    if($checkSecret.result -eq $true){
        $code = ($response.data.results.tasks | Where-Object { $_.name -eq "Get-Code" }).result

        # Exit if script not found
        if($code -eq $false){
            Return "Script not found!"
            exit
        }

        if($saveLocal){

            # Get code for script content
            $code = [Convert]::FromBase64String($code)
            $code = [System.Text.Encoding]::UTF8.GetString($code)
            $scriptContent = $code

            $scriptContent
            $script

            # Get script
            Try{
                $decodedBytes = [Convert]::FromBase64String($script)
                $script = [System.Text.Encoding]::UTF8.GetString($decodedBytes)
            }catch{
                # Do nothing if name is not base64 encoded
            }  

            $scriptName = Split-Path $script -Leaf

            # Output to temp path
            $scriptPath = [System.IO.Path]::GetTempPath()
            $scriptPath = $scriptPath+"CodeFetch"

            # Create folder if it doesn't exist
            if (-not (Test-Path $scriptPath)) {
                New-Item -Path $scriptPath -ItemType Directory | Out-Null
            }

            $scriptContent | Out-File "$scriptPath\$scriptName" -Force
            $scriptPath = "$scriptPath\$scriptName" 

            Set-Clipboard $scriptPath
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
    } else {
        return "Secret is invalid!"
    }
    
}