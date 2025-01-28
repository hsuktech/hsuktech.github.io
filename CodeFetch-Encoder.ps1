$script = Read-Host "Enter the script path"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($script)
$encodedFilePath = [Convert]::ToBase64String($bytes)
Return $encodedFilePath