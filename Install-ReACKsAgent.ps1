# Check Chocolatey
if(Get-Command choco -ErrorAction silentlycontinue){
    # Chocolatey is installed
}else{
    # Install chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

 # Add Source
choco source add -n=reacks -s="https://pkgs.dev.azure.com/hsukltd/Packages/_packaging/reacks/nuget/v2"

# Install Agent
$url = Read-Host "Please enter URL"
$pat = Read-Host "Please enter PAT"
choco install reacks.agent -y --params="'/ServerUrl:$url /PAT:$pat'"
