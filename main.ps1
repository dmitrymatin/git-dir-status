param([string]$path = "C:\Users\$env:UserName\source\repos")

$initialLocation = Get-Location

Write-Host "Checking git statuses for path $path" -ForegroundColor darkblue

$directories = @(Get-ChildItem -Path $path -Directory | Select-Object -ExpandProperty FullName)

foreach ($dir in $directories) {
    Set-Location -Path $dir
    try {
        # redirect stderr to stdout https://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-3.html
        $gitOutputString = $(git status --porcelain 2>&1)

        $isGitError = $gitOutputString -match "fatal"

        if ($isGitError) {
            Write-Host "git fatal error happened in directory $dir\: $gitOutputString" -ForegroundColor darkred
            continue
        }

        $untrackedFilesExist = git status --porcelain | Where-Object { $_ -match '^\?\?' }
        if ($untrackedFilesExist) {
            Write-Host "There are untracked files in $dir" -ForegroundColor yellow
        }
        else {
            $uncommitedChangesExist = git status --porcelain | Where-Object { $_ -notmatch '^\?\?' }
            if ($uncommitedChangesExist) {
                Write-Host "There are uncommitted changes to files in $dir" -ForegroundColor yellow
            }
            else {
                Write-Host "$dir is clean" -ForegroundColor green
            }
        }
    }
    catch {
        Write-Host "ERROR while working with directory $dir" -ForegroundColor darkred
    }
}

# Clean-up
Set-Location -Path $initialLocation