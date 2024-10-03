function CodeFetch-RunAsSystem {
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string[]] $filePath
        )

    # Define the download URL for PsExec
    $psexecUrl = "https://download.sysinternals.com/files/PSTools.zip"
    $tempFolder = [System.IO.Path]::GetTempPath()
    $tempFolder = "$tempFolder"+"CodeFetch"
    $zipFile = "$tempFolder\PSTools.zip"
    $psexecPath = "$tempFolder\PSTools\PsExec.exe"

    # Automatically accept the PsExec EULA by adding the registry key
    $eulaKey = "HKCU:\Software\Sysinternals\PsExec"
    if (-not (Test-Path $eulaKey)) {
        Write-Output "Automatically accepting the PsExec EULA..."
        New-Item -Path "HKCU:\Software\Sysinternals" -Name "PsExec" -Force | Out-Null
        New-ItemProperty -Path $eulaKey -Name "EulaAccepted" -Value 1 -PropertyType DWord -Force | Out-Null
    }

    # Create temporary folder if it doesn't exist
    if (-not (Test-Path $tempFolder)) {
        New-Item -Path $tempFolder -ItemType Directory | Out-Null
    }

    # Download PsExec
    Write-Output "Downloading PsExec..."
    Invoke-WebRequest -Uri $psexecUrl -OutFile $zipFile

    # Extract the zip file
    Write-Output "Extracting PsExec..."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile, "$tempFolder\PSTools")

    # Run PsExec as SYSTEM
    Write-Output "Running PsExec as SYSTEM..."
    #Start-Process -FilePath "$psexecPath" -ArgumentList "-accepteula -i -s cmd.exe" -Wait

    # Alternatively, to run PowerShell as SYSTEM, use this:
    Start-Process -FilePath "$psexecPath" -ArgumentList "-accepteula", "-i", "-s", "powershell.exe", "-ExecutionPolicy", "Bypass", "-File", "$filePath" -Wait

    # Wait for the SYSTEM command prompt or PowerShell session to close

    # Clean up: delete the PsExec files and temporary folder
    Write-Output "Cleaning up PsExec files..."
    Remove-Item -Path $zipFile -Force
    Remove-Item -Path "$tempFolder\PSTools" -Recurse -Force

    Write-Output "PsExec has been deleted. All tasks complete."
}
