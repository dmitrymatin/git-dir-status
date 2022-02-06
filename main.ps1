param([string]$path = "C:\Users\dmitr\source\repos")

$initialLocation = Get-Location

Write-Output("Checking git statuses for path " + $path)

$directories = @(Get-ChildItem -Path $path -Directory | Select-Object -ExpandProperty FullName)

foreach ($dir in $directories) {
    Write-Output($dir)
    Set-Location -Path $dir

    $result = git diff-index --quiet HEAD
    if (0 -eq $result) {
        Write-Output("no uncommited changes in " + $dir)
    }
    else {
        Write-Output("uncommitted changes in " + $dir)
    }
}

# Clean-up
Set-Location -Path $initialLocation