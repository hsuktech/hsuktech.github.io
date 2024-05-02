function RunLocalCode {
param(
    [Parameter(Position=0, Mandatory=$true)]
    [string[]] $scriptName,

    [Parameter(Position=1, Mandatory=$true)]
    [string[]] $sharedSecret,

    [Parameter(Position=2, Mandatory=$true)]
    [string[]] $webhookUri
    )

    #$scriptName = ""
    #$sharedSecret = ""
    #$webhookUri = ""

    if(Test-Path variable:global:webhookUri){
    # Do nothing
    } else { 
        $webhookUri = Read-Host "Webhook Uri"
    }
    
    if(Test-Path variable:global:sharedSecret){
        # Do nothing
    } else { 
        $sharedSecret = Read-Host "Shared Secret"
    }

    $body = @"
    {
        "`$sharedSecret": "$sharedSecret", 
        "`$scriptName": "$scriptName"
    }
"@

    $body

    # Azure SQL on HSUK with query
    $result = Invoke-WebRequest -Method Post -Uri "$webhookUri" `
        -Headers @{'Content-Type' = 'application/json'} -Body $body

    #$result
    $result = $result | ConvertFrom-Json
    $url = $result.resultUrl

    $url

    do {
        $response = Invoke-WebRequest -Uri $url -Method Get -MaximumRedirection 0
        $status = ($response.Content | ConvertFrom-Json).status
        if($status -ne "Completed"){
            continue
        }
        else{
            #Write-Output $response
            break
        }
    } while ($true)

    $response = $response.Content | ConvertFrom-Json
    $code = $response.data.results.tasks.result 
    
    # Save script as local file
    #$scriptText = $code.ScriptText
    #$scriptText | Out-File "C:\Assets\Automation\Temp\$scriptName"

    Invoke-Expression $code.ScriptText
    
    # This doesn't work
    #Start-Process powershell.exe -ArgumentList "-Command "Invoke-Command -FilePath C:\Assets\Automation\Temp\$scriptName"" `
    #    -WindowStyle Hidden -PassThru -Wait -RedirectStandardOutput "C:\Assets\Automation\Logs\$scriptName.txt"   
        
}
