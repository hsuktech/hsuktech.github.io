# Public Scripts
This GitHub Pages website contains several public scripts.

## CodeFetch
To use the CodeFetch.ps1 function in several ways. 

### Build your command using this template

```
iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetch.ps1);CodeFetch -scriptName "<VALID SCRIPT NAME>" -sharedSecret "<VALID SECRET>" -codeFetchUri "<VALID WEBHOOK>"
```

> NOTE: You can use the -saveLocal switch to save the file to the user's temp path [System.IO.Path]::GetTempPath()
> NOTE: You can use the -dotSource switch alongside save local to load the code into the current PowerShell Session

### Use the CodeFetcher command which will request the URL, Secret and Script Name

```
iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetcher.ps1)
```

### Load the CodeFetch Profile

```
iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetchPsProfile.ps1)
```