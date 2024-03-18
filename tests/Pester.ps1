$scriptFolder = ".\tests"

# Get all PowerShell script files in the folder
$scripts = Get-ChildItem -Path $scriptFolder -Filter "*.Tests.ps1"

# Loop through each script and execute it
foreach ($script in $scripts) {
    Write-Host "Executing script: $($script.Name)"
    & $script.FullName
}
