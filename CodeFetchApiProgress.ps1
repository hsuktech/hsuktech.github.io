function CodeFetch {
param(
    [Parameter(Position=0, Mandatory=$true)]
    [string[]] $script,

    [Parameter(Position=1, Mandatory=$false)]
    [switch]$saveLocal,

    [Parameter(Position=2, Mandatory=$false)]
    [switch]$dotSource,

    [Parameter(Position=3, Mandatory=$false)]
    [switch]$reset
    )

    # Reset sharedSecret
    if($reset){
        Remove-Item ENV:CF_SHARED_SECRET
    } else {
        # Do nothing
    }

    # Check that the sharedSecret token exists
    if($env:CF_SHARED_SECRET -eq $null) {
        Write-Output "Please add the environment variable for the Shared Secret"
        $env:CF_SHARED_SECRET = Read-Host "Enter Shared Secret"
    } else {
        # Do nothing
    }

    # Build JSON to send
    $body = @"
    {
        "sharedSecret": "$env:CF_SHARED_SECRET", 
        "script": "$script"
    }
"@

    # Request webhook, exit if error
    try {
        $timeout = 30  # Max wait time in seconds

        # Start Web Request in a Background Job
        $job = Start-Job -ScriptBlock {
            param ($body)
            Invoke-WebRequest -Method Post -Uri "https://api.datarelay.io/api:Ls7M8AB3/codefetch/core/get-code" -Headers @{'Content-Type' = 'application/json'} -Body $body -ErrorAction Stop
        } -ArgumentList $body

        # Progress Bar While Waiting
        $elapsed = 0
        while ($true) {
            $percentComplete = ($elapsed / $timeout) * 100
            Write-Progress -Activity "Processing..." -Status "Elapsed: $elapsed sec" -PercentComplete $percentComplete

            # Check if Job is Failed
            if (Get-Job -Id $job.Id | Where-Object { $_.State -eq 'Failed' }) {
                Write-Progress -Activity "Processing..." -Completed
                break
            }

            # Check if Job is Completed
            if (Get-Job -Id $job.Id | Where-Object { $_.State -eq 'Completed' }) {
                Write-Progress -Activity "Processing..." -Completed
                break
            }

            Start-Sleep -Seconds 1
            $elapsed++

            # Timeout Condition
            if ($elapsed -ge $timeout) {
                Stop-Job -Id $job.Id
                Remove-Job -Id $job.Id
                Write-Host "Timed out!"
                #exit
            }
        }

        # Retrieve Job Output
        $result = Receive-Job -Id $job.Id
        Remove-Job -Id $job.Id

        $result = $result | ConvertFrom-Json
        $code = $result.code

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
    }
    catch {
        Write-Host "Error with CodeFetch, please try again" -ForegroundColor Red
    }
  
}