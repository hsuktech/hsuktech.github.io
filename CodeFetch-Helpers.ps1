# This function tidies up the cloned repository
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