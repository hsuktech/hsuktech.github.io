# TODO: Load this helper from CodeFetch!! #codefetch

# This function tidies up the cloned repository to include only the files that are tagged
function Clean-Repo {

    param (
        [Parameter(Mandatory=$true)]
        [string]$searchPath
    )

    # Ensure the repo exists before proceeding
    if (!(Test-Path -Path "$searchPath")) {
        Write-Host "Error: Repository clone failed!" -ForegroundColor Red
        exit 1
    }

    # Find all directories containing .codefetch_exclude and store them in an array
    $excludeDirs = Get-ChildItem -Path "$searchPath" -Recurse -Force -File -Filter ".codefetch_exclude" |
        ForEach-Object { $_.DirectoryName } | Select-Object -Unique

    # Delete the directories after finding them
    foreach ($dir in $excludeDirs) {
        if (Test-Path -Path $dir) {
            Remove-Item -Recurse -Force $dir
            #Write-Host "Deleted: $dir"
        }
    }

    # Remove files that don't contain the #CF-UPLOAD tag
    Get-ChildItem -Path "$searchPath" -Recurse -File |
        Where-Object { -not (Select-String -Path $_.FullName -Pattern "#CF-UPLOAD" -Quiet) } |
        Remove-Item -Force

    # Remove the .git directory
    $gitPath = "$searchPath\.git"
    if (Test-Path -Path $gitPath) {
        Remove-Item -Recurse -Force $gitPath
    }

    # Remove the .gitignore file
    $gitIgnorePath = "$searchPath\.gitignore"
    if (Test-Path -Path $gitIgnorePath) {
        Remove-Item -Recurse -Force $gitIgnorePath
    }

    # Remove empty directories
    function Remove-EmptyFolders {
        param (
            [string]$Path
        )

        # Loop to remove empty folders until none remain
        do {
            $emptyFolders = Get-ChildItem -Path $Path -Recurse -Directory |
                Where-Object { (Get-ChildItem -Path $_.FullName -Force | Measure-Object).Count -eq 0 }

            if ($emptyFolders) {
                $emptyFolders | Remove-Item -Recurse -Force
            }
        } while ($emptyFolders.Count -gt 0) # Continue until no empty folders remain
    }

    # Call function to clean empty folders
    Remove-EmptyFolders -Path "$searchPath"
}   

# This function indexes and encrypts the files to be copied
function Process-Repo {
    
    param (
        [Parameter(Mandatory=$true)]
        [string]$sharedSecret,
        [Parameter(Mandatory=$true)]
        [string]$repoName

    )

    # Index path
    $indexFile = "cf_index.json"
    Remove-Item -Force $indexFile -ErrorAction SilentlyContinue

    # Metadata index
    $indexJson = @()

    # SHA1 hash of the repo name to add to the path
    $repoNameHash = Get-SHA ($repoName) -algorithm "SHA1"

    # Encrypt all remaining files using AES-256
    Get-ChildItem -Path . -Recurse -File | ForEach-Object {
        $inputFile = $_.FullName

        # Read the first few lines of the file to extract metadata
        $lines = Get-Content -Path $inputFile -TotalCount 10

        # SHA1 hash of the file path for the CodeFetch ID
        $filePathHash = Get-SHA ($inputFile) -algorithm "SHA1"   

        # Get the relative file path 
        $filePath = Resolve-Path -Path $inputFile -Relative
        $filePath = ($filePath -replace '\\', '/') -replace '^\./', ''

        # Build the path
        $filePath = "$repoNameHash/$filePath"
        
        # Initialize a hashtable to store metadata for the current file
        $metadata = @{
            Name        = $null
            Tags        = $null
            Description = $null
            CodeFetchId = $filePathHash
            FilePath    = $filePath
        }

        # Parse lines for metadata
        foreach ($line in $lines) {
            if ($line -match "^#\s*CF-Name:\s*(.+)") {
                $metadata.Name = $matches[1].Trim()
            }
            elseif ($line -match "^#\s*CF-Tags:\s*(.+)") {
                $metadata.Tags = $matches[1].Trim() -split "\s*,\s*"
            }
            elseif ($line -match "^#\s*CF-Description:\s*(.+)") {
                $metadata.Description = $matches[1].Trim()
            }
        }

        # Add to the index
        $indexJson += $metadata

        # Encrypt the file
        #$outputFile = "$inputFile.enc"
        #openssl enc -aes-256-cbc -salt -pbkdf2 -in "$inputFile" -out "$outputFile" -pass pass:"$sharedSecret"
        
        # Remove the original file after encryption
        #Remove-Item -Force "$inputFile"
    }

    # Convert the metadata array to JSON and write it to the output file
    $indexJson | ConvertTo-Json -Depth 3 | Set-Content -Path $indexFile

    $indexJson | ConvertTo-Json -Depth 3
}

# This function returns the SHA hash of a string
function Get-SHA {
    param (
        [string]$inputString,
        [string]$algorithm = "SHA256"
    )

    $hashAlgorithm = [System.Security.Cryptography.HashAlgorithm]::Create($algorithm)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($inputString)
    $hashBytes = $hashAlgorithm.ComputeHash($bytes)

    return -join ($hashBytes | ForEach-Object { "{0:X2}" -f $_ })
}
