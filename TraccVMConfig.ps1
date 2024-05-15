# Run VMEditor.exe
CodeFetch -scriptName TRACC-VMEditor.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri

# Resize VM
CodeFetch -scriptName TRACC-ResizeVM.ps1 -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri
